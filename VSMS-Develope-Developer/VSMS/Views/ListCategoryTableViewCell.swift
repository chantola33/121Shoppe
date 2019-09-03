//
//  ListCategoryTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/19/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ListCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var categoryID: String?
    weak var delegate: CellClickProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickHandle)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func clickHandle(){
        self.delegate?.cellXibClick(ID: categoryID!.toInt())
    }
    
}
