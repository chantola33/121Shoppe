//
//  DiscountCollectionViewCell.swift
//  VSMS
//
//  Created by usah on 6/13/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {

 
    
    @IBOutlet weak var imgProduct: CustomImage!
    @IBOutlet weak var MotoDiscount: UILabel!
    @IBOutlet weak var MotoPrice: UILabel!
    @IBOutlet weak var MotoName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblView: UILabel!
    
    var data: HomePageModel!
    weak var delegate: CellClickProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.layer.cornerRadius = imgUser.frame.width * 0.5
               imgUser.clipsToBounds = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
    }
    
    func reload()
    {
        
        let ProductName = data.post_sub_title
       
        let SplitName = ProductName.components(separatedBy: ",")
        if SplitName.count > 1 {
            if UserDefaults.standard.string(forKey: currentLangKey) == "en" {
                MotoName.text = SplitName[0]
            }else {
                MotoName.text = SplitName[1]
            }
        }
        imgProduct.LoadFromURL(url: data.imagefront)
       // MotoName.text = data.post_sub_title
        MotoPrice.text = "\(data.cost.toDouble() - data.discount.toDouble())".toCurrency()
        MotoDiscount.attributedText = data.cost.strikeThrough()
        RequestHandle.CountView(postID: self.data.product ){ (count) in
            performOn(.Main, closure: {
                self.lblView.text = "views".localizable()+count.toString()
            })
        }
        let createby = data.create_at?.toInt()
        AccountViewModel.LoadUserAccountByID(postID: createby!) { (user) in
            performOn(.Main, closure: {
                let username = user
                UserFireBase.LoadProfile(proName: username) { (coverurl) in
                    performOn(.Main, closure: {
                        let img = coverurl
                        self.imgUser.ImageLoadFromURL(url: img )
                    })
                }
            })
        }
    }
    
    @objc
    func handerCellClick(){
        self.delegate?.cellXibClick(ID: data.product)
    }

}

