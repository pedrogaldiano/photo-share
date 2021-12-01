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
        edit.title = "Edit"
        edit.navigationItem.largeTitleDisplayMode = .always
        
        let navEdit = UINavigationController(rootViewController: edit)
        navEdit.tabBarItem = UITabBarItem(title: edit.title, image: UIImage(systemName: "house"), tag: 1)
        navEdit.navigationBar.prefersLargeTitles = true
        
        
        let shared = SharedController()
        shared.title = "Shared"
        shared.navigationItem.largeTitleDisplayMode = .always
        
        let navShared = UINavigationController(rootViewController: shared)
        navShared.tabBarItem = UITabBarItem(title: shared.title, image: UIImage(systemName: "photo"), tag: 1)
        navShared.navigationBar.prefersLargeTitles = true
        
        
        
        setViewControllers([navEdit, navShared], animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
