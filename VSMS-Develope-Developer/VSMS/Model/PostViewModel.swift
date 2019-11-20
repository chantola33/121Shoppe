//
//  PostViewModel.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/4/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PostViewModel {
    var PostID: Int = -1
    var title: String = ""
    var post_type: String = ""
    var category: Int = 0
    var type: Int = 1
    var brand: Int = 0
    var modeling: Int = 0
    var year: Int = 0
    var condition: String = ""
    var color: String = ""
    var vin_code: String = ""
    var machine_code: String = ""
    var description: String = ""
    var cost: String = "0.0"
    var created_by: Int = User.getUserID()
    var discount_type: String = "amount"
    var discount: String = "0.0"
    var status: Int = 1
    var user: Int = User.getUserID()
    
    
    //var discount_type: String = ""
    var name: String = ""
    var contact_phone: String = User.getUsername()
    var contact_email: String = ""
    var contact_address: String = ""
    
    //Image
    var front_image_path: String?
    var front_image_base64: String?
    
    var right_image_path: String?
    var right_image_base64: String?
    
    var left_image_path: String?
    var left_image_base64: String?
    
    var back_image_path: String?
    var back_image_base64: String?
    
    //Array Post
    var sale_post: [[String: Any]] = [[:]]
    var rent_post: [[String: Any]] = [[:]]
    var buy_post: [[String: Any]] = [[:]]
    
    
    //helper fields
    var PostTypeVal: String?
    var CategoryVal: String?
    var TypeVal: String?
    var BrandVal: String?
    var ModelVal: String?
    var YearVal: String?
    var ConditionVal: String?
    var ColorVal: String?
    var DiscountTypeVal: String?
    var TitleVal: String?
    var PriceVal: String?
    var DiscountVal: String?
    var NameVal: String?
    var PhoneNumberVal: String?
    var EmailVal: String?
    var AddressVal: String?
    
    //Constructor
    init(){
        
    }
    
    func LoadPostByID(ID: Int, completion: @escaping (PostViewModel) -> Void)
    {
        let result = PostViewModel()
        let semephore = DispatchGroup()
        
        semephore.enter()
        Alamofire.request(PROJECT_API.LOADPRODUCTOFUSER(ProID: ID),
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers
        ).responseJSON
        { response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                
                //get master data
                result.PostID = json["id"].stringValue.toInt()
                result.title = json["title"].stringValue
                result.post_type = json["post_type"].stringValue
                result.category = json["category"].stringValue.toInt()
                result.type = json["type"].stringValue.toInt()
                result.brand = json["brand"].stringValue.toInt()
                result.modeling = json["modeling"].stringValue.toInt()
                result.year = json["year"].stringValue.toInt()
                result.condition = json["condition"].stringValue
                result.color = json["color"].stringValue
                result.description = json["description"].stringValue
                result.status = json["status"].stringValue.toInt()
                result.discount_type = json["discount_type"].stringValue
                result.discount = json["discount"].stringValue
                result.cost = json["cost"].stringValue
                result.user = json["created_by"].stringValue.toInt()
                
                result.contact_phone = json["contact_phone"].stringValue
                result.contact_email = json["contact_email"].stringValue
                result.contact_address = json["contact_address"].stringValue
                
                result.front_image_base64 = json["front_image_base64"].stringValue
                result.left_image_base64 = json["left_image_base64"].stringValue
                result.right_image_base64 = json["right_image_base64"].stringValue
                result.back_image_base64 = json["back_image_base64"].stringValue
                
                result.front_image_path = result.front_image_base64
                result.left_image_path = result.left_image_base64
                result.right_image_path = result.right_image_base64
                result.back_image_path = result.back_image_base64
                semephore.leave()
                
                if result.post_type == "sell"
                {
                    result.sale_post = JSON(json["sales"]).arrayValue.map{
                        SalePost(json: $0).asDictionary
                    }
                }
                else if result.post_type == "buy"
                {
                    result.buy_post = JSON(json["buys"]).arrayValue.map{
                        BuyPost(json: $0).asDictionary
                    }
                }
                else if result.post_type == "rents"
                {
                    result.rent_post = JSON(json["rents"]).arrayValue.map{
                        RentPost(json: $0).asDictionary
                    }
                }
                
                
                result.PostTypeVal = json["post_type"].stringValue.capitalizingFirstLetter()
                result.ConditionVal = result.condition.capitalizingFirstLetter()
                result.ColorVal = result.color.capitalizingFirstLetter()
                result.DiscountTypeVal = result.discount_type.capitalizingFirstLetter()
                result.TitleVal = result.title
                result.PriceVal = result.cost
                result.DiscountVal = result.discount
                result.PhoneNumberVal = result.contact_phone
                result.EmailVal = result.contact_email
                result.AddressVal = result.contact_address
                
                semephore.enter()
                Converts.getCategorybyID(id: result.category, completion: { (category) in
                    result.CategoryVal = category
                    semephore.leave()
                })
                
                semephore.enter()
                Converts.getTypebyID(id: result.type, completion: { (type) in
                    result.TypeVal = type
                    semephore.leave()
                })
                
                semephore.enter()
                Converts.getBrandbyModeID(id: result.modeling, completion: { (brand) in
                    result.BrandVal = brand
                    semephore.leave()
                })
                
                semephore.enter()
                Converts.getBrandIDbyModelID(ModelID: result.modeling.toString(), completion: { (brandID) in
                    result.brand = brandID.toInt()
                    semephore.leave()
                })
                
                semephore.enter()
                Converts.getModelbyID(id: result.modeling, completion: { (model) in
                    result.ModelVal = model
                    semephore.leave()
                })
                
                semephore.enter()
                Converts.getYearbyID(id: result.year, completion: { (year) in
                    result.YearVal = year
                    semephore.leave()
                })
                
                semephore.notify(queue: .main, execute: {
                    completion(result)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    init(json: JSON)
    {
        self.PostID = json["id"].stringValue.toInt()
        self.title = json["title"].stringValue
        self.post_type = json["post_type"].stringValue
        self.category = json["category"].stringValue.toInt()
        self.type = json["type"].stringValue.toInt()
        self.brand = json["brand"].stringValue.toInt()
        self.modeling = json["model"].stringValue.toInt()
        self.year = json["year"].stringValue.toInt()
        self.condition = json["condition"].stringValue
    }

    var asDictionary : [String:Any]
    {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    var asParameters: [String: Any]
    {
        let parameter: Parameters =
        [
            "id": self.PostID,
            "title": self.title,
            "post_type": self.post_type,
            "category": self.category,
            "type": self.type,
            "brand": self.brand,
            "modeling": self.modeling,
            "year": self.year,
            "condition": self.condition,
            "color": self.color,
            "description": self.description,
            "cost": self.cost,
            "discount_type": self.discount_type,
            "discount": self.discount,
            "status": self.status
        ]
        return parameter
    }
}

class SalePost {
    var id: Int = -1
    var sale_status: Int = 3
    var record_status: Int = 1
    var sold_date: Date?
    var price: String = ""
    var total_price: String = ""
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    init() {}
    
    init(id: Int, saleStatus: Int, recordStatus: Int, SoldDate: Date?, price: String, total: String) {
        self.id = id
        self.sale_status = saleStatus
        self.record_status = recordStatus
        self.sold_date = SoldDate
        self.price = price
        self.total_price = total
    }
    
    init(json: JSON)
    {
        self.id = json["id"].stringValue.toInt()
        self.sale_status = json["sale_status"].stringValue.toInt()
        self.record_status = json["record_status"].stringValue.toInt()
        //self.sold_date = json["sold_date"].stringValue.to
        self.price = json["price"].stringValue
        self.total_price = json["total_price"].stringValue
    }
}

class RentPost {
    var id: Int = -1
    var rent_status: Int = 3
    var record_status: Int = 1
    var rent_type: String = "month" //day,week,month
    var rent_date: Date?
    var return_date: Date?
    var price: String = ""
    var total_price: String = ""
    var rent_count_number: Int = 0
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    init() {}
    
    init(json: JSON){
        self.id = json["id"].stringValue.toInt()
        self.rent_status = json["rent_status"].stringValue.toInt()
        self.record_status = json["record_status"].stringValue.toInt()
        self.rent_type = json["rent_type"].stringValue
        self.price = json["price"].stringValue
        self.total_price = json["total_price"].stringValue
    }
}

class BuyPost {
    var id: Int = -1
    var buy_status: Int = 3
    var record_status: Int = 1
    var created: Date?
    //var post: Int = 3
    var total_price: String = ""
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    init() {}
    
    init(json: JSON){
        self.id = json["id"].stringValue.toInt()
        self.buy_status = json["buy_status"].stringValue.toInt()
        self.record_status = json["record_status"].stringValue.toInt()
        self.total_price = json["total_price"].stringValue
    }
}

//////////////////////

class PostAdViewModel
{
    var id: Int = -1
    
    //Detail
    var title: String = ""
    var post_type: String = ""
    var category: Int = 0
    var type: Int = 1
    var brand: Int = 0
    var modeling: Int = 0
    var year: Int = 0
    var condition: String = ""
    var color: String = ""
    var description: String = ""
    var cost: String = "0"
    // machine section
    var used_eta1: String = "0"
    var used_eta2: String = "0"
    var used_eta3: String = "0"
    var used_eta4: String = "0"
    
    var used_machine1: String = "0"
    var used_machine2: String = "0"
    var used_machine3: String = "0"
    var used_machine4: String = "0"
    var used_other1: String = "0"
    
    var left_right_enginecounter: String = "0"
    var engine_head: String = "0"
    var machine_assembly: String = "0"
    var console: String = "0"
    
    var accessories: String = "0"
    //Discount
    var discount_type: String = "amount"
    var discount: String = "0"

    ///User
    var machine_code: String = ""
    var user: Int = User.getUserID()
    var created_by: Int = User.getUserID()
    var modified_by: Int?
    var vin_code: String = ""
    
    //Contact
    var name: String = User.getfirstname()
    var contact_phone: String = User.getUsername()
    var contact_email: String = ""
    var contact_address: String = ""
    var post_sub_title: String = ""
    //Image
    var front_image_path: String?
    var front_image_base64: String?
    
    var right_image_path: String?
    var right_image_base64: String?
    
    var left_image_path: String?
    var left_image_base64: String?
    
    var back_image_path: String?
    var back_image_base64: String?
    
    var extra_image1: String?
    var extra_image2: String?
    
    //record
    var status: Int = 3
    var modified: Date?
    
    //Array Post
    var sale_post: [[String: Any]] = [[:]]
    var rent_post: [[String: Any]] = [[:]]
    var buy_post: [[String: Any]] = [[:]]
    
    //Object helper
    var sale: SalePost?
    var rent: RentPost?
    var buy: BuyPost?
    
    init(){}
    
    init(PostIDToDelete: Int)
    {
        self.id = PostIDToDelete
    }
    
    init(json: JSON)
    {
        self.id = json["id"].stringValue.toInt()
        //Detail
        self.title = json["title"].stringValue
        self.post_type = json["post_type"].stringValue
        self.category = json["category"].stringValue.toInt()
        self.type = json["type"].stringValue.toInt()
        self.brand = json["brand"].stringValue.toInt()
        self.modeling = json["modeling"].stringValue.toInt()
        self.year = json["year"].stringValue.toInt()
        self.condition = json["condition"].stringValue
        self.color = json["color"].stringValue
        self.description = json["description"].stringValue
        self.cost = json["cost"].stringValue
        
        self.post_sub_title = json["post_sub_title"].stringValue
        // machine section
        self.used_eta1 = json["used_eta1"].stringValue
        self.used_eta2 = json["used_eta2"].stringValue
        self.used_eta3 = json["used_eta3"].stringValue
        self.used_eta4 = json["used_eta4"].stringValue
        
        self.used_machine1 = json["used_machine1"].stringValue
        self.used_machine2 = json["used_machine2"].stringValue
        self.used_machine3 = json["used_machine3"].stringValue
        self.used_machine4 = json["used_machine4"].stringValue
        
        self.used_other1 = json["used_other1"].stringValue
        //Discount
        self.discount_type = json["discount_type"].stringValue
        self.discount = json["discount"].stringValue
        
        //Contact
        self.machine_code = json["machine_code"].stringValue // Using instead of Name of User in Post AD
        self.vin_code = json["vin_code"].stringValue //Using instead of Address Location 
        self.contact_phone = json["contact_phone"].stringValue
        self.contact_email = json["contact_email"].stringValue
        self.contact_address = json["contact_address"].stringValue
        
        
        //Photo
        self.front_image_path = json["front_image_path"].stringValue
        self.left_image_path = json["left_image_path"].stringValue
        self.right_image_path = json["right_image_path"].stringValue
        self.back_image_path = json["back_image_path"].stringValue
        self.extra_image1 = json["extra_image1"].stringValue
        self.extra_image2 = json["extra_image2"].stringValue
        //record
        self.user = json["user"].stringValue.toInt()
        self.status = json["status"].stringValue.toInt()
        
        
        if self.post_type == "sell"
        {
            self.sale = JSON(json["sales"]).arrayValue.map{
                SalePost(json: $0)
                }.first
        }
        else if self.post_type == "buy"
        {
            self.buy = JSON(json["buys"]).arrayValue.map{
                BuyPost(json: $0)
                }.first
        }
        else if self.post_type == "rent"
        {
            self.rent = JSON(json["rents"]).arrayValue.map{
                RentPost(json: $0)
            }.first
        }
        
    }
    
    func Load(PostID: Int, completion: @escaping (PostAdViewModel) -> Void)
    {
        Alamofire.request(PROJECT_API.LOADPRODUCT(ProID: PostID),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { response in
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    let result = PostAdViewModel(json: json)
                    completion(result)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func Save(completion: @escaping (Bool) -> Void)
    {
        self.AssignPostType()
        Alamofire.request(absolute_URL,
                          method: .post,
                          parameters: self.asDictionary,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { response in
                            switch response.result{
                            case .success(let value):
                                print(value)
                                let data = JSON(value)
                                if IsNilorEmpty(value: data["id"].stringValue) {
                                    print("something Wrong")
                                    completion(false)
                                    return
                                }
                                //Save post to Firebase
//                                let pfb = PostFireBase(PostJson: data)
//                                pfb.Save {
//                                    completion(true)
//                                }
                                completion(true)
                            case .failure(let error):
                                print(error)
                                completion(false)
                            }
        }.resume()
    }
    
    func Update(completion: @escaping (Bool) -> Void)
    {
        self.AssignBeforeUpdate()
        
        Alamofire.request("\(absolute_URL)\(self.id)/",
                          method: .patch,
                          parameters: self.asDictionary,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { response in
                            switch response.result{
                            case .success(let value):
                                print(value)
                                let data = JSON(value)
                                if IsNilorEmpty(value: data["id"].stringValue) {
                                    print("something Wrong")
                                    completion(false)
                                    return
                                }
                                //Update post to Firebase
//                                let pfb = PostFireBase(PostJson: data)
//                                pfb.Update {
//                                    completion(true)
//                                }
                                completion(true)
                            case .failure(let error):
                                print(error)
                                completion(false)
                            }
        }
    }
    
    static func Delete(PostID: Int, completion: @escaping (Bool) -> Void)
    {
        let para: Parameters = ["status": 2]
        Alamofire.request("\(PROJECT_API.UpdateProductStatus)\(PostID)/",
            method: .put,
            parameters: para,
            encoding: JSONEncoding.default,
            headers: httpHeader()
            ).responseJSON { response in
                switch response.result{
                case .success(let value):
                    print(value)
                    let data = JSON(value)
                    if IsNilorEmpty(value: data["id"].stringValue) {
                        print("something Wrong")
                        completion(false)
                        return
                    }
                    //Update Status Delete
                    PostFireBase.Load(PostID: data["id"].stringValue, { (Post) in
                        Post.Delete {
                            completion(true)
                        }
                    })
                case .failure(let error):
                    print(error)
                    completion(false)
                }
        }
    }
    
    var asDictionary : [String:Any]
    {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
    
    var absolute_URL: String
    {
        var URL = ""
        if self.post_type == "sell"
        {
            URL = PROJECT_API.POST_SELL
        }
        else if self.post_type == "buy"
        {
            URL = PROJECT_API.POST_BUYS
        }
        else if self.post_type == "rent"
        {
            URL = PROJECT_API.POST_RENTS
        }
        return URL
    }
    
    private func AssignPostType()
    {
        if self.post_type == "sell"
        {
            let postSell = SalePost()
            postSell.price = self.cost
            postSell.total_price = self.cost
            self.sale_post = [postSell.asDictionary]
        }
        else if self.post_type == "buy"
        {
            let postBuy = BuyPost()
            postBuy.total_price = self.cost
            self.buy_post = [postBuy.asDictionary]
        }
        else if self.post_type == "rent"
        {
            let postRent = RentPost()
            postRent.price = self.cost
            postRent.total_price = self.cost
            self.rent_post = [postRent.asDictionary]
        }
    }
    
    private func AssignBeforeUpdate()
    {
        if self.post_type == "sell"
        {
            sale?.price = self.cost
            sale?.total_price = self.cost
            self.sale_post = [sale!.asDictionary]
            self.sale = nil
        }
        else if self.post_type == "buy"
        {
            buy?.total_price = self.cost
            self.buy_post = [buy!.asDictionary]
            self.buy = nil
        }
        else if self.post_type == "rent"
        {
            rent?.price = self.cost
            rent?.total_price = self.cost
            self.rent_post = [rent!.asDictionary]
            self.rent = nil
        }
    }
}
