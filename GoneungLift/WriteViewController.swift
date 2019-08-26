//
//  WriteViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class WriteViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lbPlaceName: UILabel!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lbNick: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnHideKeyboard: UIButton!
    
    @IBOutlet weak var image1View: UIView!
    @IBOutlet weak var image2View: UIView!
    @IBOutlet weak var image3View: UIView!
    
    var placeCode: String!
    var placeName: String!
    var content: String!
    var id: String!
    
    var defaultText: String!
    var isEdit: Bool! = false
    var imageList: [UIImage?] = []
    var imageNameList: [String?] = []
    
    @IBOutlet weak var alcWidthOfImageView3: NSLayoutConstraint!
    @IBOutlet weak var alcLeadingOfImageView3: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnProfile.layer.cornerRadius = 20.0
        lbNick.text = User.info.userNick
        textview.layer.borderColor = UIColor.lightGray.cgColor
        textview.layer.borderWidth = 0.5
        
        if isEdit {
            btnPost.setTitle("수정", for: .normal)
            textview.text = content
            lbDate.isHidden = true
            GetImage(imageName: imageNameList[0]) { (image) in
                
                if (image != nil) {
                    self.imageList.append(image)
                    self.updateImageSetting()
                }
            }
            
            GetImage(imageName: imageNameList[1]) { (image) in
                if (image != nil) {
                    self.imageList.append(image)
                    self.updateImageSetting()
                }            }
            
            GetImage(imageName: imageNameList[2]) { (image) in
                if (image != nil) {
                    self.imageList.append(image)
                    self.updateImageSetting()
                }
                
            }
            
        } else {
            image1View.isHidden = true
            image2View.isHidden = true
            image3View.isHidden = true
            
            lbDate.isHidden = true
            
            btnPost.setTitle("게시", for: .normal)
            
            defaultText = "'\(placeName!)'에는 어떤일이 있었나요?"
            textview.text = defaultText
        }
        
        lbPlaceName.text = placeName
        
        btnHideKeyboard.isHidden = true

    }

    // MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textview.text == defaultText {
            textview.text = ""
        }
        
        btnHideKeyboard.isHidden = false
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textview.text == "" {
            textview.text = defaultText
        }
        btnHideKeyboard.isHidden = true
        return true
    }

    @IBAction func didTouchHideKeyboard(_ sender: UIButton) {
        
        textview.resignFirstResponder()
        
    }
    
    func addImage(image: UIImage) {
        
        if imageList.contains(nil) {
            
            var index = 0
            
            for image in imageList {
                if image == nil {
                    imageList.remove(at: 0)
                }
                index += 1
            }
        }

        
        if imageList.count == 3 {
            return
        }
        
        imageList.append(image)
        updateImageSetting()
    }
    
    func updateImageSetting() {
        
        if imageList.count == 0 {
            image1View.isHidden = true
            image2View.isHidden = true
            image3View.isHidden = true

        } else if imageList.count == 1 {
            image1View.isHidden = false
            image2View.isHidden = true
            image3View.isHidden = true
            
            imageView1.image = imageList[0]
            
        } else if imageList.count == 2 {
            
            image1View.isHidden = false
            image2View.isHidden = false
            image3View.isHidden = true
            
            alcWidthOfImageView3.constant = 0.0
            alcLeadingOfImageView3.constant = 0.0
            
            imageView1.image = imageList[0]
            imageView2.image = imageList[1]
            
        } else if imageList.count == 3 {
            
            image1View.isHidden = false
            image2View.isHidden = false
            image3View.isHidden = false
            
            imageView1.image = imageList[0]
            imageView2.image = imageList[1]
            imageView3.image = imageList[2]
            
            alcWidthOfImageView3.constant = (DEVICE_WIDTH() - 5)/2
            alcLeadingOfImageView3.constant = 5.0
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.addImage(image: image)
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)

    }
    
    @IBAction func didTouchBackground(_ sender: UIButton) {
        
        if textview.isFirstResponder {
            textview.resignFirstResponder()
        }
    }
    // MARK: - User Action

    // button tag : 300, 301, 302
    @IBAction func didTouchDeleteButton(_ sender: UIButton) {
        
        if imageList.count == 0 { return }
        
        imageList.remove(at: sender.tag - 300)
        
        updateImageSetting()
    }
    
    @IBAction func didTouchPostButton(_ sender: UIButton) {
        
        if textview.text == "" { return }
        
        if isEdit {
            
            if imageList.count == 0 {
                imageList = [nil, nil, nil]
            } else if imageList.count == 1 {
                imageList = [imageList[0], nil, nil]
            } else if imageList.count == 2 {
                imageList = [imageList[0], imageList[1], nil]
            }
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyyMMdd"
            
            let dateString = formatter.string(from: Date())
            
            print(dateString)
            
            NetManager().requestModifyPost(id: id, placeCode: placeCode, content: textview.text, image1: imageList[0], imageName: "\(placeCode!)_\(dateString)_1", image2: imageList[1], imageName2: "\(placeCode!)_\(dateString)_2", image3: imageList[2], imageName3: "\(placeCode!)_\(dateString)_3") { (result) in
                
                
                
                
            }

        } else {
            
            if imageList.count == 0 {
                imageList = [nil, nil, nil]
            } else if imageList.count == 1 {
                imageList = [imageList[0], nil, nil]
            } else if imageList.count == 2 {
                imageList = [imageList[0], imageList[1], nil]
            }
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyyMMdd"
            
            let dateString = formatter.string(from: Date())
            
            print(dateString)
            
            NetManager().requestUploadPost(placeCode: placeCode, content: textview.text, image1: imageList[0], imageName: "\(placeCode!)_\(dateString)_1", image2: imageList[1], imageName2: "\(placeCode!)_\(dateString)_2", image3: imageList[2], imageName3: "\(placeCode!)_\(dateString)_3") { (result) in
                
                
                
                
            }
        }
    }
    
    @IBAction func didTouchCameraButton(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTouchAlbumButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    
    @IBAction func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
