//
//  FSVenueCategoryDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface FSVenueCategoryDTO : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortName;

@end
