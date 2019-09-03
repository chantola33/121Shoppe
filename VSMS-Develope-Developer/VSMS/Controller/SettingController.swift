//
//  SettingController.swift
//  VSMS
//
//  Created by usah on 3/17/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSSelectionMenu

    
class SettingTableController: UITableViewController
{
    
    @IBOutlet weak var btnLogOut: BottomDetail!
    @IBOutlet weak var lblLanguage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0
        {
            PresentController.ChangePassword(from: self)
        }
        
        if indexPath.section == 1 && indexPath.row == 0
        {
            Message.AlertChangeLanguage(from: self) { (code) in
                LanguageManager.setLanguage(lang: code)
            }
        }
        
        if indexPath.section == 2 && indexPath.row == 0
        {
            Message.AlertLogOutMessage(from: self) {
                User.resetUserDefault()
                PresentController.HomePage()
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SettingTableController
{
    
}
