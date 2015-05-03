//
//  ASJPlaceID.m
//  GooglePlacesDemo
//
//  Created by sudeep on 26/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJPlaceID.h"

typedef void (^CallbackBlock)(ASJResponseStatusCode, NSString *);

@interface ASJPlaceID ()

@property (nonatomic) NSString *placeName;
@property (copy) CallbackBlock callback;

- (void)executeRequest;
- (NSURL *)urlForPlaceIDQuery;

@end

@implementation ASJPlaceID


#pragma mark - Public

- (void)asjPlaceIDForPlaceNamed:(NSString *)place
					completion:(void (^)(ASJResponseStatusCode statusCode, NSString *placeID))completion {
	_placeName = place;
	_callback = completion;
	[self executeRequest];
}


#pragma mark - Private

- (void)executeRequest {
	NSURL *url = [self urlForPlaceIDQuery];
	[self executeRequestForURL:url
					completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
						
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
	NSString *stub = [NSString stringWithFormat:@"%@?query=%@&key=%@", kPlaceIDSubURL, _placeName, [ASJConstants sharedInstance].apiKey];
	stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
	return queryURL;
}

@end
