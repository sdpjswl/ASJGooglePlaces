//
//  SJConstants.m
//  SJGooglePlacesExample
//
//  Created by ABS_MAC02 on 29/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJConstants.h"

@implementation SJConstants

+ (instancetype)sharedInstance {
	static SJConstants *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

@end
