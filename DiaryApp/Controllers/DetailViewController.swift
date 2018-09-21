//
//  DetailViewController.swift
//  DiaryApp
//
//  Created by Michele Mola on 07/09/2018.
//  Copyright © 2018 Michele Mola. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
  var type:Int!
  var context: NSManagedObjectContext?
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var emoticonImageView: UIImageView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var fenxiangbtn: UIButton!
    
  var entry: Entry?
  var emoticon: Emoticon = .happy
  
  lazy var photoPickerManager: PhotoPickerManager = {
    let manager = PhotoPickerManager(presentingController: self)
    manager.delegate = self
    return manager
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fenxiangbtn.isHidden = true
    if type == 1{
        fenxiangbtn.isHidden = false
    }
    configureView()
  }
  
    @IBAction func fxbtn(_ sender: UIButton) {
        let texstr = "\(contentTextView.text!)"
        let arr = ["\(texstr)"]
        let activtvc = UIActivityViewController.init(activityItems: arr, applicationActivities: nil)
        activtvc.excludedActivityTypes = [UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.assignToContact,UIActivityType.saveToCameraRoll]
        self.present(activtvc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func configureView() {
    contentTextView.delegate = self
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    imageView.addGestureRecognizer(tap)
    
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 40

    if let entry = entry {
      
      let stringDate = dateToString(entry.creationDate as Date)
      dateLabel.text = stringDate
      contentTextView.text = entry.contentText
    
      switch entry.emoticonStatus {
      case .bad:
        emoticonImageView.image = #imageLiteral(resourceName: "icn_bad")
      case .average:
        emoticonImageView.image = #imageLiteral(resourceName: "icn_average")
      case .happy:
        emoticonImageView.image = #imageLiteral(resourceName: "icn_happy")
      }
      
      checkCounter(text: contentTextView.text)
      
      imageView.image = entry.image
      addLocationButton.setTitle(" \(entry.locationName ?? "添加位置")", for: .normal)
      
    } else {
      
      let stringDate = dateToString(Date())
      dateLabel.text = stringDate
      contentTextView.text = "今天发生了什么事?"
      contentTextView.textColor = UIColor.lightGray
    }
    
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    photoPickerManager.presentPhotoPicker(animated: true)
  }
    
  func dateToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "zh_CN")
    let formattedDate = formatter.string(from: date)
    
    return formattedDate
  }
  
  @IBAction func savePressed(_ sender: UIBarButtonItem) {
    guard let context = context, let contentText = contentTextView.text else { return }
    
    let buttonTitle = addLocationButton.title(for: .normal)
    let locationName = buttonTitle == "  添加位置" ? nil : buttonTitle
    
    if let entry = entry {
      let _ = Entry.update(entry, withImage: imageView.image, locationName: locationName, content: contentText, emoticon: self.emoticon, in: context)
    } else {
      let _ = Entry.createWith(image: imageView.image, locationName: locationName, content: contentText, emoticon: self.emoticon, in: context)
    }
    
    do {
      try context.save()
      
      navigationController?.navigationController?.popViewController(animated: true)
    } catch let error as NSError {
      alertWith(title: "Alert", message: "保存失败")
      print("Could not save. \(error), \(error.userInfo)")
    }
    
  }
  
  @IBAction func changeEmoticon(_ sender: UIButton) {
    switch sender.tag {
    case 0:
      emoticonImageView.image = #imageLiteral(resourceName: "icn_bad")
      self.emoticon = .bad
    case 1:
      emoticonImageView.image = #imageLiteral(resourceName: "icn_average")
      self.emoticon = .average
    case 2:
      emoticonImageView.image = #imageLiteral(resourceName: "icn_happy")
      self.emoticon = .happy
    default:
      return
    }
  }
  
  func checkCounter(text: String) {
    let contentCount = text.count
    counterLabel.text = "\(contentCount) / 200"
    counterLabel.textColor = contentCount == 200 ? .red : .green
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }
  
  func alertWith(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "关闭", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showLocation" {
      if let vc = segue.destination as? LocationViewController {
        vc.delegate = self
      }
    }
  }
  
}

extension DetailViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "今天发生了什么事?"
      textView.textColor = UIColor.lightGray
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    checkCounter(text: textView.text)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    let currentText = textView.text ?? ""
    
    guard let stringRange = Range(range, in: currentText) else { return false }
    let changedText = currentText.replacingCharacters(in: stringRange, with: text)
    
    return changedText.count <= 200
  }
}

extension DetailViewController: PhotoPickerManagerDelegate {
  func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
    imageView.image = image
    
    manager.dismissPhotoPicker(animated: true, completion: nil)
  }
}

extension DetailViewController: LocationViewControllerDelegate {
  func location(withName name: String) {
    addLocationButton.setTitle(" \(name)", for: .normal)
  }
  
  
}

