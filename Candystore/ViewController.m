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
    self.mapViewModel = [[MapViewModel alloc] init];
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
            self.addressLabel.text = [NSString stringWithFormat:@"%@", firstLine];
            [self.view layoutIfNeeded];
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
            [self.mapViewModel updateMarkersFromVenues:venues withFinishedBlock:^(NSArray<GMSMarker *> *markersAdded, NSArray<GMSMarker *> *markersRemoved) {
                NSLog(@"%ld marsersAdded, %ld markersRemoved from a total of %ld venues", markersAdded.count, markersRemoved.count, venues.count);
                [markersAdded enumerateObjectsUsingBlock:^(GMSMarker * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.map = self.mapView;
                }];
                [markersRemoved enumerateObjectsUsingBlock:^(GMSMarker * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.map = nil;
                }];
            }];
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
    if (self.locationManager.location) {
        CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
        [self zoomAtCurrentLocation:coordinate];
    }
}

- (IBAction)closeBarButtonItemClick:(id)sender {
    self.mapViewModel.selectedMarker = nil;
    [self hideVenueDetailsView];
    [self.navigationItem setRightBarButtonItem:nil
                                      animated:true];
}


#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations && locations.lastObject) {
        CLLocationCoordinate2D coordinate = locations.lastObject.coordinate;
        
        
        [self addCurrentLocationMarker:coordinate];
        [self loadAddressAtCoordinate:coordinate];
        
        //We explicitly refresh when receiving location
        //and moving camera to it
        NSLog(@"Received Location");
        self.mapViewModel.shouldRefresh = YES;
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
    self.mapViewModel.selectedMarker = marker;
    self.venueDetailsViewController.venue = [self.mapViewModel selectedVenue];
    [self showVenueDetailsView];
    [self.navigationItem setRightBarButtonItem:self.closeBarButtonItem
                                      animated:true];
    return YES;
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self hideVenueDetailsView];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    self.mapViewModel.selectedMarker = nil;
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    self.mapViewModel.shouldRefresh = gesture;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"idleAtCameraPosition");
    if (self.mapViewModel.shouldRefresh) {
        NSLog(@"refreshing");
        self.mapViewModel.shouldRefresh = NO;
        [self cancelRefreshVenues];
        [self performSelector:@selector(refreshVenues)
                   withObject:nil
                   afterDelay:1.5f];
    }
}

@end
