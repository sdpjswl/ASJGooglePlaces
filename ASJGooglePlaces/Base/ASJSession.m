//
//  ASJSession.m
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

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
