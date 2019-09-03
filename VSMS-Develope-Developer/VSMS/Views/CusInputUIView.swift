//
//  CusInputUIView.swift
//  VSMS
//
//  Created by Rathana on 8/9/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class CusInputUIView: UIView, UITextFieldDelegate {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var txtInput: UITextField!
    @IBOutlet private weak var imgValidate: UIImageView!
    @IBOutlet private weak var secondaryLabel: UILabel!
    
    @IBInspectable private var placeHolder: String = ""
    @IBInspectable var keyboard:Int{
        get{
            return self.txtInput.keyboardType.rawValue
        }
        set(keyboardIndex){
            self.txtInput.keyboardType = UIKeyboardType.init(rawValue: keyboardIndex)!
        }
    }
    
    @IBInspectable var Value:String {
        get{
            return txtInput.text ?? ""
        }
        set(newValue){
            if newValue == "" {
                return
            }
            imgValidate.Inputchecked()
            secondaryLabel.isHidden = false
            txtInput.text = newValue
        }
    }
    
    @IBInspectable var disabled: Bool {
        get{
            return txtInput.isUserInteractionEnabled
        }
        set(newValue){
            txtInput.isUserInteractionEnabled = !newValue
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    private func setupXib()
    {
        Bundle.main.loadNibNamed("CusInputUIView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    private func configXib()
    {
        txtInput.delegate = self
        secondaryLabel.text = self.placeHolder
        txtInput.placeholder = self.placeHolder
        txtInput.returnKeyType = UIReturnKeyType.done
        
        if keyboard == 4
        {
            txtInput.addDoneButtonOnKeyboard()
        }
    }
    
    @IBAction func TextChangeHandle(_ sender: UITextField) {
        
        if sender.text!.count > 0 {
            self.secondaryLabel.isHidden = false
        }
        else
        {
            self.secondaryLabel.isHidden = true
        }
        
        switch keyboard
        {
        case 0:
            if sender.text!.count > 2
            {
                imgValidate.Inputchecked()
            }
            else{
                imgValidate.InputCrossed()
            }
        case 4:
            if sender.text!.count > 0
            {
                imgValidate.Inputchecked()
            }
            else{
                imgValidate.InputCrossed()
            }
        default:
            break
        }
        if (sender.text?.last == "\n") {
            txtInput.resignFirstResponder()
        }
    }
    
}
