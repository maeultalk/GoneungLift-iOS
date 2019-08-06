//
//  LoginViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTouchLoginButton(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "sgMoveToMainVC", sender: self)
    }
    
}
