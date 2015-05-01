//
//  SJDetails+Create.h
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJDetails.h"

@interface SJDetails (Create)

+ (SJDetails *)placeDetailsFromResponse:(NSDictionary *)response;

@end
