//
//  SJPlacePhotos.h
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJSession.h"

@interface SJPlacePhotos : SJSession

- (void)sjPlacePhotosForPlaceNamed:(NSString *)place
					  completion:(void (^)(SJResponseStatusCode statusCode, NSArray *placePhotos))completion;

@end
