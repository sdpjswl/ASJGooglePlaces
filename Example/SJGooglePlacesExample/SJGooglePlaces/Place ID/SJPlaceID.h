//
//  SJPlaceID.h
//  SJGooglePlacesExample
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJSession.h"

@interface SJPlaceID : SJSession

- (void)sjPlaceIDForPlaceNamed:(NSString *)place
                    completion:(void (^)(SJResponseStatusCode statusCode, NSString *placeID))completion;

@end
