//
//  SharedController.swift
//  Photo Share
//
//  Created by PEDRO GALDIANO DE CASTRO on 01/12/21.
//

import UIKit

class SharedController: UIViewController {
    var images = [UIImage]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shared"
        view.backgroundColor = .systemBackground
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
    }
}

extension SharedController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
}
