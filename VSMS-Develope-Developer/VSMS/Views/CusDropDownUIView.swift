//
//  CustDropDownUIView.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/12/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit

class CusDropDownUIView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var imgValidate: UIImageView!
    @IBOutlet private weak var secondaryLabel: UILabel!
    @IBOutlet private weak var lblText: UILabel!
    
    private var placeHolderValue = ""
    private var id: String = ""
    private var value: String = ""
    
    @IBInspectable var placeHolder: String {
        get{
            return self.placeHolderValue
        }
        set(newValue){
            self.placeHolderValue = newValue
        }
    }
    
    @IBInspectable var Value:String {
        get{
            return self.value
        }
        set(newValue){
            setValue(value: newValue)
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
    
    private func setupXib()
    {
        Bundle.main.loadNibNamed("CusDropDownUIView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }

    private func configXib()
    {
        secondaryLabel.text = placeHolder
        lblText.text = placeHolder
    }
}

extension CusDropDownUIView
{
    func setValue(value: String)
    {
        if value != ""
        {
            secondaryLabel.isHidden = false
            lblText.text = value
            lblText.textColor = UIColor.black
            imgValidate.Inputchecked()
        }
        else{
            secondaryLabel.isHidden = true
            lblText.text = placeHolder
            lblText.textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            imgValidate.InputCrossed()
        }
    }
}
