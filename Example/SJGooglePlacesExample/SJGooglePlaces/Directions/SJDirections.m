//
//  SJDirections.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import CoreGraphics;
#import "SJDirections.h"

typedef void (^CallbackBlock)(SJResponseStatusCode, SJOriginDestination *);

@interface SJDirections ()

@property (copy, nonatomic) NSString *originName;
@property (copy, nonatomic) NSString *destinationName;
@property (nonatomic) CLLocationCoordinate2D origin;
@property (nonatomic) CLLocationCoordinate2D destination;
@property (copy) CallbackBlock callback;

- (void)executeRequest;
- (NSURL *)urlForDirectionsQuery;
+ (SJOriginDestination *)directionDetailsForResponse:(NSDictionary *)response;

@end

@implementation SJDirections


#pragma mark - Public

- (void)sjDirectionsPolylineFromOriginNamed:(NSString *)origin
						   destinationNamed:(NSString *)destination
								 completion:(void (^)(SJResponseStatusCode statusCode, SJOriginDestination *directionDetails))completion {
	_originName = origin;
	_destinationName = destination;
	_callback = completion;
	[self executeRequest];
}

- (void)sjDirectionsPolylineFromOrigin:(CLLocationCoordinate2D)origin
				   destination:(CLLocationCoordinate2D)destination
					completion:(void (^)(SJResponseStatusCode statusCode, SJOriginDestination *directionDetails))completion {
	_origin = origin;
	_destination = destination;
	_callback = completion;
	[self executeRequest];
}

- (void)executeRequest {
	NSURL *url = [self urlForDirectionsQuery];
	[self executeRequestForURL:url
					completion:^(SJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
                        
                        SJOriginDestination *directionDetails = [SJDirections directionDetailsForResponse:response];
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

+ (SJOriginDestination *)directionDetailsForResponse:(NSDictionary *)response {
    
	NSDictionary *topRoute = [response[@"routes"] firstObject];
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
    
    SJOriginDestination *directionDetails = [[SJOriginDestination alloc] init];
    directionDetails.originName = originName;
    directionDetails.destinationName = destinationName;
    directionDetails.origin = origin;
    directionDetails.destination = destination;
    directionDetails.polyline = polyline;
    return directionDetails;
}

@end
