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
- (void)runPlaceIDRequest;

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
  [self dismissKeyboard];
  [self runPlaceIDRequest];
}

- (void)runPlaceIDRequest
{
  ASJPlaceID *api = [[ASJPlaceID alloc] init];
  [api placeIDForPlace:_placeTextField.text completion:^(ASJResponseStatusCode statusCode, NSString *placeID, NSError *error)
   {
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
