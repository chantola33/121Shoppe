//
//  RequestHandle.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/17/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var headers: HTTPHeaders = [
    "Cookie": "",
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization" : User.getUserEncoded(),
]


func makeAPhoneCall(phoneNumber: String)  {
    let url: NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
}

class RequestHandle {
    var AllPostNextPage: String?
    var AllPostPreviousePage: String?
    
    
    
    func LoadAllPosts(completion: @escaping ([HomePageModel]) -> Void){
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.HOMEPAGE,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.AllPostNextPage = json["next"].stringValue
                    self.AllPostPreviousePage = json["previous"].stringValue
                    result = (json["results"].array?.map{
                        HomePageModel(id: $0["id"].stringValue.toInt(),
                                      name: $0["title"].stringValue,
                                      cost: $0["cost"].stringValue,
                                      imagefront: $0["front_image_base64"].stringValue,
                                      discount: $0["discount"].stringValue,
                                      postType: $0["post_type"].stringValue,
                                      postSubTitle: $0["post_sub_title"].stringValue)
                        }) ?? []
                    
                    performOn(.Main, closure: {
                        completion(result)
                    })
                case .failure:
                    print("error")
                }
        }
    }
    
    static func LoadRelated(postType: String, category: String, modeling: String, completion: @escaping ([HomePageModel]) -> Void){
       // print(PROJECT_API.RELATED_PRODUCT(postType: postType, category: category, modeling: modeling))
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.RELATED_PRODUCT(postType: postType, category: category, modeling: modeling),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    result = (json["results"].array?.map{
                       HomePageModel(json: $0)
                        }) ?? []
                    
                    completion(result)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    static func LoadBestDeal(completion: @escaping ([HomePageModel]) -> Void){
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.BESTDEAL,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    result = json["results"].array?.map{
                        HomePageModel(json: $0)
                        } ?? []
                    completion(result)
                case .failure:
                    print("error")
                }
        }
       
    }
    
    static func Conditionlike(ProID: String, UserID: String, completion: @escaping (Bool) -> Void){
        Alamofire.request(PROJECT_API.CONDITIONLIKE(ProID: ProID, UserID: UserID), method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    // print(json)
                    completion(json["count"].stringValue.toInt() >= 1 ? true : false)
                case .failure:
                    print("error")
                }
        }
        
    }
    
    static func getWallpaper(completion: @escaping ([String]) -> Void){
        var post: [String] = []
        Alamofire.request(PROJECT_API.WALLPAPER,
                          method: .get,
                          encoding: JSONEncoding.default
                          ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    post = json["results"].array?.map{
                            $0["wallpaper_image"].stringValue
                    } ?? []
                 completion(post)
                 
                case .failure:
                    print("error")
                }
        }
    }
   
    static func CountView(postID: Int, completion: @escaping (Int) -> Void){
        Alamofire.request(PROJECT_API.COUNT_VIEWS(ProID: postID),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                   // print(json)
                    completion(json["count"].stringValue.toInt())
                case .failure:
                    print("error")
                }
        }
        
    }
  
    static func UserProfile(UserID: String, completion: @escaping (UIImage) -> Void){
        Alamofire.request(PROJECT_API.USER_PRO(UserID: UserID),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    // print(json)
                    completion(json["profile_photo"].stringValue.base64ToImage() ?? UIImage())
                case .failure:
                    print("error")
                }
        }
    }
    
    static func LoadAllPostByPostTypeAndCategory(filter: RelatedFilter, completion: @escaping ([HomePageModel]) -> Void) {
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.RELATED_PRODUCT(postType: filter.type, category: filter.category, modeling: filter.modeling),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    result = (json["results"].array?.map{
                        HomePageModel(json: $0)
                        }) ?? []
                    
                    performOn(.Main, closure: {
                        completion(result)
                    })
                case .failure:
                    print("error")
                }
        }
    }
    
