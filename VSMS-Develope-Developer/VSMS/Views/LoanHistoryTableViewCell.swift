//
//  LoanHistoryTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/8/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class LoanHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProduct: CustomImage!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPostType: UILabel!
    @IBOutlet weak var lblView: UILabel!
    
    var ProductID: Int!
    var LoanID: Int!
    
    func reloadXib()
    {
        RequestHandle.LoadListProductByPostID(postID: ProductID) { (val) in

            performOn(.Main, closure: {
                self.imgProduct.LoadFromURL(url: val.imagefront)
                self.lblProductName.text = val.title.capitalizingFirstLetter()
//                self.lblDuration.text = val.create_at?.getDuration()
                self.lblPrice.text = val.cost.toCurrency()
                self.lblPostType.SetPostType(postType: val.postType)
                self.lblView.text = "5 views"
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
