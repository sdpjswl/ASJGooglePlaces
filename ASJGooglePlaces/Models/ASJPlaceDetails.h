//
// ASJPlaceDetails.h
//
// Copyright (c) 2014-2016 Sudeep Jaiswal
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

#import "ASJPhoto.h"
#import <CoreLocation/CLLocation.h>

@interface ASJPlaceDetails : NSObject

/**
 *  The unique ID assigned by Google to each place.
 */
@property (copy, nonatomic) NSString *placeID;

/**
 *  The place's name.
 */
@property (copy, nonatomic) NSString *name;

/**
 *  The place's address.
 */
@property (copy, nonatomic) NSString *address;

/**
 *  The place's phone number (if available).
 */
@property (copy, nonatomic) NSString *phone;

/**
 *  The place's website (if available).
 */
@property (copy, nonatomic) NSString *website;

/**
 *  The place's photos (if available).
 */
@property (copy, nonatomic) NSArray <ASJPhoto *> *photos;

/**
 *  The place's coordinates.
 */
@property (assign, nonatomic) CLLocationCoordinate2D location;

/**
 *  A helper method that creates an 'ASJDetails' model object from a JSON response.
 *
 *  @param response JSON fetched from Google API.
 *
 *  @return An instance of 'ASJDetails'.
 */
+ (ASJPlaceDetails *)placeDetailsForResponse:(NSDictionary *)response;

@end
