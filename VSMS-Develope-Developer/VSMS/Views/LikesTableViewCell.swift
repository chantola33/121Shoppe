//
//  LikesTableViewCell.swift
//  VSMS
//
//  Created by Rathana on 7/5/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LikesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var LikesImage: CustomImage!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPostType: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var btnlike: UIButton!
    
    //Internal Properties
    var ProID: Int = -1
    weak var delegate: ProfileCellClickProtocol?
    var ProductData = LikeViewModel()
    var DeleteHandle: ((Int) -> Void)?
    var record_status: Int = 0
    
    var ImgPath = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func reload()
    {
        if let imageFromCache = imageCache.object(forKey: ImgPath as AnyObject) as? UIImage {
            self.LikesImage.image = imageFromCache
        }
        
        RequestHandle.LoadListProductByPostID(postID: ProductData.post) { (val) in
            performOn(.Main, closure: {
                let ProductName = val.post_sub_title
                var SplitName = ProductName.components(separatedBy: ",")
                if SplitName.count > 1 {
                    if UserDefaults.standard.string(forKey: currentLangKey) == "en" {
                        self.lblName.text = SplitName[0]
                    }else {
                        self.lblName.text = SplitName[1]
                    }
                }
                self.LikesImage.LoadFromURL(url: val.imagefront)
//                self.lblName.text = val.post_sub_title.capitalizingFirstLetter()
                self.lblPrice.text = val.cost.toCurrency()
                self.lblDuration.text = val.create_at?.getDuration()
                self.lblPostType.SetPostType(postType: val.postType)
                
                self.ImgPath = val.imagefront
            })
        }
        RequestHandle.CountView(postID: self.ProductData.post) { (count) in
            performOn(.Main, closure: {
                self.lblViewCount.text = count.toString()+" Views"
            })
        }
    }
    
    @objc func handerCellClick(){
        self.delegate?.cellClickToDetail(ID: ProductData.post)
    }
    

    @IBAction func btnlikeTapped(_ sender: Any) {
        Message.ConfirmUnlike(message: "Are you suer to unlike this product?") {
            self.DeleteHandle!(self.ProductData.id)
        }
    }
    
   
}
