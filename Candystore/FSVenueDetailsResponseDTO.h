//
//  FSVenueDetailsResponseDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBaseResponseDTO.h"
#import "FSVenuesResponseDTO.h"
#import "FSPhotosDataDTO.h"
#import "JSONModel.h"


@interface FSVeuneDetailsDTO : FSVenueDTO

@property (nonatomic, strong) NSNumber<Optional> *rating;
@property (nonatomic, strong) FSPhotosDataDTO *photos;

@end

@interface FSVenueDetailsDataDTO : JSONModel

@property (nonatomic, strong) FSVeuneDetailsDTO *venue;

@end

@interface FSVenueDetailsResponseDTO : FSBaseResponseDTO

@property (nonatomic, strong) FSVenueDetailsDataDTO *response;

@end
