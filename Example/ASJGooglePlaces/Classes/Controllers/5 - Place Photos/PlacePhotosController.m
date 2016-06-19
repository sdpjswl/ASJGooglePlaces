//
//  PlacePhotosController.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJPlacePhotosAPI.h"
#import "PlacePhotosController.h"

static NSString *const kCellIdentifier = @"cell";

@interface PlacePhotosController () <UICollectionViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (copy, nonatomic) NSArray *photos;

- (void)setup;
- (void)setupCollectionView;
- (void)setupFlowLayout;
- (IBAction)goTapped:(id)sender;
- (void)executePlacePhotosRequest;
- (void)reloadCollectionView;

@end

@implementation PlacePhotosController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
}

#pragma mark - Setup

- (void)setup
{
  self.title = @"Place Photos";
  [self setupCollectionView];
  [self setupFlowLayout];
}

- (void)setupCollectionView
{
  Class cellClass = [UICollectionViewCell class];
  [_photosCollectionView registerClass:cellClass forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)setupFlowLayout
{
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  layout.itemSize = CGSizeMake(80.0f, 80.0f);
  layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
  _photosCollectionView.collectionViewLayout = layout;
}

#pragma mark - IBAction

- (IBAction)goTapped:(id)sender
{
  if (!_placeTextField.text.length)
  {
    [self showEmptyTextFieldsAlert];
    return;
  }
  [self dismissKeyboard];
  [self executePlacePhotosRequest];
}

- (void)executePlacePhotosRequest
{
  ASJPlacePhotosAPI *api = [[ASJPlacePhotosAPI alloc] init];
  [api placePhotosForPlace:_placeTextField.text completion:^(ASJResponseStatusCode statusCode, NSArray<UIImage *> *placePhotos, NSError *error)
   {
     if (!placePhotos.count)
     {
       NSString *message = [NSString stringWithFormat:@"No photos found for %@.", _placeTextField.text];
       if (error) {
         message = error.localizedDescription;
       }
       
       [self showAlertWithMessage:message];
       return;
     }
     
     _photos = placePhotos;
     [self reloadCollectionView];
   }];
}

- (void)reloadCollectionView
{
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [_photosCollectionView reloadData];
  }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.clipsToBounds = YES;
  imageView.image = _photos[indexPath.row];
  [cell.contentView addSubview:imageView];
  
  return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

@end
