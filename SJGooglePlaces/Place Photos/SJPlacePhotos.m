//
//  SJPlacePhotos.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import UIKit;
#import "SJPlacePhotos.h"
#import "SJPlaceDetails.h"
#import "SJPhoto.h"
#import "SJDetails.h"

typedef void (^CallbackBlock)(SJResponseStatusCode, NSArray *);

@interface SJPlacePhotos ()

@property (nonatomic) NSString *placeName;
@property (nonatomic) SJDetails *placeDetails;
@property (nonatomic) NSArray *photos;
@property (copy) CallbackBlock callback;

- (void)fetchPlaceDetails;
- (void)fetchPlacePhotosWithCompletion:(void (^)(NSArray *photos))completion;
- (NSURL *)urlForPlacePhoto:(SJPhoto *)photo;

@end

@implementation SJPlacePhotos


#pragma mark - Public

- (void)sjPlacePhotosForPlaceNamed:(NSString *)place
                        completion:(void (^)(SJResponseStatusCode statusCode, NSArray *placePhotos))completion {
    _placeName = place;
    _callback = completion;
    [self fetchPlaceDetails];
}

- (void)fetchPlaceDetails {
    SJPlaceDetails *api = [[SJPlaceDetails alloc] init];
    [api sjPlaceDetailsForPlaceNamed:_placeName
                          completion:^(SJResponseStatusCode statusCode, SJDetails *placeDetails) {
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
        _callback(SJResponseStatusCodeOk, _placeDetails.photos);
        return;
    }
    NSMutableArray *temp = @[].mutableCopy;
    for (SJPhoto *photo in _placeDetails.photos) {
        NSURL *url = [self urlForPlacePhoto:photo];
        [self executeRequestForURL:url
                        completion:^(SJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
                            
                            UIImage *image = [UIImage imageWithData:data];
                            [temp addObject:image];
                            if (temp.count == _placeDetails.photos.count && completion) {
                                NSArray *images = [NSArray arrayWithArray:temp];
                                completion(images);
                            }
                        }];
    }
}

- (NSURL *)urlForPlacePhoto:(SJPhoto *)photo {
    NSString *stub = [NSString stringWithFormat:@"%@?photoreference=%@&maxwidth=%ld&key=%@", kPlacePhotosSubURL, photo.photoReference, photo.width, [SJConstants sharedInstance].apiKey];
    stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
    return queryURL;
}

@end
