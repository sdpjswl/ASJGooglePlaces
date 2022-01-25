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
        
        self->_placeDetails = placeDetails;
        [self showDetailsOnScreen];
    }];
}

- (void)showDetailsOnScreen
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
        if (self->_placeDetails.placeID.length)
        {
            self->_placeIDLabel.text = self->_placeDetails.placeID;
        }
        if (self->_placeDetails.name.length)
        {
            self->_nameLabel.text = self->_placeDetails.name;
        }
        if (self->_placeDetails.address.length)
        {
            self->_addressLabel.text = self->_placeDetails.address;
            self->_addressLabel.preferredMaxLayoutWidth = [self->_addressLabel preferredMaxWidthWithPadding:15.0];
        }
        if (self->_placeDetails.phone.length)
        {
            self->_phoneLabel.text = self->_placeDetails.phone;
        }
        if (self->_placeDetails.website.length)
        {
            self->_websiteLabel.text = self->_placeDetails.website;
        }
        
        CGFloat lat = self->_placeDetails.location.latitude;
        CGFloat lng = self->_placeDetails.location.longitude;
        if (lat && lng)
        {
            self->_locationLabel.text = [NSString stringWithFormat:@"%f, %f", lat, lng];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
