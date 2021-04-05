//
//  Coordinator.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 05/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    func start(id: String?)
    func goTo(route: Route)
}

enum Route {
    case Home
    case Detail(imdbId: String)
}

class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        
        self.window = window
        
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        
    }
    
    func start(id: String?) {
        if let imdbId = id {
            goTo(route: .Detail(imdbId: imdbId))
        } else {
            goTo(route: .Home)
        }
    }
    
    func goTo(route: Route) {
        switch route {
        case .Home:
            let viewController = ViewController()
            viewController.coordinator = self
            refreshView(vc: viewController)
            break
        case .Detail(let imdbId):
            let detailViewController = DetailViewController()
            detailViewController.coordinator = self
            detailViewController.imdbId = imdbId
            refreshView(vc: detailViewController)
            break
        }
    }
    
    func refreshView(vc: UIViewController) {
        rootViewController.pushViewController(vc, animated: false)
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
