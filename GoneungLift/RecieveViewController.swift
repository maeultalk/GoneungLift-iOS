//
//  RecieveViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 18/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var alcHeightOfTitle: NSLayoutConstraint!
    @IBOutlet weak var lbBadge: UILabel!
    @IBOutlet weak var alcWidthOfBadge: NSLayoutConstraint!
    @IBOutlet weak var alcTrailingOfBadge: NSLayoutConstraint!
    
    func cellTitle(title: String) {
        lbTitle.text = title
        alcHeightOfTitle.constant = title.height(withConstrainedWidth: DEVICE_WIDTH() - 40, font: UIFont.systemFont(ofSize: 15.0))
    }
    
    func setBadge(count: Int) {
        if count == 0 {
            lbBadge.isHidden = true
            alcTrailingOfBadge.constant = 0.0
            alcWidthOfBadge.constant = 0.0
        } else {
            lbBadge.text = "\(count)"
            alcWidthOfBadge.constant = 20.0
            alcTrailingOfBadge.constant = 5.0
            lbBadge.layer.cornerRadius = 10.0
            lbBadge.clipsToBounds = true
        }
    }
}

class RecieveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lbNick: UILabel!
    @IBOutlet weak var btnPlane: UIButton!
    
    var inboxList: [Inbox] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnProfile.layer.cornerRadius = 20.0
        btnProfile.clipsToBounds = true
        btnPlane.layer.cornerRadius = 25.0
        btnPlane.clipsToBounds = true
        
        lbNick.text = User.info.userNick

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetManager().requestInboxList { (results) in
            self.inboxList = results
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.performSegue(withIdentifier: "sgMoveToNewInboxVC", sender: self)
        
        return false
    }
    
    //MARK: - UITableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InboxCell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! InboxCell
        
        cell.cellTitle(title: inboxList[indexPath.row].subject)
        cell.setBadge(count: Int(inboxList[indexPath.row].badge)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = inboxList[indexPath.row]
        
        let maxWidth = data.badge=="0" ? DEVICE_WIDTH()-40 : DEVICE_WIDTH()-65
        
        let titleHeight = inboxList[indexPath.row].subject.height(withConstrainedWidth: maxWidth, font: UIFont.systemFont(ofSize: 15.0))
        
        return titleHeight + 30
    }
    
    var selectedIndex: Int! = 0
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        self.performSegue(withIdentifier: "sgMoveToInboxDetailVC", sender: self)
        
        let data = inboxList[selectedIndex]
        
        NetManager().requestResetInboxBadgeCount(inboxId: data.id)
    }
    
    @IBAction func didTouchNewInboxButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgMoveToNewInboxVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgMoveToInboxDetailVC" {
            let vc: RecieveDetailViewController = segue.destination as! RecieveDetailViewController
            vc.inboxId = inboxList[selectedIndex].id
            vc.inboxTitle = inboxList[selectedIndex].subject
            vc.isNewInbox = false

            vc.hidesBottomBarWhenPushed = true

        } else if segue.identifier == "sgMoveToNewInboxVC" {
            
            let vc: RecieveDetailViewController = segue.destination as! RecieveDetailViewController
            vc.hidesBottomBarWhenPushed = true
            vc.isNewInbox = true
        }
        
        
    }

}
