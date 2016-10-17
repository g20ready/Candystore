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
    
    static var images = [String: UIImage]()
    
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
    
    static func getCategoryIconUrl(category: FSVenueCategoryDTO) -> (String) {
        return category.icon.prefix + "88" + category.icon.suffix
    }
    
    public static func getCandyStoreMarker(
        coordinate: CLLocationCoordinate2D, venue: FSVenueDTO!, onMarkerReady: @escaping (GMSMarker) -> Void) {
        let userData: NSMutableDictionary = NSMutableDictionary()
        userData["venue"] = venue
        if (venue.categories != nil && venue.categories.count > 0) {
            let category = venue.categories.first! as! FSVenueCategoryDTO
            let imageUrl = self.getCategoryIconUrl(category: category)
            downloadImage(imageUrl: imageUrl, onImageDownloaded: {
                (image) in
                DispatchQueue.main.async {
                    
                    let icon = Utils.image(withBackgroundImage: iconVenue, andForegroundImage: image)
                    let iconSelected = Utils.image(withBackgroundImage: iconVenueSelected, andForegroundImage: image)
                    userData["icon"] = icon
                    userData["iconSelected"] = iconSelected
                    
                    let marker = GMSMarker(position: coordinate)
                    marker.userData = userData
                    marker.icon = icon
                    onMarkerReady(marker)
                }
            })
        }
    }
    
    public static func downloadImage(imageUrl: String, onImageDownloaded: @escaping (UIImage) -> Void) {
        let url = URL(string: imageUrl)
        SDWebImageDownloader.shared().downloadImage(
            with: url, options: SDWebImageDownloaderOptions(rawValue: UInt(0x0)), progress: nil, completed:{
                (image, data, err, finished) in
                if (err != nil) {
                    return
                }
                onImageDownloaded(image!)
        })
        
    }
    
    
    
}
