//
//  IntroViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit
import FirebaseAuth

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Data().getUserInfo().isUserInfo {
            
            Auth.auth().signIn(withEmail: Data().getUserInfo().email, password: Data().getUserInfo().pw) {  user, error in
                if error == nil {
                    
                    if let userInfo = Auth.auth().currentUser {
                        User.info.userNick = userInfo.displayName
                        User.info.userEmail = userInfo.email
                    }
                    
                    self.performSegue(withIdentifier: "sgMoveToMainVC", sender: self)

                    
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "stid-loginVC") as! LoginViewController
                    
                    loginVC.registerNoti()
                    
                    var controllers: Array = self.navigationController!.viewControllers
                    
                    controllers.insert(loginVC, at: controllers.count-1)
                    
                    self.navigationController?.viewControllers = controllers

                    
                    
                } else {
                    print(error)
                }
            }

            
        } else {
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                self.performSegue(withIdentifier: "sgMoveToLoginVC", sender: self)
            }

        }
    }

}
