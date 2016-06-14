//
//  DirectionsController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 29/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJDirections.h"
#import "DirectionsController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DirectionsController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originLatTextField;
@property (weak, nonatomic) IBOutlet UITextField *originLngTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationLatTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationLngTextField;
@property (weak, nonatomic) IBOutlet UITextField *originNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationNameTextField;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (copy, nonatomic) NSArray *coordinateTextFields;
@property (copy, nonatomic) NSArray *nameTextFields;
@property (strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) NSArray<ASJOriginDestination *> *directionDetails;

- (IBAction)goTapped:(id)sender;
- (void)executeDirectionsRequest;
- (void)showMap;

@end

@implementation DirectionsController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Directions";
}

#pragma mark - IBAction

- (IBAction)goTapped:(id)sender
{
  [self dismissKeyboard];
  [self executeDirectionsRequest];
}

- (void)executeDirectionsRequest
{
  ASJDirections *api = [[ASJDirections alloc] init];
  BOOL isActiveTextFieldCoordinateType = [_coordinateTextFields containsObject:_activeTextField];
  
  if (!isActiveTextFieldCoordinateType)
  {
    NSString *origin = _originNameTextField.text;
    NSString *destination = _destinationNameTextField.text;
    
    [api directionsFromOriginNamed:origin destinationNamed:destination completion:^(ASJResponseStatusCode statusCode, NSArray<ASJOriginDestination *> *directionDetails, NSError *error)
     {
       _directionDetails = directionDetails;
       [self showMap];
     }];
    
    return;
  }
  
  CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(_originLatTextField.text.doubleValue, _originLngTextField.text.doubleValue);
  CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(_destinationLatTextField.text.doubleValue, _destinationLngTextField.text.doubleValue);
  
  [api directionsFromOrigin:origin destination:destination completion:^(ASJResponseStatusCode statusCode, NSArray<ASJOriginDestination *> *directionDetails, NSError *error)
   {
     _directionDetails = directionDetails;
     [self showMap];
   }];
}

- (void)showMap
{
  if (!_directionDetails)
  {
    [self showAlertWithMessage:@"No directions found."];
    return;
  }
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^
   {
     static GMSMapView *map = nil;
     if (!map) {
       map = [[GMSMapView alloc] initWithFrame:_mapContainerView.bounds];
     }
     [map clear];
     
     ASJOriginDestination *originDestination = _directionDetails[0];
     GMSPath *path = [GMSPath pathFromEncodedPath:originDestination.polyline];
     GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
     GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0];
     GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
     polyline.strokeWidth = 5.0;
     polyline.strokeColor = [UIColor colorWithRed:50.0/255.0 green:205.0/255.0 blue:50.0/255.0 alpha:1.0];
     polyline.map = map;
     
     GMSMarker *origin = [GMSMarker markerWithPosition:originDestination.origin];
     origin.title = originDestination.originName;
     origin.map = map;
     
     GMSMarker *destination = [GMSMarker markerWithPosition:originDestination.destination];
     destination.title = originDestination.destinationName;
     destination.map = map;
     
     [_mapContainerView addSubview:map];
     [map animateWithCameraUpdate:update];
   }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if (!_activeTextField) {
    _activeTextField = textField;
    return YES;
  }
  
  BOOL isActiveTextFieldCoordinateType = [_coordinateTextFields containsObject:_activeTextField];
  if (_activeTextField.text.length) {
    BOOL isTextFieldCoordinateType = [_coordinateTextFields containsObject:textField];
    if (isActiveTextFieldCoordinateType == isTextFieldCoordinateType) {
      return YES;
    }
    return NO;
  }
  _activeTextField = textField;
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

#pragma mark - Properties

- (NSArray *)coordinateTextFields
{
  return @[_originLatTextField, _originLngTextField, _destinationLatTextField, _destinationLngTextField];
}

- (NSArray *)nameTextFields
{
  return @[_originNameTextField, _destinationNameTextField];
}

@end