//    static func FilterButton(filter: RelatedFilter, completion: @escaping ([HomePageModel]) -> Void) {
//        var result: [HomePageModel] = []
//        Alamofire.request(PROJECT_API.RELATED_PRODUCT(postType: , category: <#T##String#>, modeling: <#T##String#>))
//    }
    
    static func SearchProduct(filter: SearchFilter, completion: @escaping ([HomePageModel]) -> Void) {
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.SEARCH_PRODUCT(filter: filter),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    result = (json["results"].array?.map{
                        HomePageModel(json: $0)
                        }) ?? []
                    
                    performOn(.Main, closure: {
                        completion(result)
                    })
                case .failure:
                    print("error")
                }
        }
    }
    
    static func SearchView(filter: RelatedFilter, completion: @escaping ([HomePageModel]) -> Void) {
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.FILTERBUTTON(filterbtn: filter),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (reponse) in
                switch reponse.result {
                case .success(let value):
                    let json = JSON(value)
                    result = (json["results"].array?.map{
                        HomePageModel(json: $0)
                        }) ?? []
                    performOn(.Main, closure: {
                        completion(result)
                    })
                case .failure:
                    print("error")
                }
                
        }
    }
    
    static func LoadAllPostByUser(completion: @escaping ([HomePageModel]) -> Void){
        var result: [HomePageModel] = []
        Alamofire.request(PROJECT_API.POSTBYUSERACTIVEFILTER,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    result = (json["results"].array?.map{
                        HomePageModel(json: $0
                        )}) ?? []
                    
                    performOn(.Main, closure: {
                        completion(result)
                    })
                case .failure:
                    print("error")
                }
        }
    }
    
    static func LoadAllPostLikeByUser(completion: @escaping ([String]) -> Void){
        var posts: [String] = []
        
        Alamofire.request(PROJECT_API.LIKEBYUSER,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    posts = json["results"].array?.map{
                            $0["post"].stringValue
                        } ?? []
                    
                    performOn(.Main, closure: {
                        completion(posts)
                    })
                case .failure:
                    print("error")
                }
        }.resume()
    }
    
    static func LoadListProductByPostID(postID: Int, completion: @escaping (HomePageModel) -> Void){
        var result = HomePageModel()
        Alamofire.request(PROJECT_API.LOADPRODUCT(ProID: postID),
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON
            { response in
                switch response.result{
                case .success (let value):
                    let json = JSON(value)
                    result = HomePageModel(json: json)
                    completion(result)
                case .failure(_):
                    break
                }
        }
    }
}

class HomepageRequestHandler {
    var next: String = ""
    var previous: String = ""
    var count: Int = 0
    
    //Array Data
    var AllPostArr: [HomePageModel] = []
    
    init(){
    }
    
    func LoadAllPosts(completion: @escaping () -> Void){
        Alamofire.request(PROJECT_API.HOMEPAGE,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.next = json["next"].stringValue
                    self.previous = json["previous"].stringValue
                    self.count = json["count"].stringValue.toInt()
                    
                    self.AllPostArr = (json["results"].array?.map{
                        HomePageModel(json: $0)
                        }) ?? []
                    completion()
                case .failure:
                    print("error")
                }
        }
    }
    
    func LoadAllPostsNextPage(completion: @escaping () -> Void){
        if self.next == "" {
            return
        }

        Alamofire.request(self.next,
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.next = json["next"].stringValue
                    self.previous = json["previous"].stringValue
                    self.count = json["count"].stringValue.toInt()
                    
                    self.AllPostArr += (json["results"].array?.map{
                        HomePageModel(json: $0)
                        }) ?? []
                    completion()
                case .failure:
                    print("error")
                }
        }
    }
    
    func IsEndofDataAllPost() -> Bool {
        return next == ""
    }
}

class UserProfileRequestHandle {
    
    var Profile = ImageProfileModel()
    
    var NextPostActive: String = ""
    var NextPostHistory: String = ""
    var NextLike: String = ""
    var NextLoanActive: String = ""
    var NextLoanHistory: String = ""
    
