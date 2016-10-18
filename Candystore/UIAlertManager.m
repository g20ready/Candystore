//
//  UIAlertManager.m
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import "UIAlertManager.h"

@implementation UIAlertManager

+ (void) presentAlert:(UIViewController *) controller
            withTitle:(NSString *) title
              message:(NSString *) message
          actionTitle:(NSString*) actionTitle {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"No Network"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:alertController completion:nil];
    }];
    [alertController addAction:action];
    [controller presentViewController:alertController animated:true completion:nil];
}

@end
