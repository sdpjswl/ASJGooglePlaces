//
//  ASJPlacePhotos.h
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJSession.h"

@interface ASJPlacePhotos : ASJSession

- (void)asjPlacePhotosForPlaceNamed:(NSString *)place
					  completion:(void (^)(ASJResponseStatusCode statusCode, NSArray *placePhotos))completion;

@end
