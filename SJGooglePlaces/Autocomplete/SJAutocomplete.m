//
//  SJAutocomplete.m
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "SJAutocomplete.h"
#import "SJPlace+Create.h"

typedef void (^CallbackBlock)(SJResponseStatusCode, NSArray *);

@interface SJAutocomplete ()

@property (copy, nonatomic) NSString *input;
@property (copy) CallbackBlock callback;

- (void)executeRequest;
- (NSURL *)urlForAutocompleteQuery;

@end

@implementation SJAutocomplete


#pragma mark - Public

- (void)sjAutocompleteForInput:(NSString *)input
					completion:(void (^)(SJResponseStatusCode statusCode, NSArray *places))completion {
	
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
					completion:^(SJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
						
                        NSArray *places = [SJPlace placesForResponse:response];
						if (_callback) {
							_callback(statusCode, places);
						}
					}];
}

- (NSURL *)urlForAutocompleteQuery {
	NSString *stub = [NSString stringWithFormat:@"%@?input=%@&key=%@", kAutocompleteSubURL, _input, [SJConstants sharedInstance].apiKey];
	stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
	return queryURL;
}

@end
