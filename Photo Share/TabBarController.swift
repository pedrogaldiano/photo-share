//
//  TabBarController.swift
//  Photo Share
//
//  Created by PEDRO GALDIANO DE CASTRO on 01/12/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let edit = EditController()
        let shared = SharedController()
      
        let navEdit = UINavigationController(rootViewController: edit)
        let navShared = UINavigationController(rootViewController: shared)
      
        edit.title = "Edit"
        edit.navigationItem.largeTitleDisplayMode = .always
      
        shared.title = "Shared"
        shared.navigationItem.largeTitleDisplayMode = .always
        
        
        navEdit.tabBarItem = UITabBarItem(title: edit.title, image: UIImage(systemName: "pencil"), tag: 1)
        navEdit.navigationBar.prefersLargeTitles = true
        
        navShared.tabBarItem = UITabBarItem(title: shared.title, image: UIImage(systemName: "photo"), tag: 1)
        navShared.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navEdit, navShared], animated: false)
    }
}
