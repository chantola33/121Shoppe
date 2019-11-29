
import UIKit

protocol Localizable {
    func localizeUI()
}

extension Notification.Name {
    static let LanguageNotification = "LanguageNotification"
}

class BaseViewController: UIViewController, Localizable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.localizeUI),
                                               name: NSNotification.Name(rawValue: NSNotification.Name.LanguageNotification),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localizeUI()
    }

    @objc func localizeUI() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class BaseTableViewController: UITableViewController, Localizable {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.localizeUI),
                                               name: NSNotification.Name(rawValue: NSNotification.Name.LanguageNotification),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localizeUI()
    }

    @objc func localizeUI() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
