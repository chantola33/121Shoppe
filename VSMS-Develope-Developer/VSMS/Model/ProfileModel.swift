//
//  ProfileModel.swift
//  VSMS
//
//  Created by Rathana on 7/6/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ProfileModel {
    
    var PosID: Int = -1
    var title: String = ""
    var category: Int = 0
    var condition: String = ""
    var cost: String = "0.0"
    var base64Img: String = ""
    var frontImage: UIImage?
   
    
    init() {}
    
    init(id: Int, name: String, cost: String, base64Img: String){
        self.PosID = id
        self.title = name
        self.cost = cost
        self.base64Img = base64Img
        
    }
    
    init(json: JSON){
        self.PosID = json["id"].stringValue.toInt()
        self.title = json["title"].stringValue
        self.category = json["category"].stringValue.toInt()
        self.cost = json["cost"].stringValue
        self.base64Img = json["front_image_base64"].stringValue
        
    }
}


struct Profile {
    var ID: String
    var Name: String
    var PhoneNumber: String
    var Profile: UIImage
    var email: String
    var Address: String
    var Address_Name: String
}

class ImageProfileModel {
    
    var profileID : String = ""
    var name: String = ""
    var firstName: String = ""
    var email: String = ""
    var address: String = ""
    var address_Name: String = ""
    var profile: ImageSubClass = ImageSubClass()
    
    init(){}
    
    init(json: JSON){
        self.profileID = json["id"].stringValue
        self.name = json["username"].stringValue
        self.firstName = json["first_name"].stringValue
        self.profile = ImageSubClass(json: json["profile"])
        self.email = json["email"].stringValue
        self.address = json["address"].stringValue
        self.address_Name = json["responsible_officer"].stringValue
    }
    
}


class ImageSubClass {
    var telephone: String = ""
    var profile_image: String = ""
    var cover_image: String = ""
    var address: String = ""
    var address_name: String = ""
    
    init(){}
    
    init(json: JSON){
        self.telephone = json["telephone"].stringValue
        self.profile_image = json["profile_photo"].stringValue
        self.cover_image = json["cover_photo"].stringValue
        self.address = json["address"].stringValue
        self.address_name = json["responsible_officer"].stringValue
    }
}



class LikebyUserModel {
    
    var post: Int = -1
    var likeby:  Int = -1
    var pro_detail = ProfileModel()
    var productShow = HomePageModel()
    
    init() {}
    
    init(post: Int,likeby: Int){
        self.post = post
        self.likeby = likeby
        
        performOn(.HighPriority) {
            DetailViewModel.LoadProductByIDOfUser(ProID: self.post) { (val) in
                self.pro_detail.PosID = val.id
                self.pro_detail.title = val.title
                self.pro_detail.cost = val.cost
                self.pro_detail.frontImage = val.front_image_base64
            }
        }
    }
    
    init(json: JSON) {
        self.post = json["post"].stringValue.toInt()
        self.likeby = json["like_by"].stringValue.toInt()
    }
    
    
    func getListProduct(json: JSON){
        self.post = json["post"].stringValue.toInt()
        self.likeby = json["like_by"].stringValue.toInt()
        
        performOn(.HighPriority) {
            RequestHandle.LoadListProductByPostID(postID: self.post, completion: { (val) in
                self.productShow = val
            })
        }
    }
}
