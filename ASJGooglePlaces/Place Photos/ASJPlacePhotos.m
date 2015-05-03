//
//  ASJPlacePhotos.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import UIKit;
#import "ASJPlacePhotos.h"
#import "ASJPlaceDetails.h"
#import "ASJPhoto.h"
#import "ASJDetails.h"

typedef void (^CallbackBlock)(ASJResponseStatusCode, NSArray *);

@interface ASJPlacePhotos ()

@property (nonatomic) NSString *placeName;
@property (nonatomic) ASJDetails *placeDetails;
@property (nonatomic) NSArray *photos;
@property (copy) CallbackBlock callback;

- (void)fetchPlaceDetails;
- (void)fetchPlacePhotosWithCompletion:(void (^)(NSArray *photos))completion;
- (NSURL *)urlForPlacePhoto:(ASJPhoto *)photo;

@end

@implementation ASJPlacePhotos


#pragma mark - Public

- (void)asjPlacePhotosForPlaceNamed:(NSString *)place
                        completion:(void (^)(ASJResponseStatusCode statusCode, NSArray *placePhotos))completion {
    _placeName = place;
    _callback = completion;
    [self fetchPlaceDetails];
}

- (void)fetchPlaceDetails {
    ASJPlaceDetails *api = [[ASJPlaceDetails alloc] init];
    [api asjPlaceDetailsForPlaceNamed:_placeName
                          completion:^(ASJResponseStatusCode statusCode, ASJDetails *placeDetails) {
                              _placeDetails = placeDetails;
                              [self fetchPlacePhotosWithCompletion:^(NSArray *photos) {
                                  if (_callback) {
                                      _callback(statusCode, photos);
                                  }
                              }];
                          }];
}


#pragma mark - Private

- (void)fetchPlacePhotosWithCompletion:(void (^)(NSArray *photos))completion {
    if (!_placeDetails.photos.count && _callback) {
        _callback(ASJResponseStatusCodeOk, _placeDetails.photos);
        return;
    }
    NSMutableArray *temp = @[].mutableCopy;
    for (ASJPhoto *photo in _placeDetails.photos) {
        NSURL *url = [self urlForPlacePhoto:photo];
        [self executeRequestForURL:url
                        completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
                            
                            UIImage *image = [UIImage imageWithData:data];
                            [temp addObject:image];
                            if (temp.count == _placeDetails.photos.count && completion) {
                                NSArray *images = [NSArray arrayWithArray:temp];
                                completion(images);
                            }
                        }];
    }
}

- (NSURL *)urlForPlacePhoto:(ASJPhoto *)photo {
    NSString *stub = [NSString stringWithFormat:@"%@?photoreference=%@&maxwidth=%ld&key=%@", kPlacePhotosSubURL, photo.photoReference, photo.width, [ASJConstants sharedInstance].apiKey];
    stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
    return queryURL;
}

@end
