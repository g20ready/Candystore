//
//  MapViewModel.m
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import "MapViewModel.h"

@implementation MapViewModel

@synthesize currentLocationCoordinate;

@synthesize shouldRefresh;

#pragma mark Init

- (id) init {
    self = [super init];
    if (self) {
        self.markers = [NSMutableDictionary dictionary];
        self.currentLocationCoordinate = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

#pragma mark Public

- (void) updateMarkersFromVenues:(NSArray<FSVenueDTO*>*) venues withFinishedBlock:(markerUpdateFinished) markersUpdatedBlock {
    
    NSArray<GMSMarker*> *removed = [[self.markers.allKeys bk_select:^BOOL(NSString* venueId) {
        return ![venues bk_any:^BOOL(FSVenueDTO *venue) {
            FSVenueDTO *selectedVenue = [self selectedVenue];
            BOOL isSelectedVenue = selectedVenue != nil && [venueId isEqualToString:selectedVenue.id];
            return [venueId isEqualToString:venue.id] || isSelectedVenue;
        }];
    }] bk_map:^id(NSString *venueId) {
        GMSMarker *marker = [self.markers objectForKey:venueId];
        [self.markers removeObjectForKey:venueId];
        return marker;
    }];
    
    NSArray<GMSMarker*> *added = [[venues bk_select:^BOOL(FSVenueDTO *venue) {
        return ![self.markers.allKeys bk_any:^BOOL(NSString *venueId) {
            return [venue.id isEqualToString:venueId];
        }];
    }] bk_map:^id(FSVenueDTO *venue) {
        GMSMarker *marker = [[MarkerManager shared] getMarkerWithVenue:venue];
        self.markers[venue.id] = marker;
        return marker;
    }];
    
    if (markersUpdatedBlock) {
        markersUpdatedBlock(added, removed);
    }
}

- (FSVenueDTO *)selectedVenue {
    if (_selectedMarker) {
        NSDictionary *userData = _selectedMarker.userData;
        return userData[@"venue"];
    }
    return nil;
}

- (BOOL)isCurrentLocationValid {
    return CLLocationCoordinate2DIsValid(self.currentLocationCoordinate);
}


#pragma mark Getters & Setters

- (GMSMarker *)selectedMarker {
    return _selectedMarker;
}

- (void) setSelectedMarker:(GMSMarker *)marker {
    if (_selectedMarker) {
        [self unhilightMarker:_selectedMarker];
    }
    if (marker) {
        [self highlightMarker:marker];
        _selectedMarker = marker;
    }
}

#pragma mark Private

- (void) unhilightMarker:(GMSMarker *)marker {
    NSDictionary *userData = marker.userData;
    marker.icon = userData[@"icon"];
}

- (void) highlightMarker:(GMSMarker *)marker {
    NSDictionary *userData = marker.userData;
    marker.icon = userData[@"iconSelected"];
}


@end
