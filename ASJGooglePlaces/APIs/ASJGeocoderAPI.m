//
//  ASJGeocoderAPI.m
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

#import "ASJGeocoderAPI.h"
#import "ASJGeocode.h"

@interface ASJGeocoderAPI()
@property (copy, nonatomic) NSString *placeID;
@property (copy) GeocoderBlock completion;
@property (readonly, weak, nonatomic) NSURL *geocoderURL;

@end

@implementation ASJGeocoderAPI

#pragma mark - Public

- (void)geocoderForPlaceID:(NSString *)placeID completion:(GeocoderBlock)completion {
    _placeID = placeID;
    _completion = completion;
    [self executeGoogleGeocoderRequest];
}

#pragma mark - Private

- (void)executeGoogleGeocoderRequest
{
    [self executeRequestForURL:self.geocoderURL completion:^(ASJResponseStatusCode statusCode, NSDictionary *response, NSError *error)
    {
        if (!_completion) {
            return;
        }

        NSArray *results = response[@"results"];
        if (!results.count)
        {
            _completion(statusCode, nil, error);
            return;
        }

        NSArray *geocodes = [ASJGeocode geocodesForResponse:response];
        _completion(statusCode, geocodes, error);
    }];
}

- (NSURL *)geocoderURL
{
    NSString *relativePath = [NSString stringWithFormat:@"%@?key=%@", k_asj_GeocoderSubURL, self.apiKey];
    if(_placeID)
        relativePath = [relativePath stringByAppendingFormat:@"&place_id=%@", _placeID];
    relativePath = [relativePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:relativePath relativeToURL:self.baseURL];
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:k_asj_GeocoderBaseURL];
}

@end
