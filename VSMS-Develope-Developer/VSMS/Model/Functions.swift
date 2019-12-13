//
//  Functions.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/4/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Photos

var http_absoluteString = "http://103.205.26.103:8000"
//var http_absoluteString = "http://121shoppe.com"

class PROJECT_API {
    /////
    static var CATEGORIES = "\(http_absoluteString)/api/v1/categories/"
    static var MODELS = "\(http_absoluteString)/api/v1/models/"
    static var BRANDS = "\(http_absoluteString)/api/v1/brands/"
    static var YEARS = "\(http_absoluteString)/api/v1/years/"
    static var TYPES = "\(http_absoluteString)/api/v1/types/"
    static var STATUS = "\(http_absoluteString)/api/v1/status/"
    static var PROVINCES = "\(http_absoluteString)/api/v1/provinces/"
    static var GROUPS = "\(http_absoluteString)/api/v1/groups/"
    static var POSTLIKEBYUSER = "\(http_absoluteString)/like/?post&like_by"
    static var SHOP = "\(http_absoluteString)/api/v1/shop/"
   
    
    //Profile
    static var POST_BYUSER = "\(http_absoluteString)/postbyuser/"
    static var USER = "\(http_absoluteString)/api/v1/users/\(User.getUserID())/"
    static var POSTBYUSERACTIVE = "\(http_absoluteString)/postbyuser/"
    static var POSTBYUSERACTIVEFILTER = "\(http_absoluteString)/postbyuserfilter/"
    static var POSTBYUSERHISTORY = "\(http_absoluteString)/posybyuserhistory/?status=2"
    static var PROFILE_PIC = "\(http_absoluteString)/api/v1/users/\(User.getUserID())/profilephoto/"
    static var COVER_PIC = "\(http_absoluteString)/api/v1/users/\(User.getUserID())/coverphoto/"
    static var LIKEBYUSER = "\(http_absoluteString)/likebyuser/"
    static var LOANBYUSERACTIVE = "\(http_absoluteString)/loanbyuser/?record_status=1"
    static var LOANBYUSERHISTORY = "\(http_absoluteString)/loanbyuser/?record_status=2"
    
    //LogIN
    static var LOGIN = "\(http_absoluteString)/api/v1/rest-auth/login/"
    static var REGISTER = "\(http_absoluteString)/api/v1/users/"
    static var CHANGEPASSWORD = "\(http_absoluteString)/api/v1/changepassword/"
    
    //Homepage
    static var WALLPAPER = "\(http_absoluteString)/api/v1/wallpaper/"
    static var HOMEPAGE = "\(http_absoluteString)/allposts/"
    static var BESTDEAL = "\(http_absoluteString)/bestdeal/"
    static func filterUsernameAndFacebookKey(username: String, fbKey: String) -> String
    {
        return "\(http_absoluteString)/api/v1/userfilter/?last_name=\(fbKey)&username=\(username)"
    }
    
    static func DETAIL_USER(userID: String) -> String {
        return "\(http_absoluteString)/postbyuserfilter/\(userID)/"
    }
    
    static func RELATED_PRODUCT(postType: String, category: String, modeling: String) -> String {
        return "\(http_absoluteString)/relatedpost/?post_type=\(postType)&category=\(category)&modeling=\(modeling)&min_price=&max_price="
    }
    static func SEARCH_PRODUCT(filter: SearchFilter) -> String {
        return "\(http_absoluteString)/postsearch/?search=\(filter.search)&category=\(filter.category)&modeling=\(filter.model)&year=\(filter.year)"
    }
    
//    static func FILTER_BUTTON(postType: String, category: String, modeling: String, min_price: String, max_price: String, years: String) -> String {
//        return "\(http_absoluteString)/relatedpost/??post_type=\(postType)&category=\(category)&modeling\(modeling)&min_price=\(min_price)&max_price=\(max_price)&year=\(years)"
//    }
    
    static func FILTERBUTTON(filterbtn: RelatedFilter) -> String {
        return
"\(http_absoluteString)relatepost/?post_type=\(filterbtn.type)&category=\(filterbtn.category)&modeling\(filterbtn.modeling)&min_price=\(filterbtn.min_price)&max_price=\(filterbtn.max_price)&year=\(filterbtn.years)"
    }
    
