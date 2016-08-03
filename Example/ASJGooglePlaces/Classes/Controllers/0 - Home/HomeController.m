//
//  HomeController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 12/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "HomeController.h"

static NSString *const kCellIdentifier = @"cell";

@interface HomeController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (copy, nonatomic) NSArray *options;
@property (copy, nonatomic) NSArray *optionsSegueIdentifiers;

- (void)setup;

@end

@implementation HomeController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // unselect the selected row if any
  NSIndexPath *selection = [_optionsTableView indexPathForSelectedRow];
  if (selection) {
    [_optionsTableView deselectRowAtIndexPath:selection animated:YES];
  }
}

#pragma mark - Setup

- (void)setup
{
  Class cellClass = [UITableViewCell class];
  [_optionsTableView registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = self.options[indexPath.row];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *segueIdentifier = self.optionsSegueIdentifiers[indexPath.row];
  [self performSegueWithIdentifier:segueIdentifier sender:self];
}


#pragma mark - Property

- (NSArray *)options
{
  return @[@"Autocomplete",
           @"Directions",
           @"Place Details",
           @"Place ID",
           @"Place Photos"];
}

- (NSArray *)optionsSegueIdentifiers
{
  return @[@"AutocompleteController",
           @"DirectionsController",
           @"PlaceDetailsController",
           @"PlaceIDController",
           @"PlacePhotosController"];
}

@end
