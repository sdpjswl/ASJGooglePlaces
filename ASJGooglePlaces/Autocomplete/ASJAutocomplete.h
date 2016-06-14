//
// ASJAutocomplete.h
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

#import "ASJPlace.h"
#import "ASJSession.h"

typedef void(^AutocompleteBlock)(ASJResponseStatusCode statusCode, NSArray<ASJPlace *> *places, NSError *error);

@interface ASJAutocomplete : ASJSession

/**
 *  The minimum number of characters input after which autocomplete results should be fetched.
 */
@property (assign, nonatomic) NSUInteger minimumInputLength;

/**
 *  Fetch place results from Google's Places Autocomplete API.
 *
 *  @param input      The search query against which place results are te be fetched.
 *  @param completion The completion block that is called after the API call is complete. It contains an array of 'ASJPlace' instances and a status code indicating the result of the request. Be sure you check it for ay failure conditions.
 */
- (void)autocompleteForQuery:(NSString *)query completion:(AutocompleteBlock)completion;

@end
