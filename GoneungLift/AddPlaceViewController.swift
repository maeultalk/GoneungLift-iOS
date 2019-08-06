//
//  AddPlaceViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 17/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class AddPlaceViewController: UIViewController {
    @IBOutlet weak var tfPlace: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchAddButton(_ sender: UIButton) {
        if tfPlace.text == "" {
            
            ShowAlert(vc: self, tite: "장소를 입력해주세요", okTitle: "확인", okCompletion:{}, cancelTitle: "", cancelCompletion: {})
            
        } else {
            
            ShowAlert(vc: self, tite: "장소를 등록하시겠습니까?", okTitle: "확인", okCompletion: {
                NetManager().requestNewPlace(placeName: self.tfPlace.text!) { (result) in
                    
                }

            }, cancelTitle: "취소", cancelCompletion: {})
        }
    }
}
