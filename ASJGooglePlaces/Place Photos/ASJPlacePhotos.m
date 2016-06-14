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

#import "ASJPlaceDetails.h"
#import "ASJPlacePhotos.h"
#import <UIKit/UIImage.h>

@interface ASJPlacePhotos ()

@property (copy, nonatomic) NSString *place;
@property (strong, nonatomic) ASJDetails *placeDetails;
@property (copy) PlacePhotosBlock completion;

- (void)fetchPlaceDetails;
- (NSURL *)urlForPhoto:(ASJPhoto *)photo;

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
  [api placeDetailsForPlace:_place completion:^(ASJResponseStatusCode statusCode, ASJDetails *placeDetails, NSError *error)
   {
     if (!_completion) {
       return;
     }
     
     if (statusCode != ASJResponseStatusCodeOk ||
         !_placeDetails.photos.count)
     {
       _completion(statusCode, nil, error);
       return;
     }
     
     _placeDetails = placeDetails;
     [self executeGooglePlacesRequest];
   }];
}

- (void)executeGooglePlacesRequest
{
  if (!_completion) {
    return;
  }
  
  
  
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  for (ASJPhoto *photo in _placeDetails.photos)
  {
    NSURL *url = [self urlForPhoto:photo];
    [self executeRequestForURL:url completion:^(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error)
     {
#warning check this, need image data
       //       UIImage *image = [UIImage imageWithData:data];
       //       [temp addObject:image];
       
       if (temp.count == _placeDetails.photos.count) {
         _completion(statusCode, [NSArray arrayWithArray:temp], error);
       }
     }];
  }
}

- (NSURL *)urlForPhoto:(ASJPhoto *)photo
{
  NSString *relativePath = [NSString stringWithFormat:@"%@?photoreference=%@&maxwidth=%ld&key=%@", kPlacePhotosSubURL, photo.photoReference, (unsigned long)photo.width, self.apiKey];
  relativePath = [relativePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  return [NSURL URLWithString:relativePath relativeToURL:self.baseURL];
}

@end
