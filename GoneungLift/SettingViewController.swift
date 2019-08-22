//
//  SettingViewContoller.swift
//  GoneungLift
//
//  Created by 김민아 on 01/08/2019.
//  Copyright © 2019 김민아. All rights reserved.
//
import UIKit
import Foundation
import FirebaseAuth
class SettingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lbNickname: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbNickname.text = User.info.userNick
        lbEmail.text = User.info.userEmail
    }
    
    @IBAction func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchLogoutButton(_ sender: Any) {

        ShowAlert(vc: self, tite: "로그아웃 하시겠습니까?", okTitle: "확인", okCompletion: {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout.notification"), object: nil, userInfo: nil)
            
            
        }, cancelTitle: "취소", cancelCompletion: {})
        
    }
    
    
}
