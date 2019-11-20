//
//  StructTemplate.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/14/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import RSSelectionMenu
import TLPhotoPicker
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()

struct DropDownTemplate: Codable, UniquePropertyDelegate {
    let ID: String?
    let Text: String?
    let Text_kh: String?
    let Fkey: String?
    
    func getUniquePropertyName() -> String {
        return "ID"
    }
}

struct imageWithPLAsset {
    var image: UIImage
    var PLAsset: TLPHAsset?
    var selectedImage: UIImage?
}

class CustomImage: UIImageView
{
    var urlString = ""
    
    func LoadFromURL(url: String)
    {
        self.urlString = url
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            return
        }
        
        Alamofire.request(url, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                DispatchQueue.main.async {
                    if self.urlString == url
                    {
                        if let img = UIImage(data: responseData.data!){
                            self.image = img
                            imageCache.setObject(img, forKey: url as AnyObject)
                        }
                    }
                }
            })
    }
}


