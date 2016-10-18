//
//  UIAlertManager.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertManager : NSObject

+ (void) presentAlert:(UIViewController *) controller
            withTitle:(NSString *) title
              message:(NSString *) message
          actionTitle:(NSString*) actionTitle;

@end
