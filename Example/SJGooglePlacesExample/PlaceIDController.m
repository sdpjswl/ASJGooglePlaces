//
//  PlaceIDController.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "PlaceIDController.h"
#import "SJPlaceID.h"

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
    [self runPlaceIDRequest];
}

- (void)runPlaceIDRequest {
    SJPlaceID *api = [[SJPlaceID alloc] init];
    [api sjPlaceIDForPlaceNamed:_placeTextField.text
                     completion:^(SJResponseStatusCode statusCode, NSString *placeID) {
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
