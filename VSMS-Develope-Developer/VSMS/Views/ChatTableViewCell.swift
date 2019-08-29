//
//  ChatTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/3/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var OwnChatView: UIView!
    @IBOutlet weak var ownText: UILabel!
    @IBOutlet weak var SomeoneChatView: UIView!
    @IBOutlet weak var someoneText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        OwnChatView.layer.cornerRadius = 16
        SomeoneChatView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isOwnText(text: String)
    {
        self.SomeoneChatView.isHidden = true
        ownText.text = text
        
        self.OwnChatView.widthAnchor.constraint(equalToConstant: text.estimateFrame().width + 23).isActive = true
    }
    
    
    func isSomeOneText(text: String)
    {
        self.OwnChatView.isHidden = true
        someoneText.text = text
        self.SomeoneChatView.widthAnchor.constraint(equalToConstant: text.estimateFrame().width + 23).isActive = true
    }
}
