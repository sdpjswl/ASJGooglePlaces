//
//  SJStatusCodeValueTransformer.m
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJStatusCodeValueTransformer.h"
#import "SJConstants.h"

@implementation SJStatusCodeValueTransformer

+ (Class)transformedValueClass {
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    
    if (!value && ![value respondsToSelector:@selector(length)]) {
        NSLog(@"you must pass an NSString");
        return nil;
    }
    
    NSString *statusCode = (NSString *)value;
    if (areStringsEqual(statusCode, @"OK")) {
        return @(SJResponseStatusCodeOk);
    }
    if (areStringsEqual(statusCode, @"ZERO_RESULTS")) {
        return @(SJResponseStatusCodeZeroResults);
    }
    if (areStringsEqual(statusCode, @"OVER_QUERY_LIMIT")) {
        return @(SJResponseStatusCodeOverQueryLimit);
    }
    if (areStringsEqual(statusCode, @"REQUEST_DENIED")) {
        return @(SJResponseStatusCodeRequestDenied);
    }
    if (areStringsEqual(statusCode, @"INVALID_REQUEST")) {
        return @(SJResponseStatusCodeInvalidRequest);
    }
	if (areStringsEqual(statusCode, @"UNKNOWN_ERROR")) {
		return @(SJResponseStatusCodeUnknownError);
	}
	if (areStringsEqual(statusCode, @"NOT_FOUND")) {
		return @(SJResponseStatusCodeNotFound);
	}
    return nil;
}

BOOL areStringsEqual (NSString *string1, NSString *string2) {
    return [string1 isEqualToString:string2];
}

@end
