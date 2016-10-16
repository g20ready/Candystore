//
//  ReverseGeocodeManager.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import Foundation;
import MapKit;
import GooglePlaces;

@objc public class SWiftManager : NSObject {
    
    public static func printHello() {
        print("hello world!");
    }
    
    public static func getAddress(coordinate: CLLocationCoordinate2D) -> String {
        print("Ακαδημίας 120");
        return "Ακαδημίας 120";
    }
    
    public static func getVenues() {
        var url = String("https://api.foursquare.com/v2/venues/search?client_id= UQJURAE0M2WR5LRC1CKB115NOKPETM4WV41E0BYEJFFDK5IT&client_secret=NC5J25U0SCXIUJBXOUKJ1CGZLYKKCR0E3QOQ5I0MSZ00BDBS&ll=37.968869,23.702137&query=candy%20stores&v=20130815")
        url = url?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed);
        let manager = AFHTTPSessionManager();
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.get(url!, parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask!, responseObject: Any?) in
            }, failure: {
                (task: URLSessionDataTask?, error: Error) in
                print("error")
        });
        
    }
    
}



