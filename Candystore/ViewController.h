//
//  ViewController.h
//  Candystore
//
//  Created by Marsel Xhaxho on 15/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <NSArray+BlocksKit.h>

#import "MapViewModel.h"

#import "Candystore-Swift.h"

#import "Utils.h"
#import "UIColor+AppColors.h"
#import "NetworkManager.h"

@import GoogleMaps;
@import GooglePlaces;

@interface ViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@property (weak, nonatomic) IBOutlet UIView *detailsContainerView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *venueDetailsContainerTopConstraint;

@property (nonatomic, strong) VenueDetailsViewController *venueDetailsViewController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeBarButtonItem;

@property (nonatomic, strong) MapViewModel *mapViewModel;

@property (nonatomic, assign) BOOL shouldRefresh;

@property (nonatomic, strong) NSURLSessionDataTask *fetchVenuesRequest;

@end

