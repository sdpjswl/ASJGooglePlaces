//
//  PlaceIDController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJPlaceID.h"
#import "PlaceIDController.h"

@interface PlaceIDController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeIDLabel;

- (IBAction)goTapped:(id)sender;
- (void)executePlaceIDRequest;

@end

@implementation PlaceIDController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Place ID";
}

#pragma mark - Setup
- (IBAction)goTapped:(id)sender
{
  if (!_placeTextField.text.length)
  {
    [self showEmptyTextFieldsAlert];
    return;
  }
  [self dismissKeyboard];
  [self executePlaceIDRequest];
}

- (void)executePlaceIDRequest
{
  ASJPlaceID *api = [[ASJPlaceID alloc] init];
  [api placeIDForPlace:_placeTextField.text completion:^(ASJResponseStatusCode statusCode, NSString *placeID, NSError *error)
   {
     if (!placeID.length || error)
     {
       [self showAlertWithMessage:error.localizedDescription];
       return;
     }
     
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       _placeIDLabel.text = placeID;
     }];
   }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

@end
