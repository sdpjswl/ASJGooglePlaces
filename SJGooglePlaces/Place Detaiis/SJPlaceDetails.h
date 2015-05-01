//
//  SJPlaceDetails.h
//  GooglePlacesDemo
//
//  Created by sudeep on 27/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJSession.h"
#import "SJDetails.h"

@interface SJPlaceDetails : SJSession

- (void)sjPlaceDetailsForPlaceNamed:(NSString *)place
					  completion:(void (^)(SJResponseStatusCode statusCode, SJDetails *placeDetails))completion;

- (void)sjPlaceDetailsForPlaceID:(NSString *)placeID
					completion:(void (^)(SJResponseStatusCode statusCode, SJDetails *placeDetails))completion;

@end
