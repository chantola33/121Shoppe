//
//  LoanViewController.swift
//  VSMS
//
//  Created by Vuthy Tep on 8/8/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import RSSelectionMenu
import Toast_Swift

class LoanViewController: UITableViewController { 
    
    
    @IBOutlet weak var inpJob: CusInputUIView!
    @IBOutlet weak var inpCoBorrower: CusDropDownUIView!
    @IBOutlet weak var inpMonthlyIncome: CusInputUIView!
    @IBOutlet weak var inpMonthlyExpense: CusInputUIView!
    @IBOutlet weak var inpLoanPurpose: CusInputUIView!
    @IBOutlet weak var inpLoanAmount: CusInputUIView!
    @IBOutlet weak var inpTerm: CusInputUIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBOutlet weak var inpState: CusDropDownUIView!
    @IBOutlet weak var inpFamily: CusDropDownUIView!
    @IBOutlet weak var inpStaff: CusDropDownUIView!
    @IBOutlet weak var inpHouse: CusDropDownUIView!
    
    
    var Loan: LoanViewModel = LoanViewModel()
    var is_Edit: Bool = false
    var is_Detail: Bool = false
    var StringArr: [String] = ["Yes", "No"]
    
    var BorrowSelected = [String]()
    var StateSelected = [String]()
    var FamilySelected = [String]()
    var StaffSelected = [String]()
    var HouseSelected = [String]()
    
    var tableSection = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if is_Detail
        {
            self.view.makeToastActivity(.center)
            LoanViewModel.Detail(loanID: Loan.id!) { (val) in
                self.view.hideToastActivity()
                self.Loan = val
                self.LoadData()
                self.tableView.allowsSelection = false
                self.disableInputWhenDetail()
                self.tableSection = 3
                self.tableView.reloadData()
            }
        }
        
        if is_Edit
        {
            self.btnSubmit.setTitle("Update", for: .normal)
            self.navigationItem.title = "Edit Loan Information"
            self.view.makeToastActivity(.center)
            LoanViewModel.Detail(loanID: Loan.id!) { (val) in
                self.Loan = val
                self.LoadData()
                self.view.hideToastActivity()
            }
        }
        
    }
    
    func LoadData()
    {
        inpJob.Value = Loan.job
        inpCoBorrower.Value = Loan.username
        inpMonthlyIncome.Value = Loan.average_income
        inpMonthlyExpense.Value = Loan.average_expense
        inpLoanPurpose.Value = Loan.loan_purpose
        inpLoanAmount.Value = Loan.loan_amount
        inpTerm.Value = Loan.loan_duration
        inpState.Value = getBoolToString(val: Loan.staff_id)
        inpFamily.Value = getBoolToString(val: Loan.family_book)
        inpStaff.Value = getBoolToString(val: Loan.state_id)
        inpHouse.Value = getBoolToString(val: Loan.house_plant)
    }
    
    private func disableInputWhenDetail()
    {
        inpJob.disabled = true
        inpMonthlyIncome.disabled = true
        inpMonthlyExpense.disabled = true
        inpLoanPurpose.disabled = true
        inpLoanAmount.disabled = true
        inpTerm.disabled = true
    }
    
    
    
    @IBAction func submitClick(_ sender: Any) {
        Loan.job = inpJob.Value
        Loan.average_income = inpMonthlyIncome.Value
        Loan.average_expense = inpMonthlyExpense.Value
        //Loan.username = inpCoBorrower.value
        Loan.loan_purpose = inpLoanPurpose.Value
        Loan.loan_amount = inpLoanAmount.Value
        Loan.loan_duration = inpTerm.Value
        
        if is_Edit {
            Loan.Update { (result) in
                if result
                {
                    Message.SuccessMessage(message: "Loan has been updated successfully.", View: self, callback: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        else{
            Loan.Save { (check) in
                if check
                {
                    Message.SuccessMessage(message: "Loan has been submit successfully.", View: self, callback: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    // MARK: - Configuration
    func Configuration()
    {
        self.navigationItem.title = "Loan Information"
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableSection
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1
        {
            self.SelectBorrowerOption(style: .alert(title: "Co-Borrower", action: nil, height:150))
        }
        
        if indexPath.section == 2
        {
            switch indexPath.row
            {
            case 0:
                self.SelectStateOption(style: .alert(title: "State ID", action: nil, height: 150))
            case 1:
                self.SelectFamilyOption(style: .alert(title: "Family Book", action: nil, height: 150))
            case 2:
                self.SelectStaffOption(style: .alert(title: "Staff ID / Salary Slip", action: nil, height: 150))
            case 3:
                self.SelectHouseOption(style: .alert(title: "House Plant", action: nil, height: 150))
            default:
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension LoanViewController
{
    func SelectBorrowerOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: StringArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items: BorrowSelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self!.BorrowSelected = selectedItems
            self!.inpCoBorrower.Value = text!
            self!.Loan.username = text!
            self!.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func SelectStateOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: StringArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items: StateSelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self!.StateSelected = selectedItems
            self!.inpState.Value = text!
            self!.Loan.state_id = text!.getBoolean()
            self!.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func SelectFamilyOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: StringArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items: FamilySelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self!.FamilySelected = selectedItems
            self!.inpFamily.Value = text!
            self!.Loan.family_book = text!.getBoolean()
            self!.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func SelectStaffOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: StringArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items: StaffSelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self!.StaffSelected = selectedItems
            self!.inpStaff.Value = text!
            self!.Loan.staff_id = text!.getBoolean()
            self!.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func SelectHouseOption(style: PresentationStyle)
    {
        let selectionMenu = RSSelectionMenu(dataSource: StringArr) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.setSelectedItems(items: HouseSelected)
        { [weak self] (text, index, isSelected, selectedItems) in
            self!.HouseSelected = selectedItems
            self!.inpHouse.Value = text!
            self!.Loan.house_plant = text!.getBoolean()
            self!.tableView.reloadData()
        }
        selectionMenu.show(style: style, from: self)
    }
    
    func getBoolToString(val: Bool) -> String
    {
        if val {
            return "Yes"
        }
        else {
            return "No"
        }
    }
}

private extension String
{
    func getBoolean() -> Bool
    {
        if self == "Yes"
        {
            return true
        }
        else
        {
            return false
        }
    }

}

