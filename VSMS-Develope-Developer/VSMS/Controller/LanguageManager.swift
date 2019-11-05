
import UIKit

// Language
private let defaultLang = "km-KH"
let currentLangKey = "CurrentLanguageKey"

enum LanguageCode: String {
    case english    = "en"
    case khmer      = "km-KH"
}

class LanguageManager: NSObject {
    
    // MARK : - Language
    class func setLanguage(lang: LanguageCode) {
        let language = Bundle.main.localizations.contains(lang.rawValue) ? lang.rawValue : defaultLang
        if language != currentLanguage {
            UserDefaults.standard.set(language, forKey: currentLangKey)
            UserDefaults.standard.synchronize()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotification.Name.LanguageNotification), object: nil)
    }
    
    class var currentLanguage: String {
        if let currentLanguage = UserDefaults.standard.object(forKey: currentLangKey) as? String {
            return currentLanguage
        }
        return defaultLang
    }
    
}
