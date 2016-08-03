//
// ASJResponseValidator.h
//
// Copyright (c) 2014-2016 Sudeep Jaiswal
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

typedef void(^ValidatorBlock)(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error);

@interface ASJResponseValidator : NSObject

/**
 *  Validates the response of the Google API call. Each call is being processed by this method before being passed on to the respective completion block.
 *
 *  @param data       The 'NSData' object received in the request's completion block.
 *  @param error      The 'NSError' object received in the request's completion block.
 *  @param completion A completion block that is called after validation is complete.
 */
+ (void)validateData:(NSData *)data error:(NSError *)error completion:(ValidatorBlock)completion;

@end
