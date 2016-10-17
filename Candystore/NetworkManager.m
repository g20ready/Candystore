//
//  NetworkManager.m
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (NetworkManager *)sharedManager {
    static NetworkManager *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[NetworkManager alloc] init];
    });
    return sharedEngine;
}

- (NSString*) urlWithKeys:(NSString *) url {
    NSString *result = [url stringByReplacingOccurrencesOfString:@"_CLIENT_ID"
                                                      withString:FOURSQUARE_CLIENT_ID];
    result = [result stringByReplacingOccurrencesOfString:@"_CLIENT_SECRET"
                                               withString:FOURSQUARE_CLIENT_SECRET];
    result = [result stringByReplacingOccurrencesOfString:@"_VERSION"
                                               withString:FOURSQUARE_VERSION];
    return result;
}

- (NSString*) encodeUrl:(NSString *) url {
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSURLSessionDataTask *) fetchVenuesAtLat:(NSNumber*) lat
                    atLng:(NSNumber*) lng
                    query:(NSString*) query
               completion:(fetchedVenues) completionHandler {
    NSString *url = [self urlWithKeys:VENUES_URL];
    url = [url stringByReplacingOccurrencesOfString:@"_LAT"
                                         withString:[lat stringValue]];
    url = [url stringByReplacingOccurrencesOfString:@"_LNG"
                                         withString:[lng stringValue]];
    url = [url stringByReplacingOccurrencesOfString:@"_QUERY" withString:query];
    url = [self encodeUrl:url];
    NSLog(@"GET: %@", url);
    
    return [self GET:url
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSError *err = nil;
        FSVenuesResponseDTO *response = [[FSVenuesResponseDTO alloc] initWithDictionary:responseObject error:&err];
        if (err) {
            completionHandler(nil, err);
            return;
        }
        completionHandler(response.response.venues, nil);
    }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        completionHandler(nil, error);
    }];
}

- (NSURLSessionDataTask *) fetchVenueDetails:(NSString *)venueId
                completion:(fetchedVenueDetails)completionHandler {
    NSString *url = [self urlWithKeys:VENUE_DETAILS_URL];
    url = [url stringByReplacingOccurrencesOfString:@"_VENUE_ID"
                                         withString:venueId];
    url = [self encodeUrl:url];
    
    NSLog(@"GET: %@", url);
    
    return [self GET:url
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSError *err = nil;
        FSVenueDetailsResponseDTO *response = [[FSVenueDetailsResponseDTO alloc] initWithDictionary:responseObject error:&err];
        if (err) {
            completionHandler(nil, err);
            return;
        }
        completionHandler(response.response.venue, nil);
    }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        completionHandler(nil, error);
    }];
}


@end
