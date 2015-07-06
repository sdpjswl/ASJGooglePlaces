//  ASJDirections.m
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

@import CoreGraphics;
#import "ASJDirections.h"

typedef void (^CallbackBlock)(ASJResponseStatusCode, ASJOriginDestination *);

@interface ASJDirections ()

@property (copy, nonatomic) NSString *originName;
@property (copy, nonatomic) NSString *destinationName;
@property (nonatomic) CLLocationCoordinate2D origin;
@property (nonatomic) CLLocationCoordinate2D destination;
@property (copy) CallbackBlock callback;

- (void)executeRequest;
- (NSURL *)urlForDirectionsQuery;
+ (ASJOriginDestination *)directionDetailsForResponse:(NSDictionary *)response;

@end

@implementation ASJDirections


#pragma mark - Public

- (void)asjDirectionsPolylineFromOriginNamed:(NSString *)origin
						   destinationNamed:(NSString *)destination
								 completion:(void (^)(ASJResponseStatusCode statusCode, ASJOriginDestination *directionDetails))completion {
	_originName = origin;
	_destinationName = destination;
	_callback = completion;
	[self executeRequest];
}

- (void)asjDirectionsPolylineFromOrigin:(CLLocationCoordinate2D)origin
				   destination:(CLLocationCoordinate2D)destination
					completion:(void (^)(ASJResponseStatusCode statusCode, ASJOriginDestination *directionDetails))completion {
	_origin = origin;
	_destination = destination;
	_callback = completion;
	[self executeRequest];
}

- (void)executeRequest {
	NSURL *url = [self urlForDirectionsQuery];
	[self executeRequestForURL:url
					completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
                        
                        ASJOriginDestination *directionDetails = [ASJDirections directionDetailsForResponse:response];
						if (_callback) {
							_callback(statusCode, directionDetails);
						}
					}];
}

- (NSURL *)urlForDirectionsQuery {
	NSString *urlString = nil;
	if (_originName && _destinationName) {
		urlString = [NSString stringWithFormat:@"%@?origin=%@&destination=%@", kDirectionsBaseURL, _originName, _destinationName];
	}
	else {
		urlString = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f", kDirectionsBaseURL, _origin.latitude, _origin.longitude, _destination.latitude, _destination.longitude];
	}
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:urlString];
	return queryURL;
}

+ (ASJOriginDestination *)directionDetailsForResponse:(NSDictionary *)response {
    
	NSDictionary *topRoute = [response[@"routes"] firstObject];
    if (!topRoute) {
        return nil;
    }
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
    return directionDetails;
}

@end
