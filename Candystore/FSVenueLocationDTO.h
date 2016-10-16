//
//  FSVenueLocationDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface FSVenueLocationDTO : JSONModel

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray<NSString *> *formattedAddress;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;

@end
