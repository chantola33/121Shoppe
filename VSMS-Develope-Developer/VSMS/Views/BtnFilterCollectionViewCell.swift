//
//  BtnFilterCollectionViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/20/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import LGButton


class BtnFilterCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var btnFilter: LGButton!
    
    var indexButton: Int?
    var clickRespone: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickHandle(_ sender: LGButton) {
        self.clickRespone?(indexButton!)
    }
}
