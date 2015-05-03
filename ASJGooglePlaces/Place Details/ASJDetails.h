//
//  ASJDetails.h
//  GooglePlacesDemo
//
//  Created by sudeep on 28/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface ASJDetails : NSObject

@property (copy, nonatomic) NSString *placeID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *website;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) NSArray *photos; // of type ASJPhoto

@end
