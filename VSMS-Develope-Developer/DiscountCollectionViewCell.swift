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
        imgProduct.LoadFromURL(url: data.imagefront)
        MotoName.text = data.post_sub_title
        MotoPrice.text = "\(data.cost.toDouble() - data.discount.toDouble())".toCurrency()
        MotoDiscount.attributedText = data.cost.strikeThrough()
        print("discount id")
        print(data.product)
        RequestHandle.CountView(postID: self.data.product ){ (count) in
            performOn(.Main, closure: {
                print("count")
                print(count.toString())
                self.lblView.text = "views".localizable()+count.toString()
            })
        }
    }
    
    @objc
    func handerCellClick(){
        self.delegate?.cellXibClick(ID: data.product)
    }

}

