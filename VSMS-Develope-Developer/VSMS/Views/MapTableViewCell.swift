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

class MapTableViewCell: UITableViewCell,CLLocationManagerDelegate,GMSMapViewDelegate {
     
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var userdetail: Profile?
    var ProductDetail = DetailViewModel()
    lazy var geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            mapView.settings.setAllGesturesEnabled(false)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations Locations: [CLLocation]){
        let Address = userdetail?.Address
        let AddressPro = ProductDetail.contact_address
        if (Address == nil || Address == ""){
            let fullAddress = AddressPro.components(separatedBy: ",")
            let latitude = fullAddress[0].toDouble() //First
            let Longtitude = fullAddress[1].toDouble() //Last
            showSpecificPath(latitude: latitude , Longtitude: Longtitude )
        }else {
            let fullAddress = Address?.components(separatedBy: ",")
            let latitude = fullAddress?[0].toDouble() //First
            let Longtitude = fullAddress?[1].toDouble() //Last
            showSpecificPath(latitude: latitude ?? 0.0, Longtitude: Longtitude ?? 0.0)
        }
//        let fullAddress = Address?.components(separatedBy: ",")
//        let latitude = fullAddress?[0].toDouble() //First
//        let Longtitude = fullAddress?[1].toDouble() //Last
//        showSpecificPath(latitude: latitude ?? 0.0, Longtitude: Longtitude ?? 0.0)
    }
    
    func showSpecificPath(latitude: CLLocationDegrees, Longtitude: CLLocationDegrees){
        let Address = userdetail?.Address
        let AddressPro = ProductDetail.contact_address
        
        if (Address == nil || Address == ""){
            let fullAddress = AddressPro.components(separatedBy: ",")
            _ = fullAddress[0].toDouble() //First
            _ = fullAddress[1].toDouble() //Last
        }else {
            let fullAddress = Address?.components(separatedBy: ",")
            _ = fullAddress?[0].toDouble() //First
            _ = fullAddress?[1].toDouble() //Last
        }
        let camera = GMSCameraPosition.camera(withLatitude: latitude , longitude: Longtitude , zoom: 16)
        self.mapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
        let location = CLLocation(latitude: latitude , longitude: Longtitude )
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude , longitude: Longtitude )
            marker.map = self.mapView
            
        }
        
    }

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            lblAddress.text = "Unable to Find Address for Location"
        }else{
            if let placemarks = placemarks, let placemark = placemarks.first{
                lblAddress.text = "Address: \(placemark.compactAddrss ?? "")"
            }else{
                lblAddress.text = "No Maching Address Found"
            }
        }
        
    }
    
}
