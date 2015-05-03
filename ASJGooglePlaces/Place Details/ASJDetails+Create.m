//
//  ASJDetails+Create.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJDetails+Create.h"
#import "ASJPhoto+Create.h"

@implementation ASJDetails (Create)

+ (ASJDetails *)placeDetailsFromResponse:(NSDictionary *)response {
	
	NSDictionary *result = response[@"result"];
	ASJDetails *detail = [[ASJDetails alloc] init];
	detail.placeID = result[@"place_id"];
	detail.name = result[@"name"];
	detail.address = result[@"formatted_address"];
	detail.phone = result[@"formatted_phone_number"];
	detail.website = result[@"website"];
	detail.photos = [ASJPhoto photosFromResponse:result[@"photos"]];
	
	NSNumber *lat = result[@"geometry"][@"location"][@"lat"];
	NSNumber *lng = result[@"geometry"][@"location"][@"lng"];
	detail.location = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue);
	return detail;
}

@end
