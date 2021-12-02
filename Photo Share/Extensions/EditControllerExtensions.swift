//
//  EditControllerExtensions.swift
//  Photo Share
//
//  Created by PEDRO GALDIANO DE CASTRO on 01/12/21.
//

import Foundation
import UIKit

extension EditController {
   func addStyleIntensitySlider() {
    intensity.minimumValue = 0
    intensity.maximumValue = 1
    intensity.isContinuous = true
    intensity.tintColor = UIColor.blue
    intensity.isUserInteractionEnabled = true
    intensity.value = 0
  }
  
   func addStyleEditContainerImageView() {
    editContainerImageView.layer.borderWidth = 2
    editContainerImageView.layer.borderColor = UIColor.gray.cgColor
    editContainerImageView.layer.cornerRadius = 5
   }
  
   func addStylePrefersButton() {
    prefersStyleButton.setTitle("Change Filter", for: .normal)
    prefersStyleButton.layer.backgroundColor = UIColor.systemBlue.cgColor
    prefersStyleButton.layer.cornerRadius = 5
    prefersStyleButton.setTitleColor(.white, for: .normal)
    prefersStyleButton.titleLabel?.font = .systemFont(ofSize: 28)
    prefersStyleButton.titleLabel?.adjustsFontSizeToFitWidth = true
  }
}

extension EditController {
   func editContainerImageViewConstraints() {
    NSLayoutConstraint.activate([
      editContainerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      editContainerImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),
      editContainerImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20),
      editContainerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
   func addImageViewConstraints() {
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: editContainerImageView.safeAreaLayoutGuide.topAnchor, constant: 4),
      imageView.bottomAnchor.constraint(equalTo: editContainerImageView.safeAreaLayoutGuide.bottomAnchor, constant: -4),
      imageView.trailingAnchor.constraint(equalTo: editContainerImageView.safeAreaLayoutGuide.trailingAnchor, constant: -4),
      imageView.leadingAnchor.constraint(equalTo: editContainerImageView.safeAreaLayoutGuide.leadingAnchor, constant: 4)
    ])
  }
  
   func addSliderViewConstraints() {
    NSLayoutConstraint.activate([
      intensity.widthAnchor.constraint(equalTo: editContainerImageView.widthAnchor, constant: -20),
      intensity.topAnchor.constraint(equalTo: editContainerImageView.bottomAnchor, constant: 10),
      intensity.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
    ])
  }
  
   func addChangeFilterConstraints() {
    NSLayoutConstraint.activate([
      prefersStyleButton.topAnchor.constraint(equalTo: intensity.bottomAnchor, constant: 20),
      prefersStyleButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      prefersStyleButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
      prefersStyleButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.10),
      prefersStyleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
    ])
  }
}
