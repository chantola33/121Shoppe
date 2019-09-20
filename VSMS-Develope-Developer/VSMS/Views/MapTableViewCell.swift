//
//  MapTableViewCell.swift
//  VSMS
//
//  Created by Vuthy Tep on 9/18/19.
//  Copyright © 2019 121. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapTableViewCell: UITableViewCell {
     
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
