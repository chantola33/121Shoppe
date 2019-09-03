//
//  LoanViewModel.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/12/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoanViewModel
{
    var id: Int?
    
    var job: String = ""
    var average_income: String = ""
    var average_expense: String = ""
    var telephone: String = "077350356" //Thou Number
    var gender: String = ""
    var loan_purpose: String = ""
    var loan_amount: String = ""
    var loan_duration: String = ""
    var loan_interest_rate: String = "0.00"
    var username: String = "No"
    
    var state_id: Bool = false
    var family_book: Bool = false
    var staff_id: Bool = false
    var house_plant: Bool = false
    
    var loan_status: Int = 1
    var record_status: Int = 1
    var loan_to: Int = 0
    var post: Int = 0
    
    var created_by: Int = User.getUserID()
    var modified_by: Int = User.getUserID()
    
    init(){}
    
    init(json: JSON)
    {
        self.id = json["id"].stringValue.toInt()
        self.job = json["job"].stringValue
        self.average_income = json["average_income"].stringValue
        self.average_expense = json["average_expense"].stringValue
        
        self.loan_purpose = json["loan_purpose"].stringValue
        self.loan_amount = json["loan_amount"].stringValue
        self.loan_duration = json["loan_duration"].stringValue
        
        self.username = json["username"].stringValue
        self.state_id = json["state_id"].stringValue.jsonToBool()
        self.family_book = json["family_book"].stringValue.jsonToBool()
        self.staff_id = json["staff_id"].stringValue.jsonToBool()
        self.house_plant = json["house_plant"].stringValue.jsonToBool()
        
        self.loan_status = json["loan_status"].stringValue.toInt()
        self.loan_to = json["loan_to"].stringValue.toInt()
        self.record_status = json["record_status"].stringValue.toInt()
        
        self.loan_to = json["loan_to"].stringValue.toInt()
        self.post = json["post"].stringValue.toInt()
        self.created_by = json["created_by"].stringValue.toInt()
        
        self.telephone = json["telephone"].stringValue
        self.gender = json["gender"].stringValue
        self.loan_interest_rate = json["loan_interest_rate"].stringValue
    }
    
    func Save(completion: @escaping (Bool) -> Void)
    {
        Alamofire.request(PROJECT_API.LOAN,
                          method: .post,
                          parameters: self.asDictionary,
                          encoding: JSONEncoding.default,
                          headers: headers
            ).responseJSON { response in
                            switch response.result{
                            case .success(let value):
                                print(value)
                                completion(true)
                            case .failure:
                                completion(false)
                    }
        }
    }
    
    func Update(completion: @escaping (Bool) -> Void)
    {
        Alamofire.request("\(PROJECT_API.LOAN)\(self.id!)",
            method: .patch,
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
    
    static func Detail(loanID: Int, completion: @escaping (LoanViewModel) -> Void)
    {
        Alamofire.request("\(PROJECT_API.LOAN)\(loanID)",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    completion(LoanViewModel(json: json))
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func Delete(completion: @escaping (Bool) -> Void)
    {
        self.record_status = 2
        self.loan_status = 12
        
        Alamofire.request("\(PROJECT_API.LOAN)\(self.id!)",
                          method: .patch,
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
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
            guard label != nil else { return nil }
            return (label!,value)
        }).compactMap{ $0 })
        return dict
    }
}

private extension String
{
    func jsonToBool() -> Bool
    {
        if self == "true"{
            return true
        }
        else{
            return false
        }
    }
}

