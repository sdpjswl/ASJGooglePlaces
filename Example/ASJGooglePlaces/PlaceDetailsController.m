//
//  PlaceDetailsController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "PlaceDetailsController.h"
#import "ASJPlaceDetails.h"
#import "UILabel+PreferredWidth.h"
#import "UIViewController+Utilities.h"

@interface PlaceDetailsController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *placeTextField;
@property (nonatomic) IBOutlet UILabel *placeIDLabel;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic) IBOutlet UILabel *websiteLabel;
@property (nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic) ASJDetails *placeDetails;

- (IBAction)goTapped:(id)sender;
- (void)runPlaceDetailsRequest;
- (void)showDetailsOnScreen;
+ (NSString *)locationStringFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@implementation PlaceDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Place Details";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Methods

- (IBAction)goTapped:(id)sender {
    [self dismissKeyboard];
    [self runPlaceDetailsRequest];
}

- (void)runPlaceDetailsRequest {
    ASJPlaceDetails *api = [[ASJPlaceDetails alloc] init];
    [api asjPlaceDetailsForPlaceNamed:_placeTextField.text
                          completion:^(ASJResponseStatusCode statusCode, ASJDetails *placeDetails) {
                              _placeDetails = placeDetails;
                              [self showDetailsOnScreen];
                          }];
}

- (void)showDetailsOnScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_placeDetails.placeID) {
            _placeIDLabel.text = _placeDetails.placeID;
        }
        if (_placeDetails.name) {
            _nameLabel.text = _placeDetails.name;
        }
        if (_placeDetails.address) {
            _addressLabel.text = _placeDetails.address;
            _addressLabel.preferredMaxLayoutWidth = [_addressLabel preferredMaxWidthWithPadding:15.0];
        }
        if (_placeDetails.phone) {
            _phoneLabel.text = _placeDetails.phone;
        }
        if (_placeDetails.website) {
            _websiteLabel.text = _placeDetails.website;
        }
        if (_placeDetails.location.latitude && _placeDetails.location.longitude)  {
            _locationLabel.text = [PlaceDetailsController locationStringFromCoordinate:_placeDetails.location];
        }
    });
}


#pragma mark - Helper function

+ (NSString *)locationStringFromCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
