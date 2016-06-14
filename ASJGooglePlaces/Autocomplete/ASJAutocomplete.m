//
// ASJAutocomplete.m
//
// Copyright (c) 2014 Sudeep Jaiswal
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

@interface ASJAutocomplete ()

@property (copy, nonatomic) NSString *query;
@property (copy) AutocompleteBlock completion;
@property (readonly, weak, nonatomic) NSURL *autocompleteURL;

@end

@implementation ASJAutocomplete

#pragma mark - Public

- (void)autocompleteForQuery:(NSString *)query completion:(AutocompleteBlock)completion
{
  _query = query;
  _completion = completion;
  
  if (query.length >= _minimumInputLength) {
    [self executeGooglePlacesRequest];
  }
}

#pragma mark - Private

- (void)executeGooglePlacesRequest
{
  [self executeRequestForURL:self.autocompleteURL completion:^(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error)
   {
     if (_completion)
     {
       NSArray *places = [ASJPlace placesForResponse:response];
       _completion(statusCode, places, error);
     }
   }];
}

- (NSURL *)autocompleteURL
{
  NSString *relativePath = [NSString stringWithFormat:@"%@?input=%@&key=%@", kAutocompleteSubURL, _query, self.apiKey];
  relativePath = [relativePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  return [NSURL URLWithString:relativePath relativeToURL:self.baseURL];
}

@end
