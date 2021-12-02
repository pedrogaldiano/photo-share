//
//  ViewController.swift
//  Photo Share
//
//  Created by PEDRO GALDIANO DE CASTRO on 01/12/21.
//

import UIKit

class EditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    lazy var imageView: UIImageView = { return UIImageView() }()
    lazy var editContainerImageView: UIView = { return UIView() }()
    lazy var intensity: UISlider = { return UISlider() }()
    lazy var prefersStyleButton: UIButton = { return UIButton() }()
    lazy var saveImageButton: UIButton = { return UIButton() }()
    lazy var currentFilter: CIFilter = { return CIFilter(name: "CISepiaTone")! }()
    lazy var context: CIContext = { return CIContext() }()
    lazy var currentImage: UIImage = { return UIImage() }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
          barButtonSystemItem: .add,
          target: self,
          action: #selector(addImageToEdit)
        )
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(
          barButtonSystemItem: .save,
          target: self,
          action: #selector(saveImage)
        )
     
        intensity.addTarget(self, action: #selector(intensityValueChanged), for: .valueChanged)
        
        addStylePrefersButton()
        prefersStyleButton.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
              
        imageView.translatesAutoresizingMaskIntoConstraints = false
        editContainerImageView.translatesAutoresizingMaskIntoConstraints = false
        intensity.translatesAutoresizingMaskIntoConstraints = false
        prefersStyleButton.translatesAutoresizingMaskIntoConstraints = false
      
        if imageView.image == nil {
          imageView.image = UIImage(named: "default-image")
          imageView.contentMode = .scaleAspectFit
        }
        
        editContainerImageView.addSubview(imageView)
        view.addSubview(editContainerImageView)
        view.addSubview(intensity)
        view.addSubview(prefersStyleButton)
        
        editContainerImageViewConstraints()
        addImageViewConstraints()
        addSliderViewConstraints()
        addChangeFilterConstraints()
    }
  
    @objc func addImageToEdit() {
      let picker = UIImagePickerController()
      
      picker.allowsEditing = true
      picker.delegate = self
      
      present(picker, animated: true)
    }
  
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let image = info[.editedImage] as? UIImage else { return }
  
      dismiss(animated: true)
      
      currentImage = image
      
      let beginImage = CIImage(image: currentImage)
      currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
      
      applyProcessing()
    }
  
    @objc func intensityValueChanged(sender: UISlider) {
      applyProcessing()
    }
  
    func applyProcessing() {
      let inputKeys = currentFilter.inputKeys

      if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
      if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
      if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
      if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
      
      guard let image = currentFilter.outputImage else {
        let alert = UIAlertController(
          title: "Error",
          message: "Does not exist an image for processing.",
          preferredStyle: .alert
        )
        
        alert.addAction(
          UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(alert, animated: true)
        return
      }
      
      if let cgimg = context.createCGImage(image, from: image.extent) {
        let processedImage = UIImage(cgImage: cgimg)
        imageView.image = processedImage
        imageView.contentMode = .scaleToFill
      }
    }
  
    @objc func changeFilter(_ sender: UIButton) {
      let alertController = UIAlertController(title: "Filters", message: nil, preferredStyle: .actionSheet)
        
      alertController.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
     
     //alertController.popoverPresentationController?.sourceView = imageView
        
      present(alertController, animated: true)
    }
  
    func setFilter(action: UIAlertAction) {
      guard let actionTitle = action.title else { return }
      
      currentFilter = CIFilter(name: actionTitle)!
      
      let beginImage = CIImage(image: currentImage)
      currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
      
      applyProcessing()
    }
  
    @objc func saveImage() {
      guard let image = imageView.image else {
        let alert = UIAlertController(
          title: "Error",
          message: "You can not save a non existent image!",
          preferredStyle: .alert
        )

        alert.addAction(
          UIAlertAction(
            title: "OK",
            style: .default
          )
        )
        
        present(alert, animated: true)
        return
      }
      
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
      if let error = error {
        // we got back an error!
        let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
      } else {
        let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos library.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
      }
    }
}



