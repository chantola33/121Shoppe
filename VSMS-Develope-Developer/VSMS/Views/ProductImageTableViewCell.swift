//
//  ProductImageTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/17/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ProductImageTableViewCell: UITableViewCell {


    @IBOutlet weak var imgProduct: CustomImage!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblPostType: UILabel!
    
    var ProductID: Int?
    var data = HomePageModel()
    weak var delegate: CellClickProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
        lblDuration.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let ProductName = data.post_sub_title
        let SplitName = ProductName.components(separatedBy: ",")

        if SplitName.count > 1 {
            if UserDefaults.standard.string(forKey: currentLangKey) == "en" {
                lblProductName.text = SplitName[0]
            }else {
                lblProductName.text = SplitName[1]
            }
        }
        imgProduct.LoadFromURL(url: data.imagefront)
//        lblProductName.text = data.title.capitalizingFirstLetter()
        lblProductPrice.text = data.cost.toCurrency()
       // lblDuration.text = data.create_at?.getDuration()
        RequestHandle.CountView(postID: data.product) { (count) in
            self.lblViews.text = "views".localizable()+count.toString()
        }
        lblPostType.SetPostType(postType: data.postType.localizable())
    }
    
    @objc
    func handerCellClick(){
        self.delegate?.cellXibClick(ID: data.product)
    }
}
