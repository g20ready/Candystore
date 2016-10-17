//
//  FSVenuesResponseDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBaseResponseDTO.h"
#import "FSVenueLocationDTO.h"
#import "FSVenueCategoryDTO.h"
#import "JSONModel.h"

@protocol FSVenueDTO @end

@interface FSVenueDTO : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FSVenueLocationDTO *location;
@property (nonatomic, strong) NSArray<FSVenueCategoryDTO> *categories;

@end

@interface FSVenuesDataDTO : JSONModel

@property (nonatomic, strong) NSArray<FSVenueDTO> *venues;

@end

@interface FSVenuesResponseDTO : FSBaseResponseDTO

@property (nonatomic, strong) FSVenuesDataDTO *response;

@end


