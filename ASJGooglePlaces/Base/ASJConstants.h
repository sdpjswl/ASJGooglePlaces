//
// ASJConstants.h
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

@import Foundation;

@interface ASJConstants : NSObject

/**
 *  The API key used to authorize requests. You must set this before making any requests. This is usually done in AppDelegate's 'application:didFinishLaunchingWithOptions:' method.
 */
@property (copy, nonatomic) NSString *apiKey;

/**
 *  The singleton object. Use it to set the API key in your AppDelegate.
 *
 *  @return The instance of 'ASJConstants'.
 */
+ (instancetype)sharedInstance;

@end

/**
 *  Every Places API request gives a 'status code' in its response. Each is mapped to an enum.
 */
typedef NS_ENUM(NSUInteger, ASJResponseStatusCode) {
  /**
   *  For response 'OK'.
   */
  ASJResponseStatusCodeOk,
  /**
   *  For response 'ZERO_RESULTS'.
   */
  ASJResponseStatusCodeZeroResults,
  /**
   *  For response 'OVER_QUERY_LIMIT'.
   */
  ASJResponseStatusCodeOverQueryLimit,
  /**
   *  For response 'REQUEST_DENIED'.
   */
  ASJResponseStatusCodeRequestDenied,
  /**
   *  For response 'INVALID_REQUEST'.
   */
  ASJResponseStatusCodeInvalidRequest,
  /**
   *  For response 'UNKNOWN_ERROR'.
   */
  ASJResponseStatusCodeUnknownError,
  /**
   *  For response 'NOT_FOUND'.
   */
  ASJResponseStatusCodeNotFound
};

/**
 *  These are a few constants that help construct the different URLs used to make API calls.
 */
static NSString *const kBaseURL             = @"https://maps.googleapis.com/maps/api/place/";
static NSString *const kDirectionsBaseURL   = @"http://maps.googleapis.com/maps/api/directions/json?alternatives=true&";
static NSString *const kAutocompleteSubURL  = @"autocomplete/json";
static NSString *const kPlaceDetailsSubURL  = @"details/json";
static NSString *const kPlaceIDSubURL       = @"textsearch/json";
static NSString *const kPlacePhotosSubURL   = @"photo";
