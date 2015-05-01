//
//  SJPlace+Create.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJPlace+Create.h"

@implementation SJPlace (Create)

+ (NSArray *)placesForResponse:(NSDictionary *)response {
	NSArray *predictions = response[@"predictions"];
	NSMutableArray *temp = @[].mutableCopy;
	for (NSDictionary *dict in predictions) {
		SJPlace *place = [[SJPlace alloc] init];
		place.placeID = dict[@"place_id"];
		place.placeDescription = dict[@"description"];
		[temp addObject:place];
	}
	return [NSArray arrayWithArray:temp];
}

@end
