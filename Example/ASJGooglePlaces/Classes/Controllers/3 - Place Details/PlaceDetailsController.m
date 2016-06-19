//
//  PlaceDetailsController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJPlaceDetailsAPI.h"
#import "PlaceDetailsController.h"
#import "UILabel+PreferredWidth.h"

@interface PlaceDetailsController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) ASJPlaceDetails *placeDetails;

- (IBAction)goTapped:(id)sender;
- (void)executePlaceDetailsRequest;
- (void)showDetailsOnScreen;

@end

@implementation PlaceDetailsController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Place Details";
}

#pragma mark - IBAction

- (IBAction)goTapped:(id)sender
{
  if (!_placeTextField.text.length)
  {
    [self showEmptyTextFieldsAlert];
    return;
  }
  [self dismissKeyboard];
  [self executePlaceDetailsRequest];
}

- (void)executePlaceDetailsRequest
{
  ASJPlaceDetailsAPI *api = [[ASJPlaceDetailsAPI alloc] init];
  [api placeDetailsForPlace:_placeTextField.text completion:^(ASJResponseStatusCode statusCode, ASJPlaceDetails *placeDetails, NSError *error)
   {
     if (!placeDetails || error)
     {
       [self showAlertWithMessage:error.localizedDescription];
       return;
     }
     
     _placeDetails = placeDetails;
     [self showDetailsOnScreen];
   }];
}

- (void)showDetailsOnScreen
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^
   {
     if (_placeDetails.placeID.length)
     {
       _placeIDLabel.text = _placeDetails.placeID;
     }
     if (_placeDetails.name.length)
     {
       _nameLabel.text = _placeDetails.name;
     }
     if (_placeDetails.address.length)
     {
       _addressLabel.text = _placeDetails.address;
       _addressLabel.preferredMaxLayoutWidth = [_addressLabel preferredMaxWidthWithPadding:15.0];
     }
     if (_placeDetails.phone.length)
     {
       _phoneLabel.text = _placeDetails.phone;
     }
     if (_placeDetails.website.length)
     {
       _websiteLabel.text = _placeDetails.website;
     }
     
     CGFloat lat = _placeDetails.location.latitude;
     CGFloat lng = _placeDetails.location.longitude;
     if (lat && lng)
     {
       _locationLabel.text = [NSString stringWithFormat:@"%f, %f", lat, lng];
     }
   }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

@end
