//
//  ASJConstants.m
//  GooglePlacesDemo
//
//  Created by ABS_MAC02 on 29/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJConstants.h"

@implementation ASJConstants

+ (instancetype)sharedInstance {
	static ASJConstants *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

@end
