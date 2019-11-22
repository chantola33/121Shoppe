//
//  BannerModel.swift
//  VSMS
//
//  Created by usah on 11/22/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BannerModel {

    var id: Int = 0
    var wallpaper_image: String = ""
    var position: String = ""

    init() { }
    
    
    init(json: JSON) {
        self.id = json["id"].stringValue.toInt()
        self.wallpaper_image = json["wallpaper_image"].stringValue
        self.position = json["position"].stringValue
    }
}
