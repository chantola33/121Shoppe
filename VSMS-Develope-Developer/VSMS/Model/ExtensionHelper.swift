//
//  ExtensionHelper.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/9/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import Alamofire

///Global Function

func IsNilorEmpty(value: String?) -> Bool
{
    guard let val = value else{ return true }
    if val == "" { return true }
    return false
}

////////////end global Functions


extension String {
    
    func estimateFrame() -> CGRect
    {
        let size = CGSize(width: 250, height: 1000)
        
        return NSString(string: self).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil)
    }
    
    func getFirstPhoneNumber() -> String
    {
        let splitString = self.split(separator: ",")
        if let firstString = splitString.get(at: 0) {
            return String(firstString)
        }
        return ""
    }
    
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toDataEncodingUTF8() -> Data {
        return self.data(using: String.Encoding.utf8)!
    }
    
    func base64ToImage() -> UIImage?{
        let imageData = NSData(base64Encoded: self ,options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return UIImage(data: imageData! as Data) ?? UIImage()
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toISODate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if let date = formatter.date(from: self) {
            let isoDate = ISO8601DateFormatter()
            return isoDate.string(from: date)
        }
        return ""
    }
    
    func DateFormat(withFormat format: String = "dd/MM/yyyy") -> String{
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self) {
            let StringFormat = DateFormatter()
            StringFormat.locale = Locale(identifier: "Asia/Tehran")
            StringFormat.dateFormat = format
            return StringFormat.string(from: date)
        }
        return ""
    }

    // close by samang
//    func formationDate() -> String{
//
//        if self == "" {
//            return ""
//        }
//
//        let dateFormatter = DateFormatter()
//        let tempLocale = dateFormatter.locale // save locale temporarily
//        dateFormatter.locale = Locale(identifier: "Asia/Tehran") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let date = dateFormatter.date(from: self)!
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" ; //"dd-MM-yyyy HH:mm:ss"
//        dateFormatter.locale = tempLocale // reset the locale --> but no need here
//        let dateString = dateFormatter.string(from: date)
//        return dateString
//    }
    
//    func getDuration() -> String{
//        let startDate = self.formationDate()
//
//        if startDate == "" {
//            return ""
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        let formatedStartDate = dateFormatter.date(from: startDate)
//        let currentDate = Date()
//        let components = Set<Calendar.Component>([.minute, .hour, .day, .month, .year])
//        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
//
//        if differenceOfDate.year! > 0 {
//            return "\(differenceOfDate.year ?? 1) year\(differenceOfDate.year! > 1 ? "s" : "")"
//        }
//        if differenceOfDate.month! > 0 {
//            return "\(differenceOfDate.month!) month ago"
//        }
//        if differenceOfDate.day! > 0 {
//            return "\(differenceOfDate.day!) day ago"
//        }
//        if differenceOfDate.hour! > 0 {
//            return "\(differenceOfDate.hour!) hour ago"
//        }
//        if differenceOfDate.minute! > 0 {
//            return "\(differenceOfDate.minute!) minute ago"
//        }
//        else {
//            return "a minute ago"
//        }
//    }
    
    func toDouble() -> Double {
        if let double = Double(self) {
            return double
        }
        else {
            return 0
        }
    }
    
    func toCurrency() -> String {
        let myDouble = self.toDouble()
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        
        let priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        return priceString
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Int {
    func toString() -> String {
        return "\(self)"
    }
    
    func toDataEncodingUTF8() -> Data {
        return self.toString().data(using: String.Encoding.utf8)!
    }
}


extension UIImage {
    func toBase64() -> String {
        guard let imageData = self.pngData() else { return "" }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) 
    }
}


extension UIImageView {
    func CirleWithWhiteBorder(thickness: CGFloat){
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = thickness
    }
    
    func Inputchecked(){
        self.image = #imageLiteral(resourceName: "check_mark")
    }
    
    func InputCrossed(){
        self.image = #imageLiteral(resourceName: "cross_mark")
    }
    
//    func LoadFromURL(url: String)
//    {
//        Alamofire.request(url, method: .get)
//            .validate()
//            .responseData(completionHandler: { (responseData) in
//                DispatchQueue.main.async {
//                   self.image = UIImage(data: responseData.data!)
//                }
//            })
//    }
}

extension UITextField {
    
    func bordercolor(){
        let myColor = UIColor(red: CGFloat(92/255.0), green: CGFloat(203/255.0),
                              blue: CGFloat(207/255.0), alpha: CGFloat(1.0))
        
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
}

extension Collection {
    func get(at index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}


extension UIView {
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        layer.addSublayer(border)
    }
    
