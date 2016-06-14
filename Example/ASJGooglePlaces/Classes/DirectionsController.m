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
#import "UIViewController+Utilities.h"

@interface DirectionsController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *originLatTextField;
@property (nonatomic) IBOutlet UITextField *originLngTextField;
@property (nonatomic) IBOutlet UITextField *destinationLatTextField;
@property (nonatomic) IBOutlet UITextField *destinationLngTextField;
@property (nonatomic) IBOutlet UITextField *originNameTextField;
@property (nonatomic) IBOutlet UITextField *destinationNameTextField;
@property (nonatomic) IBOutlet UIView *mapContainerView;
@property (nonatomic) NSArray *coordinateTextFields;
@property (nonatomic) NSArray *nameTextFields;
@property (nonatomic) UITextField *activeTextField;
@property (nonatomic) NSArray<ASJOriginDestination *> *directionDetails;

- (void)setUp;
- (IBAction)goTapped:(id)sender;
- (void)runDirectionsRequest;
- (void)showMap;

@end

@implementation DirectionsController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setUp];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Methods

- (void)setUp {
  self.title = @"Directions";
  _coordinateTextFields = @[_originLatTextField, _originLngTextField, _destinationLatTextField, _destinationLngTextField];
  _nameTextFields = @[_originNameTextField, _destinationNameTextField];
}

- (IBAction)goTapped:(id)sender {
  [self dismissKeyboard];
  [self runDirectionsRequest];
}

- (void)runDirectionsRequest
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
    [self showNoDirectionsAlert];
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

- (void)showNoDirectionsAlert
{
  [self showAlertWithMessage:@"No directions found."];
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

@end
