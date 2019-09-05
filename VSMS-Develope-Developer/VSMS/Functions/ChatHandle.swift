//
//  ChatHandle.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/3/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class ChatHandle: MessageViewModel
{
    var isseen: String?
    var message: String?
    var post: String?
    var receiver: String?
    var sender: String?
    var type: String?
    
    override init(){
        super.init()
    }
    
    init(json: JSON)
    {
        self.isseen = json["isseen"].stringValue
        self.message = json["message"].stringValue
        self.post = json["post"].stringValue
        self.receiver = json["receiver"].stringValue
        self.sender = json["sender"].stringValue
        self.type = json["type"].stringValue
    }
    
    func Save(_ completion: @escaping (() -> Void))
    {
        if Auth.auth().currentUser != nil {
            let message = Database.database().reference().child(FireBaseRealTime.MESSAGE)
            message.childByAutoId().setValue(self.asDictionary) { (error, dbReferrenc) in
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
