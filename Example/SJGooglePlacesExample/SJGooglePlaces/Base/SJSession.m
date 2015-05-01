//
//  SJSession.m
//  SJGooglePlacesExample
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJSession.h"
#import "SJResponseValidator.h"

typedef void (^CallbackBlock)(SJResponseStatusCode, NSData *, NSDictionary *);

@interface SJSession ()

@property (copy) CallbackBlock callback;

- (void)onTaskCompletionWithData:(NSData *)data error:(NSError *)error;

@end

@implementation SJSession


#pragma mark - Public

+ (NSURLSession *)sjSession {
    static NSURLSession *sjSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        sjSession = [NSURLSession sessionWithConfiguration:config];
    });
    return sjSession;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:kBaseURL];
}

- (void)executeRequestForURL:(NSURL *)url
                  completion:(void (^)(SJResponseStatusCode, NSData *, NSDictionary *))completion {
    
    _callback = completion;
    NSURLSession *session = [SJSession sjSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            [self onTaskCompletionWithData:data error:error];
                                        }];
    [task resume];
}


#pragma mark - Private

- (void)onTaskCompletionWithData:(NSData *)data error:(NSError *)error {
    
    [SJResponseValidator validateResponseData:data
                                        error:error
                                   completion:^(SJResponseStatusCode statusCode, NSDictionary *response) {
                                       if (_callback) {
                                           _callback(statusCode, data, response);
                                       }
                                   }];
}

@end
