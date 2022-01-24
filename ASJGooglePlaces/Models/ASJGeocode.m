//
//  ASJGeocode.m
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

#import "ASJGeocode.h"

@interface ASJGeocode ()

@property(nonatomic, strong) NSDictionary *dictionary;

@end

@implementation ASJGeocode

+ (NSArray<ASJGeocode *> *)geocodesForResponse:(NSDictionary *)response
{
  NSArray *results = response[@"results"];
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  
  for (NSDictionary *dict in results)
  {
    ASJGeocode *geocode = [[ASJGeocode alloc] initWithResponse:dict];
    [temp addObject:geocode];
  }
  
  return [NSArray arrayWithArray:temp];
}

- (id)initWithResponse:(NSDictionary *)dictionary
{
  self = [super init];
  if (self) {
    self.dictionary = dictionary;
  }
  return self;
}

- (CLLocationCoordinate2D)coordinate
{
  NSDictionary *location = self.dictionary[@"geometry"][@"location"];
  NSNumber *latitude = location[@"lat"];
  NSNumber *longitude = location[@"lng"];
  return CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
}

- (NSString *)placeID
{
  return self.dictionary[@"place_id"];
}

- (NSString *)locality
{
  return [self getLongNameFrom:@"locality"];
}

- (NSString *)country
{
  return [self getLongNameFrom:@"country"];
}

- (NSString *)formattedAddress
{
  return self.dictionary[@"formatted_address"];
}

- (NSArray *)addressComponents
{
  return self.dictionary[@"address_components"];
}

- (NSString *)postalCode
{
  return [self getLongNameFrom:@"postal_code"];
}

- (NSString *)countryCode
{
  return [self getShortNameFrom:@"country"];
}

- (NSString *)getLongNameFrom:(NSString *)string
{
  for (NSDictionary *dictionary in self.addressComponents)
  {
    NSString *type = ((NSArray *) dictionary[@"types"]).firstObject;
    if([type isEqual:string]) {
      return dictionary[@"long_name"];
    }
  }
  return nil;
}

- (NSString *)getShortNameFrom:(NSString *)string
{
  for (NSDictionary *dictionary in self.addressComponents)
  {
    NSString *type = ((NSArray *) dictionary[@"types"]).firstObject;
    if([type isEqual:string]) {
      return dictionary[@"short_name"];
    }
  }
  return nil;
}

- (NSArray<NSString *> *)lines
{
  NSArray<NSString *> *array = [self.formattedAddress componentsSeparatedByString:@","];
  NSMutableArray *strings = [@[] mutableCopy];
  for (NSString *line in array)
  {
    [strings addObject:[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
  }
  return [strings copy];
}

@end
