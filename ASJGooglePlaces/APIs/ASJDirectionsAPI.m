//
// ASJDirectionsAPI.m
//
// Copyright (c) 2014-2016 Sudeep Jaiswal
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

#import "ASJDirectionsAPI.h"

@interface ASJDirectionsAPI ()

@property (copy, nonatomic) NSString *originName;
@property (copy, nonatomic) NSString *destinationName;
@property (assign, nonatomic) CLLocationCoordinate2D origin;
@property (assign, nonatomic) CLLocationCoordinate2D destination;
@property (readonly, weak, nonatomic) NSURL *directionsURL;
@property (copy) DirectionsBlock completion;

@end

@implementation ASJDirectionsAPI

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
  [self executeRequestForURL:self.urlForDirectionsQuery completion:^(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error)
   {
    if (self->_completion)
    {
      NSArray *directions = [ASJDirections directionsForResponse:response];
      self->_completion(statusCode, directions, error);
    }
  }];
}

// Thanks: Deepti
- (NSURL *)urlForDirectionsQuery
{
  NSMutableString *urlString = [[NSMutableString alloc] init];
  if (_originName.length && _destinationName.length)
  {
    [urlString appendFormat:@"%@origin=%@&destination=%@", k_asj_DirectionsBaseURL, _originName, _destinationName];
  }
  else
  {
    [urlString appendFormat:@"%@origin=%f,%f&destination=%f,%f", k_asj_DirectionsBaseURL, _origin.latitude, _origin.longitude, _destination.latitude, _destination.longitude];
  }
  
  NSString *percentEscapedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  return [NSURL URLWithString:percentEscapedString];
}

@end
