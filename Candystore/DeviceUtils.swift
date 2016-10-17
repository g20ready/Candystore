//
//  DeviceUtils.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import UIKit
import Foundation

extension UIScreen {
    
    enum ScreenSize {
        case screen_3_5
        case screen_4
        case screen_4_7
        case screen_5_5
    }
    
    func calculateScreenSize() -> ScreenSize {
        if UIScreen.main.bounds.size.height == 568 {
            return ScreenSize.screen_4
        } else if UIScreen.main.bounds.size.width == 375 {
            return ScreenSize.screen_4_7
        } else if UIScreen.main.bounds.size.width == 414 {
            return ScreenSize.screen_5_5
        }
        //todo add ipad screen sizes
        return ScreenSize.screen_3_5
    }
    

}
