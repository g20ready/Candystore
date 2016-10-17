//
//  Utils.m
//  Candystore
//
//  Created by Marsel Xhaxho on 15/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

+ (UIImage *)imageWithBackgroundImage:(UIImage *)bgImage andForegroundImage:(UIImage *)fgImage {
    CGSize imageSize = bgImage.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    float minDimension = imageSize.width > imageSize.height ? imageSize.height : imageSize.width;
    [fgImage drawInRect:CGRectMake(0, 0, minDimension, minDimension)];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

@end
