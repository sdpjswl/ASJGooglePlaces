//
//  AutocompleteController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJAutocompleteAPI.h"
#import "ASJPlace.h"
#import "AutocompleteController.h"

static NSString *const kCellIdentifier = @"cell";

@interface AutocompleteController () <UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (copy, nonatomic) NSArray *results;

- (void)setup;
- (IBAction)goTapped:(id)sender;
- (void)executeAutocompleteRequest;
- (void)reloadTable;

@end

@implementation AutocompleteController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
}

#pragma mark - Setup

- (void)setup
{
  self.title = @"Autocomplete";
  Class cellClass = [UITableViewCell class];
  [_resultsTableView registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}

- (IBAction)goTapped:(id)sender
{
  if (!_placeTextField.text.length)
  {
    [self showEmptyTextFieldsAlert];
    return;
  }
  [self dismissKeyboard];
  [self executeAutocompleteRequest];
}

- (void)executeAutocompleteRequest
{
  ASJAutocompleteAPI *api = [[ASJAutocompleteAPI alloc] init];
  api.minimumInputLength = 3;
  
  [api autocompleteForQuery:_placeTextField.text completion:^(ASJResponseStatusCode statusCode, NSArray<ASJPlace *> *places, NSError *error)
   {
     if (!places.count || error)
     {
       [self showAlertWithMessage:error.localizedDescription];
       return;
     }
     
     _results = places;
     [self reloadTable];
   }];
}

- (void)reloadTable
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [_resultsTableView reloadData];
  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  
  ASJPlace *place = _results[indexPath.row];
  cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.text = place.placeDescription;
  
  return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

@end
