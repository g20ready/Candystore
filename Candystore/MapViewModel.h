//
//  MapViewModel.h
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSArray+BlocksKit.h>
#import "FSVenuesResponseDTO.h"

#import "Candystore-Swift.h"

@import GoogleMaps;

@interface MapViewModel : NSObject {
    GMSMarker *_selectedMarker;
}

#pragma mark Properties

@property (nonatomic, strong) NSMutableDictionary *markers;

#pragma mark Blocks

typedef void (^markerUpdateFinished)(NSArray<GMSMarker*> *markersAdded, NSArray<GMSMarker*> *markersRemoved);

#pragma mark Interface

- (GMSMarker *)selectedMarker;
- (void) setSelectedMarker:(GMSMarker *)marker;

- (FSVenueDTO *)selectedVenue;

- (void) updateMarkersFromVenues:(NSArray<FSVenueDTO*>*) venues withFinishedBlock:(markerUpdateFinished) markersUpdatedBlock;



@end
