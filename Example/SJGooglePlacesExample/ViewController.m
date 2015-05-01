//
//  ViewController.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 12/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *optionsTableView;
@property (nonatomic) NSArray *options;
@property (nonatomic) NSArray *optionsSegueIdentifiers;

- (void)initTable;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self initTable];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// unselect the selected row if any
	NSIndexPath *selection = [_optionsTableView indexPathForSelectedRow];
	if (selection) {
		[_optionsTableView deselectRowAtIndexPath:selection animated:YES];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - My methods

- (void)initTable {
	[_optionsTableView registerClass:[UITableViewCell class]
			  forCellReuseIdentifier:@"cell"];
	_options = @[@"Place ID",
				 @"Place Details",
				 @"Place Photos",
				 @"Autocomplete",
				 @"Directions"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:14.0];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = _options[indexPath.row];
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *segueIdentifier = self.optionsSegueIdentifiers[indexPath.row];
	[self performSegueWithIdentifier:segueIdentifier sender:self];
}


#pragma mark - Property getter

- (NSArray *)optionsSegueIdentifiers {
	return @[@"PlaceIDController",
			 @"PlaceDetailsController",
			 @"PlacePhotosController",
			 @"AutocompleteController",
			 @"DirectionsController"];
}

@end
