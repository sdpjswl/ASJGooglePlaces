//  ASJStatusCodeValueTransformer.m
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
