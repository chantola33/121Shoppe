//
//  ProductGridTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/17/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ProductGridTableViewCell: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var borderView: BorderView!
    
    //record 1 properties

    @IBOutlet weak var img_1_Product: CustomImage!
    @IBOutlet weak var lbl_1_Productname: UILabel!
    @IBOutlet weak var lbl_1_Productprice: UILabel!
    @IBOutlet weak var lbl_1_duration: UILabel!
    @IBOutlet weak var lbl_1_Views: UILabel!
    @IBOutlet weak var lbl_1_postTy: UILabel!
    
    //record 2 properties

    @IBOutlet weak var img_2_Product: CustomImage!
    @IBOutlet weak var lbl_2_Productname: UILabel!
    @IBOutlet weak var lbl_2_productprice: UILabel!
    @IBOutlet weak var lbl_2_duration: UILabel!
    @IBOutlet weak var lbl_2_Views: UILabel!
    @IBOutlet weak var lbl_2_postTy: UILabel!
    
    
    var data1: HomePageModel?
    var data2: HomePageModel?
    var cellID: Int?
    weak var delegate: CellClickProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.firstView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick1)))
        lbl_1_duration.isHidden = true
        
        self.secondView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick2)))
        lbl_2_duration.isHidden = true
    }
    
    @objc
    func handerCellClick1(){
        self.delegate?.cellXibClick(ID: data1!.product)
    }
    
    @objc
    func handerCellClick2(){
        self.delegate?.cellXibClick(ID: data2!.product)
    }
    
    func reload()
    {
        if data1 != nil {
            lbl_1_Productname.text = data1!.title.capitalizingFirstLetter()
            img_1_Product.LoadFromURL(url: data1!.imagefront)
            lbl_1_Productname.text = data1?.title
            lbl_1_Productprice.text = data1?.cost.toCurrency()
            //lbl_1_duration.text = data1?.create_at?.getDuration()
            lbl_1_postTy.SetPostType(postType: data1!.postType)
            RequestHandle.CountView(postID: (data1?.product)!) { (count) in
                self.lbl_1_Views.text = "Views: "+count.toString() 
            }
        }
        
        if data2 != nil {
            lbl_2_Productname.text = data2!.title.capitalizingFirstLetter()
            img_2_Product.LoadFromURL(url: data2!.imagefront)
            lbl_2_Productname.text = data2?.title
            lbl_2_productprice.text = data2?.cost.toCurrency()
           // lbl_2_duration.text = data2?.create_at?.getDuration()
            lbl_2_postTy.SetPostType(postType: data2!.postType)
            RequestHandle.CountView(postID: (data2?.product)!) { (count) in
                self.lbl_2_Views.text = "Views: "+count.toString()
            }
            
        }
        else
        {
            performOn(.Main) {
                self.borderView.isHidden = true
            }
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
