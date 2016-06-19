//
// ASJOriginDestination.m
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

#import "ASJOriginDestination.h"

@implementation ASJOriginDestination

// Thanks: Deepti
+ (NSArray<ASJOriginDestination *> *)directionsForResponse:(NSDictionary *)response
{
  NSArray *routesArray = [response objectForKey:@"routes"];
  NSMutableArray *originDestinationArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *topRoute in routesArray)
  {
    NSString *polyline = topRoute[@"overview_polyline"][@"points"];
    NSDictionary *legs = [topRoute[@"legs"] objectAtIndex:0];
    NSString *originName = legs[@"start_address"];
    NSString *destinationName = legs[@"end_address"];
    
    NSNumber *originLat = legs[@"start_location"][@"lat"];
    NSNumber *originLng = legs[@"start_location"][@"lng"];
    NSNumber *destinationLat = legs[@"end_location"][@"lat"];
    NSNumber *destinationLng = legs[@"end_location"][@"lng"];
    
    CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(originLat.doubleValue, originLng.doubleValue);
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(destinationLat.doubleValue, destinationLng.doubleValue);
    
    ASJOriginDestination *directionDetails = [[ASJOriginDestination alloc] init];
    directionDetails.originName = originName;
    directionDetails.destinationName = destinationName;
    directionDetails.origin = origin;
    directionDetails.destination = destination;
    directionDetails.polyline = polyline;
    
    [originDestinationArray addObject:directionDetails];
  }
  
  return originDestinationArray;
}

@end
