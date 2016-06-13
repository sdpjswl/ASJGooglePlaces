//
// ASJPlaceDetails.m
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
#import "ASJPlaceID.h"

@interface ASJPlaceDetails ()

@property (copy, nonatomic) NSString *placeName;
@property (copy, nonatomic) NSString *placeID;
@property (copy) PlaceDetailsBlock completion;
@property (readonly, weak, nonatomic) NSURL *placeDetailsURL;

- (void)fetchPlaceID;

@end

@implementation ASJPlaceDetails

#pragma mark - Public: By place name

- (void)placeDetailsForPlace:(NSString *)place completion:(PlaceDetailsBlock)completion
{
  _placeName = place;
  _completion = completion;
  [self fetchPlaceID];
}

- (void)placeDetailsForPlaceID:(NSString *)placeID completion:(PlaceDetailsBlock)completion
{
  _placeID = placeID;
  _completion = completion;
  [self executeGooglePlacesRequest];
}

#pragma mark - Private

- (void)fetchPlaceID
{
  ASJPlaceID *api = [[ASJPlaceID alloc] init];
  [api placeIDForPlace:_placeName completion:^(ASJResponseStatusCode statusCode, NSString *placeID)
   {
     _placeID = placeID;
     [self executeGooglePlacesRequest];
   }];
}

- (void)executeGooglePlacesRequest
{
  [self executeRequestForURL:self.placeDetailsURL completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response)
   {
     ASJDetails *placeDetails = [ASJDetails placeDetailsFromResponse:response];
     if (_completion) {
       _completion(statusCode, placeDetails);
     }
   }];
}

- (NSURL *)placeDetailsURL
{
  NSString *stub = [NSString stringWithFormat:@"%@?placeid=%@&key=%@", kPlaceDetailsSubURL, _placeID, self.apiKey];
  stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
  return queryURL;
}

@end
