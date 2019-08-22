//
//  LoginViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: NSNotification.Name(rawValue: "logout.notification"), object: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        tfEmail.text = ""
        tfPw.text = ""
        
        tfPw.resignFirstResponder()
        tfEmail.resignFirstResponder()

    }
 
    @objc func didReceiveNotification() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchLoginButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: self.tfEmail.text!, password: self.tfPw.text!) {  user, error in
            if error == nil {
                print("통")
                
                if let userInfo = Auth.auth().currentUser {
                    User.info.userNick = userInfo.displayName
                    User.info.userEmail = userInfo.email
                }
                
                self.performSegue(withIdentifier: "sgMoveToMainVC", sender: self)
            } else {
                print(error)
            }
//

        }
    }
    
}
