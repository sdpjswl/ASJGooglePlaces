//
//  ASJPhoto+Create.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJPhoto+Create.h"

@implementation ASJPhoto (Create)

+ (NSArray *)photosFromResponse:(NSDictionary *)response {
	NSMutableArray *temp = @[].mutableCopy;
	for (NSDictionary *dict in response) {
		ASJPhoto *photo = [[ASJPhoto alloc] init];
		photo.width = [dict[@"width"] longValue];
		photo.height = [dict[@"height"] longValue];
		photo.photoReference = dict[@"photo_reference"];
		[temp addObject:photo];
	}
	return [NSArray arrayWithArray:temp];
}

@end
