//
//  AlertService.swift
//  VSMS
//
//  Created by usah on 12/2/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    func alert() -> PopupviewController {
        let storyboard = UIStoryboard(name: "Popup", bundle:.main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "PopupviewController") as! PopupviewController
        
        return alertVC
    }
}
