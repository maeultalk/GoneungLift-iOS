//
//  ReplyViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ReplyCellDelegate: class {
    func didTouchModifyButton(index: Int)
}

class ReplyCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var lbNick: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var btnModify: UIButton!
    
    weak var delegate: ReplyCellDelegate!
    var index: Int! = 0
    
    @IBAction func didTouchModifyButton(_ sender: UIButton) {
        delegate.didTouchModifyButton(index: index)
    }
}

class ReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, ReplyCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfReply: UITextField!
    
    var replyList: NSArray!
    var postId: String!
    var commentList: [Comments] = []
    
    @IBOutlet weak var alcBottomOfInputView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfReply.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        requestReplyList()
    }
    
    //MARK: - PrivateMethods
    func requestReplyList() {
        NetManager().requestReplyList(postId: postId) { (results) in
            self.commentList = results
            self.tableView.reloadData()
        }
    }
    
    var modifyComment: Bool! = false
    var commentId: String!
    
    //MARK: - ReplyCellDelegate
    func didTouchModifyButton(index: Int) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "수정", style: .default , handler:{ (UIAlertAction)in
            print("수정")
            
            self.commentId = self.commentList[index].id
            self.modifyComment = true
            self.tfReply.text = self.commentList[index].comment
            self.tfReply.becomeFirstResponder()
            
        }))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .default , handler:{ (UIAlertAction)in
            print("삭제")
            
            self.commentId = self.commentList[index].id
            NetManager().requestDeleteComment(commentId: self.commentId, contentId: self.postId, result: { (result) in
                self.requestReplyList()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .destructive , handler:{ (UIAlertAction)in
            print("취소")
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UserAction
    @IBAction func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchSendButton(_ sender: UIButton) {
        if tfReply.text == "" { return }
        
        if modifyComment == true {
            let alert = UIAlertController(title: "수정하시겠습니까?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "수정", style: .default , handler:{ (UIAlertAction)in
                
                NetManager().requestModifyComment(commentId: self.commentId, comment: self.tfReply.text!, result: { (result) in
                    if result {
                        self.modifyComment = false
                        self.tfReply.text = ""
                        self.requestReplyList()
                    }
                })
            }))
            
            alert.addAction(UIAlertAction(title: "취소", style: .destructive , handler:{ (UIAlertAction)in
                self.modifyComment = false
                alert.dismiss(animated: true, completion: nil)
                
            }))

            self.present(alert, animated: true, completion:nil)

        } else {
            
            NetManager().requestWriteNewComment(postId: postId, userEmail: User.info.userEmail, comments: tfReply.text!) { (result) in
                
                print(result)
                if result {
                    self.tfReply.text = ""
                    self.requestReplyList()
                }
            }
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
    
    //MARK: - UITableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReplyCell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
        
        let data = commentList[indexPath.row]
        
        cell.lbNick.text = data.nick
        cell.lbTime.text = data.date
        cell.lbComment.text = data.comment
        cell.btnModify.isHidden = data.email==User.info.userEmail ? false : true
        cell.index = indexPath.item
        cell.delegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        let height = commentList[indexPath.row].comment.height(withConstrainedWidth: DEVICE_WIDTH() - 20, font: UIFont.systemFont(ofSize: 15.0))
        
        return 55.0 + height
    }

}
