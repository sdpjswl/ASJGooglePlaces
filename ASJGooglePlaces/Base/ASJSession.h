//
//  ASJSession.h
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import Foundation;
#import "ASJConstants.h"

@interface ASJSession : NSObject

@property (nonatomic) NSURL *baseURL;

+ (NSURLSession *)asjSession;
- (void)executeRequestForURL:(NSURL *)url
				  completion:(void (^)(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response))completion;

@end
