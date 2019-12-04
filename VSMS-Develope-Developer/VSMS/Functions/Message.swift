//
//  Message.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/11/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit


var paginationRecord: Int = 5

class Message {
    
    static var alert: UIAlertController?
    
    public static func ErrorMessage(message: String, View: UIViewController) {
        let AlertMessage = UIAlertController(title: "error".localizable(),
                                             message: message,
                                             preferredStyle: .alert)
        AlertMessage.addAction(UIAlertAction(title: "cancel".localizable(), style: .cancel, handler: nil))
        View.present(AlertMessage, animated: true, completion: nil)
    }
    
    public static func SuccessMessage(message: String, View: UIViewController, callback:@escaping (() -> Void)){
        let AlertMessage = UIAlertController(title: "successfully".localizable(),
                                             message: message,
                                             preferredStyle: .alert)
        AlertMessage.addAction(UIAlertAction(title: "ok".localizable(), style: .default, handler: { (alert) in
            callback()
        }))
        View.present(AlertMessage, animated: true, completion: nil)
    }
    
    public static func ConfirmUnlike(message: String, callback:@escaping (() -> Void)){
        let AlertMessage = UIAlertController(title: "unlike".localizable(),
                                             message: message,
                                             preferredStyle: .alert)
        AlertMessage.addAction(UIAlertAction(title: "remove".localizable(), style: .destructive, handler: { (alert) in
            callback()
        }))
        AlertMessage.addAction(UIAlertAction(title: "cancel".localizable(), style: .default, handler: nil))
        let view = UIApplication.topViewController()
        view!.present(AlertMessage, animated: true, completion: nil)
    }
    
    public static func ConfirmDeleteMessage(message: String, callback:@escaping (() -> Void)){
        let AlertMessage = UIAlertController(title: "delete".localizable(),
                                             message: message,
                                             preferredStyle: .alert)
        AlertMessage.addAction(UIAlertAction(title: "delete".localizable(), style: .destructive, handler: { (alert) in
            callback()
        }))
        AlertMessage.addAction(UIAlertAction(title: "cancel".localizable(), style: .default, handler: nil))
        let view = UIApplication.topViewController()
        view!.present(AlertMessage, animated: true, completion: nil)
    }
    
    public static func AlertMessage(message: String, header: String, View: UIViewController, callback:@escaping (() -> Void)){
        let AlertMessage = UIAlertController(title: header,
                                             message: message,
                                             preferredStyle: .alert)
        AlertMessage.addAction(UIAlertAction(title: "Cancel".localizable(), style: .cancel, handler: { (alert) in
            callback()
        }))
        AlertMessage.addAction(UIAlertAction(title: "ok".localizable(), style: .default, handler: { (alert) in
            callback()
        }))
        
        View.present(AlertMessage, animated: true, completion: nil)
    }
    
    public static func WarningMessage(message: String, View: UIViewController, callback:@escaping (() -> Void)){
        let AlertMessage = UIAlertController(title: "warning".localizable(),
                                             message: message,
                                             preferredStyle: .alert)
        
        AlertMessage.addAction(UIAlertAction(title: "ok".localizable(), style: .default, handler: { (alert) in
            callback()
        }))
        
        View.present(AlertMessage, animated: true, completion: nil)
    }
    
    public static func AttentionMessage(message: String, View: UIViewController, callback:@escaping (() -> Void)){
        let AlertMessage = UIAlertController(title: "attention".localizable(),
                                             message: message,
                                             preferredStyle: .alert)
        
        AlertMessage.addAction(UIAlertAction(title: "cancel".localizable(), style: .default, handler: { (alert) in
            callback()
        }))
        
        View.present(AlertMessage, animated: true, completion: nil)
    }
    
    static func AlertLogOutMessage(from: UIViewController, completion: @escaping () -> Void)
    {
        let alertCon = UIAlertController(title: "messageout".localizable(), message: nil, preferredStyle: .actionSheet)
        alertCon.addAction(UIAlertAction(title: "logout".localizable(), style: .destructive, handler: { (alert) in
            completion()
        }))
        alertCon.addAction(UIAlertAction(title: "cancel".localizable(), style: .cancel, handler: nil))
        from.present(alertCon, animated: true, completion: nil)
    }
    
    static func AlertChangeLanguage(from: UIViewController, completion: @escaping (LanguageCode) -> Void)
    {
        let alertCon = UIAlertController(title: "langauge".localizable(), message: nil, preferredStyle: .actionSheet)
        alertCon.addAction(UIAlertAction(title: "english".localizable(), style: .default, handler: { (alert) in
            completion(LanguageCode.english)
        }))
        alertCon.addAction(UIAlertAction(title: "khmer".localizable(), style: .default, handler: { (alert) in
            completion(LanguageCode.khmer)
        }))
        alertCon.addAction(UIAlertAction(title: "cancel".localizable(), style: .cancel, handler: nil))
        from.present(alertCon, animated: true, completion: nil)
    }
    
    static func Loading(from: UIViewController, text: String = "Please wait...".localizable())
    {
        alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert!.view.addSubview(loadingIndicator)
        if let topVC = UIApplication.topViewController() {
            topVC.present(alert!, animated: true, completion: nil)
        }
        
    }
    
    static func DismissLoading()
    {
        alert?.dismiss(animated: false, completion: nil)
        alert?.dismissActivityIndicator()
    }
}


class UIViewBorderButtom: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: frame.minX, y: frame.height, width: frame.width, height: 0.5);
        layer.addSublayer(border)
    }
}


class BottomDetail: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
    }
}

class BorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        self.dropShadow()
    }
}



public enum QueueType {
    case Main
    case Background
    case LowPriority
    case HighPriority
    
    var queue: DispatchQueue {
        switch self {
        case .Main:
            return DispatchQueue.main
        case .Background:
            return DispatchQueue(label: "com.app.queue",
                                 qos: .background,
                                 target: nil)
        case .LowPriority:
            return DispatchQueue.global(qos: .userInitiated)
        case .HighPriority:
            return DispatchQueue.global(qos: .userInitiated)
        }
    }
}

func performOn(_ queueType: QueueType, closure: @escaping () -> Void) {
    queueType.queue.async(execute: closure)
}


func showToast(message : String, view: UIViewController) {
    
    let toastLabel = UILabel(frame: CGRect(x: view.view.frame.size.width/2 - 75, y: view.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    view.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}

class Alert {
    class func showAlert(title: String, titleColor: UIColor, message: String, titleAction: String, actionStyle: UIAlertAction.Style, vc: UIViewController, _ callback: @escaping () -> Void) {
        
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: titleColor])
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: titleAction, style: actionStyle, handler: { (alertAction) in
            callback()
        }))
        vc.present(alert, animated: true)
    }
}
