//
//  DirectionsController.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 29/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "DirectionsController.h"
#import "SJDirections.h"
#import <GoogleMaps/GoogleMaps.h>

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
@property (nonatomic) SJOriginDestination *directionDetails;

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
    [self runDirectionsRequest];
}

- (void)runDirectionsRequest {
    
    SJDirections *api = [[SJDirections alloc] init];
    BOOL isActiveTextFieldCoordinateType = [_coordinateTextFields containsObject:_activeTextField];
    
    if (isActiveTextFieldCoordinateType) {
        
        CGFloat originLat = _originLatTextField.text.doubleValue;
        CGFloat originLng = _originLngTextField.text.doubleValue;
        CGFloat destinationLat = _destinationLatTextField.text.doubleValue;
        CGFloat destinationLng = _destinationLngTextField.text.doubleValue;
        
        [api sjDirectionsPolylineFromOrigin:CLLocationCoordinate2DMake(originLat, originLng)
                                destination:CLLocationCoordinate2DMake(destinationLat, destinationLng)
                                 completion:^(SJResponseStatusCode statusCode, SJOriginDestination *directionDetails) {
                                     _directionDetails = directionDetails;
                                     [self showMap];
                                 }];
        return;
    }
    
    NSString *originName = _originNameTextField.text;
    NSString *destinationName = _destinationNameTextField.text;
    
    [api sjDirectionsPolylineFromOriginNamed:originName
                            destinationNamed:destinationName
                                  completion:^(SJResponseStatusCode statusCode, SJOriginDestination *directionDetails) {
                                      _directionDetails = directionDetails;
                                      [self showMap];
                                  }];
}

- (void)showMap {
    dispatch_async(dispatch_get_main_queue(), ^{
        static GMSMapView *map = nil;
        if (!map) {
            map = [[GMSMapView alloc] initWithFrame:_mapContainerView.bounds];
        }
        [map clear];
        
        GMSPath *path = [GMSPath pathFromEncodedPath:_directionDetails.polyline];
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 5.0;
        polyline.strokeColor = [UIColor colorWithRed:50.0/255.0 green:205.0/255.0 blue:50.0/255.0 alpha:1.0];
        polyline.map = map;
        
        GMSMarker *origin = [GMSMarker markerWithPosition:_directionDetails.origin];
        origin.title = _directionDetails.originName;
        origin.map = map;
        GMSMarker *destination = [GMSMarker markerWithPosition:_directionDetails.destination];
        destination.title = _directionDetails.destinationName;
        destination.map = map;
        
        [_mapContainerView addSubview:map];
        [map animateWithCameraUpdate:update];
    });
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
