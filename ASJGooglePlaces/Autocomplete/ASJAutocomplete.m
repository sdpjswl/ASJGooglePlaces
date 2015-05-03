//
//  ASJAutocomplete.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJAutocomplete.h"
#import "ASJPlace+Create.h"

typedef void (^CallbackBlock)(ASJResponseStatusCode, NSArray *);

@interface ASJAutocomplete ()

@property (copy, nonatomic) NSString *input;
@property (copy) CallbackBlock callback;

- (void)executeRequest;
- (NSURL *)urlForAutocompleteQuery;

@end

@implementation ASJAutocomplete


#pragma mark - Public

- (void)asjAutocompleteForInput:(NSString *)input
					completion:(void (^)(ASJResponseStatusCode statusCode, NSArray *places))completion {
	
	_input = input;
	_callback = completion;
	if (!_minimumInputLength) {
		[self executeRequest];
		return;
	}
	if (input.length >= _minimumInputLength) {
		[self executeRequest];
	}
}


#pragma mark - Private

- (void)executeRequest {
	NSURL *url = [self urlForAutocompleteQuery];
	[self executeRequestForURL:url
					completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
						
                        NSArray *places = [ASJPlace placesForResponse:response];
						if (_callback) {
							_callback(statusCode, places);
						}
					}];
}

- (NSURL *)urlForAutocompleteQuery {
	NSString *stub = [NSString stringWithFormat:@"%@?input=%@&key=%@", kAutocompleteSubURL, _input, [ASJConstants sharedInstance].apiKey];
	stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
	return queryURL;
}

@end