    //Post Ad
    static var POST_BUYS = "\(http_absoluteString)/api/v1/postbuys/"
    static var POST_RENTS = "\(http_absoluteString)/postrent/"
    static var POST_SELL = "\(http_absoluteString)/postsale/"
    
    //Loan
    static var LOAN = "\(http_absoluteString)/api/v1/loan/"
    static var LOADLOANBYUSER = "\(http_absoluteString)/loanbyuser/"

    //Detail
    static func LOADPRODUCT(ProID: Int) -> String {
        return "\(http_absoluteString)/detailposts/\(ProID)/"
    }
    static func GETUSERDETAIL(ID: Int) -> String {
        return "\(http_absoluteString)/api/v1/users/\(ID)/"
    }
    static func LOADPRODUCTOFUSER(ProID: Int) -> String {
        return "\(http_absoluteString)/postbyuser/\(ProID)/"
    }
    static func CONDITIONLIKE(ProID: String, UserID: String) -> String {
        return "\(http_absoluteString)/like/?post=\(ProID)&like_by=\(UserID)"
    }
    
    static var USERUNLIKE = "\(http_absoluteString)/like/"
    
    static func POSTBYUSER_FILTER(UserID: String,approved: String?,rejected: String?, modify: String?) -> String {
        return "\(http_absoluteString)/postbyuserfilter/?created_by=\(UserID)&approved_by=\(approved ?? "")&rejected_by=\(rejected ?? "")&modified_by=\(modify ?? "")"
    }
    
    static var UpdateProductStatus = "\(http_absoluteString)/api/v1/renewaldelete/"
    
    //Count Views
    static func COUNT_VIEWS(ProID: Int) -> String {
        return "\(http_absoluteString)/countview/?post=\(ProID)"
    }
    
    static var SUBMIT_COUNTVIEW = "\(http_absoluteString)/countview/"
    
    static func USER_PRO(UserID: String) -> String {
        return "\(http_absoluteString)/api/v1/users/\(User.getUserID())/profilephoto/"
    }
}

func httpHeader() -> HTTPHeaders
{
    let head: HTTPHeaders = [
        "Cookie": "",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization" : User.getUserEncoded(),
    ]
    return head
}

class User {

    static func setupNewUserLogIn(pk: Int, username: String, firstname: String, password: String)
    {
        User.resetUserDefault()
        
        let defaultUser = UserDefaults.standard
        defaultUser.set(pk, forKey: "userid")
        defaultUser.set(username, forKey: "username")
        defaultUser.set(firstname, forKey: "first_name")
        defaultUser.set(password, forKey: "password")
        defaultUser.synchronize()
    }
    
    static func getUserID() -> Int {
        let defaultValues = UserDefaults.standard
        return Int(defaultValues.string(forKey: "userid") ?? "0") ?? 0
    }
    
    static func getUsername() -> String {
        let defaultValues = UserDefaults.standard
        return defaultValues.string(forKey: "username") ?? ""
    }
    
    static func setNewUsername(username: String)
    {
        let userDefault = UserDefaults.standard
        userDefault.set(username, forKey: "username")
        userDefault.synchronize()
    }
    
    static func setNewFirstName(firstName: String)
    {
        let userDefault = UserDefaults.standard
        userDefault.set(firstName, forKey: "first_name")
        userDefault.synchronize()
    }
    
    static func getfirstname() -> String
    {
        let defaultValues = UserDefaults.standard
        return defaultValues.string(forKey: "first_name") ?? ""
    }
    
    static func setNewPassword(newPassword: String)
    {
        let userDefault = UserDefaults.standard
        userDefault.set(newPassword, forKey: "password")
        userDefault.synchronize()
    }
    
    static func getPassword() -> String
    {
        let defaultValues = UserDefaults.standard
        let password = defaultValues.string(forKey: "password") ?? ""
        return password
    }
    
