//
//  PostsTableViewCell.swift
//  VSMS
//
//  Created by Rathana on 7/5/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class PostsTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var PostImage: CustomImage!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnButtonView: UIView!
    @IBOutlet weak var lblPostType: UILabel!
    @IBOutlet weak var lblView: UILabel!
    
    
    @IBOutlet weak var btnContainer: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    
    
    //Internal Properties
    var ProID: Int?
    var Data = HomePageModel()
    weak var delelgate: ProfileCellClickProtocol?
    var PostRenew = Renewaldelete()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
    }
    
    @objc func handerCellClick(){
        self.delelgate?.cellClickToDetail(ID: Data.product)
    }
    
    func reload()
    {
        let ProductName = Data.post_sub_title
        let SplitName = ProductName.components(separatedBy: ",")
        if SplitName.count > 1 {
            if UserDefaults.standard.string(forKey: currentLangKey) == "en" {
                lblName.text = SplitName[0]
            }else {
                lblName.text = SplitName[1]
            }
        }
        PostImage.LoadFromURL(url: Data.imagefront)
        lblPrice.text = Data.cost.toCurrency()
//        lblDuration.text = Data.create_at?.getDuration()
        lblPostType.SetPostType(postType: Data.postType)
        btnStatus.setTextByRecordStatus(status: Data.status!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func buttonTransterTapped(_ sender: Any) {
        print("Transfer")
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = df.string(from: d)
        print(formattedDate)
        if Data.status == 3 {
            print("pending")
        }else {
         
            Message.ConfirmRenewMessage(message: "renewmessage".localizable()) {
                let productid = self.Data.product
                self.PostRenew.id = productid
                self.PostRenew.status = 4
                self.PostRenew.modified = formattedDate
                self.PostRenew.modified_by = User.getUserID()
                self.PostRenew.rejected_comments = ""
                self.PostRenew.Renewal(PostID: productid ) { (result) in
                    if result {
                        print("Successful")
                    }else {
                        print("fail")
                    }
                }
            }
        }
    }
    
    @IBAction func buttonEditTepped(_ sender: Any) {
        self.delelgate?.cellClickToEdit(ID: Data.product)
    }
    
    @IBAction func buttonDeleteTepped(_ sender: Any) {
        Message.ConfirmDeleteMessage(message: "Are you to delete this post?") {
            self.delelgate?.cellClickToDelete(ID: self.Data.product)
        }
    }

    
}


