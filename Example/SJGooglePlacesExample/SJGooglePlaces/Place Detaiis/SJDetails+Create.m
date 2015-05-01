//
//  SJDetails+Create.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJDetails+Create.h"
#import "SJPhoto+Create.h"

@implementation SJDetails (Create)

+ (SJDetails *)placeDetailsFromResponse:(NSDictionary *)response {
	
	NSDictionary *result = response[@"result"];
	SJDetails *detail = [[SJDetails alloc] init];
	detail.placeID = result[@"place_id"];
	detail.name = result[@"name"];
	detail.address = result[@"formatted_address"];
	detail.phone = result[@"formatted_phone_number"];
	detail.website = result[@"website"];
	detail.photos = [SJPhoto photosFromResponse:result[@"photos"]];
	
	NSNumber *lat = result[@"geometry"][@"location"][@"lat"];
	NSNumber *lng = result[@"geometry"][@"location"][@"lng"];
	detail.location = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue);
	return detail;
}

@end
