//
//  Protocol.swift
//  VSMS
//
//  Created by Vuthy Tep on 7/3/19.
//  Copyright © 2019 121. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol XibtoXib {
    func getDropDownID(Id: String)
}

protocol getValueFromXibDetail: class {    
    func getTitle(value: CellClickViewModel)
    func getPostType(value: CellClickViewModel)
    func getCategory(value: CellClickViewModel)
    func getType(value: CellClickViewModel)
    func getBrand(value: CellClickViewModel)
    func getModel(value: CellClickViewModel)
    func getYear(value: CellClickViewModel)
    func getCondition(value: CellClickViewModel)
    func getColor(value: CellClickViewModel)
    func getVinCode(value: CellClickViewModel)
    func getMachinecode(value: CellClickViewModel)
    func getDescription(value: CellClickViewModel)
    func getPrice(value: CellClickViewModel)
}

protocol getValueFromXibDiscount: class {
    func getDiscountType(value: CellClickViewModel)
    func getDiscount(value: CellClickViewModel)
}

protocol getValueFromXibContact: class {
    func getName(value: CellClickViewModel)
    func getPhoneNumber(value: CellClickViewModel)
    func getEmail(value: CellClickViewModel)
    func getAddress(value: CellClickViewModel)
}

protocol getValueFromXibPhoto: class {
    func getPhoto(Photos: [imageWithPLAsset])
}


protocol RecordCountProtocol: class {
    func getHeighOfCollectionView(recordCount: CGFloat)
}
protocol getDropdowntypeProtocol: class {
    func getDropDownTypeData(type: String)
}

protocol refreshCollectionProtocol: class {
    func refreshCollection(listImage: [imageWithPLAsset])
}

protocol ProfileCellClickProtocol: class {
    func cellClickToDetail(ID: Int)
    func cellClickToEdit(ID: Int)
    func cellClickToDelete(ID: Int)
}

protocol InitailViewControllerProtocol: class {
    func pushNewViewController(ID: Int)
}

protocol CollectionToTableProtocol: class {
    func getFromCollectionCell(ProID: Int)
}

protocol CellClickProtocol: class {
    func cellXibClick(ID: Int)
}

protocol leftMenuClick: class {
    func cellClick(list: String)
}

protocol navigationToHomepage: class {
    func menuClick(list: String)
}

class CellClickViewModel {
    var ID: String = ""
    var Value: String = ""
    var IndexPathKey: NSIndexPath? = nil
    var isChecked: Bool = false
}


struct dropdownData: Codable {
    var ID: String
    var Text: String
    var FKKey: String?
    
    init(json: JSON) {
        self.ID = json["id"].stringValue
        self.Text = json["Text"].stringValue
        self.FKKey = json["FKKey"].string
    }
    
    init(ID: String, Text: String, FKKey: String? ) {
        self.ID = ID
        self.Text = Text
        self.FKKey = FKKey
    }
}
