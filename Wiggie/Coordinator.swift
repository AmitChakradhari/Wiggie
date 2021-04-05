//
//  Coordinator.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 05/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    func start()
}


class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        
        self.window = window
        
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        
    }
    
    func start() {
        let viewController = ViewController()
        viewController.coordinator = self
        rootViewController.pushViewController(viewController, animated: false)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func presentDetail(imdbId: String) {
        let detailViewController = DetailViewController()
        detailViewController.coordinator = self
        detailViewController.imdbId = imdbId
        rootViewController.pushViewController(detailViewController, animated: true)
    }
}
