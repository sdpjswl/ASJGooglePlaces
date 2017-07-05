//
// ASJSession.m
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

#import "ASJResponseValidator.h"
#import "ASJSession.h"
#import <Foundation/NSException.h>

@interface ASJSession ()

@property (copy) SessionBlock completion;

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
  return [NSURL URLWithString:k_asj_BaseURL];
}

- (NSString *)apiKey
{
  return [ASJConstants sharedInstance].apiKey;
}

- (NSString *)languageKey
{
  return [ASJConstants sharedInstance].languageKey;
}

- (void)executeRequestForURL:(NSURL *)url completion:(SessionBlock)completion
{
    if (self.languageKey) {
        NSString *urlString = [url absoluteString];
        urlString = [urlString stringByAppendingFormat:@"&language=%@", self.languageKey];
        url = [[NSURL alloc] initWithString:urlString];
    }
    _completion = completion;
    [[self.urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self validate:data error:error];
    }] resume];
}

#pragma mark - Private

- (void)validate:(NSData *)data error:(NSError *)error
{
  [ASJResponseValidator validateData:data error:error completion:^(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error)
   {
     if (_completion) {
         dispatch_async(dispatch_get_main_queue(), ^{
           _completion(statusCode, response, error);
         });
     }
   }];
}

- (void)executeGooglePlacesRequest
{
  NSAssert(NO, @"You must implement this method in subclass and make your API call here.");
}

@end
