//
// ASJPlacePhotosAPI.m
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

#import "ASJPlaceDetailsAPI.h"
#import "ASJPlacePhotosAPI.h"
#import <UIKit/UIImage.h>

@interface ASJPlacePhotosAPI ()

@property (copy, nonatomic) NSString *place;
@property (copy, nonatomic) NSString *placeID;
@property (strong, nonatomic) ASJPlaceDetails *placeDetails;
@property (copy) PlacePhotosBlock completion;

- (void)fetchPlaceDetailsByName;
- (void)fetchPlaceDetailsByID;
- (NSURL *)urlForPhoto:(ASJPhoto *)photo;

@end

@implementation ASJPlacePhotosAPI

#pragma mark - Public

- (void)placePhotosForPlace:(NSString *)place completion:(PlacePhotosBlock)completion
{
  _place = place;
  _completion = completion;
  [self fetchPlaceDetailsByName];
}

- (void)placePhotosForPlaceID:(NSString *)placeID completion:(PlacePhotosBlock)completion
{
  _placeID = placeID;
  _completion = completion;
  [self fetchPlaceDetailsByID];
}

#pragma mark - Private

- (void)fetchPlaceDetailsByName
{
  ASJPlaceDetailsAPI *api = [[ASJPlaceDetailsAPI alloc] init];
  [api placeDetailsForPlace:_place completion:^(ASJResponseStatusCode statusCode, ASJPlaceDetails *placeDetails, NSError *error)
   {
     if (!_completion) {
       return;
     }
     
     if (statusCode != ASJResponseStatusCodeOk ||
         !placeDetails.photos.count)
     {
       _completion(statusCode, nil, error);
       return;
     }
     
     _placeDetails = placeDetails;
     [self executeGooglePlacesRequest];
   }];
}

- (void)fetchPlaceDetailsByID
{
  ASJPlaceDetailsAPI *api = [[ASJPlaceDetailsAPI alloc] init];
  [api placeDetailsForPlaceID:_placeID completion:^(ASJResponseStatusCode statusCode, ASJPlaceDetails *placeDetails, NSError *error)
   {
     if (!_completion) {
       return;
     }
     
     if (statusCode != ASJResponseStatusCodeOk ||
         !placeDetails.photos.count)
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
       if ([response.allKeys containsObject:@"image"])
       {
         UIImage *image = response[@"image"];
         [temp addObject:image];
       }
       
       if (temp.count == _placeDetails.photos.count) {
         _completion(statusCode, [NSArray arrayWithArray:temp], error);
       }
     }];
  }
}

- (NSURL *)urlForPhoto:(ASJPhoto *)photo
{
  NSString *relativePath = [NSString stringWithFormat:@"%@?photoreference=%@&maxwidth=%ld&key=%@", kPlacePhotosSubURL, photo.photoReference, (unsigned long)photo.width, self.apiKey];
  relativePath = [relativePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  return [NSURL URLWithString:relativePath relativeToURL:self.baseURL];
}

@end
