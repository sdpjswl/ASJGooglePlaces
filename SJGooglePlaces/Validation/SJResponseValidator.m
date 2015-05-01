//
//  SJResponseValidator.m
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJResponseValidator.h"
#import "SJStatusCodeValueTransformer.h"

@implementation SJResponseValidator

+ (void)validateResponseData:(NSData *)data
					   error:(NSError *)error
				  completion:(void (^)(SJResponseStatusCode, NSDictionary *))completion {
	
	if (!data) {
		return;
	}
	if (error) {
		NSLog(@"%@", error.localizedDescription);
		return;
	}
	
	NSDictionary *response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	
	SJStatusCodeValueTransformer *transformer = [[SJStatusCodeValueTransformer alloc] init];
	NSNumber *statusCodeBoxed = [transformer transformedValue:response[@"status"]];
	SJResponseStatusCode statusCode = statusCodeBoxed.unsignedIntegerValue;
	
	if (completion) {
		completion(statusCode, response);
	}
}

@end
