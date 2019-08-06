//
//  PlaceDetailViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var lbPlaceTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var alcLeadingOfIndicator: NSLayoutConstraint!
    
    var placeTitle: String!
    var placeCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnWrite.layer.cornerRadius = 25.0
        btnWrite.clipsToBounds = true
        
        scrollView.layoutIfNeeded()
        
        let placeListView = PlaceListView.initPlaceListViewWithTargetFrame(frame: CGRect(x: 0.0, y: 0.0, width: DEVICE_WIDTH(), height: scrollView.bounds.size.height), placeCode: placeCode)
        placeListView.parentVC = self
        
        let placeInfoView = PlaceInfoView.initPlaceInfoWithTargetFrame(frame: CGRect(x: DEVICE_WIDTH(), y: 0.0, width: DEVICE_WIDTH(), height: scrollView.bounds.size.height))
        
        scrollView.addSubview(placeListView)
        scrollView.addSubview(placeInfoView)
        
        scrollView.contentSize = CGSize(width: DEVICE_WIDTH()*2, height: scrollView.bounds.size.height)
        scrollView.isScrollEnabled = false
        
        lbPlaceTitle.text = placeTitle
    }
    
    @IBAction func didTouchTimeLineButton(_ sender: UIButton) {
        alcLeadingOfIndicator.constant = 0.0

        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func didTouchInfoButton(_ sender: UIButton) {
        alcLeadingOfIndicator.constant = sender.frame.size.width
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentOffset = CGPoint(x: DEVICE_WIDTH(), y: 0.0)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func didTouchStoreButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTouchBackButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sgMoveToWriteVC" {
            let writeVC = segue.destination as! WriteViewController
            writeVC.placeName = placeTitle
            writeVC.placeCode = placeCode
        }
    }

}
