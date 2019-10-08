//
//  ContectViewController.swift
//  VSMS
//
//  Created by Rathana on 7/21/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageprofile: UIImageView!
    @IBOutlet weak var btnpost: UIButton!
    @IBOutlet weak var btncontact: UIButton!
    @IBOutlet weak var linepost: UILabel!
    @IBOutlet weak var linecontact: UILabel!
    var ProfileHandleRequest = UserProfileRequestHandle()
    
    @IBOutlet weak var labelName: UILabel!
    var listtype = true
    var index = 0
   // var tel = ImageSubClass()
    var imgprofile = ImageProfileModel()
    var postArr: [HomePageModel] = []
    var UserPostID: Int?
    var ProductDetail = DetailViewModel()
    var userdetail:Profile?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource =  self
        imageprofile.layer.cornerRadius = imageprofile.frame.width * 0.5
        imageprofile.clipsToBounds = true
        
        imageprofile.CirleWithWhiteBorder(thickness: 3)
        self.btnpost.backgroundColor = #colorLiteral(red: 0, green: 0.5215686275, blue: 0.4666666667, alpha: 1)
        self.btncontact.backgroundColor = #colorLiteral(red: 0, green: 0.5215686275, blue: 0.4666666667, alpha: 1)
        self.btnpost.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.btncontact.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        tableView.reloadData()
        
        XibRegister()
        //LoadUserProfileInfo()
        LoadAllPostByUser()
        
        performOn(.Main) {
            self.ProfileHandleRequest.LoadAllPostByUser {
                self.tableView.reloadData()
            }
        }
        
        if let img = self.userdetail?.Profile {
            imageprofile.image = img
        }

        labelName.text = self.userdetail?.FirstName
    }
    
    func XibRegister(){
        
        let post = UINib(nibName: "ProductListTableViewCell", bundle: nil)
        tableView.register(post, forCellReuseIdentifier: "ProductListCell")
        let map = UINib(nibName: "MapTableViewCell", bundle: nil)
        tableView.register(map, forCellReuseIdentifier: "Map")
    }
    

    
    
    @objc
   func LoadAllPostByUser(){
//        print(PROJECT_API.POSTBYUSER_FILTER(UserID: userdetail!.ID, approved: ProductDetail.approved, rejected: ProductDetail.rejected, modify: ""))
        
        Alamofire.request(PROJECT_API.POSTBYUSER_FILTER(UserID: userdetail!.ID, approved: ProductDetail.approved, rejected: ProductDetail.rejected, modify: ""),
                          method: .get,
                          encoding: JSONEncoding.default
            ).responseJSON
            { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    self.postArr = (json["results"].array?.map{
                        HomePageModel(json: $0)
                        } ?? [])
                    print(json)

                    self.tableView.reloadData()
                case .failure:
                    print("error")
                }
        }
    }
    
    
    @IBAction func buttonpostTap(_ sender: Any) {
        if (btnpost != nil){
            linepost.alpha = 1
            linecontact.alpha = 0
        }
        else{
            linepost.alpha = 0
            linecontact.alpha = 1
        }
      listtype = true
      tableView.reloadData()
    }
    
    
    @IBAction func buttonContactTap(_ sender: Any) {
       
        if (btncontact != nil){
            linepost.alpha = 0
            linecontact.alpha = 1
        }else{
            linecontact.alpha = 1
            linecontact.alpha = 0
        }
        listtype = false
         tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listtype == true {
            return postArr.count
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listtype == true {
            return 100
        }else {
            if indexPath.row == 2 {
                return 320
            }
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if listtype == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
            cell.ProductData = postArr[indexPath.row]
            cell.reload()
            return cell
            
        }
        else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "contectCell")
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Phone"
                cell?.detailTextLabel?.text = userdetail?.PhoneNumber
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Email"
                cell?.detailTextLabel?.text = userdetail?.email
            } else {
                let map = tableView.dequeueReusableCell(withIdentifier: "Map", for: indexPath) as! MapTableViewCell
                map.userdetail = userdetail
                map.ProductDetail = ProductDetail
                return map

            }
            
            return cell ?? UITableViewCell()
        }
       
    }

}


