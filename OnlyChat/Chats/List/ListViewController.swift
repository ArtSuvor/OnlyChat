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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cel")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
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
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .waitingChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cel", for: indexPath)
                cell.backgroundColor = .gray
                return cell
                
            case .activeChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .purple
                return cell
            }
        })
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
        return section
    }
    
//MARK: - WaitingChats
    private func createWaitingChatSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(88),
                                                                                          heightDimension: .absolute(88)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
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
