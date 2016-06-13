//
// ASJDirections.m
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

#import "ASJDirections.h"

@interface ASJDirections ()

@property (copy, nonatomic) NSString *originName;
@property (copy, nonatomic) NSString *destinationName;
@property (assign, nonatomic) CLLocationCoordinate2D origin;
@property (assign, nonatomic) CLLocationCoordinate2D destination;
@property (readonly, weak, nonatomic) NSURL *directionsURL;
@property (copy) DirectionsBlock completion;

+ (ASJOriginDestination *)directionDetailsForResponse:(NSDictionary *)response;

@end

@implementation ASJDirections

#pragma mark - Public

- (void)directionsFromOriginNamed:(NSString *)origin destinationNamed:(NSString *)destination completion:(DirectionsBlock)completion
{
  _originName = origin;
  _destinationName = destination;
  _completion = completion;
  [self executeGooglePlacesRequest];
}

- (void)directionsFromOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination completion:(DirectionsBlock)completion
{
  _origin = origin;
  _destination = destination;
  _completion = completion;
  [self executeGooglePlacesRequest];
}

#pragma mark - Private

- (void)executeGooglePlacesRequest
{
  [self executeRequestForURL:self.urlForDirectionsQuery completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response)
   {
     if (!_completion) {
       return;
     }
     
     ASJOriginDestination *directionDetails = [ASJOriginDestination directionDetailsForResponse:response];
     _completion(statusCode, directionDetails);
   }];
}

- (NSURL *)urlForDirectionsQuery
{
  NSMutableString *urlString = nil;
  if (_originName.length && _destinationName.length)
  {
    [urlString appendFormat:@"%@origin=%@&destination=%@", kDirectionsBaseURL, _originName, _destinationName];
  }
  else
  {
    [urlString appendFormat:@"%@&origin=%f,%f&destination=%f,%f", kDirectionsBaseURL, _origin.latitude, _origin.longitude, _destination.latitude, _destination.longitude];
    [urlString appendString:@"&sensor=false&mode=driving"];
  }
  
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding].mutableCopy;
  return [NSURL URLWithString:urlString];
}

@end