    func dropShadow() {
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}


extension UINavigationBar {
    func installBlurEffect() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
}


extension Collection {
    
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
    
}

extension UISearchBar {
    func enable() {
        isUserInteractionEnabled = true
        alpha = 1.0
    }
    
    func disable() {
        isUserInteractionEnabled = false
        alpha = 0.5
    }
}


extension UIViewController {
    func PushToDetailProductViewController(productID: Int){
        DetailViewModel.LoadProductByID(ProID: productID) { (val) in
            self.hidesBottomBarWhenPushed = true
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                viewController.ProductDetail = val
                viewController.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(viewController, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
    
    func PushToDetailProductByUserViewController(productID: Int){
        DetailViewModel.LoadProductByIDOfUser(ProID: productID) { (val) in
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                viewController.ProductDetail = val
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func PushToLogInViewController(){
        if let currentView = UIApplication.topViewController() {
            let log: UINavigationController = {
                let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                return UINavigationController(rootViewController: profile)
            }()
            currentView.present(log, animated: false, completion: nil)
        }
    }
    
}

extension UITableViewCell {
    func PustToDetailProductViewController(ProID: Int)
    {
        DetailViewModel.LoadProductByIDOfUser(ProID: ProID) { (val) in
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                viewController.ProductDetail = val
                self.window?.rootViewController?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}


extension UIViewController {
    var top: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController?.top
        }
        if let controller = self as? UISplitViewController {
            return controller.viewControllers.last?.top
        }
        if let controller = self as? UITabBarController {
            return controller.selectedViewController?.top
        }
        if let controller = presentedViewController {
            return controller.top
        }
        return self
    }
    
    func ShowDefaultNavigation(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1882352941, green: 0.2470588235, blue: 0.6235294118, alpha: 1)
            
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func HasTabNoNav(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func HasNavNoTab(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}


extension UIAlertController {
    
    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
    }
    
    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 20)
        ActivityIndicatorData.activityIndicator.color = UIColor.blue
        ActivityIndicatorData.activityIndicator.startAnimating()
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(vc, forKey: "contentViewController")
    }
    
    func dismissActivityIndicator() {
        ActivityIndicatorData.activityIndicator.stopAnimating()
        self.dismiss(animated: false)
    }
}


extension UITableView {
    func noRecordCell(Indexpath: IndexPath) -> UITableViewCell
    {
        self.register(UINib(nibName: "HelperTableViewCell", bundle: nil), forCellReuseIdentifier: "HelperTableCell")
        
        let cell = self.dequeueReusableCell(withIdentifier: "HelperTableCell", for: Indexpath) as! HelperTableViewCell
        cell.lblText.text = "No Record!"
        return cell
    }
    
    func loadingCell(Indexpath: IndexPath) -> LoadingTableViewCell
    {
        self.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        
        let cell = self.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: Indexpath) as! LoadingTableViewCell
        cell.activity.startAnimating()
        return cell
    }
    
    func ProductListTableCell(Indexpath: IndexPath) -> ProductListTableViewCell
    {
        self.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        let cell = self.dequeueReusableCell(withIdentifier: "ProductListCell", for: Indexpath) as! ProductListTableViewCell
        return cell
    }
}

extension UILabel {
    func SetPostType(postType: String)
    {
        if postType == "sell".localizable()
        {
            self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if postType == "rent".localizable()
        {
            self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else if postType == "buy".localizable()
        {
            self.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }else {
            self.backgroundColor = .white
        }
        self.textColor = UIColor.white
        self.text = postType.capitalizingFirstLetter()
    }
    
    func SetValueText(value: String?)
    {
        if value != ""
        {
            self.textColor = UIColor.black
            self.text = value
        }
        else{
            self.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.text = value
        }
    }

}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
    
}

extension UIImageView
{
    func ImageLoadFromURL(url: String)
    {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            return
        }
        
        Alamofire.request(url, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                DispatchQueue.main.async {
                        if let img = UIImage(data: responseData.data!){
                            self.image = img
                            imageCache.setObject(img, forKey: url as AnyObject)
                        }
                    
                }
            })
    }
    
    
    
}


extension UIButton
{
    func setTextByRecordStatus(status: Int)
    {
        switch status
        {
        case 3:
            self.setTitle("Pending", for: .normal)
            self.setTitleColor(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), for: .normal)
        case 4:
            self.setTitle("Approved", for: .normal)
            self.setTitleColor(#colorLiteral(red: 0.16155532, green: 0.6208058596, blue: 0.002179143718, alpha: 1), for: .normal)
        default:
            break
        }
    }
}

///formate Date
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
