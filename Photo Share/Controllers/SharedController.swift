import UIKit

class SharedController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    lazy var images = { return [UIImage]() }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
      
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 125, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      
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
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewConstraints()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
          barButtonSystemItem: .add,
          target: self,
          action: #selector(importImage)
        )
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
      
        cell.imageView.image = images[indexPath.item]
        cell.imageView.contentMode = .scaleToFill
        
        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
      
        cell.addSubview(cell.imageView)
        collectionView.addSubview(cell)
        
        NSLayoutConstraint.activate([
          cell.imageView.topAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.topAnchor),
          cell.imageView.bottomAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.bottomAnchor),
          cell.imageView.leftAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.leftAnchor),
          cell.imageView.rightAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.rightAnchor),
        ])

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
