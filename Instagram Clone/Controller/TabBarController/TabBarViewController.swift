//
//  TabBarViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: Variables
    static var shared = TabBarViewController()
    var userId = String()
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewControllers = viewControllers else {
            return
        }
        for viewController in viewControllers {
            if let navigation = viewController as? UINavigationController {
                if let chatView = navigation.viewControllers.first as? ChatViewController {
                    chatView.userId = userId
                }
            }
        }
    }
    

}
