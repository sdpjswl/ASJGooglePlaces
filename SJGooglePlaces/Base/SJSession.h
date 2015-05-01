//
//  SJSession.h
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import Foundation;
#import "SJConstants.h"

@interface SJSession : NSObject

@property (nonatomic) NSURL *baseURL;

+ (NSURLSession *)sjSession;
- (void)executeRequestForURL:(NSURL *)url
				  completion:(void (^)(SJResponseStatusCode statusCode, NSData *data, NSDictionary *response))completion;

@end
