//
//  ASJPlaceID.h
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJSession.h"

@interface ASJPlaceID : ASJSession

- (void)asjPlaceIDForPlaceNamed:(NSString *)place
                    completion:(void (^)(ASJResponseStatusCode statusCode, NSString *placeID))completion;

@end
