//
// ASJResponseValidator.m
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

#import "ASJResponseValidator.h"
#import "ASJStatusCodeValueTransformer.h"
#import <Foundation/NSData.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSJSONSerialization.h>
#import <UIKit/UIImage.h>

@implementation ASJResponseValidator

+ (void)validateData:(NSData *)data error:(NSError *)error completion:(ValidatorBlock)completion
{
  if (!completion) {
    return;
  }
  
  if (!data.length || error)
  {
    completion(ASJResponseStatusCodeOtherIssue, nil, error);
    return;
  }
  
  NSError *jsonError = nil;
  NSDictionary *response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
  
  if (!response || jsonError)
  {
    // try to look for image
    UIImage *image = [UIImage imageWithData:data];
    if (!image) {
      completion(ASJResponseStatusCodeOtherIssue, response, jsonError);
      return;
    }
    else {
      response = @{@"image": image};
      completion(ASJResponseStatusCodeOk, response, nil);
      return;
    }
  }
  
  // for all types of requests except photos
  ASJStatusCodeValueTransformer *transformer = [[ASJStatusCodeValueTransformer alloc] init];
  NSNumber *statusCodeBoxed = [transformer transformedValue:response[@"status"]];
  ASJResponseStatusCode statusCode = (ASJResponseStatusCode)statusCodeBoxed.unsignedIntegerValue;
  completion(statusCode, response, jsonError);
}

@end
