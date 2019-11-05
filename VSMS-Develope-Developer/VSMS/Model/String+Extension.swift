
import Foundation

extension String {
    
    func localizable() -> String {
        let path = Bundle.main.path(forResource: LanguageManager.currentLanguage,
                                    ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

