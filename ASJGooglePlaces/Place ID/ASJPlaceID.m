//  ASJPlaceID.m
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
