//
//  ContactsViewController.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

class ContactsViewController: UIViewController {
    
//MARK: - Enum Section
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people online"
            }
        }
    }
    
//MARK: - Properties
    private let users = Bundle.main.decode([ModelUser].self, from: "users.json")
    
//MARK: - UI
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ModelUser>!
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setCollectionView()
        createDataSource()
        reloadData()
    }
    
//MARK: - Methods
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
    
//MARK: - Set Collection
    private func setCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .mainWhite()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(ContactsCell.self, forCellWithReuseIdentifier: ContactsCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        view.addSubview(collectionView)
    }
    
//MARK: - ReloadData
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ModelUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(users, toSection: .users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - CompositionalLayout
extension ContactsViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] (index, environment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: index),
                  let self = self else { fatalError("Unknown section kind") }
            
            switch section {
            case .users:
                return self.createContactsSection()
            }
        }
        return layout
    }
    
//MARK: - Contacts Section
    private func createContactsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .fractionalWidth(0.6)),
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
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

//MARK: - DataSource
extension ContactsViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section),
                  let self = self else { return UICollectionViewCell() }
            switch section {
            case .users:
                return self.config(collectionView: collectionView, cellType: ContactsCell.self, with: itemIdentifier, for: indexPath)
            }
        })
        
        dataSource.supplementaryViewProvider = {[weak self] collection, kind, index in
            guard let sectionHeader = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: index) as? SectionHeader,
                  let self = self else { fatalError("Can not create new section header") }
            guard let section = Section(rawValue: index.section) else { fatalError("Unknown kind section") }
            let users = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configTitle(text: section.description(usersCount: users.count),
                                      font: .systemFont(ofSize: 35, weight: .light),
                                      textColor: .black)
            return sectionHeader
        }
    }
}

//MARK: - SearchBarDelegate
extension ContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
