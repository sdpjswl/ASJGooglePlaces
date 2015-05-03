//
//  ASJPlaceDetails.h
//  GooglePlacesDemo
//
//  Created by sudeep on 27/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJSession.h"
#import "ASJDetails.h"

@interface ASJPlaceDetails : ASJSession

- (void)asjPlaceDetailsForPlaceNamed:(NSString *)place
					  completion:(void (^)(ASJResponseStatusCode statusCode, ASJDetails *placeDetails))completion;

- (void)asjPlaceDetailsForPlaceID:(NSString *)placeID
					completion:(void (^)(ASJResponseStatusCode statusCode, ASJDetails *placeDetails))completion;

@end
