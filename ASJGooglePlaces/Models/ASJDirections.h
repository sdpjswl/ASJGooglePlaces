//
// ASJDirections.h
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

#import <CoreLocation/CLLocation.h>

@interface ASJDirections : NSObject

/**
 *  The starting point's name.
 */
@property (copy, nonatomic) NSString *originName;

/**
 *  The destination's name.
 */
@property (copy, nonatomic) NSString *destinationName;

/**
 *  The starting point's coordinates.
 */
@property (nonatomic) CLLocationCoordinate2D origin;

/**
 *  The destication's coordinates.
 */
@property (nonatomic) CLLocationCoordinate2D destination;

/**
 *  The polyline between points A and B. You can use this string to show a path between two points on a 'GMSMapView'.
 */
@property (copy, nonatomic) NSString *polyline;

/**
 *  A helper method that creates 'ASJOriginDestination' model objects from a JSON response.
 *
 *  @param response JSON fetched from Google API.
 *
 *  @return An array of 'ASJOriginDestination' instances.
 */
+ (NSArray<ASJDirections *> *)directionsForResponse:(NSDictionary *)response;

@end
