//
//  ASJDirections.h
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import CoreLocation;
#import "ASJSession.h"
#import "ASJOriginDestination.h"

@interface ASJDirections : ASJSession

- (void)asjDirectionsPolylineFromOriginNamed:(NSString *)origin
						   destinationNamed:(NSString *)destination
							completion:(void (^)(ASJResponseStatusCode statusCode, ASJOriginDestination *directionDetails))completion;

- (void)asjDirectionsPolylineFromOrigin:(CLLocationCoordinate2D)origin
				   destination:(CLLocationCoordinate2D)destination
					completion:(void (^)(ASJResponseStatusCode statusCode, ASJOriginDestination *directionDetails))completion;

@end
