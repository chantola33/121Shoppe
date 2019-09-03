//
//  PostsTableViewCell.swift
//  VSMS
//
//  Created by Rathana on 7/5/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var PostImage: CustomImage!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnButtonView: UIView!
    @IBOutlet weak var lblPostType: UILabel!
    @IBOutlet weak var lblView: UILabel!
    
    
    @IBOutlet weak var btnContainer: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    
    
    //Internal Properties
    var ProID: Int?
    var Data = HomePageModel()
    weak var delelgate: ProfileCellClickProtocol?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handerCellClick)))
    }
    
    @objc func handerCellClick(){
        self.delelgate?.cellClickToDetail(ID: Data.product)
    }
    
    func reload()
    {
        PostImage.LoadFromURL(url: Data.imagefront)
        lblName.text = Data.title.capitalizingFirstLetter()
        lblPrice.text = Data.cost.toCurrency()
        lblDuration.text = Data.create_at?.getDuration()
        lblPostType.SetPostType(postType: Data.postType)
        btnStatus.setTextByRecordStatus(status: Data.status!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func buttonTransterTapped(_ sender: Any) {
        print("Transfer")
    }
    
    @IBAction func buttonEditTepped(_ sender: Any) {
        self.delelgate?.cellClickToEdit(ID: Data.product)
    }
    
    @IBAction func buttonDeleteTepped(_ sender: Any) {
        Message.ConfirmDeleteMessage(message: "Are you to delete this post?") {
            self.delelgate?.cellClickToDelete(ID: self.Data.product)
        }
    }

    
}


