//  ASJAutocomplete.m
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
