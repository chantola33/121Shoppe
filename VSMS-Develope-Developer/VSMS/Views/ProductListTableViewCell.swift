//
//  ProductListTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/17/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ProductListTableViewCell: UITableViewCell {


    @IBOutlet weak var imgProductImage: CustomImage!
    @IBOutlet weak var lblProductname: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblPostType: UILabel!
    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var profileuser: UIImageView!
    //
    var ProfileHandleRequest = UserProfileRequestHandle()
    //
    var UserPro = DetailViewModel()
    var userdetail: Profile?
    var ProductID: Int?
    var ProductData = HomePageModel()
    weak var delegate: CellClickProtocol?
    // user account
    var UserAccount = AccountViewModel()
    var username = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileuser.layer.cornerRadius = profileuser.frame.width * 0.5
        profileuser.clipsToBounds = true
        // Initialization code
   self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
        lblDuration.isHidden = true
    }
    
    func reload()
    {
        
        profileuser.ImageLoadFromURL(url: ProfileHandleRequest.Profile.profile.profile_image)
//        UserFireBase.Load { (user) in
//            print("User")
//            print(user)
//            if user != nil {
//                performOn(.Main, closure: {
//                    self.profileuser.ImageLoadFromURL(url: user.imageURL)
//                })
//            }
//        }
 // get user profile by samang 07/11/19
        let createby = ProductData.create_at?.toInt()
        AccountViewModel.LoadUserAccountByID(postID: createby!) { (user) in
            performOn(.Main, closure: {
                self.username = user
                UserFireBase.LoadProfile(proName: self.username) { (coverurl) in
                    performOn(.Main, closure: {
                        let img = coverurl
                        self.profileuser.ImageLoadFromURL(url: img )
                    })
                }
            })
        }
        
        let ProductName = ProductData.post_sub_title
        let SplitName = ProductName.components(separatedBy: ",")

        if SplitName.count > 1 {
        if UserDefaults.standard.string(forKey: currentLangKey) == "en" {
            lblProductname.text = SplitName[0]
        }else {
            lblProductname.text = SplitName[1]
        }
        }
        imgProductImage.LoadFromURL(url: ProductData.imagefront)
       
        lblProductPrice.text = ProductData.cost.toCurrency()
       // lblDuration.text = ProductData.create_at?.getDuration()
        lblPostType.SetPostType(postType: ProductData.postType.localizable())
        RequestHandle.CountView(postID: self.ProductData.product) { (count) in
            performOn(.Main, closure: {
                self.lblView.text = "views".localizable()+count.toString()
                self.lblView.reloadInputViews()
            })
        }
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    @objc
    func handerCellClick(){
        self.delegate?.cellXibClick(ID: ProductData.product)
    }
    
}

