//
//  GooglePlaceDetails.h
//  Golopo
//
//  Created by Sudeep Jaiswal on 14/09/14.
//  Copyright (c) 2014 Sudeep Jaiswal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GooglePlaceDetailsDelegate <NSObject>

-(void)didFetchPlaceDetailsWithCoordinate:(CLLocationCoordinate2D)coordinates andImage:(UIImage *)image;

@end


@interface GooglePlaceDetails : NSObject {
    CLLocationCoordinate2D fetchedCoordinate;
}

@property (nonatomic, strong) id<GooglePlaceDetailsDelegate>delegate;

-(void)getPlaceDetailsForPlaceID:(NSString *)placeID;

@end
