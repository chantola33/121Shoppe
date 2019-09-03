//
//  String+Extension.swift
//  Locoalization
//
//  Created by kosal pen on 8/4/19.
//  Copyright © 2019 kosal pen. All rights reserved.
//

import Foundation

extension String {
    
    func localizable() -> String {
        let path = Bundle.main.path(forResource: LanguageManager.currentLanguage,
                                    ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

