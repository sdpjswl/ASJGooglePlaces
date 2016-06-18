//
//  BaseController.h
//  ASJGooglePlaces
//
//  Created by sudeep on 14/06/16.
//  Copyright © 2016 Sudeep Jaiswal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController

- (void)showEmptyTextFieldsAlert;
- (void)showAlertWithMessage:(NSString *)message;
- (void)dismissKeyboard;

@end
