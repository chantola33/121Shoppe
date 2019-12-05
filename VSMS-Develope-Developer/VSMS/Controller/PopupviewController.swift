//
//  PopupviewController.swift
//  VSMS
//
//  Created by usah on 11/27/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit

class PopupviewController: BaseViewController {
    
    @IBOutlet weak var shop_name: UITextField!
    @IBOutlet weak var shop_address: UITextField!
    @IBOutlet weak var shop_image: UIImageView!
    var ShopData : [AccountViewModel] = []
    var putshop = AccountViewModel()
    let alertService = AlertService()
    
    var pickPhotoCheck = ""
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
      
        shop_image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        shop_image.addGestureRecognizer(tapGesture)
    }
   
    override func didReceiveMemoryWarning() {
        	super.didReceiveMemoryWarning()
    }
    @objc func tapGesture(){
       
        print("action image")
        self.pickPhotoCheck = "profile"
        let alertCon = UIAlertController(title: "Edit Profile", message: nil, preferredStyle: .actionSheet)
        let uploadBtn = UIAlertAction(title: "Upload", style: .default) { (alert) in
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true, completion: nil)
        }
        let takeNewCover = UIAlertAction(title: "Take a Photo", style: .default) { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.present(self.picker, animated: true, completion: nil)
            }
            else{
                Message.ErrorMessage(message: "Camera in your device is not avialable.", View: self)
            }
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertCon.addAction(uploadBtn)
        alertCon.addAction(takeNewCover)
        alertCon.addAction(cancelBtn)
        present(alertCon, animated: true, completion: nil)
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func onClickSubmit(_ sender: Any) {
//        let user = User.getUserID()
//        let image = UIImage(named: "121logo")
        let pushAlert = alertService.setData(name: shop_name.text!, address: shop_address.text!)
        present(pushAlert, animated: true)
        dismiss(animated: true)
    }

}

extension PopupviewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true)
            selectedImage.UpLoadProfile(completion: {
                self.shop_image.image = selectedImage
            })
        }
    }
}





    

