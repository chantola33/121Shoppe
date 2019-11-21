//
//  CountViewModel.swift
//  VSMS
//
//  Created by usah on 11/21/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class CountViewModel {
    
    var number: Int = 0
    var post: Int = 0
  
    init(){}
    
    init(json: JSON) {
        self.number = json["number"].stringValue.toInt()
        self.post = json["post"].stringValue.toInt()
        
    }
  
    func SubmitCountView(completion: @escaping (Bool) -> Void )
    {
        Alamofire.request(PROJECT_API.SUBMIT_COUNTVIEW,
                          method: .post,
                          parameters: self.asDictionary,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { response in
                switch response.result{
                case .success(let value):
                    print(value)
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
                
        }
    }
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) ->
            (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
}
