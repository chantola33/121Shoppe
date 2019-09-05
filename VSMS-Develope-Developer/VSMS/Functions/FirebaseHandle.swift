//
//  FirebaseHandle.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/22/19.
//  Copyright © 2019 121. All rights reserved.
//

import Alamofire
import Foundation
import Firebase
import SwiftyJSON


class FireBaseRealTime
{
    static var USER = "users"
    static var POST = "Testing"
    static var MESSAGE = "Testing"
}


class UserFireBase
{
    var id: String = ""
    var username: String = ""
    var password: String = ""
    var imageURL: String = "default"
    var coverURL: String = "default"
    var search: String = ""
    var status: String = "online"
    
    init() { }
    
    init(json: JSON)
    {
        self.id = json["id"].stringValue
        self.username = json["username"].stringValue
        self.password = json["password"].stringValue
        self.search = json["search"].stringValue
        self.imageURL = json["imageURL"].stringValue
        self.coverURL = json["coverURL"].stringValue
        self.status = json["status"].stringValue
    }

    static func Load(_ completion: @escaping ((UserFireBase) -> Void))
    {
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if user != nil
            {
                let userFirebase = Database.database().reference().child(FireBaseRealTime.USER).child(user!.uid)
                userFirebase.observe(.value, with: { (snapShot) in
                    let data = JSON(snapShot.value as Any)
                    completion(UserFireBase(json: data))
                })
            }
        }
    }
    
    func Save(_ completion: @escaping (() -> Void))
    {
        let user = Database.database().reference().child(FireBaseRealTime.USER)
        user.child(self.id).setValue(self.asDictionary) { (error, dbReferrenc) in
            completion()
        }
    }
    
    func Update(_ completion: @escaping (() -> Void))
    {
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if user != nil
            {
                if user?.uid == self.id
                {
                    let userUpdate = Database.database().reference().child(FireBaseRealTime.USER).child(user!.uid)
                    userUpdate.setValue(self.asDictionary, withCompletionBlock: { (error, dbReference) in
                        completion()
                    })
                }
            }
        }
    }

    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }

}

class PostFireBase
{
    var id: String = "0"
    var coverUrl: String = ""
    var createdAt: String = ""
    var createdBy: String = ""
    var discountAmount: String = ""
    var discountType: String = ""
    var isProduction: Bool = false
    var location: String = ""
    var price: String = ""
    var status: Int = 3
    var title: String = ""
    var type: String = ""
    var viewCount: String = ""
    
    init() {}
    
    init(json: JSON)
    {
        self.id = json["id"].stringValue
        self.coverUrl = json["coverUrl"].stringValue
        self.createdAt = json["createdAt"].stringValue
        self.createdBy = json["createdBy"].stringValue
        self.discountAmount = json["discountAmount"].stringValue
        self.discountType = json["discountType"].stringValue
        self.isProduction = json["isProduction"].stringValue.StringToBoolean()
        self.location = json["location"].stringValue
        self.price = json["price"].stringValue
        self.status = json["status"].stringValue.toInt()
        self.title = json["title"].stringValue
        self.type = json["type"].stringValue
        self.viewCount = json["viewCount"].stringValue
    }
    
    init(PostJson: JSON)
    {
        self.id = PostJson["id"].stringValue
        self.coverUrl = PostJson["front_image_path"].stringValue
        self.createdAt = PostJson["created"].stringValue
        self.createdBy = PostJson["created_by"].stringValue
        self.discountAmount = PostJson["discount"].stringValue
        self.discountType = PostJson["discount_type"].stringValue
        self.isProduction = false
        self.location = PostJson["vin_code"].stringValue
        self.price = PostJson["cost"].stringValue
        self.status = PostJson["status"].stringValue.toInt()
        self.title = PostJson["title"].stringValue
        self.type = PostJson["post_type"].stringValue
        self.viewCount = "0"
    }
    
    static func Load(PostID: String, _ completion: @escaping ((PostFireBase) -> Void))
    {
        if Auth.auth().currentUser != nil {
            let userFirebase = Database.database().reference().child(FireBaseRealTime.POST).child(PostID)
            userFirebase.observe(.value, with: { (snapShot) in
                let data = JSON(snapShot.value as Any)
                completion(PostFireBase(json: data))
            })
        }
    }
    
    func Save(_ completion: @escaping (() -> Void))
    {
        if Auth.auth().currentUser != nil {
            let post = Database.database().reference().child(FireBaseRealTime.POST)
            post.child(self.id).setValue(self.asDictionary) { (error, dbReferrenc) in
                completion()
            }
        }
        else {
            print("Not authenticated")
        }
    }
    
    func Update(_ completion: @escaping (() -> Void))
    {
        if Auth.auth().currentUser != nil {
            let post = Database.database().reference().child(FireBaseRealTime.POST).child(self.id)
            post.setValue(self.asDictionary) { (error, dbReferrenc) in
                completion()
            }
        }
        else {
            print("Not authenticated")
        }
    }
    
    func Delete(_ completion: @escaping (() -> Void))
    {
        if Auth.auth().currentUser != nil {
            self.status = 2
            let post = Database.database().reference().child(FireBaseRealTime.POST).child(self.id)
            post.setValue(self.asDictionary) { (error, dbReferrenc) in
                completion()
            }
        }
        else {
            print("Not authenticated")
        }
    }
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
}


private extension String
{
    func StringToBoolean() -> Bool
    {
        if self == "false" {
            return false
        }
        return true
    }
}
