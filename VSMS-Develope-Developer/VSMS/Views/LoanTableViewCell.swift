//
//  LoanTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/7/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class LoanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProduct: CustomImage!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblPostType: UILabel!
    @IBOutlet weak var lblView: UILabel!
    
    
    var ProductID: Int!
    var LoanID: Int!
    
    var EditHandle: ((Int) -> Void)?
    var DeleteHandle: ((Int) -> Void)?
    var DetailHandle: ((Int) -> Void)?
    
    func ReloadXib()
    {
        RequestHandle.LoadListProductByPostID(postID: ProductID) { (val) in
            performOn(.Main, closure: {
                self.imgProduct.LoadFromURL(url: val.imagefront)
                self.lblProductName.text = val.title.capitalizingFirstLetter()
                self.lblDuration.text = val.create_at?.getDuration()
                self.lblProductPrice.text = val.cost.toCurrency()
                self.lblPostType.SetPostType(postType: val.postType)
                self.lblView.text = "5 views"
            })
        }
    }
    
    
    @IBAction func btnEditclick(_ sender: UIButton) {
        self.EditHandle!(LoanID)
    }
    
    @IBAction func btnDeleteClick(_ sender: Any) {
        Message.ConfirmDeleteMessage(message: "Are you to delete this loan?") {
            self.DeleteHandle!(self.LoanID)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc
    func handerCellClick()
    {
        self.DetailHandle!(LoanID)
    }
    
}
