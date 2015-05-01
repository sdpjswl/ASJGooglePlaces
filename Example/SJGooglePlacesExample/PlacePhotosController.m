//
//  PlacePhotosController.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "PlacePhotosController.h"
#import "SJPlacePhotos.h"

@interface PlacePhotosController () <UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *placeTextField;
@property (nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (nonatomic) NSArray *photos;

- (void)setUp;
- (IBAction)goTapped:(id)sender;
- (void)runPlacePhotosRequest;
- (void)showNoPhotosAlert;
- (void)reloadCollectionView;

@end

@implementation PlacePhotosController

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
	self.title = @"Place Photos";
	[_photosCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _photosCollectionView.collectionViewLayout = layout;
}

- (IBAction)goTapped:(id)sender {
	[self runPlacePhotosRequest];
}

- (void)runPlacePhotosRequest {
	SJPlacePhotos *api = [[SJPlacePhotos alloc] init];
	[api sjPlacePhotosForPlaceNamed:_placeTextField.text
						 completion:^(SJResponseStatusCode statusCode, NSArray *placePhotos) {
                             _photos = placePhotos;
                             if (!_photos.count) {
                                 [self showNoPhotosAlert];
                                 return;
                             }
                             [self reloadCollectionView];
                         }];
}

- (void)showNoPhotosAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Boo!" message:@"No photos found." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)reloadCollectionView {
	dispatch_async(dispatch_get_main_queue(), ^{
		[_photosCollectionView reloadData];
	});
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
	imageView.image = _photos[indexPath.row];
    [cell.contentView addSubview:imageView];
	return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}

@end
