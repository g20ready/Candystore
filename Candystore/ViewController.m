//
//  ViewController.m
//  Candystore
//
//  Created by Marsel Xhaxho on 15/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import "ViewController.h"

#import "Candystore-Swift.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)loadView {
    [super loadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark Functions

- (void)setup {
    [self setupStatusBar];
    [self setupNavigationBar];
    [self setupGoogleMap];
    [self setupAddressView];
    [self setupCurrentLocationView];
    [self setupLocationManager];
}

- (void)setupStatusBar {
    [Utils setStatusBarBackgroundColor:[UIColor greenDark]];
}

- (void)setupNavigationBar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenLight]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
}

- (void)setupAddressView {
    [self.addressView setBackgroundColor:[UIColor bordeauxDark]];
    [self.addressLabel setTextColor:[UIColor whiteColor]];
}

- (void)setupCurrentLocationView {
    [self.currentLocationLabel setTextColor:[UIColor bordeauxLight]];
}

- (void)setupGoogleMap {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapContainerView.bounds
                                            camera:camera];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.myLocationEnabled = YES;
    mapView.delegate = self;
    [self.mapContainerView addSubview:mapView];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.map = mapView;
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }else if (status == kCLAuthorizationStatusDenied) {
        self.addressLabel.text = @"Enable location services!";
    }else {
        [self.locationManager requestLocation];
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations && locations.lastObject) {
        CLLocationCoordinate2D coordinate = locations.lastObject.coordinate;
        self.latitudeLabel.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error while reverse geocoding address");
                return;
            }
            if (response.firstResult) {
                GMSAddress *address = response.firstResult;
                NSString *firstLine = [address.lines firstObject];
                [UIView animateWithDuration:0.4 animations:^{
                    self.addressLabel.text = [NSString stringWithFormat:@"%@", firstLine];
                    [self.view layoutIfNeeded];
                }];
            }
        }];
        
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager:didFailWithError:%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        self.addressLabel.text = @"Enable location services!";
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestLocation];
    }
}

#pragma mark GMSMapVieeDelegate

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"didTapMarker:");
    return YES;
}


@end
