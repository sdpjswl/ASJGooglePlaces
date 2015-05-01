//
//  SJOriginDestination.h
//  GooglePlacesDemo
//
//  Created by sudeep on 01/05/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface SJOriginDestination : NSObject

@property (copy, nonatomic) NSString *originName;
@property (copy, nonatomic) NSString *destinationName;
@property (nonatomic) CLLocationCoordinate2D origin;
@property (nonatomic) CLLocationCoordinate2D destination;
@property (copy, nonatomic) NSString *polyline;

@end
