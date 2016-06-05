//  ASJSession.m
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

#import "ASJSession.h"
#import "ASJResponseValidator.h"

typedef void (^CallbackBlock)(ASJResponseStatusCode, NSData *, NSDictionary *);

@interface ASJSession ()

@property (copy) CallbackBlock callback;

- (void)onTaskCompletionWithData:(NSData *)data error:(NSError *)error;

@end

@implementation ASJSession


#pragma mark - Public

+ (NSURLSession *)asjSession {
    static NSURLSession *ASJSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        ASJSession = [NSURLSession sessionWithConfiguration:config];
    });
    return ASJSession;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:kBaseURL];
}

- (void)executeRequestForURL:(NSURL *)url
                  completion:(void (^)(ASJResponseStatusCode, NSData *, NSDictionary *))completion {
    
    _callback = completion;
    NSURLSession *session = [ASJSession asjSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            [self onTaskCompletionWithData:data error:error];
                                        }];
    [task resume];
}


#pragma mark - Private

- (void)onTaskCompletionWithData:(NSData *)data error:(NSError *)error {
    
    [ASJResponseValidator validateResponseData:data
                                        error:error
                                   completion:^(ASJResponseStatusCode statusCode, NSDictionary *response) {
                                       if (_callback) {
                                           _callback(statusCode, data, response);
                                       }
                                   }];
}

@end
