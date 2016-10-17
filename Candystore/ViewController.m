//
//  ViewController.m
//  Candystore
//
//  Created by Marsel Xhaxho on 15/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView;
@synthesize markers;

- (void)viewDidLoad {self.mapView.selectedMarker = nil;
    [super viewDidLoad];
    [self setup];
    [self hideVenueDetailsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"venueDetailsSegue"]) {
        self.venueDetailsViewController = segue.destinationViewController;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark Setup

- (void)setup {
    [self setupStatusBar];
    [self setupNavigationBar];
    [self setupGoogleMap];
    [self setupAddressView];
    [self setupCurrentLocationView];
    [self setupLocationManager];
    [self setupData];
}

- (void)setupStatusBar {
    [Utils setStatusBarBackgroundColor:[UIColor greenDark]];
}

- (void)setupNavigationBar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenLight]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)setupAddressView {
    [self.addressView setBackgroundColor:[UIColor bordeauxDark]];
    [self.addressLabel setTextColor:[UIColor whiteColor]];
}

- (void)setupCurrentLocationView {
    [self.currentLocationLabel setTextColor:[UIColor bordeauxLight]];
}

- (void)setupGoogleMap {
    mapView = [[GMSMapView alloc] initWithFrame:self.mapContainerView.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    [self.mapContainerView addSubview:mapView];
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager requestLocation];
}

- (void)setupData {
    markers = [NSMutableArray array];
}

#pragma mark Functions

- (void)updateAddressLabel {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.addressLabel.text = @"Locating you...";
    }else {
        self.addressLabel.text = @"Enable location services...";
    }
}


- (void)addCurrentLocationMarker:(CLLocationCoordinate2D)coordinate {
    GMSMarker *marker = [MarkerHelper getCurrentLocationMarkerWithCoordinate:coordinate];
    marker.map = mapView;
}

- (void)zoomAtCurrentLocation:(CLLocationCoordinate2D)coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:15];
    //Forcing refresh when we zoom at current location
    self.shouldRefresh = YES;
    [self.mapView animateToCameraPosition:camera];
}

- (void)loadAddressAtCoordinate:(CLLocationCoordinate2D)coordinate {
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

- (void)cancelRequest {
    if (self.fetchVenuesRequest &&
        self.fetchVenuesRequest.state == NSURLSessionTaskStateRunning) {
        [self.fetchVenuesRequest cancel];
    }
}

- (void)loadVenuesNearCoordinate:(CLLocationCoordinate2D)coordinate {
    NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:coordinate.longitude];
    
//    [self cancelRequest];
    
    self.fetchVenuesRequest =
    [[NetworkManager sharedManager] fetchVenuesAtLat:lat
                                               atLng:lng
                                               query:@"candy store"
                                          completion:
     ^(NSArray<FSVenueDTO *> *venues, NSError *error)
    {
        if (error) {
            NSLog(@"Error fetching candy stores : %@", error.localizedDescription);
            return;
        }
        [[MarkerManager shared] downloadCategoryImagesWithVenues:venues onFinishedDownloading:^{
            [self clearMarkers];
            [self addMarkersFromVenues:venues];
        }];
        
    }];
}

- (void)refreshVenues {
    CLLocationCoordinate2D coordinate = self.mapView.camera.target;
    [self loadVenuesNearCoordinate:coordinate];
    
}

- (void)cancelRefreshVenues {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(refreshVenues)
                                               object:nil];
}

- (void)addMarkersFromVenues:(NSArray<FSVenueDTO*> *) venues {
    NSLog(@"addMarkersFromVenues");
    [venues enumerateObjectsUsingBlock:^(FSVenueDTO * _Nonnull venue, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.selectedMarker) {
            NSDictionary *userDate = self.selectedMarker.userData;
            FSVenueDTO *selectedMarkerVenue = [userDate objectForKey:@"venue"];
            if ([selectedMarkerVenue.id isEqualToString:venue.id]) {
                return;
            }
        }
        GMSMarker *marker = [[MarkerManager shared] getMarkerWithVenue:venue];
        marker.map = mapView;
        [markers addObject:marker];
    }];
}

- (void)clearMarkers {
    NSLog(@"Clearing Markers");
    [self.mapView clear];
//    if (self.markers) {
//        [self.markers enumerateObjectsUsingBlock:^(GMSMarker * _Nonnull marker, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![marker isEqual:self.selectedMarker]) {
//                marker.map = nil;
//                [self.markers removeObject:marker];
//            }else {
//                NSLog(@"marker %ld is selected Marker", idx);
//            }
//        }];
//    }
}

- (void) unhighlightMarkerIfNeeded {
    if (self.selectedMarker) {
        NSMutableDictionary *dict = [self.selectedMarker userData];
        self.selectedMarker.icon = [dict objectForKey:@"icon"];
        self.selectedMarker = nil;
    }
}

- (void) highlightMarker:(GMSMarker *)marker {
    if (marker) {
        NSMutableDictionary *userData = marker.userData;
        marker.icon = [userData objectForKey:@"iconSelected"];
        self.selectedMarker = marker;
        self.venueDetailsViewController.venue = [userData objectForKey:@"venue"];
    }
}

- (void) hideVenueDetailsView {
    self.venueDetailsContainerTopConstraint.constant = -120;
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:30
                        options:0x0
                     animations:^
    {
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        NSLog(@"hideVenueDetailsView.finished");
    }];
}

- (void) showVenueDetailsView {
    self.venueDetailsContainerTopConstraint.constant = 16;
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:30
                        options:0x0
                     animations:^
    {
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        NSLog(@"showVenueDetailsView.finished");
    }];
}

#pragma mark NavigationItemHandlers

- (IBAction)homeBarButtonItemClick:(id)sender {
    NSLog(@"homeBarButtonItemClick");
}

- (IBAction)closeBarButtonItemClick:(id)sender {
    [self unhighlightMarkerIfNeeded];
    [self hideVenueDetailsView];
    [self.navigationItem setRightBarButtonItem:nil
                                      animated:true];
}


#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations && locations.lastObject) {
        CLLocationCoordinate2D coordinate = locations.lastObject.coordinate;
        NSLog(@"didUpdateLocation [%f, %f]",
              coordinate.latitude, coordinate.longitude);
        [self addCurrentLocationMarker:coordinate];
        [self loadAddressAtCoordinate:coordinate];
        [self zoomAtCurrentLocation:coordinate];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager:didFailWithError:%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self updateAddressLabel];
    [self.locationManager requestLocation];
}

#pragma mark GMSMapVieeDelegate

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    [self cancelRefreshVenues];
    
    if (![marker userData]) {
        return YES;
    }
    if ([marker isEqual:self.selectedMarker]) {
        return YES;
    }
    [self unhighlightMarkerIfNeeded];
    [self highlightMarker:marker];
    [self showVenueDetailsView];
    [self.navigationItem setRightBarButtonItem:self.closeBarButtonItem
                                      animated:true];
    return YES;
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"didTapAtCoordinate");
    if (self.selectedMarker) {
        [self hideVenueDetailsView];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    [self unhighlightMarkerIfNeeded];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    NSLog(@"moved");
    self.shouldRefresh = gesture;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    if (self.shouldRefresh) {
        NSLog(@"Refreshing");
        self.shouldRefresh = false;
        [self performSelector:@selector(refreshVenues)
                   withObject:nil
                   afterDelay:1.5f];
    }
}

@end
