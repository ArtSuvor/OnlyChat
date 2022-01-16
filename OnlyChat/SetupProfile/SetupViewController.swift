//
//  SetupViewController.swift
//  OnlyChat
//
//  Created by Art on 16.01.2022.
//

import UIKit

class SetupViewController: UIViewController {
    
//MARK: - UI elements
    
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - SwitfUI
import SwiftUI

struct SetuoViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = SetupViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
