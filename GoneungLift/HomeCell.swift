//
//  HomeCell.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

protocol HomeCellDelegate: class {
    
    func didTouchLikeButton(isLike: Bool, index: NSInteger)
    func didTouchCommentButton(index: NSInteger)
    func didTouchPlaceButton(inex: NSInteger)
    func didTouchMoreButton(index: NSInteger)
}

class HomeCell: UICollectionViewCell {
    
    var index: NSInteger! = 0
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbNick: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbContents: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var lbPlace: UILabel!
    @IBOutlet weak var imageBaseView: UIView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    var isLike: Bool! = false
    @IBOutlet weak var btnLikeIcon: UIButton!
    @IBOutlet weak var lbLike: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var alcHeightOfPlaceView: NSLayoutConstraint!
    @IBOutlet weak var alcTrailingOfImageView2: NSLayoutConstraint!
    @IBOutlet weak var alcWidthOfImageView3: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfImageBaseView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfContents: NSLayoutConstraint!
    
    weak var delegate: HomeCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnProfile.layer.cornerRadius = 20.0
    }
    
    func setUserProfile(profile: String, nick: String, time: String, email: String) {
        SetImageView(imageView: ivProfile, imageName: profile)
        
        ivProfile.sd_setImage(with: URL.init(string: profile), completed: nil)
        lbNick.text = nick
        lbTime.text = time
        
        btnMore.isHidden = email == User.info.userEmail ? false : true
    }
    
    func setContents(title: String, contents: String) {
        
        if title == "" {
            alcHeightOfPlaceView.constant = 0.0
        } else {
            alcHeightOfPlaceView.constant = 40.0
        }
        lbPlace.text = title
        lbContents.text = contents
        
        alcHeightOfContents.constant = contents.height(withConstrainedWidth: DEVICE_WIDTH() - 30, font: UIFont.systemFont(ofSize: 15.0))
    }
    
    func setLike(isFavorite: Bool) {
        
        isLike = isFavorite
        
        if isFavorite {
            let yellowColor = UIColor(red: 253/255.0, green: 203/255.0, blue: 56/255.0, alpha: 1.0)
            lbLike.textColor = yellowColor
            btnLikeIcon.tintColor = yellowColor

        } else {
            lbLike.textColor = .darkGray
            btnLikeIcon.tintColor = .darkGray
        }
    }
    
    func setImageView(image1: String, image2: String, image3: String) {
        
        // 이미지 갯수에 따라서 레이아웃 변경
        if image1 == "" {
            alcHeightOfImageBaseView.constant = 0.0
            imageBaseView.isHidden = true
            return
            
        } else {
            imageBaseView.isHidden = false
            alcHeightOfImageBaseView.constant = 120.0
            
            SetImageView(imageView: imageView1, imageName: image1)
        }
        
        if image2 == "" {
            return
        } else {
            alcHeightOfImageBaseView.constant = 245.0
            
            SetImageView(imageView: imageView2, imageName: image2)
        }
        
        if image3 == "" {
            alcTrailingOfImageView2.constant = 0.0
            alcWidthOfImageView3.constant = 0.0
            return
        } else {
            alcTrailingOfImageView2.constant = 5.0
            alcWidthOfImageView3.constant = (DEVICE_WIDTH()-5)/2
            
            SetImageView(imageView: imageView3, imageName: image3)
        }
    }
    
    @IBAction func didTouchPlaceButton(_ sender: UIButton) {
        self.delegate.didTouchPlaceButton(inex: index)
    }
    
    @IBAction func didTouchLikeButton(_ sender: UIButton) {
        self.delegate.didTouchLikeButton(isLike: !isLike, index: index)
    }
    
    @IBAction func didTouchCommentButton(_ sender: UIButton) {
        self.delegate.didTouchCommentButton(index: index)
    }
    
    @IBAction func didTouchShareButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTouchMoreButton(_ sender: UIButton) {
        self.delegate.didTouchMoreButton(index: index)
    }
}
