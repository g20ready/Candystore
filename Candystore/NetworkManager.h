//
//  NetworkManager.h
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Definitions.h"
#import "FSVenuesResponseDTO.h"
#import "FSVenueDetailsResponseDTO.h"

static NSString * const VENUES_URL = @"https://api.foursquare.com/v2/venues/search?client_id= _CLIENT_ID&client_secret=_CLIENT_SECRET&v=_VERSION&ll=_LAT,_LNG&query=_QUERY";

static NSString * const VENUE_DETAILS_URL = @"https://api.foursquare.com/v2/venues/_VENUE_ID?client_id= _CLIENT_ID&client_secret=_CLIENT_SECRET&v=_VERSION";

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager *)sharedManager;

#pragma mark GET

typedef void (^fetchedVenues)(NSArray<FSVenueDTO *>* venues, NSError* error);

- (NSURLSessionDataTask *) fetchVenuesAtLat:(NSNumber*) lat
                    atLng:(NSNumber*) lng
                    query:(NSString*) query
               completion:(fetchedVenues) completionHandler;

typedef void (^fetchedVenueDetails)(FSVeuneDetailsDTO *venueDetails, NSError* error);

- (NSURLSessionDataTask *) fetchVenueDetails:(NSString*) venueId
             completion:(fetchedVenueDetails) completionHandler;


@end