    //Record count
    var AllPostActiveCount: Int = 0
    var AllPostHistoryCount: Int = 0
    
    //List Data
    var PostActive: [HomePageModel] = []
    var PostHistory: [HomePageModel] = []
    var PostLike: [LikeViewModel] = []
    var PostLoanActive: [ListLoanViewModel] = []
    var PostLoanHistory: [ListLoanViewModel] = []
    
    //Helper properties
    private let semephore = DispatchGroup()
    
    var headers: HTTPHeaders = [
        "Cookie": "",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization" : User.getUserEncoded(),
    ]
    
    init(){}
    
    func LoadProfileDetail(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.USER,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.Profile = ImageProfileModel(json: json)
                    completion()
                case .failure:
                    print("error")
                }
        }
    }
    
    
    func LoadAllPostByUser(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.POSTBYUSERACTIVE,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextPostActive = json["next"].stringValue
                    self.AllPostActiveCount = json["count"].stringValue.toInt()

                    self.PostActive = (json["results"].array?.map{
                        HomePageModel(json: $0)
                        }) ?? []
                        completion()

                case .failure:
                    print("error")
                }
        }
    }
    
    func NextPostByUser(completion: @escaping () -> Void)
    {
        if self.NextPostActive == "" {
            return
        }
        
        Alamofire.request(self.NextPostActive,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextPostActive = json["next"].stringValue
                    self.AllPostActiveCount = json["count"].stringValue.toInt()
                    
                    self.PostActive += json["results"].array?.map{
                            HomePageModel(json: $0)
                        } ?? []
                    completion()
                    
                case .failure:
                    print("error")
                }
        }
    }
    
    func LoadAllPostHistoryByUser(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.POSTBYUSERHISTORY,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextPostHistory = json["next"].stringValue
                    self.AllPostHistoryCount = json["count"].stringValue.toInt()
                    
                    self.PostHistory = (json["results"].array?.map{
                        HomePageModel(json: $0)}) ?? []
                    completion()
                    
                case .failure:
                    print("error")
                }
        }
    }
    
    func NextPostHistoryByUser(completion: @escaping () -> Void)
    {
        if self.NextPostHistory == "" {
            return
        }
        
        Alamofire.request(self.NextPostHistory,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextPostHistory = json["next"].stringValue
                    self.AllPostHistoryCount = json["count"].stringValue.toInt()
                    
                    self.PostHistory += (json["results"].array?.map{
                        HomePageModel(json: $0)}) ?? []
                    
                    completion()
                    
                case .failure:
                    print("error")
                }
        }
    }
    
    func LoadAllPostLikeByUser(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.LIKEBYUSER,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextLike = json["next"].stringValue
                    self.PostLike = json["results"].arrayValue.map{
                        LikeViewModel(json: $0)
                    }
                        
                    completion()
                    
                case .failure:
                    print("error")
                }
        }
    }
    
    func LoadNextPostLikeByUser(completion: @escaping () -> Void)
    {
        guard NextLike != "" else {
            return
        }
        
        semephore.enter()
        Alamofire.request(PROJECT_API.LIKEBYUSER,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextLike = json["next"].stringValue
                    
                    self.semephore.leave()
                    
                    
                case .failure:
                    print("error")
                }
        }
        
        semephore.notify(queue: .main) {
            completion()
        }
    }
    
    func LoadLoanActiveByUser(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.LOANBYUSERACTIVE,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextLoanActive = json["next"].stringValue
                    self.PostLoanActive = json["results"].arrayValue.map{
                        ListLoanViewModel(id: $0["id"].stringValue.toInt(), post: $0["post"].stringValue.toInt())
                    }
                    
                    completion()
                    
                case .failure:
                    print("error")
                    completion()
                }
        }
    }
    
    func LoadNextLoanActiveByUser(completion: @escaping () -> Void)
    {
        guard NextLoanActive != "" else {
            return
        }
        Alamofire.request(PROJECT_API.LOANBYUSERACTIVE,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextLoanActive = json["next"].stringValue
                    self.PostLoanActive += json["results"].arrayValue.map{
                        ListLoanViewModel(id: $0["id"].stringValue.toInt(), post: $0["post"].stringValue.toInt())
                    }
                    
                case .failure:
                    print("error")
                }
        }
    }
    
    func LoadLoanHistoryByUser(completion: @escaping () -> Void)
    {
        Alamofire.request(PROJECT_API.LOANBYUSERHISTORY,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: self.headers
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.NextLoanHistory = json["next"].stringValue
                    self.PostLoanHistory = json["results"].arrayValue.map{
                        ListLoanViewModel(id: $0["id"].stringValue.toInt(), post: $0["post"].stringValue.toInt())
                    }
                    completion()
                case .failure:
                    print("error")
                    completion()
                }
        }
    }
    
    func IsEndofDataNextPostActive() -> Bool {
        return self.NextPostActive == ""
    }
}


