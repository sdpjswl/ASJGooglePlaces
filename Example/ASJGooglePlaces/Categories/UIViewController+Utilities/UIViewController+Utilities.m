//
//  UIViewController+Utilities.m
//  ASJGooglePlaces
//
//  Created by sudeep on 03/05/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Boo!" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

@end
