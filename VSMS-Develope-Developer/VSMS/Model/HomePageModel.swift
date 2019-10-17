//
//  HomePageModel.swift
//  VSMS
//
//  Created by Rathana on 7/9/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HomePageModel {
    
    var product: Int = -1
    var title: String = ""
    var category: Int = 0
    var cost: String = "0.0"
    var imagefront: String = ""
    var discount: String = "0.0"
    var postType: String = ""
    var create_at: String?
    var status: Int?
    var loanID: Int?
    var post_sub_title: String = ""
        
    init() {}
    
    init(id: Int, name: String, cost: String, imagefront: String, postSubTitle: String){
        self.product = id
        self.title = name
        self.cost = cost
        self.imagefront = imagefront
        self.post_sub_title = postSubTitle
    }
    
    init(id: Int, name: String, cost: String, imagefront: String,discount: String, postType: String, postSubTitle: String){
        self.product = id
        self.title = name
        self.cost = cost
        self.imagefront = imagefront
        self.discount = discount
        self.postType = postType
        self.post_sub_title = postSubTitle
    }
    
    init(id: Int, name: String, cost: String, imagefront: String,discount: String, postType: String, createdat: String, postSubTitle: String){
        self.product = id
        self.title = name
        self.cost = cost
        self.imagefront = imagefront
        self.discount = discount
        self.postType = postType
        self.create_at = createdat
        self.post_sub_title = postSubTitle
    }
    
    init(loanID: Int, postID: Int, title: String, cost: String, discount: String, imageFront: String, postType: String, created_by: String, postSubTitle: String)
    {
        self.loanID = loanID
        self.product = postID
        self.title = title
        self.cost = cost
        self.discount = discount
        self.imagefront = imageFront
        self.postType = postType
        self.create_at = created_by
        self.post_sub_title = postSubTitle
    }
    
    init(postID: Int){
        performOn(.HighPriority) {
            RequestHandle.LoadListProductByPostID(postID: postID) { (val) in
                self.product = val.product
                self.title = val.title
                self.category = val.category
                self.cost = val.cost
                self.discount = val.discount
                self.postType = val.postType
                self.imagefront = val.imagefront
                self.create_at = val.create_at
                self.post_sub_title = val.post_sub_title
            }
        }
        print("out")
    }
    
    init(json: JSON){
        self.product = json["id"].stringValue.toInt()
        self.title = json["title"].stringValue
        self.cost = json["cost"].stringValue
        self.discount = json["discount"].stringValue
        self.imagefront = json["front_image_path"].stringValue
        self.postType = json["post_type"].stringValue
        self.create_at = json["created"].stringValue
        self.status = json["status"].stringValue.toInt()
        self.post_sub_title = json["post_sub_title"].stringValue
    }
    
}



class RelatedFilter {
    var type: String = ""
    var category: String = ""
    var modeling: String = ""
    var min_price: String = ""
    var max_price: String = ""
    var years: String = ""
    
    init() {}
}


class SearchFilter{
    var search: String = ""
    var category: String = ""
    var brand: String = ""
    var year: String = ""
    var model: String = ""
    
    var modelings: [String] = []
    
    init() {}
}


