//
//  ASJResponseValidator.h
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import Foundation;
#import "ASJConstants.h"

@interface ASJResponseValidator : NSObject

+ (void)validateResponseData:(NSData *)data
                       error:(NSError *)error
                  completion:(void (^)(ASJResponseStatusCode statusCode, NSDictionary *response))completion;

@end
