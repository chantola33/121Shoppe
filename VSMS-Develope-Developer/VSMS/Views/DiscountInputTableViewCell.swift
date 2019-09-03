////
////  DiscountInputTableViewCell.swift
////  VSMS
////
////  Created by Vuthy Tep on 7/9/19.
////  Copyright © 2019 121. All rights reserved.
////
//
//import UIKit
//
//
//class DiscountInputTableViewCell: UITableViewCell, getDropdowntypeProtocol {
//
//    @IBOutlet weak var btnDiscountType: UIButton!
//    @IBOutlet weak var lblDiscount: UILabel!
//    @IBOutlet weak var txtDiscount: UITextField!
//    
//    
//    @IBOutlet weak var discountTypeCheck: UIImageView!
//    @IBOutlet weak var discountCheck: UIImageView!
//    
//    
//    weak var setValueDelegate: getValueFromXibDiscount?
//    var passingData = CellClickViewModel()
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupDiscountTypeDropDown()
//        // Initialization code
//        
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleClick)))
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    @objc
//    func HandleClick(){
//        if passingData.IndexPathKey?.row == 0 {
//            Dropdown.show()
//        }
//    }
//    
//    func getDropDownTypeData(type: String) {
//        lblDiscount.text = "Discount \(type)"
//    }
//   
//    @IBAction func txtDiscountChange(_ sender: UITextField) {
//        
//        if sender.text!.count > 0 {
//            discountCheck.Inputchecked()
//        }
//        else{
//            discountCheck.InputCrossed()
//        }
//        
//        passingData.ID = sender.text?.lowercased() ?? ""
//        passingData.Value = sender.text ?? ""
//        self.setValueDelegate?.getDiscount(value: passingData)
//    }
//    
//    func setupDiscountTypeDropDown(){
//        Dropdown.anchorView = self.btnDiscountType
//        Dropdown.dataSource = Functions.getDiscountTypeList()
//        Dropdown.width = self.frame.width
//        // Action triggered on selection
//        Dropdown.selectionAction = { [weak self] (index, item) in
//            self?.discountTypeCheck.Inputchecked()
//            self?.passingData.ID = item.lowercased()
//            self?.passingData.Value = item
//            self?.setValueDelegate?.getDiscountType(value: self!.passingData)
//            self?.btnDiscountType.setTitle(item, for: .normal)
//            self!.Dropdown.hide()
//        }
//    }
//    
//}
