//
//  UIViewController+Ext.swift
//  OnlyChat
//
//  Created by Art on 17.01.2022.
//

import UIKit

extension UIViewController {
    func config<T: ConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for index: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: index) as? T else {
            fatalError("Unknown section kind")
        }
        cell.configure(with: value)
        return cell
    }
    
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
