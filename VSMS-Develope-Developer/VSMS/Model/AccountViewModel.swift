//
//  AccountViewModel.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/6/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AccountViewModel {
    var id: Int?
    var username: String = User.getUsername()
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var group: [Int] = [1]
    var password: String = User.getPassword()
    var Shops :  [AccountShop] = []
   
    var ProfileData = AccountSubProfile()

    // shop field
    var shops: [[String: Any]] = [[:]]
    var user: Int?
    var shop_name: String = ""
    var shop_address: String = ""
    var shop_image: String = ""
    var record_status: Int?

    init(user: Int, shop_name: String, shop_address: String, shop_image: String) {
        self.user = user
        self.shop_name = shop_name
        self.shop_address = shop_address
        self.shop_image = shop_image
    }
    //
    var asDictionary : [String:Any] {
        let parameter: Parameters = [
            //"id": self.id ?? "",
            "first_name": self.firstname,
            //"lastname": self.lastname,
            "email": self.email,
            "groups": [self.group[0]],
            "password": self.password,
            "profile": self.ProfileData.asDictionary
        ]
        return parameter
    }
    
    var asShopDictionary : [String:Any] {
        let parameter: Parameters = [
            "user": self.user ?? 0,
            "shop_name": self.shop_name,
            "shop_address": self.shop_address,
            "shop_image": self.shop_image,
            "record_status": self.record_status ?? 1
        ]
        return parameter
    }
    
    var asRegisterDictionary : [String:Any] {
        let parameter: Parameters = [
            "username": self.username,
            "first_name": self.firstname,
            //"lastname": self.lastname,
            "email": self.email,
            "groups": [self.group[0]],
            "password": self.password,
            "profile": self.ProfileData.asDictionary
        ]
        return parameter
    }
    
    var asLoginDictionary: Parameters {
        let parameter: Parameters = [
            "username": self.username,
            "password": self.password
        ]
        return parameter
    }
    
    init() {}
    
    func LoadUserAccount(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.GETUSERDETAIL(ID: User.getUserID()),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let profile = json["profile"]
                   // let shop = JSON(value)
                    
                    self.id = json["id"].stringValue.toInt()
                    self.username = json["username"].stringValue
                    self.firstname = json["first_name"].stringValue
                    self.lastname = json["last_name"].stringValue
                    self.email = json["email"].stringValue
                    self.group = json["groups"].arrayValue.map{ $0.stringValue.toInt() }
                    self.ProfileData.gender = profile["gender"].stringValue
                    self.ProfileData.date_of_birth = profile["date_of_birth"].stringValue
                    self.ProfileData.telephone = profile["telephone"].stringValue
                    self.ProfileData.address = profile["address"].stringValue
                    self.ProfileData.province = profile["province"].stringValue.toInt()
                    self.ProfileData.marital_status = profile["marital_status"].stringValue
                    self.ProfileData.wing_account_name = profile["wing_account_name"].stringValue
                    self.ProfileData.wing_account_number = profile["wing_account_number"].stringValue
                    self.ProfileData.place_of_birth = profile["place_of_birth"].stringValue.toInt()
                    self.ProfileData.group = profile["group"].stringValue.toInt()
                    self.ProfileData.responsible_officer = profile["responsible_officer"].stringValue
                  
//                    self.shops = JSON(json["shops"]).arrayValue.map{ AccountShop(json: $0).ShopDictionary                    }
     
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func Shop(completion: @escaping (Bool) -> Void)
    {
        let headers: HTTPHeaders = [
            "Cookie": "",
            "Accept": "application/json",
            "Content-Type": "application/json",
            ]
        Alamofire.request(PROJECT_API.SHOP,
                          method: .post,
                          parameters: self.asShopDictionary,
                          encoding: JSONEncoding.default,
                          headers: headers
            ).responseJSON
            { response in
                switch response.result {
                case .success(let value): print("Success")
                        print(value)
//                        let json = JSON(value)
//                    if json["id"].stringValue == ""
//                    {
//                        completion(false)
//                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }
    func UpdateUserAccount(completion: @escaping () -> Void)
    {
        
        Alamofire.request(PROJECT_API.GETUSERDETAIL(ID: self.id!),
                          method: .patch,
                          parameters: self.asDictionary,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { (respone) in
                switch respone.result
                {
                case .success(let value):
                    print(value)
                    User.setNewFirstName(firstName: self.firstname)
                    completion()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func RegisterUser(completion: @escaping (Bool) -> Void)
    {
        let headers: HTTPHeaders = [
                        "Cookie": "",
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                    ]
        
        Alamofire.request(PROJECT_API.REGISTER,
                          method: .post,
                          parameters: self.asRegisterDictionary,
                          encoding: JSONEncoding.default,
                          headers: headers
            ).responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    print("Success")
                    print(value)
                    let json = JSON(value)
                    
                    if json["id"].stringValue == ""
                    {
                        completion(false)
                    }
                    else
                    {
                        User.setupNewUserLogIn(pk: json["id"].stringValue.toInt(),
                                               username: json["username"].stringValue,
                                               firstname: json["first_name"].stringValue,
                                               password: self.password)
                        completion(true)
                    }
                case .failure(let error):
                    print(error)
                    completion(false)
                }
                
        }
    }
    
    func LogInUser(completion: @escaping (Bool) -> Void)
    {
        let headers = [
            "Cookie": ""
        ]
        
        Alamofire.request(PROJECT_API.LOGIN,
                          method: .post,
                          parameters: self.asLoginDictionary,
                          encoding: JSONEncoding.default,
                          headers: headers
            ).responseJSON
            { response in
                
                if response.response?.statusCode == 400 {
                    // handle as appropriate
                    completion(false)
                    return
                }
                
                switch response.result
                {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    let user = JSON(json["user"])
                    User.setupNewUserLogIn(pk: user["pk"].stringValue.toInt(),
                                           username: user["username"].stringValue,
                                           firstname: user["first_name"].stringValue,
                                           password: self.password)
                    completion(true)
                case .failure(let error):
                    print(error)
                    print("log wrong")
                    completion(false)
                }
        }
    }
    
    static func IsUserExist(userName: String, fbKey: String, completion: @escaping (Bool) -> Void)
    {
        print(PROJECT_API.filterUsernameAndFacebookKey(username: userName, fbKey: fbKey))
        Alamofire.request(PROJECT_API.filterUsernameAndFacebookKey(username: userName, fbKey: fbKey),
            method: .get,
            encoding: JSONEncoding.default
            ).responseJSON { response in
                
                switch response.result{
                case .success(let value):
                    let check = JSON(value)
                    let count = check["count"].stringValue.toInt()
                    if count > 0 {
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}

class AccountShop{
    var id: Int?
    var user: Int?
    var shop_name: String = ""
    var shop_address: String = ""
    var shop_image: String = ""
    var record_status: Int?
    
    var ShopDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    init() {}
    init(id: Int, user: Int, shop_name: String, shop_address: String, shop_image: String, record_status: Int){
        self.id = id
        self.user = user
        self.shop_name = shop_name
        self.shop_address = shop_address
        self.shop_image = shop_image
        self.record_status = record_status
    }
    init(json: JSON) {
        self.id = json["id"].stringValue.toInt()
        self.user = json["user"].stringValue.toInt()
        self.shop_name = json["shop_name"].stringValue
        self.shop_address = json["shop_address"].stringValue
        self.shop_image = json["shop_image"].stringValue
        self.record_status = json["record_status"].stringValue.toInt()
    }
}
class AccountSubProfile{
    var gender: String = ""
    var date_of_birth: String = Date().iso8601
    var telephone: String = ""
    var address: String = ""
    var province: Int?
    var marital_status: String = ""
    var wing_account_name: String = ""
    var wing_account_number: String = ""
    var place_of_birth: Int?
    var responsible_officer: String = ""
    var group:Int?
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    init() {}
    
    
}
