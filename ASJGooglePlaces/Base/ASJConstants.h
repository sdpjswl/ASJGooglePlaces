//  ASJConstants.h
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

@import Foundation;

@interface ASJConstants : NSObject

@property (copy, nonatomic) NSString *apiKey;

+ (instancetype)sharedInstance;

@end

typedef NS_ENUM(NSUInteger, ASJResponseStatusCode) {
	ASJResponseStatusCodeOk,
	ASJResponseStatusCodeZeroResults,
	ASJResponseStatusCodeOverQueryLimit,
	ASJResponseStatusCodeRequestDenied,
	ASJResponseStatusCodeInvalidRequest,
	ASJResponseStatusCodeUnknownError,
	ASJResponseStatusCodeNotFound
};

static NSString *const kBaseURL = @"https://maps.googleapis.com/maps/api/place/";
static NSString *const kDirectionsBaseURL = @"https://maps.googleapis.com/maps/api/directions/json";
static NSString *const kAutocompleteSubURL = @"autocomplete/json";
static NSString *const kPlaceDetailsSubURL = @"details/json";
static NSString *const kPlaceIDSubURL = @"textsearch/json";
static NSString *const kPlacePhotosSubURL = @"photo";
