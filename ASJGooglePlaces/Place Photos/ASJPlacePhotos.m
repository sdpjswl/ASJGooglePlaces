//  ASJPlacePhotos.m
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
    NSString *stub = [NSString stringWithFormat:@"%@?photoreference=%@&maxwidth=%ld&key=%@", kPlacePhotosSubURL, photo.photoReference, (unsigned long)photo.width, [ASJConstants sharedInstance].apiKey];
    stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
    return queryURL;
}

@end
