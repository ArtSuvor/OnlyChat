//
//  ListViewController.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

struct ChatOnly: Hashable, Decodable {
    let userName: String
    let userImage: String
    let lastMessage: String
    let id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatOnly, rhs: ChatOnly) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListViewController: UIViewController {
    
    let chats: [ChatOnly] = [
    ChatOnly(userName: "afdads", userImage: UIImage(named: "human1")!, lastMessage: "adfgfdhjads"),
    ChatOnly(userName: "adklfjha", userImage: UIImage(named: "human2")!, lastMessage: "cvbahdfguarekhhviarhiaeri"),
    ChatOnly(userName: "dssdd", userImage: UIImage(named: "human3")!, lastMessage: " dgjhdfvadfvheruh hvuhdavfndjff")]
    
//MARK: - Enum Section
    enum Section: Int, CaseIterable {
        case activeChats
    }
    
//MARK: - UI elements
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatOnly>?
    
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
    
//MARK: - Set DataSource
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .activeChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .purple
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatOnly>()
        snapshot.appendSections([.activeChats])
        snapshot.appendItems(chats, toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - CompositionalLayout
extension ListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                            heightDimension: .absolute(88)),
                                                         subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
        }
        return layout
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
