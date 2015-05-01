//
//  SJPlaceID.m
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJPlaceID.h"

typedef void (^CallbackBlock)(SJResponseStatusCode, NSString *);

@interface SJPlaceID ()

@property (nonatomic) NSString *placeName;
@property (copy) CallbackBlock callback;

- (void)executeRequest;
- (NSURL *)urlForPlaceIDQuery;

@end

@implementation SJPlaceID


#pragma mark - Public

- (void)sjPlaceIDForPlaceNamed:(NSString *)place
					completion:(void (^)(SJResponseStatusCode statusCode, NSString *placeID))completion {
	_placeName = place;
	_callback = completion;
	[self executeRequest];
}


#pragma mark - Private

- (void)executeRequest {
	NSURL *url = [self urlForPlaceIDQuery];
	[self executeRequestForURL:url
					completion:^(SJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
						
                        NSString *placeID = nil;
                        NSArray *results = response[@"results"];
                        if (results.count) {
                            NSDictionary *topResult = results[0];
                            placeID = topResult[@"place_id"];
                        }
						if (_callback) {
							_callback(statusCode, placeID);
						}
					}];
}

- (NSURL *)urlForPlaceIDQuery {
	NSString *stub = [NSString stringWithFormat:@"%@?query=%@&key=%@", kPlaceIDSubURL, _placeName, [SJConstants sharedInstance].apiKey];
	stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
	return queryURL;
}

@end
