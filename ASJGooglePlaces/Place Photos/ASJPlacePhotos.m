//
// ASJPlacePhotos.m
//
// Copyright (c) 2014 Sudeep Jaiswal
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

#import "ASJPlacePhotos.h"
#import "ASJPlaceDetails.h"
#import <UIKit/UIImage.h>
//#import "ASJDetails.h"

@interface ASJPlacePhotos ()

@property (copy, nonatomic) NSString *place;
@property (strong, nonatomic) ASJDetails *placeDetails;
@property (copy) PlacePhotosBlock completion;

- (void)fetchPlaceDetails;
- (void)fetchPlacePhotosWithCompletion:(void (^)(NSArray *photos))completion;
- (NSURL *)urlForPlacePhoto:(ASJPhoto *)photo;

@end

@implementation ASJPlacePhotos

#pragma mark - Public

- (void)placePhotosForPlace:(NSString *)place completion:(PlacePhotosBlock)completion
{
  _place = place;
  _completion = completion;
  [self fetchPlaceDetails];
}

#pragma mark - Private

- (void)fetchPlaceDetails
{
  ASJPlaceDetails *api = [[ASJPlaceDetails alloc] init];
  [api placeDetailsForPlace:_place completion:^(ASJResponseStatusCode statusCode, ASJDetails *placeDetails)
   {
     if (statusCode == ASJResponseStatusCodeOk)
     {
       _placeDetails = placeDetails;
       [self executeGooglePlacesRequest];
       return;
     }
     
     if (_completion) {
       _completion(statusCode, nil);
     }
   }];
}

- (void)executeGooglePlacesRequest
{
  if (!_placeDetails.photos.count && _completion)
  {
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

- (NSURL *)urlForPlacePhoto:(ASJPhoto *)photo
  {
  NSString *stub = [NSString stringWithFormat:@"%@?photoreference=%@&maxwidth=%ld&key=%@", kPlacePhotosSubURL, photo.photoReference, (unsigned long)photo.width, self.apiKey];
  stub = [stub stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
  return queryURL;
}

@end
