//
// ASJSession.h
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

#warning add nullability annotations

#import "ASJConstants.h"
#import <Foundation/NSCharacterSet.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSURLSession.h>

@protocol ASJSession <NSObject>

/**
 *  A required method you must implement to write the logic that calls the Google Places API.
 */
- (void)executeGooglePlacesRequest;

@end

typedef void(^SessionBlock)(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error);

@interface ASJSession : NSObject <ASJSession>

/**
 *  A single URL session to make all API calls.
 *
 *  @return An instance of NSURLSession.
 */
@property (readonly, strong, nonatomic) NSURLSession *urlSession;

/**
 *  The base URL for all Google Place API requests.
 */
@property (readonly, strong, nonatomic) NSURL *baseURL;

/**
 *  The key that authorizes each API call. If you don't have a key, generate one from https://console.developers.google.com
 */
@property (readonly, copy, nonatomic) NSString *apiKey;

/**
 *  A generic method that executes a URL request. For subclass use.
 *
 *  @param url        The URL to be executed.
 *  @param completion A completion block that is executed when the API call is complete.
 */
- (void)executeRequestForURL:(NSURL *)url completion:(SessionBlock)completion;

@end
