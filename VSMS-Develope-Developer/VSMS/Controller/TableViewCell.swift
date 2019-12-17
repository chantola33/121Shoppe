//
//  TableViewCell.swift
//  VSMS
//
//  Created by usah on 12/11/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblProName: UILabel!
   
    @IBOutlet var imgUser: CustomImage!
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var lblViews: UILabel!
    @IBOutlet var lblType: UILabel!
    weak var delegate: CellClickProtocol?
    var ProductData = HomePageModel()
    
     var username = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
    }

    func reload() {
        imgProduct.ImageLoadFromURL(url: ProductData.imagefront)
        lblProName.text = ProductData.post_sub_title
        lblPrice.text = ProductData.cost
        lblType.SetPostType(postType: ProductData.postType.localizable())
        RequestHandle.CountView(postID: self.ProductData.product) { (count) in
            performOn(.Main, closure: {
                self.lblViews.text = "views".localizable()+count.toString()
                self.lblViews.reloadInputViews()
            })
        }
        
        let createby = ProductData.create_at?.toInt()
        AccountViewModel.LoadUserAccountByID(postID: createby!) { (user) in
            performOn(.Main, closure: {
                self.username = user
                UserFireBase.LoadProfile(proName: self.username) { (coverurl) in
                    performOn(.Main, closure: {
                        let img = coverurl
                        self.imgUser.ImageLoadFromURL(url: img )
                    })
                }
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
