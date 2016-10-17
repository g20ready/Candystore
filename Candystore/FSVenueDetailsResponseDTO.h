//
//  FSVenueDetailsResponseDTO.h
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

@interface FSVeuneDetailsDTO : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FSVenueLocationDTO *location;
@property (nonatomic, strong) NSArray<FSVenueCategoryDTO> *categories;
@property (nonatomic, strong) NSNumber *rating;

@end

@interface FSVenueDetailsDataDTO : JSONModel

@property (nonatomic, strong) FSVeuneDetailsDTO *venue;

@end

@interface FSVenueDetailsResponseDTO : FSBaseResponseDTO

@property (nonatomic, strong) FSVenueDetailsDataDTO *response;

@end
