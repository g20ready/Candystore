//
//  FSUtilsTests.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 18/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import XCTest
@testable import Candystore

class FSUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCategoryIconUrlValidInput() {
        let prefix = "https://ss3.4sqi.net/img/categories_v2/arts_entertainment/default_"
        let suffix = ".png"
        let expectedIconUrl = "https://ss3.4sqi.net/img/categories_v2/arts_entertainment/default_44.png"
        let iconUrl = FSUtils.urlForCategoryIcon(prefix: prefix, resolution: 44, suffix: suffix)
        XCTAssertEqual(iconUrl, expectedIconUrl)
    }
    
    func testCategoryIconUrlFallback() {
        let prefix = "https://ss3.4sqi.net/img/categories_v2/arts_entertainment/default_"
        let suffix = ".png"
        let expectedIconUrl = "https://ss3.4sqi.net/img/categories_v2/arts_entertainment/default_88.png"
        let iconUrl = FSUtils.urlForCategoryIcon(prefix: prefix, resolution: 100, suffix: suffix)
        XCTAssertEqual(iconUrl, expectedIconUrl)
    }
    
    func testPhotoUrlValidInput() {
        let prefix = "https://irs0.4sqi.net/img/general/"
        let suffix = "/26739064_mUxQ4CGrobFqwpcAIoX6YoAdH0xCDT4YAxaU6y65PPI.jpg"
        let expectedPhotoUrl = "https://irs0.4sqi.net/img/general/300x300/26739064_mUxQ4CGrobFqwpcAIoX6YoAdH0xCDT4YAxaU6y65PPI.jpg"
        let photoUrl = FSUtils.urlForPhoto(prefix: prefix, resolution: 300, suffix: suffix)
        XCTAssertEqual(photoUrl, expectedPhotoUrl)
    }
    
    func testPhotoUrlFallback() {
        let prefix = "https://irs0.4sqi.net/img/general/"
        let suffix = "/26739064_mUxQ4CGrobFqwpcAIoX6YoAdH0xCDT4YAxaU6y65PPI.jpg"
        let expectedPhotoUrl = "https://irs0.4sqi.net/img/general/500x500/26739064_mUxQ4CGrobFqwpcAIoX6YoAdH0xCDT4YAxaU6y65PPI.jpg"
        let photoUrl = FSUtils.urlForPhoto(prefix: prefix, resolution: 1000, suffix: suffix)
        XCTAssertEqual(photoUrl, expectedPhotoUrl)
    }
    
}
