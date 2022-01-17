//
//  ListViewController.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

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
    private let activeChats = Bundle.main.decode([ChatModel].self, from: "activeChats.json")
    private let waitingChats = Bundle.main.decode([ChatModel].self, from: "waitingChats.json")
    
//MARK: - UI elements
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData()
    }
    
//MARK: - SetCollection
    private func setCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)

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
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - DataSource
extension ListViewController {
    private func config<T: ConfiguringCell>(cellType: T.Type, with value: ChatModel, for index: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: index) as? T else {
            fatalError("Unknown section kind")
        }
        cell.configure(with: value)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section),
                  let self = self else { return UICollectionViewCell() }
            switch section {
            case .waitingChats:
                return self.config(cellType: WaitingChatCell.self, with: itemIdentifier, for: indexPath)
            case .activeChats:
                return self.config(cellType: ActiveChatCell.self, with: itemIdentifier, for: indexPath)
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
        print(searchText)
    }
}

//MARK: - SwiftUI
import SwiftUI

struct ListViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = ListViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
