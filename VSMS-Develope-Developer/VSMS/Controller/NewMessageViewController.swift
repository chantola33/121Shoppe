//
//  NewMessageViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/2/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {
    
    //components
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var chatContainer: UIView!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tblView: UITableView!
    
    
    //Helper Properties
    var yVal: CGFloat = 0
    var chatInfo: MessageViewModel?
    
    func initailize()
    {
        self.navigationItem.title = chatInfo?.username?.getFirstPhoneNumber()
        imgProduct.ImageLoadFromURL(url: chatInfo?.proImage ?? "")
        lblProductName.text = chatInfo?.proName
        lblPrice.text = chatInfo?.proPrice?.toCurrency()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling any function here
        config()
        hideKeyboardWhenTappedAround()
        initailize()
    }
    
    ///Function, Selector and configuration
    private func config()
    {
        let leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(BackHandle))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BackHandle)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.yVal = self.chatContainer.frame.origin.y
    }
    
    func initialize()
    {
        self.navigationItem.title = chatInfo?.username?.getFirstPhoneNumber()
        imgProduct.ImageLoadFromURL(url: chatInfo?.proImage ?? "")
        lblProductName.text = chatInfo?.proName
        lblPrice.text = chatInfo?.proPrice?.toCurrency()
    }
    
    @objc func BackHandle()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.chatContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(keyboardSize.height)).isActive = true
            self.chatContainer.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.chatContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.chatContainer.layoutIfNeeded()
    }
}
