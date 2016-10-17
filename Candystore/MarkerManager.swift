
//
//  MarkerManager.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MarkerManager : NSObject {
    
    //MARK: Singleton
    
    public static let shared = MarkerManager()
    
    //MARK: Properties
    
    var downloadedImages = [String: UIImage]()
    
    //MARK: Constructor
    
    private override init() {
        
    }
    
    //MARK: Public
    
    public func getCurrentLocationMarker(coordinate: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.icon = UIImage.init(named: "ico-my-location-pin")
        return marker
    }
    
    public func getMarker(venue: FSVenueDTO) -> GMSMarker {
        if (venue.categories != nil && venue.categories.count > 0) {
            let category = venue.categories.first! as! FSVenueCategoryDTO
            let image = self.downloadedImages[category.id]
            return self.getVenueMarker(venue: venue, categoryIcon: image!)
        }
        return self.getVenueMarker(venue: venue, categoryIcon: UIImage())
    }
    
    public func downloadCategoryImages(venues: NSArray, onFinishedDownloading: @escaping () -> Void) {
        let iconsToDownload = categoryIconsToDownload(venues: venues)
        var downloadedCount = 0
        let toDownloadCount = iconsToDownload.keys.count
        for (id, url) in iconsToDownload {
            SDWebImageManager.shared().downloadImage(with: URL(string: url), options: SDWebImageOptions(rawValue: UInt(0x0)), progress: nil, completed: { (image, err, cache, finished, url) in
                
                downloadedCount = downloadedCount + 1
                
                if (err != nil) {
                    print("Error downloading image " + err!.localizedDescription)
                    return
                }
                if self.downloadedImages[id] == nil {
                    print("adding image to downloaded image with id " + id)
                    self.downloadedImages[id] = image
                }
                if downloadedCount == toDownloadCount {
                    DispatchQueue.main.async {
                        onFinishedDownloading()
                    }
                }
            })
        }
    }
    
    //MARK: Private
    
    private func categoryIconsToDownload(venues: NSArray) -> [String: String] {
        var iconsToDownload = [String: String]()
        for venue in venues as! [FSVenueDTO] {
            if (venue.categories != nil && venue.categories.count > 0) {
                let category = venue.categories.first! as! FSVenueCategoryDTO
                if self.downloadedImages[category.id] == nil && iconsToDownload[category.id] == nil{
                    iconsToDownload[category.id] = getCategoryIconUrl(category: category)
                }
            }
        }
        return iconsToDownload
    }
    
    private func getCategoryIconUrl(category: FSVenueCategoryDTO) -> String {
        return category.icon.prefix + "88" + category.icon.suffix
    }
    
    private func getVenueMarker(venue: FSVenueDTO, categoryIcon: UIImage) -> GMSMarker {
        let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat!.doubleValue, longitude: venue.location.lng!.doubleValue)
        let icon = Utils.image(withBackgroundImage: UIImage.init(named: "ico-venue")!, andForegroundImage: categoryIcon)
        let iconSelected = Utils.image(withBackgroundImage: UIImage.init(named: "ico-venue-selected")!, andForegroundImage: categoryIcon)
        let marker = GMSMarker(position: coordinate)
        marker.icon = icon
        marker.userData = getUserDataDictionary(venue: venue, icon: icon!, iconSelected: iconSelected!)
        return marker
    }
    
    private func getUserDataDictionary(venue: FSVenueDTO, icon: UIImage, iconSelected: UIImage) -> NSMutableDictionary{
        let userData: NSMutableDictionary = NSMutableDictionary()
        userData["venue"] = venue
        userData["icon"] = icon
        userData["iconSelected"] = iconSelected
        return userData;
    }
    
}
