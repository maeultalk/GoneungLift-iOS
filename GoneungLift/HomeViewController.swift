//
//  HomeViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 15/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnWrite: UIButton!
    
    var dataList: [MainContents]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        btnWrite.layer.cornerRadius = 25.0
        
        loadMainList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMainList()
    }

    //MARK: - UserAction
    @IBAction func didTouchReloadButton(_ sender: UIButton) {
        loadMainList()
    }
    
    //MARK: - HomeCellDelegate
    func didTouchLikeButton(isLike: Bool, index: NSInteger) {
        
        let data = dataList[index] as MainContents
        
        if isLike {
            NetManager().requestLike(contentId: data.id) { (result) in
                if result {
                    self.loadMainList()
                }
            }
        } else {
            NetManager().requestUnlike(contentId: data.id) { (result) in
                if result {
                    self.loadMainList()
                }
            }
        }
    }
    
    func didTouchMoreButton(index: NSInteger) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "수정", style: .default , handler:{ (UIAlertAction)in
            print("수정")
            
            let writeVC = self.storyboard?.instantiateViewController(withIdentifier: "stid-writeVC") as! WriteViewController
            let data = self.dataList![index] as MainContents

            writeVC.isEdit = true
            
            writeVC.placeCode = data.place_code
            writeVC.placeName = data.place_name
            writeVC.content = data.content
            writeVC.imageNameList = [data.image, data.image2, data.image3]
            writeVC.id = data.id

            writeVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(writeVC, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .default , handler:{ (UIAlertAction)in
            print("삭제")
            
            let data = self.dataList![index] as MainContents
            
            NetManager().requestDeletePost(id:data.id , result: { (result) in
                self.loadMainList()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .destructive , handler:{ (UIAlertAction)in
            print("취소")
        }))
        
        self.present(alert, animated: true, completion:nil)

    }
    
    func didTouchCommentButton(index: NSInteger) {
        let replyVC: ReplyViewController = self.storyboard?.instantiateViewController(withIdentifier: "stid-replyVC") as! ReplyViewController
        replyVC.hidesBottomBarWhenPushed = true
        replyVC.postId = dataList[index].id

        self.navigationController?.pushViewController(replyVC, animated: true)
    }
    
    func didTouchPlaceButton(inex: NSInteger) {
        
        let detailVC: PlaceDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "stid-placeDetailVC") as! PlaceDetailViewController
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.placeCode = dataList![inex].place_code
        detailVC.placeTitle = dataList![inex].place_name
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: - UICollectionViewDelegate/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.delegate = self
        cell.index = indexPath.item
        
        let data = dataList![indexPath.item] as MainContents
        
        cell.setContents(title: data.place_name, contents: data.content)
        cell.setUserProfile(profile: "", nick: data.user, time: data.date, email: data.email)
        cell.setImageView(image1: data.image, image2: data.image2, image3: data.image3)
        cell.setLike(isFavorite: Bool(data.favorite)!)
        cell.lbCount.text = data.comments
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //temp
        return CGSize(width: DEVICE_WIDTH(), height: heightOfCell(contents: dataList[indexPath.item]))
    }
    
    //MARK: - PrivateMethod
    func loadMainList() {
        NetManager().requestMainList(userEmail: User.info.userEmail) { (result) in
            self.dataList = result
            self.collectionView.reloadData()
        }
    }
    
    func heightOfCell(contents: MainContents) -> CGFloat {
        
        var height: CGFloat = 0.0
        // 40 + 50 + 40 + 20
        let defaltHeight: CGFloat = 150.0
        
        height += defaltHeight
        
        height += contents.content.height(withConstrainedWidth: DEVICE_WIDTH() - 30, font: UIFont.systemFont(ofSize: 15.0))
        
        if contents.image == "" {
            return height
        } else {
            height += 120.0
        }
        
        if contents.image2 == "" {
            return height
        } else {
            height += 125.0
        }
        
        return height
    }
    
    
}
