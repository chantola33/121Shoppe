//
//  BtnFilterCollectionViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import LGButton
import RSSelectionMenu
import Alamofire
import SwiftyJSON


class BtnFilterCollectionViewCell: UICollectionViewCell {

    var ProductDetail = DetailViewModel()
    @IBOutlet weak var btnFilter: LGButton!
    
    var indexButton: Int?
    var clickRespone: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickHandle(_ sender: LGButton) {
        self.clickRespone?(indexButton!)
        switch indexButton {
        case 0:
            print("Post")
        case 1:
            print("Category")
        case 2:
            print("Brand")
        case 3:
            print("Years")
        case 4:
            print("Prices")
        default:
            break
        }
    }
   
}
