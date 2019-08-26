//
//  Data.swift
//  GoneungLift
//
//  Created by 김민아 on 16/07/2019.
//  Copyright © 2019 김민아. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    static let info = User()
    
    var userEmail: String!
    var userNick: String!
    
}

class Data: NSObject {

    override init() {
        UserDefaults.standard.register(defaults: ["user_email" : ""])
    }
    
    func getUserInfo() -> (isUserInfo: Bool, email: String, pw: String) {
        
        let email: String = UserDefaults.standard.value(forKey: "user_email") as! String
        
        if email == "" {
            return (false, "", "")
        } else {
            
            let pw = UserDefaults.standard.value(forKey: "user_pw") as! String
            
            return (true, email, pw)
        }
    }
    
    func setUserInfo(email: String, pw: String) {
        UserDefaults.standard.set(email, forKey: "user_email")
        UserDefaults.standard.set(pw, forKey: "user_pw")
    }
    
}

protocol JSONable {
    init?(parameter: JSON)
}
class InboxContents: JSONable {
    
    required init(parameter: JSON) {
        id = parameter["id"].stringValue
        inbox = parameter["inbox"].stringValue
        send = parameter["send"].stringValue
        place_code = parameter["place_code"].stringValue
        place_name = parameter["place_name"].stringValue
        contents = parameter["contents"].stringValue
        good = parameter["good"].stringValue
        image = parameter["image"].stringValue
        image2 = parameter["image2"].stringValue
        image3 = parameter["image3"].stringValue
        nmap = parameter["nmap"].stringValue
        collect = parameter["collect"].stringValue
        
    }
    
    var id: String! = ""
    var inbox: String! = ""
    var send: String! = ""
    var place_code: String! = ""
    var place_name: String! = ""
    var contents: String! = ""
    var good: String! = ""
    var image: String! = ""
    var image2: String! = ""
    var image3: String! = ""
    var nmap: String! = ""
    var collect: String! = ""
}

class MainContents: JSONable {
    
    required init(parameter: JSON) {
        id = parameter["id"].stringValue
        place_code = parameter["place_code"].stringValue
        email = parameter["email"].stringValue
        user = parameter["user"].stringValue
        date = parameter["date"].stringValue
        content = parameter["content"].stringValue
        comments = parameter["comments"].stringValue
        image = parameter["image"].stringValue
        image2 = parameter["image2"].stringValue
        image3 = parameter["image3"].stringValue
        good = parameter["good"].stringValue
        good_cnt = parameter["good_cnt"].stringValue
        favorite = parameter["favorite"].stringValue
        place_name = parameter["place_name"].stringValue

    }
    
    var id: String! = ""
    var place_code: String! = ""
    var email: String! = ""
    var user: String! = ""
    var date: String! = ""
    var content: String! = ""
    var comments: String! = ""
    var image: String! = ""
    var image2: String! = ""
    var image3: String! = ""
    var good: String! = ""
    var good_cnt: String! = ""
    var favorite: String! = ""
    var place_name: String! = ""
}

class Comments: JSONable {
    required init(parameter: JSON) {
        id = parameter["id"].stringValue
        email = parameter["email"].stringValue
        nick = parameter["nick"].stringValue
        date = parameter["date"].stringValue
        comment = parameter["comment"].stringValue
    }
    
    var id: String! = ""
    var email: String! = ""
    var nick: String! = ""
    var date: String! = ""
    var comment: String! = ""
}

class PlaceContents: JSONable {
    required init(parameter: JSON) {
        id = parameter["id"].stringValue
        code = parameter["code"].stringValue
        name = parameter["name"].stringValue
        type = parameter["type"].stringValue
    }
    
    var id: String! = ""
    var code: String! = ""
    var name: String! = ""
    var type: String! = ""
}

class Inbox: JSONable {
    required init(parameter: JSON) {
        id = parameter["id"].stringValue
        user = parameter["user"].stringValue
        subject = parameter["subject"].stringValue
        badge = parameter["badge"].stringValue
    }
    
    var id: String! = ""
    var user: String! = ""
    var subject: String! = ""
    var badge: String! = ""
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(parameter: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}

