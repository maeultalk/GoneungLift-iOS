//
//  SearchViewController.swift
//  GoneungLift
//
//  Created by 김민아 on 18/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var lbPlaceName: UILabel!
    @IBOutlet weak var lbContent: UILabel!

    @IBOutlet weak var alcHeightOfPlaceName: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfContent: NSLayoutConstraint!

    func setSearchResult(placeName: String, content: String) {
        lbPlaceName.text = placeName
        lbContent.text = content
        lbContent.isHidden = false

        alcHeightOfPlaceName.constant = placeName.height(withConstrainedWidth: DEVICE_WIDTH() - 40, font: UIFont.systemFont(ofSize: 16.0))
        
        alcHeightOfContent.constant = content.height(withConstrainedWidth: DEVICE_WIDTH() - 40, font: UIFont.systemFont(ofSize: 15.0))
    }
    
    func setPlaceSearchResult(placeName: String) {
        lbPlaceName.text = placeName
        lbContent.isHidden = true
        alcHeightOfPlaceName.constant = 30.0
        alcHeightOfContent.constant = 0.0
    }
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var noResultView: UIView!
    
    @IBOutlet weak var alcHeightOfInputView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfNewPlaceView: NSLayoutConstraint!
    
    var placeList: [PlaceContents]! = []
    var searchList: [MainContents]! = []
    var isSearchResultPage: Bool! = false
    var searchWord: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchVC를 결과 화면으로 재사용
        if isSearchResultPage {
            alcHeightOfInputView.constant = 0.0
            alcHeightOfNewPlaceView.constant = 0.0
            loadPlaceContentList(place: searchWord)
            lbTitle.text = searchWord
        } else {
            loadPlaceList()
        }
        
    }
    
    func loadPlaceList() {
        NetManager().requestPlaceList(placeName: tfSearch.text!) { (results) in
            self.placeList = results
            self.tableView.reloadData()
        }
    }
    
    func loadPlaceContentList(place: String) {
        NetManager().requestPlaceContentsList(placeName: place) { (results) in
        
            self.searchList = results
            self.tableView.reloadData()
            
            self.noResultView.isHidden = self.searchList.count==0 ? false : true
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    //MARK: - UITableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        if isSearchResultPage {
            let data = searchList[indexPath.item]
            cell.setSearchResult(placeName: data.place_name, content: data.content)
        } else {
            let data = placeList[indexPath.item]
            cell.setPlaceSearchResult(placeName: data.name)
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchResultPage ? searchList.count : placeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearchResultPage {
            let titleHeight: CGFloat = searchList![indexPath.row].place_name.height(withConstrainedWidth: DEVICE_WIDTH() - 40, font: UIFont.systemFont(ofSize: 16.0))

            let contentHeight = searchList![indexPath.row].content.height(withConstrainedWidth: DEVICE_WIDTH() - 40, font: UIFont.systemFont(ofSize: 15.0))
            
            return titleHeight + contentHeight + 35.0
        }
        
//        let titleHeight = placeList![indexPath.row].name.height(withConstrainedWidth: DEVICE_WIDTH() - 70, font: UIFont.systemFont(ofSize: 16.0))

        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchResultPage {
            
        } else {
            let searchVC: SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "stid-searchVC") as! SearchViewController
            
            searchVC.isSearchResultPage = true
            searchVC.searchWord = placeList[indexPath.item].name
            
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tfSearch.resignFirstResponder()
    }
    //MARK: - User Action
    
    @IBAction func textfieldDidChaged(_ sender: UITextField) {
        loadPlaceList()
    }
    
    @IBAction func didTouchSearchButton(_ sender: UIButton) {
        
        let searchVC: SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "stid-searchVC") as! SearchViewController
        
        searchVC.isSearchResultPage = true
        searchVC.searchWord = tfSearch.text!
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func didTouchBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
