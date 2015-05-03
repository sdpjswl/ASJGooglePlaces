//
//  ASJPlace+Create.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJPlace+Create.h"

@implementation ASJPlace (Create)

+ (NSArray *)placesForResponse:(NSDictionary *)response {
	NSArray *predictions = response[@"predictions"];
	NSMutableArray *temp = @[].mutableCopy;
	for (NSDictionary *dict in predictions) {
		ASJPlace *place = [[ASJPlace alloc] init];
		place.placeID = dict[@"place_id"];
		place.placeDescription = dict[@"description"];
		[temp addObject:place];
	}
	return [NSArray arrayWithArray:temp];
}

@end
