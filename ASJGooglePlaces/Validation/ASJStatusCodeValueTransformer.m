//
//  ASJStatusCodeValueTransformer.m
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJStatusCodeValueTransformer.h"
#import "ASJConstants.h"

@implementation ASJStatusCodeValueTransformer

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
        return @(ASJResponseStatusCodeOk);
    }
    if (areStringsEqual(statusCode, @"ZERO_RESULTS")) {
        return @(ASJResponseStatusCodeZeroResults);
    }
    if (areStringsEqual(statusCode, @"OVER_QUERY_LIMIT")) {
        return @(ASJResponseStatusCodeOverQueryLimit);
    }
    if (areStringsEqual(statusCode, @"REQUEST_DENIED")) {
        return @(ASJResponseStatusCodeRequestDenied);
    }
    if (areStringsEqual(statusCode, @"INVALID_REQUEST")) {
        return @(ASJResponseStatusCodeInvalidRequest);
    }
	if (areStringsEqual(statusCode, @"UNKNOWN_ERROR")) {
		return @(ASJResponseStatusCodeUnknownError);
	}
	if (areStringsEqual(statusCode, @"NOT_FOUND")) {
		return @(ASJResponseStatusCodeNotFound);
	}
    return nil;
}

BOOL areStringsEqual (NSString *string1, NSString *string2) {
    return [string1 isEqualToString:string2];
}

@end
