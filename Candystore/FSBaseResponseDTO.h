//
//  FSBaseResponseDTO.h
//  Candystore
//
//  Created by Marsel Xhaxho on 16/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface FSBaseResponseMeta : JSONModel

@property (strong, nonatomic) NSString* requestId;
@property (nonatomic, assign) NSInteger code;

@end

@interface FSBaseResponseDTO : JSONModel

@property (strong, nonatomic) FSBaseResponseMeta *meta;

@end


