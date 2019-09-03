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
        
    init() {}
    
    init(id: Int, name: String, cost: String, imagefront: String){
        self.product = id
        self.title = name
        self.cost = cost
        self.imagefront = imagefront
    }
    
    init(id: Int, name: String, cost: String, imagefront: String,discount: String, postType: String){
        self.product = id
        self.title = name
        self.cost = cost
        self.imagefront = imagefront
        self.discount = discount
        self.postType = postType
    }
    
    init(id: Int, name: String, cost: String, imagefront: String,discount: String, postType: String, createdat: String){
        self.product = id
        self.title = name
        self.cost = cost
        self.imagefront = imagefront
        self.discount = discount
        self.postType = postType
        self.create_at = createdat
    }
    
    init(loanID: Int, postID: Int, title: String, cost: String, discount: String, imageFront: String, postType: String, created_by: String)
    {
        self.loanID = loanID
        self.product = postID
        self.title = title
        self.cost = cost
        self.discount = discount
        self.imagefront = imageFront
        self.postType = postType
        self.create_at = created_by
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
    }
    
}



class RelatedFilter {
    var type: String = ""
    var category: String = ""
    var modeling: String = ""
    var min_price: String = ""
    var max_price: String = ""
    
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


