//
//  PostList.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/7/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PostModel {
    
    var id: String
    var title: String
    var category: Int
    var status: String
    var condition: String
    var discountType: String
    var discount: Float
    var year: Int
    var modeling: Int
    var description: String
    var cost: Float
    var postType: String
    var vincode: Int
    var machine: Int
    var type: String
    var color: String
    
    init() {
        self.id = ""
        self.title = ""
        self.category = 0
        self.status = ""
        self.condition = ""
        self.discountType = ""
        self.discount  = 0.0
        self.year  = 0
        self.modeling = 0
        self.description = ""
        self.cost = 0.0
        self.postType = ""
        self.vincode = 0
        self.machine = 0
        self.type = ""
        self.color = ""
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        self.category = json["category"].intValue
        self.status = json["status"].stringValue
        self.condition = json["condition"].stringValue
        self.discountType = json["discountType"].stringValue
        self.discount  = json["discount"].floatValue
        self.year  = json["year"].intValue
        self.modeling = json["modeling"].intValue
        self.description = json["description"].stringValue
        self.cost = json["cost"].floatValue
        self.postType = json["id"].stringValue
        self.vincode = json["vincode"].intValue
        self.machine = json["machine"].intValue
        self.type = json["type"].stringValue
        self.color = json["color"].stringValue
    }
}
