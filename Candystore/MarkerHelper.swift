//
//  MapHelper.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps

@objc public class MarkerHelper : NSObject {
    
    static var iconVenue: UIImage {
        return UIImage.init(named: "ico-venue")!
    }
    
    static var iconVenueSelected: UIImage {
        return UIImage.init(named: "ico-venue-selected")!
    }
    
    public static func getCurrentLocationMarker(coordinate: CLLocationCoordinate2D) -> GMSMarker{
        let marker = GMSMarker(position: coordinate)
        marker.icon = UIImage.init(named: "ico-my-location-pin")
        return marker
    }
    
    public static func getCandyStoreMarker(
        coordinate: CLLocationCoordinate2D, object: Any?) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.icon = iconVenue
        marker.userData = object
        return marker
    }
    
    
}
