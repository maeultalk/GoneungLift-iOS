//
//  RecieveDetailViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 18/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

var maxLabelWidth: CGFloat = DEVICE_WIDTH() - 30.0 - 40.0 - 15.0
var maxWidth: CGFloat = DEVICE_WIDTH() - 30.0 - 40.0 - 5.0

class SendCell: UITableViewCell {
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var labelBaseView: UIView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var alcWidthOfContentView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfContentView: NSLayoutConstraint!

    func setContent(content: String) {
        labelBaseView.layer.cornerRadius = 3.0
        btnProfile.layer.cornerRadius = 20.0
        
        lbContent.text = content
        
        if content.width(withConstrainedHeight: UIFont.systemFont(ofSize: 13.5)) > maxLabelWidth {
            alcWidthOfContentView.constant = maxWidth
            alcHeightOfContentView.constant = content.height(withConstrainedWidth: maxLabelWidth, font: UIFont.systemFont(ofSize: 13.5)) + 24.0
        } else {
            alcWidthOfContentView.constant = content.width(withConstrainedHeight: UIFont.systemFont(ofSize: 13.5)) + 10.0
            alcHeightOfContentView.constant = 40.0
        }
    }
}

protocol RecieveCellDelegate: class {
    func didTouchPlaceDetailButton(index: Int)
}

class RecieveCell: UITableViewCell {
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbPlaceName: UILabel!
    @IBOutlet weak var imageBaseView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var contentsBaseView: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnPlaceDetail: UIView!
    var index: Int!
    
    @IBOutlet weak var alcHeightOfContentView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfPlaceName: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfMapView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfImageView: NSLayoutConstraint!
    @IBOutlet weak var alcWidthOfImage2: NSLayoutConstraint!
    @IBOutlet weak var alcTrailingOfImage2: NSLayoutConstraint!
    
    weak var delegate: RecieveCellDelegate!
    
    @IBAction func didTouchPlaceDetailButton(_ sender: UIButton) {
        self.delegate.didTouchPlaceDetailButton(index: index)
    }
    
    func setContent(content: String, placeName: String, mapCode: String) {
        contentsBaseView.layer.cornerRadius = 3.0
        ivProfile.layer.cornerRadius = 3.0
        
        lbContent.text = content
        
        alcHeightOfContentView.constant = content.height(withConstrainedWidth: maxLabelWidth, font: UIFont.systemFont(ofSize: 14.0)) + 84.0
        
        if placeName == "" {
            alcHeightOfPlaceName.constant = 0.0
        } else {
            lbPlaceName.text = placeName
            alcHeightOfPlaceName.constant = 40.0
            alcHeightOfContentView.constant += alcHeightOfPlaceName.constant
        }
        
        if mapCode == "" {
            alcHeightOfMapView.constant = 0.0
        } else {
            alcHeightOfMapView.constant = 30.0
            alcHeightOfContentView.constant += alcHeightOfMapView.constant
        }
    }

    func setImage(image: String, image2: String, image3: String) {

        if image == "" {
            alcHeightOfImageView.constant = 0.0
            imageBaseView.isHidden = true
            return
        }
        
        imageBaseView.isHidden = false
        SetImageView(imageView: imageView1, imageName: image)

        if image2 == "" {
            alcHeightOfImageView.constant = 120.0
        } else {
            alcHeightOfImageView.constant = 245.0
            SetImageView(imageView: imageView2, imageName: image2)
        }
        
        if image3 == "" {
            alcWidthOfImage2.constant = baseView.bounds.size.width
            
            alcTrailingOfImage2.constant = 0.0
        } else {
            alcWidthOfImage2.constant = (baseView.bounds.size.width-5)/2
            alcTrailingOfImage2.constant = 5.0
            SetImageView(imageView: imageView3, imageName: image3)
        }
        
        alcHeightOfContentView.constant += alcHeightOfImageView.constant
    }
}

class RecieveDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecieveCellDelegate, UITextFieldDelegate {

    var inboxId: String!
    var dataList: [InboxContents] = []
    var isNewInbox: Bool = false
    var inboxTitle: String!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfInput: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alcBottomOfInputView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewInbox {
            
        } else {
            lbTitle.text = inboxTitle
            reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    func reloadData() {
        NetManager().requestInboxDetail(inboxId: inboxId) { (result) in
            self.dataList = result
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Notification
    @objc func didRecieveNotification(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            let height = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).height
            
            self.view.setNeedsLayout()
            self.alcBottomOfInputView.constant = height
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

            self.view.setNeedsLayout()
            self.alcBottomOfInputView.constant = 0.0
            self.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)

            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchSendButton(_ sender: UIButton) {
        if tfInput.text == "" {
            return
        }
        
        if isNewInbox == true && dataList.count == 0 {
            
            NetManager().requestMakeNewInputBox(inputString: tfInput.text!) { (result) in
                if result != "-1" {
                    self.inboxId = result
                    self.reloadData()
                    self.isNewInbox = false
                }
                
                self.tfInput.text = ""
            }
        } else {
            NetManager().requestSendInput(inputString: tfInput.text!, inboxId: inboxId) { (result) in
                if result {
                    self.reloadData()
                }
                
                self.tfInput.text = ""
            }
        }
    }
    
    // MARK: - UITableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = dataList[indexPath.item]
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 15.0)
        tempLabel.text = data.contents
        
        if data.send == "send" {
            
            if tempLabel.intrinsicContentSize.width > maxWidth {
                return data.contents.height(withConstrainedWidth: maxLabelWidth, font: UIFont.systemFont(ofSize: 13.5)) + 44.0
            } else {
                return 60.0
            }
        } else if data.send == "receive" {
            
            var height = data.contents.height(withConstrainedWidth: maxLabelWidth, font: UIFont.systemFont(ofSize: 14.0)) + 104.0
            
            if data.place_name != "" {
                height += 40.0
            }
            
            if data.nmap != "" {
                height += 30.0
            }
            
            if data.image != "" {
                height += 120.0
            }
            
            if data.image2 != "" {
                height += 125.0
            }
            
            return height
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let data = dataList[indexPath.item]
        
        if data.send == "send" {
            let sendCell: SendCell = tableView.dequeueReusableCell(withIdentifier: "SendCell", for: indexPath) as! SendCell
            sendCell.setContent(content: data.contents)
            
            return sendCell
            
        } else if data.send == "receive" {
            let recieveCell: RecieveCell = tableView.dequeueReusableCell(withIdentifier: "RecieveCell", for: indexPath) as! RecieveCell
            recieveCell.setContent(content: data.contents, placeName: data.place_name, mapCode: data.nmap)
            recieveCell.setImage(image: data.image, image2: data.image2, image3: data.image3)
            
            recieveCell.index = indexPath.item
            
            recieveCell.delegate = self
            
            return recieveCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
 
    
    // MARK: - RecieveCellDelegate
    var selectedIndex: Int!
    
    func didTouchPlaceDetailButton(index: Int) {
  
        self.selectedIndex = index
        self.performSegue(withIdentifier: "sgMoveToPlaceDetailVC", sender: nil)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgMoveToPlaceDetailVC" {
            let placeDetailVC: PlaceDetailViewController = segue.destination as! PlaceDetailViewController
            
            let data = dataList[selectedIndex]

            placeDetailVC.hidesBottomBarWhenPushed = true
            placeDetailVC.placeCode = data.place_code
            placeDetailVC.placeTitle = data.place_name
            
        }
    }
}
