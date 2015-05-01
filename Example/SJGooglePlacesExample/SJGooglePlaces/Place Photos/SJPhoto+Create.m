//
//  SJPhoto+Create.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJPhoto+Create.h"

@implementation SJPhoto (Create)

+ (NSArray *)photosFromResponse:(NSDictionary *)response {
	NSMutableArray *temp = @[].mutableCopy;
	for (NSDictionary *dict in response) {
		SJPhoto *photo = [[SJPhoto alloc] init];
		photo.width = [dict[@"width"] longValue];
		photo.height = [dict[@"height"] longValue];
		photo.photoReference = dict[@"photo_reference"];
		[temp addObject:photo];
	}
	return [NSArray arrayWithArray:temp];
}

@end
