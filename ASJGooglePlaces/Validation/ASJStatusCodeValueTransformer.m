//
// ASJStatusCodeValueTransformer.m
//
// Copyright (c) 2014 Sudeep Jaiswal
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

#import "ASJConstants.h"
#import <Foundation/NSException.h>
#import "ASJStatusCodeValueTransformer.h"

@implementation ASJStatusCodeValueTransformer

#pragma mark - Overrides

+ (Class)transformedValueClass
{
  return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

- (id)transformedValue:(id)value
{
  NSAssert([value respondsToSelector:@selector(length)], @"You must pass an NSString.");
  NSString *statusCode = (NSString *)value;
  
  if (isEqual(statusCode, @"OK"))
  {
    return @(ASJResponseStatusCodeOk);
  }
  if (isEqual(statusCode, @"ZERO_RESULTS"))
  {
    return @(ASJResponseStatusCodeZeroResults);
  }
  if (isEqual(statusCode, @"MAX_WAYPOINTS_EXCEEDED"))
  {
    return @(ASJResponseStatusCodeMaxWaypointsExceeded);
  }
  if (isEqual(statusCode, @"OVER_QUERY_LIMIT"))
  {
    return @(ASJResponseStatusCodeOverQueryLimit);
  }
  if (isEqual(statusCode, @"REQUEST_DENIED"))
  {
    return @(ASJResponseStatusCodeRequestDenied);
  }
  if (isEqual(statusCode, @"INVALID_REQUEST"))
  {
    return @(ASJResponseStatusCodeInvalidRequest);
  }
  if (isEqual(statusCode, @"UNKNOWN_ERROR"))
  {
    return @(ASJResponseStatusCodeUnknownError);
  }
  if (isEqual(statusCode, @"NOT_FOUND"))
  {
    return @(ASJResponseStatusCodeNotFound);
  }
  
  return @(ASJResponseStatusCodeOtherIssue);
}

#pragma mark - Helper

BOOL isEqual(NSString *s1, NSString *s2)
{
  return [s1 isEqualToString:s2];
}

@end
