//
//  SharedController.swift
//  Photo Share
//
//  Created by PEDRO GALDIANO DE CASTRO on 01/12/21.
//

import UIKit

class SharedController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 7
        return imageView
    }()
    lazy var images = { return [UIImage]() }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shared"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(imageView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewConstraints()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        

    }
    
        @objc func importImage() {
          let picker = UIImagePickerController()

          picker.allowsEditing = true
          picker.delegate = self

          present(picker, animated: true)
        }


        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          guard let image = info[.editedImage] as? UIImage else { return }
          dismiss(animated: true)
          images.insert(image, at: 0)
            collectionView.reloadData()
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell.")
        }
        
        let test = UIImage(
        
        cell.imageView.image = images[indexPath.item]
        cell.imageView.layer.borderColor = UIColor.black.cgColor

        
        return cell
        }
}


extension SharedController {
    
    func collectionViewConstraints(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}


    

extension SharedController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
}
