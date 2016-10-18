//
//  FSUtils.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 18/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import UIKit

class FSUtils {

    static let categoryIconResolutions: [Int] = [32, 44, 64, 88]
    
    /**
     Returns a url for an category icon object from the Foursquare Api.
     @param prefix the uri part before reolution.
     @param resolution dimension of the resource where dimension should be a value from [32, 44, 64, 77]. Fallbacks to 88.
     @param suffix the uri part after resolution.
     @return valid url
     */
    public static func urlForCategoryIcon(prefix: String, resolution: Int, suffix: String) -> String {
        var res = resolution
        if !categoryIconResolutions.contains(res) {
            res = categoryIconResolutions.last!
        }
        return ("\(prefix)\(res)\(suffix)")
    }
    
    static let photoResolution: [Int] = [34, 100, 300, 500]
    
    /**
        Returns a url for a photo object from the Foursquare Api.
        @param prefix the uri part before reolution.
        @param resolution dimension of the resource where dimension should be a value from [36, 100, 300, 500]. Fallbacks to 500.
        @param suffix the uri part after resolution.
        @return valid url
    */
    public static func urlForPhoto(prefix: String, resolution: Int, suffix: String) -> String {
        var res = resolution
        if !photoResolution.contains(res) {
            res = photoResolution.last!
        }
        return ("\(prefix)\(res)x\(res)\(suffix)")
    }

}
