//
//  CusTextAreaInput.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/14/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class CusTextAreaInput: UIView, UITextViewDelegate {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var imgCheck: UIImageView!
    @IBOutlet private weak var secondaryLabel: UILabel!
    @IBOutlet private weak var lblPlaceHolder: UILabel!
    
    @IBInspectable var placeHolder: String {
        get{
            return secondaryLabel.text ?? ""
        }
        set(newValue){
            self.secondaryLabel.text = newValue
            self.lblPlaceHolder.text = newValue
        }
    }
    
    @IBInspectable var Value: String {
        get{
            return textView.text
        }
        set(newValue){
            imgCheck.Inputchecked()
            secondaryLabel.isHidden = false
            lblPlaceHolder.isHidden = true
            textView.text = newValue
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0
        {
            secondaryLabel.isHidden = false
            lblPlaceHolder.isHidden = true
        }
        else{
            lblPlaceHolder.isHidden = false
            secondaryLabel.isHidden = true
        }
        
        if textView.text.count > 4
        {
            imgCheck.Inputchecked()
        }
        else{
            imgCheck.InputCrossed()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
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
    
    private func setupXib()
    {
        Bundle.main.loadNibNamed("CusTextAreaInput", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    private func configXib()
    {
        textView.delegate = self
    }

}
