//
//  ASJConstants.h
//  GooglePlacesDemo
//
//  Created by ABS_MAC02 on 29/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

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
