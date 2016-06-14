//
// ASJSession.m
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

#import "ASJSession.h"
#import "ASJResponseValidator.h"

@interface ASJSession ()

@property (copy) CompletionBlock completion;

- (void)validate:(NSData *)data error:(NSError *)error;

@end

@implementation ASJSession

#pragma mark - Public

- (NSURLSession *)urlSession
{
  static NSURLSession *urlSession = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    urlSession = [NSURLSession sessionWithConfiguration:config];
  });
  return urlSession;
}

- (NSURL *)baseURL
{
  return [NSURL URLWithString:kBaseURL];
}

- (NSString *)apiKey
{
  return [ASJConstants sharedInstance].apiKey;
}

- (void)executeRequestForURL:(NSURL *)url completion:(CompletionBlock)completion
{
  _completion = completion;
  [[self.urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
      [self validate:data error:error];
    }] resume];
}

#pragma mark - Private

- (void)validate:(NSData *)data error:(NSError *)error
{
  [ASJResponseValidator validateResponseData:data error:error completion:^(ASJResponseStatusCode statusCode, NSDictionary *response)
   {
     if (_completion) {
       _completion(statusCode, data, response);
     }
   }];
}

- (void)executeGooglePlacesRequest
{
  NSAssert(NO, @"You must implement this method in subclass and make your API call here.");
}

@end
