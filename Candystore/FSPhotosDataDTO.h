//
//  FSPhotosDataDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol FSPhotoItem

@end

@interface FSPhotoItem : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *prefix;
@property (nonatomic, strong) NSString *suffix;

@end

@protocol FSPhotosGroupDTO

@end

@interface FSPhotosGroupDTO : JSONModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSArray<FSPhotoItem> *items;

@end

@interface FSPhotosDataDTO : JSONModel

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSArray<FSPhotosGroupDTO> *groups;

@end
