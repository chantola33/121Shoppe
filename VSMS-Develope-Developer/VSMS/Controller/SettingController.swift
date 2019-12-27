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
import FirebaseAuth
    
class SettingTableController: BaseTableViewController
{
    
    @IBOutlet weak var btnLogOut: BottomDetail!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblChangpassword: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func localizeUI() {
        tableView.reloadData()
        btnLogOut.setTitle("btnlogout".localizable(), for: .normal)
        lblChangpassword.text = "changpassword".localizable()
        LanguageLabel.text = "language".localizable()
        lblNotification.text = "notification".localizable()
        lblVersion.text = "version".localizable()
        lblLanguage.text = "language".localizable()
       
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
