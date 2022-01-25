//
//  ASJGeocode.h
//
//  Created by Ivan Gaydamakin on 05/07/2017.
//  Copyright © 2017 Sudeep Jaiswal. All rights reserved.
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

#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASJGeocode : NSObject

/** Location, or kLocationCoordinate2DInvalid if unknown. */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/** Place id. */
@property (nonatomic, readonly, copy) NSString *placeID;

/** Locality or city. */
@property (nonatomic, readonly, copy) NSString *locality;

/** The country name. */
@property (nonatomic, readonly, copy) NSString *country;

/** Postal/Zip code. */
@property (nonatomic, copy, readonly) NSString *postalCode;

/** Country code. */
@property (nonatomic, copy, readonly) NSString *countryCode;

/** The formatted address. */
@property (nonatomic, readonly, copy) NSString *formattedAddress;

/** An array containing address components. May be nil. */
@property (nonatomic, readonly, copy) NSArray *addressComponents;

/** An array of NSString containing formatted lines of the address. May be nil. */
@property (nonatomic, copy, readonly) NSArray<NSString *> *lines;

/**
 *  A helper method that creates 'ASJGeocode' model objects from a JSON response.
 *
 *  @param response JSON fetched from Google API.
 *
 *  @return An array of 'ASJGeocode' instances.
 */
+ (NSArray<ASJGeocode *> *)geocodesForResponse:(NSDictionary *)response;

- (instancetype)initWithResponse:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
