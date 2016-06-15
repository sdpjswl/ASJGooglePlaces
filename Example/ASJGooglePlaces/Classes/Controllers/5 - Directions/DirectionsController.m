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

typedef NS_ENUM(NSInteger, DirectionsType) {
  DirectionsTypeByCoordinates,
  DirectionsTypeByName
};

static BOOL const kShouldAutofillTextFields = YES;

@interface DirectionsController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originLatTextField;
@property (weak, nonatomic) IBOutlet UITextField *originLngTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationLatTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationLngTextField;

@property (weak, nonatomic) IBOutlet UITextField *originNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationNameTextField;

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (copy, nonatomic) NSArray<ASJOriginDestination *> *directionDetails;

@property (assign, nonatomic) DirectionsType directionsType;
@property (readonly, copy, nonatomic) NSArray<UITextField *> *coordinateTextFields;
@property (readonly, copy, nonatomic) NSArray<UITextField *> *nameTextFields;

- (void)setup;
- (void)autofillTextFields;
- (void)setupDirectionsTypeBarButton;
- (IBAction)goTapped:(id)sender;
- (void)executeDirectionsByNameRequest;
- (void)executeDirectionsByCoordinatesRequest;
- (void)showMap;

@end

@implementation DirectionsController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
}

#pragma mark - Setup

- (void)setup
{
  self.title = @"Directions";
  self.directionsType = DirectionsTypeByCoordinates;
  
  [self autofillTextFields];
  [self setupDirectionsTypeBarButton];
}

- (void)autofillTextFields
{
  if (!kShouldAutofillTextFields) {
    return;
  }
  
  
}

#pragma mark - Bar button

- (void)setupDirectionsTypeBarButton
{
  UIBarButtonItem *type = [[UIBarButtonItem alloc] initWithTitle:@"Type" style:UIBarButtonItemStylePlain target:self action:@selector(directionsTypeTapped:)];
  self.navigationItem.rightBarButtonItem = type;
}

- (void)directionsTypeTapped:(id)sender
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose a directions type" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *byCoordinates = [UIAlertAction actionWithTitle:@"By coordinates" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    self.directionsType = DirectionsTypeByCoordinates;
  }];
  
  UIAlertAction *byName = [UIAlertAction actionWithTitle:@"By name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    self.directionsType = DirectionsTypeByName;
  }];
  
  [actionSheet addAction:byCoordinates];
  [actionSheet addAction:byName];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)goTapped:(id)sender
{
  [self dismissKeyboard];
  
  if (_directionsType == DirectionsTypeByCoordinates) {
    [self executeDirectionsByCoordinatesRequest];
  }
  else if (_directionsType == DirectionsTypeByName) {
    [self executeDirectionsByNameRequest];
  }
}

#pragma mark - Directions requests

- (void)executeDirectionsByCoordinatesRequest
{
  CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(_originLatTextField.text.doubleValue, _originLngTextField.text.doubleValue);
  CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(_destinationLatTextField.text.doubleValue, _destinationLngTextField.text.doubleValue);
  
  ASJDirections *api = [[ASJDirections alloc] init];
  [api directionsFromOrigin:origin destination:destination completion:^(ASJResponseStatusCode statusCode, NSArray<ASJOriginDestination *> *directionDetails, NSError *error)
   {
     if (!directionDetails.count || error)
     {
       [self showAlertWithMessage:error.localizedDescription];
       return;
     }
     
     _directionDetails = directionDetails;
     [self showMap];
   }];
}

- (void)executeDirectionsByNameRequest
{
  NSString *origin = _originNameTextField.text;
  NSString *destination = _destinationNameTextField.text;
  
  ASJDirections *api = [[ASJDirections alloc] init];
  [api directionsFromOriginNamed:origin destinationNamed:destination completion:^(ASJResponseStatusCode statusCode, NSArray<ASJOriginDestination *> *directionDetails, NSError *error)
   {
     if (!directionDetails.count || error)
     {
       [self showAlertWithMessage:error.localizedDescription];
       return;
     }
     
     _directionDetails = directionDetails;
     [self showMap];
   }];
}

#pragma mark - Map

- (void)showMap
{
  if (!_directionDetails.count)
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

#pragma mark - Properties

- (void)setDirectionsType:(DirectionsType)directionsType
{
  switch (directionsType)
  {
    case DirectionsTypeByCoordinates:
    {
      for (UITextField *textField in self.nameTextFields) { textField.enabled = NO; }
      for (UITextField *textField in self.coordinateTextFields) { textField.enabled = YES; }
      break;
    }
      
    case DirectionsTypeByName:
    {
      for (UITextField *textField in self.nameTextFields) { textField.enabled = YES; }
      for (UITextField *textField in self.coordinateTextFields) { textField.enabled = NO; }
      break;
    }
  }
}

- (NSArray<UITextField *> *)coordinateTextFields
{
  return @[_originLatTextField, _originLngTextField, _destinationLatTextField, _destinationLngTextField];
}

- (NSArray<UITextField *> *)nameTextFields
{
  return @[_originNameTextField, _destinationNameTextField];
}

@end
