//
//  ListViewController.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
//MARK: - Enum Section
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
//MARK: - Properties
    private var activeChats = [ChatModel]()
    private var waitingChats = [ChatModel]()
    private var waitingChatListener: ListenerRegistration?
    private let currentUser: ModelUser
    
//MARK: - UI elements
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
    
//MARK: - Life cycle
    init(user: ModelUser) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        title = currentUser.userName
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.standardAppearance = appearance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData(with: nil)
        addListener()
    }
    
    deinit {
        waitingChatListener?.remove()
    }
    
//MARK: - SetCollection
    private func setCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
//MARK: - SetSearchBar
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
//MARK: - Reload Data
    private func reloadData(with search: String?) {
        let filtered = activeChats.filter { chat -> Bool in
            chat.contains(filter: search)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(filtered, toSection: .activeChats)
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
//MARK: - AddListener
    private func addListener() {
        waitingChatListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                    self.present(chatRequestVC, animated: true)
                }
                self.waitingChats = chats
                self.reloadData(with: nil)
            case let .failure(error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
}

//MARK: - WaitingChatsNavigation
extension ListViewController: WaitingChatsNavigation {
    func removeWaitingChat(chat: ChatModel) {
        FirebaseService.shared.deleteWaitingChat(chat: chat) {[weak self] result in
            switch result {
            case .success:
                self?.showAlert(with: "Success", and: "Chat deleted")
            case let .failure(error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: ChatModel) {
        
    }
}

//MARK: - DataSource
extension ListViewController {    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section),
                  let self = self else { return UICollectionViewCell() }
            switch section {
            case .waitingChats:
                return self.config(collectionView: collectionView, cellType: WaitingChatCell.self, with: itemIdentifier, for: indexPath)
            case .activeChats:
                return self.config(collectionView: collectionView, cellType: ActiveChatCell.self, with: itemIdentifier, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collection, kind, index in
            guard let sectionHeader = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: index) as? SectionHeader else {
                fatalError("Can not create new section header")
            }
            guard let section = Section(rawValue: index.section) else {
                fatalError("Unknown section kind")
            }
            sectionHeader.configTitle(text: section.description(),
                                      font: .laoSangam20(),
                                      textColor: #colorLiteral(red: 92/255, green: 92/255, blue: 92/255, alpha: 1))
            return sectionHeader
        }
    }
}

//MARK: - CollectionDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            present(chatRequestVC, animated: true)
        case .activeChats:
            print("adfgad")
        }
    }
}

//MARK: - CompositionalLayout
extension ListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] (sectionIndex, environment) -> NSCollectionLayoutSection in
            guard let section = Section(rawValue: sectionIndex),
                  let self = self else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .waitingChats:
                return self.createWaitingChatSection()
            case .activeChats:
                return self.createActiveChatSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
//MARK: - ActiveChats
    private func createActiveChatSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                        heightDimension: .absolute(78)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
//MARK: - WaitingChats
    private func createWaitingChatSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(88),
                                                                                          heightDimension: .absolute(88)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
//MARK: - SectionHeader
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                                           heightDimension: .estimated(1)),
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
}

//MARK: - SearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}
