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
    
    var data: HomePageModel!
    weak var delegate: CellClickProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            })
        }
    }
    
    @objc
    func handerCellClick(){
        self.delegate?.cellXibClick(ID: data.product)
    }

}

