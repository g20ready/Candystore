//
//  FSVenueLocationDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol FSVenueLocationDTO @end

@interface FSVenueLocationDTO : JSONModel

@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, strong) NSArray<NSString *> *formattedAddress;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSNumber<Optional> *distance;

@end
