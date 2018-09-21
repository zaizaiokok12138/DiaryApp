//
//  PhotoPickerManager.swift
//  DiaryApp
//
//  Created by Michele Mola on 12/09/2018.
//  Copyright © 2018 Michele Mola. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PhotoPickerManagerDelegate: class {
  func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

class PhotoPickerManager: NSObject {
  private let imagePickerController = UIImagePickerController()
  private let presentingController: UIViewController
  weak var delegate: PhotoPickerManagerDelegate?
  
  init(presentingController: UIViewController) {
    self.presentingController = presentingController
    super.init()
    
    configure()
  }
  
  func presentPhotoPicker(animated: Bool) {
    presentingController.present(imagePickerController, animated: animated, completion: nil)
  }
  
  func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
    imagePickerController.dismiss(animated: animated, completion: completion)
  }
  
  private func configure() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePickerController.sourceType = .camera
      imagePickerController.cameraDevice = .front
    } else {
      imagePickerController.sourceType = .photoLibrary
    }
    
    imagePickerController.mediaTypes = [kUTTypeImage as String]
    
    imagePickerController.delegate = self
  }
}


extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    delegate?.manager(self, didPickImage: image)
  }
}
