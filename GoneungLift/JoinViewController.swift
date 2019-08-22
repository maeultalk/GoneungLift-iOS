//
//  JoinViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit
import FirebaseAuth

class JoinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfNick: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    @IBOutlet weak var tfPwCheck: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    @IBAction func didTouchJoinButton(_ sender: UIButton) {
        
        didTouchBackGround(UIButton())

        NetManager().reqeustCheckDuplicateNick(nick: self.tfNick.text!) { (result) in
            if result == true {
                //중복
                ShowAlert(vc: self, tite: "중복된 닉네임입니다.", okTitle: "확인", okCompletion:{}, cancelTitle: "", cancelCompletion: {})
            }else {
                //가입 고고
                NetManager().reqeustAddUser(email: self.tfEmail.text! ,nick: self.tfNick.text!) { (result) in
                    Auth.auth().createUser(withEmail: self.tfEmail.text!, password: self.tfPw.text!) { authResult, error in
                        if error == nil {
                            
                            let user = Auth.auth().currentUser
                            
                            if let user = user {
                                let changeRequest = user.createProfileChangeRequest()
                                
                                changeRequest.displayName = self.tfNick.text!
                                
                                changeRequest.commitChanges { error in
                                    if error == nil {
                                        ShowAlert(vc: self, tite: "가입이 완료되었습니다.", okTitle: "확인", okCompletion:{
                                            self.dismiss(animated: true, completion: nil)
                                            //                            self.performSegue(withIdentifier: "sgMoveToLoginVC", sender: self)
                                        }, cancelTitle: "", cancelCompletion: {})
                                    }
                                }
                            }

                        }else {
                            print(error)
                        }
                    }
                
                    }
            }
        }
    }
    
    @IBAction func didTouchLoginButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchBackGround(_ sender: UIButton) {
        
        self.tfNick.resignFirstResponder()
        self.tfEmail.resignFirstResponder()
        self.tfPw.resignFirstResponder()
        self.tfPwCheck.resignFirstResponder()
    }
    
}
