//
//  AutocompleteController.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "AutocompleteController.h"
#import "SJAutocomplete.h"
#import "SJPlace.h"

@interface AutocompleteController () <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *placeTextField;
@property (nonatomic) IBOutlet UITableView *resultsTableView;
@property (nonatomic) NSArray *results;

- (void)setUp;
- (IBAction)goTapped:(id)sender;
- (void)runAutocompleteRequest;
- (void)reloadTable;

@end

@implementation AutocompleteController

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
	self.title = @"Autocomplete";
	[_resultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (IBAction)goTapped:(id)sender {
	[self runAutocompleteRequest];
}

- (void)runAutocompleteRequest {
	SJAutocomplete *api = [[SJAutocomplete alloc] init];
	api.minimumInputLength = 3;
	[api sjAutocompleteForInput:_placeTextField.text
					 completion:^(SJResponseStatusCode statusCode, NSArray *places) {
                         _results = places;
                         [self reloadTable];
                     }];
}

- (void)reloadTable {
	dispatch_async(dispatch_get_main_queue(), ^{
		[_resultsTableView reloadData];
	});
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:14.0];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	SJPlace *place = _results[indexPath.row];
	cell.textLabel.text = place.placeDescription;
	return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}

@end