struct ListLoanViewModel
{
    var id: Int = 0
    var post: Int = 0
    
}

class LikeViewModel {
    
    var headers: HTTPHeaders = [
        "Cookie": "",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization" : User.getUserEncoded(),
        ]
    
    var id: Int = 0
    var like_by: Int = 0
    var modified: String?
    var post: Int = 0
    var record_status: Int = 0
    
    var productDetail: String = ""

    init(){}
    
    init(json: JSON)
    {
        self.id = json["id"].stringValue.toInt()
        self.like_by = json["like_by"].stringValue.toInt()
        self.modified = json["modified"].stringValue
        self.post = json["post"].stringValue.toInt()
        self.record_status = json["record_status"].stringValue.toInt()
    }
    
    func Remove(LikeID: Int, completion: @escaping (Bool) -> Void)
    {
        let parameters: Parameters = [
            "record_status": 2]
        
       self.record_status = 2
        
       Alamofire.request("\(PROJECT_API.USERUNLIKE)\(LikeID)",
        method: .patch, parameters: parameters,
        encoding: JSONEncoding.default,
        headers: self.headers
        ).responseJSON{ response in
            switch response.result {
            case .success(let value):
            print(value)
            completion(true)
            case .failure(let error):
            print(error)
            completion(false)
            }
        }
    }
    
    
    static func Detail(ProID: Int, completion: @escaping (LikeViewModel) -> Void)
    {
        Alamofire.request("\(PROJECT_API.USERUNLIKE)\(ProID)",
            method: .get,
            encoding: JSONEncoding.default,
            headers: httpHeader()
            ).responseJSON { response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    completion(LikeViewModel(json: json))
                case .failure(let error):
                    print(error)
                }
        }
    }
    
   
    
}


extension UIImage {
    func UpLoadCover(completion: @escaping () -> Void){
        let parameters: Parameters = [
            "profile": [
                "cover_photo": self.toBase64()
            ]
        ]
        Alamofire.request(PROJECT_API.COVER_PIC,
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                let profile = JSON(json["profile"])
                                UserFireBase.Load({ (userProfile) in
                                    userProfile.coverURL = profile["cover_photo"].stringValue
                                    userProfile.Update({
                                        
                                    })
                                })
                                completion()
                            case .failure(let error):
                                print(error)
                            }
        }
    }
    
    func UpLoadProfile(completion: @escaping () -> Void){
        let parameters: Parameters = [
            "profile": [
                "profile_photo": self.toBase64()
            ]
        ]
        Alamofire.request(PROJECT_API.PROFILE_PIC,
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: httpHeader()
            ).responseJSON { response in
                            switch response.result{
                            case .success(let value):
                                print(value)
                                let json = JSON(value)
                                let profile = JSON(json["profile"])
                                UserFireBase.Load({ (userProfile) in
                                    userProfile.imageURL = profile["profile_photo"].stringValue
                                    userProfile.Update({
                                        
                                    })
                                })
                                completion()
                            case .failure(let error):
                                print(error)
                            }
        }
    }
}