    static func getUserEncoded() -> String {
        let defaultValues = UserDefaults.standard
        let username = defaultValues.string(forKey: "username") ?? ""
        let password = defaultValues.string(forKey: "password") ?? ""

        let userPass = username + ":" + password
        return "Basic " + userPass.base64Encoded()!
    }

    
    static func resetUserDefault()
    {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    static func IsAuthenticated(view: UIViewController, callBack: (() -> Void)) {
        let defaultValues = UserDefaults.standard
        if defaultValues.string(forKey: "username") == nil{
            let LogInView = view.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            view.navigationController?.pushViewController(LogInView, animated: true)
            callBack()
        }
        else{
            return
        }
    }
    
    static func getUserInfo(id: Int, completion: @escaping (Profile) -> ()) {
        Alamofire.request(PROJECT_API.GETUSERDETAIL(ID: id),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                print(value)
                let profile = json["profile"]
                completion(Profile(ID: json["id"].stringValue,
                                   Name: json["username"].stringValue, FirstName: json["first_name"].stringValue,
                                   PhoneNumber: profile["telephone"].stringValue,
                                   Profile: profile["base64_profile_image"].stringValue.base64ToImage() ?? UIImage(), email: json["email"].stringValue,
                                        Address: profile["address"].stringValue,
                                        Address_Name: profile["responsible_officer"].stringValue))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    
    static func IsUserAuthorized() -> Bool {
        let defaultValues = UserDefaults.standard
        if defaultValues.string(forKey: "username") == nil{
            return false
        }
        else {
            return true
        }
    }
}

class Converts {

    static func getBrandbyID(id: Int, completion: @escaping (String) -> ()){
        Alamofire.request("\(PROJECT_API.BRANDS)\(id)/", method: .get, encoding: JSONEncoding.default).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                completion(json["brand_name"].stringValue)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getYearbyID(id: Int, completion: @escaping (String) -> ()){
        Alamofire.request("\(PROJECT_API.YEARS)\(id)/", method: .get, encoding: JSONEncoding.default ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                completion(json["year"].stringValue)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getCategorybyID(id: Int, completion: @escaping (String) -> ()){
        Alamofire.request("\(PROJECT_API.CATEGORIES)\(id)/", method: .get, encoding: JSONEncoding.default ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                completion(json["cat_name"].stringValue)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getTypebyID(id: Int, completion: @escaping (String) -> ()){
        Alamofire.request("\(PROJECT_API.TYPES)\(id)/", method: .get, encoding: JSONEncoding.default ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                completion(json["type"].stringValue)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getModelbyID(id: Int, completion: @escaping (String) -> ()){
        Alamofire.request("\(PROJECT_API.MODELS)\(id)/", method: .get, encoding: JSONEncoding.default ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                completion(json["modeling_name"].stringValue)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getBrandbyModeID(id: Int, completion: @escaping (String) -> ()){
        Alamofire.request("\(PROJECT_API.MODELS)\(id)/", method: .get, encoding: JSONEncoding.default ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                let BrandID = json["brand"].stringValue
                Converts.getBrandbyID(id: BrandID.toInt(), completion: { (val) in
                    completion(val)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getBrandIDbyModelID(ModelID: String, completion: @escaping (String) -> Void)
    {
        Alamofire.request("\(PROJECT_API.MODELS)\(ModelID)/",
                            method: .get,
                            encoding: JSONEncoding.default
            ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                let BrandID = json["brand"].stringValue
                completion(BrandID)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

class Functions {

    static func getMaritalStautsList() -> [DropDownTemplate]
    {
        return [DropDownTemplate(ID: "single", Text: "Single",Text_kh:"", Fkey: nil),
                DropDownTemplate(ID: "married", Text: "Married",Text_kh:"", Fkey: nil),
                DropDownTemplate(ID: "separated", Text: "Separated",Text_kh:"", Fkey: nil),
                DropDownTemplate(ID: "divorced", Text: "Divorced",Text_kh:"", Fkey: nil),
                DropDownTemplate(ID: "windowed", Text: "Windowed",Text_kh:"", Fkey: nil)
                ]
    }
    
    static func getProvinceList(ProvinceURL: String?, completion: @escaping ([DropDownTemplate]) -> Void)
    {
        guard ProvinceURL != "" else {
            return
        }
        
        let semephore = DispatchGroup()
        var result: [DropDownTemplate] = []
        var nextPage = ""
        semephore.enter()
        Alamofire.request(ProvinceURL!,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    nextPage = json["next"].stringValue
                    result = json["results"].array?.map {
                        DropDownTemplate(ID: $0["id"].stringValue,
                                         Text: $0["province"].stringValue,
                                         Text_kh: $0["province_kh"].stringValue,
                                         Fkey: nil)
                        } ?? []
                    semephore.leave()
                    if nextPage != "" {
                        semephore.enter()
                        Functions.getProvinceList(ProvinceURL: nextPage, completion: { (val) in
                            result += val
                            semephore.leave()
                        })
                    }
                    
                    semephore.notify(queue: .main, execute: {
                        completion(result)
                    })
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    static func getDiscountTypeList() -> [String] {
        return ["Amount", "Percentage"]
    }
    
    static func getDropDownList(key: Int ,completion: @escaping ([dropdownData]) -> ()){
        switch key{
        case 0:
            completion([//dropdownData(ID: "buy", Text: "Buy", FKKey: ""),
                        dropdownData(ID: "rent", Text: "Rent", FKKey: ""),
                        dropdownData(ID: "sell", Text: "Sell", FKKey: "")])
            break
        case 2:
            //Category
            Alamofire.request(PROJECT_API.CATEGORIES, method: .get, encoding: JSONEncoding.default).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        dropdownData(ID: $0["id"].stringValue,
                                     Text: $0["cat_name"].stringValue,
                                     FKKey: "")
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case 3:
            //Type
            Alamofire.request(PROJECT_API.TYPES, method: .get, encoding: JSONEncoding.default).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        dropdownData(ID: $0["id"].stringValue,
                                     Text: $0["type"].stringValue,
                                     FKKey: "")
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            break
        case 4:
            //Brand
            Alamofire.request(PROJECT_API.BRANDS, method: .get, encoding: JSONEncoding.default).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        dropdownData(ID: $0["id"].stringValue,
                                     Text: $0["brand_name"].stringValue,
                                     FKKey: $0["category"].stringValue)
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            break
        case 5:
            //Model
            Alamofire.request(PROJECT_API.MODELS, method: .get, encoding: JSONEncoding.default).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        dropdownData(ID: $0["id"].stringValue,
                                     Text: $0["modeling_name"].stringValue,
                                     FKKey: $0["brand"].stringValue)
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            break
        case 6:
            //years
            Alamofire.request(PROJECT_API.YEARS, method: .get, encoding: JSONEncoding.default).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        dropdownData(ID: $0["id"].stringValue,
                                     Text: $0["year"].stringValue,
                                     FKKey: "")
                    }
                
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            break
        case 7:
            //Condition
            completion([dropdownData(ID: "new", Text: "New", FKKey: ""),
                        dropdownData(ID: "used", Text: "Used", FKKey: "")])
            break
        case 8:
            //Color
            completion([dropdownData(ID: "blue", Text: "Blue", FKKey: ""),
                        dropdownData(ID: "black", Text: "Black", FKKey: ""),
                        dropdownData(ID: "silver", Text: "Silver", FKKey: ""),
                        dropdownData(ID: "red", Text: "Red", FKKey: ""),
                        dropdownData(ID: "gray", Text: "Gray", FKKey: ""),
                        dropdownData(ID: "yellow", Text: "Yellow", FKKey: ""),
                        dropdownData(ID: "pink", Text: "Pink", FKKey: ""),
                        dropdownData(ID: "purple", Text: "Purple", FKKey: ""),
                        dropdownData(ID: "orange", Text: "Orange", FKKey: ""),
                        dropdownData(ID: "green", Text: "Green", FKKey: ""),])
            break
        default:
            print("OK")
        }
    }
    
}

class GenerateList
{
    static func getPostType() -> [DropDownTemplate]
    {
        return [//DropDownTemplate(ID: "buy", Text: "Buy", Fkey: nil),
                DropDownTemplate(ID: "rent", Text: "Rent",Text_kh: "", Fkey: nil),
                DropDownTemplate(ID: "sell", Text: "Sell",Text_kh: "", Fkey: nil)]
    }
    
    static func getCategory(completion: @escaping ([DropDownTemplate]) -> Void)
    {
        Alamofire.request(PROJECT_API.CATEGORIES,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let json = JSON(value)
                let arrData = json["results"].array?.map {
                    DropDownTemplate(ID: $0["id"].stringValue,
                                     Text: $0["cat_name"].stringValue,
                                     Text_kh: $0["cat_name_kh"].stringValue,
                                     Fkey: nil)
                }
                completion(arrData ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getType(completion: @escaping ([DropDownTemplate]) -> Void)
    {
        Alamofire.request(PROJECT_API.TYPES,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        DropDownTemplate(ID: $0["id"].stringValue,
                                         Text: $0["type"].stringValue,
                                         Text_kh: $0["type_kh"].stringValue,
                                         Fkey: nil)
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    static func getBrand(completion: @escaping ([DropDownTemplate]) -> Void)
    {
        Alamofire.request(PROJECT_API.BRANDS,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        DropDownTemplate(ID: $0["id"].stringValue,
                                         Text: $0["brand_name"].stringValue,
                                         Text_kh: $0["brand_name_as_kh"].stringValue,
                                         Fkey: $0["category"].stringValue)
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    static func getModel(completion: @escaping ([DropDownTemplate]) -> Void)
    {
        Alamofire.request(PROJECT_API.MODELS,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        DropDownTemplate(ID: $0["id"].stringValue,
                                         Text: $0["modeling_name"].stringValue,
                                         Text_kh: $0["modeling_name_kh"].stringValue,
                                         Fkey: $0["brand"].stringValue)
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    static func getYear(completion: @escaping ([DropDownTemplate]) -> Void)
    {
        Alamofire.request(PROJECT_API.YEARS,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON { (respone) in
                switch respone.result {
                case .success(let value):
                    let json = JSON(value)
                    let arrData = json["results"].array?.map {
                        DropDownTemplate(ID: $0["id"].stringValue,
                                         Text: $0["year"].stringValue,
                                         Text_kh:"",
                                         Fkey: nil)
                    }
                    completion(arrData ?? [])
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    static func getCondition() -> [DropDownTemplate]
    {
        return [DropDownTemplate(ID: "new", Text: "New",Text_kh:"", Fkey: nil),
                DropDownTemplate(ID: "used", Text: "Used",Text_kh:"", Fkey: nil)]
    }
    
    static func getColor() -> [DropDownTemplate]
    {
        
        return [DropDownTemplate(ID: "blue", Text: "Blue",Text_kh:"ខៀវ", Fkey: nil),
                DropDownTemplate(ID: "black", Text: "Black",Text_kh:"ខ្មៅ", Fkey: nil),
                DropDownTemplate(ID: "silver", Text: "Silver",Text_kh:"ប្រាក់", Fkey: nil),
                DropDownTemplate(ID: "red", Text: "Red",Text_kh:"ក្រហម", Fkey: nil),
                DropDownTemplate(ID: "gray", Text: "Gray",Text_kh: "ប្រផេះ", Fkey: nil),
                DropDownTemplate(ID: "yellow", Text: "Yellow",Text_kh: "លឿង", Fkey: nil),
                DropDownTemplate(ID: "pink", Text: "Pink",Text_kh: "ផ្កាឈូក", Fkey: nil),
                DropDownTemplate(ID: "purple", Text: "Purple",Text_kh: "ស្វាយ", Fkey: nil),
                DropDownTemplate(ID: "orange", Text: "Orange",Text_kh: "ទឹកក្រូច", Fkey: nil),
                DropDownTemplate(ID: "green", Text: "Green",Text_kh: "បៃតង", Fkey: nil),]
    }
    
    static func getDiscountType() -> [DropDownTemplate]
    {
        return [DropDownTemplate(ID: "amount", Text: "Amount",Text_kh:"", Fkey: nil),
                DropDownTemplate(ID: "percentage", Text: "Percentage",Text_kh:"", Fkey: nil)]
    }
}


func PHAssetForFileURL(url: NSURL) -> PHAsset? {
    let imageRequestOptions = PHImageRequestOptions()
    imageRequestOptions.version = .current
    imageRequestOptions.deliveryMode = .fastFormat
    imageRequestOptions.resizeMode = .fast
    imageRequestOptions.isSynchronous = true
    
    let fetchResult = PHAsset.fetchAssets(with: nil)
    for index in 0..<fetchResult.count {
        if let asset = fetchResult[index] as? PHAsset {
            var found = false
            PHImageManager.default().requestImageData(for: asset,
                                                                    options: imageRequestOptions) { (_, _, _, info) in
                                                                        if let urlkey = info?["PHImageFileURLKey"] as? NSURL {
                                                                            if urlkey.absoluteString! == url.absoluteString! {
                                                                                found = true
                                                                            }
                                                                        }
            }
            if (found) {
                return asset
            }
        }
    }
    
    return nil
}
