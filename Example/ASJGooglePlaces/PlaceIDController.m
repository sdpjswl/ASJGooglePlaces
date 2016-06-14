//
//  PlaceIDController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "PlaceIDController.h"
#import "ASJPlaceID.h"
#import "UIViewController+Utilities.h"

@interface PlaceIDController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *placeTextField;
@property (nonatomic) IBOutlet UILabel *placeIDLabel;

- (IBAction)goTapped:(id)sender;
- (void)runPlaceIDRequest;

@end

@implementation PlaceIDController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.title = @"Place ID";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Methods

- (IBAction)goTapped:(id)sender {
  [self dismissKeyboard];
  [self runPlaceIDRequest];
}

- (void)runPlaceIDRequest
{
  ASJPlaceID *api = [[ASJPlaceID alloc] init];
  [api placeIDForPlace:_placeTextField.text completion:^(ASJResponseStatusCode statusCode, NSString *placeID)
   {
     dispatch_async(dispatch_get_main_queue(), ^{
       _placeIDLabel.text = placeID;
     });
   }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  return [textField resignFirstResponder];
}

@end
