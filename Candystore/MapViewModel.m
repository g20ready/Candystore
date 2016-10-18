//
//  MapViewModel.m
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import "MapViewModel.h"

@implementation MapViewModel

#pragma mark Init

- (id) init {
    self = [super init];
    if (self) {
        self.markers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Public

- (void) updateMarkersFromVenues:(NSArray<FSVenueDTO*>*) venues withFinishedBlock:(markerUpdateFinished) markersUpdatedBlock {
    
    NSArray<GMSMarker*> *removed = [[self.markers.allKeys bk_select:^BOOL(NSString* venueId) {
        return ![venues bk_any:^BOOL(FSVenueDTO *venue) {
            return [venueId isEqualToString:venue.id];
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

#pragma mark Getters & Setters

- (GMSMarker *)selectedMarker {
    NSLog(@"selectedMarker");
    return _selectedMarker;
}

- (void) setSelectedMarker:(GMSMarker *)marker {
    NSLog(@"setSelectedMarker");
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
