//
//  BaseController.m
//  ASJGooglePlaces
//
//  Created by sudeep on 14/06/16.
//  Copyright © 2016 Sudeep Jaiswal. All rights reserved.
//

#import "BaseController.h"

@implementation BaseController

- (void)showEmptyTextFieldsAlert
{
    [self showAlertWithMessage:@"One or more text fields is empty."];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Boo!" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
