//
//  PlaceInfoView.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class PlaceInfoView: UIView {
    
    class func initPlaceInfoWithTargetFrame(frame: CGRect) -> PlaceInfoView {
        
        let view: PlaceInfoView = Bundle.main.loadNibNamed("PlaceInfoView", owner: self, options: nil)?.last as! PlaceInfoView
        
        view.frame = frame
        
        return view
    }


}
