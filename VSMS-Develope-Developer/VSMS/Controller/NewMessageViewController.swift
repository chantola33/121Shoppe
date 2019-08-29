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
    
    @IBOutlet weak var textMessageContainer: UIView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    
    //Helper Properties
    var chatConversation: [String] = ["Hi","Hello", "Yes, You can/nnlasjflaslkfkajskldjalsfkalsjdflka see me.", "How are you?", "Nice to meet you"]
    var chatInfo: MessageViewModel?
    var txtconConstrait: NSLayoutConstraint?
    
    func initailize()
    {
        self.navigationItem.title = chatInfo?.username?.getFirstPhoneNumber()
        imgProduct.ImageLoadFromURL(url: chatInfo?.proImage ?? "")
        lblProductName.text = chatInfo?.proName
        lblPrice.text = chatInfo?.proPrice?.toCurrency()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //any Delegate
        tblView.delegate = self
        tblView.dataSource = self
        
        //Calling any function here
        config()
        
        hideKeyboardWhenTappedAround()
        
        initailize()
        
        keyboardHandle()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    ///Function, Selector and configuration
    private func config()
    {
        let leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(BackHandle))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BackHandle)))
        btnSend.addTarget(self, action: #selector(SendHandle), for: .touchUpInside)
    }
    
    func keyboardHandle()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //
        textMessageContainer.translatesAutoresizingMaskIntoConstraints = false
        txtconConstrait = textMessageContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        txtconConstrait?.isActive = true
        
        tblView.keyboardDismissMode = .interactive
        
        //Register xib
        tblView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
    }
    
    func initialize()
    {
        self.navigationItem.title = chatInfo?.username?.getFirstPhoneNumber()
        imgProduct.ImageLoadFromURL(url: chatInfo?.proImage ?? "")
        lblProductName.text = chatInfo?.proName
        lblPrice.text = chatInfo?.proPrice?.toCurrency()
    }
    
    @objc func SendHandle()
    {
        if let text = txtMessage.text {
            chatConversation.append(text)
            txtMessage.text = nil
            tblView.reloadData()
        }
    }
    
    @objc func BackHandle()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            txtconConstrait?.constant = -keyboardSize.height
            UIView.animate(withDuration: keyboardDuration!) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       txtconConstrait?.constant = 0
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
}


/////Extension with UITableController
extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatConversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        if indexPath.row == 1 || indexPath.row == 3{
            cell.isSomeOneText(text: chatConversation[indexPath.row])
        }
        else{
            cell.isOwnText(text: chatConversation[indexPath.row])
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return chatConversation[indexPath.row].estimateFrame().height + 30
    }
}

