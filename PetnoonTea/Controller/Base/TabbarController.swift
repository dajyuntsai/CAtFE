//
//  TabbarController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/27.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

private enum Tab {
    case home
    case shopEvent
    case rated
    case messageBoard
    case member

    func controller() -> UIViewController {
        var controller: UIViewController
        switch self {
        case .shopEvent:
            controller = UIStoryboard.shopEvent.instantiateInitialViewController()!
        case .rated:
            controller = UIStoryboard.rated.instantiateInitialViewController()!
        case .home:
            controller = UIStoryboard.home.instantiateInitialViewController()!
        case .messageBoard:
            controller = UIStoryboard.messageBoard.instantiateInitialViewController()!
        case .member:
            controller = UIStoryboard.member.instantiateInitialViewController()!
        }
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
}

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    private let tabs: [Tab] = [.shopEvent, .rated, .home, .messageBoard, .member]
    var trolleyTabBarItem: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.unselectedItemTintColor = .brown
        viewControllers = tabs.map({ $0.controller() })

        delegate = self
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let navVC = viewController as? UINavigationController,
              navVC.viewControllers.first is MemberViewController
        else { return true }

        return true
    }
}
