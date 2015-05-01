//
//  SJDirections.h
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import CoreLocation;
#import "SJSession.h"
#import "SJOriginDestination.h"

@interface SJDirections : SJSession

- (void)sjDirectionsPolylineFromOriginNamed:(NSString *)origin
						   destinationNamed:(NSString *)destination
							completion:(void (^)(SJResponseStatusCode statusCode, SJOriginDestination *directionDetails))completion;

- (void)sjDirectionsPolylineFromOrigin:(CLLocationCoordinate2D)origin
				   destination:(CLLocationCoordinate2D)destination
					completion:(void (^)(SJResponseStatusCode statusCode, SJOriginDestination *directionDetails))completion;

@end
