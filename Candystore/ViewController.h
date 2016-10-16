//
//  ViewController.h
//  Candystore
//
//  Created by Marsel Xhaxho on 15/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Utils.h"
#import "UIColor+AppColors.h"
#import "NetworkManager.h"

@import GoogleMaps;
@import GooglePlaces;

@interface ViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *addressView;

@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@end

