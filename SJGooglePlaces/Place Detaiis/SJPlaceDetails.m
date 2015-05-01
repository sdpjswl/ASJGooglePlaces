//
//  SJPlaceDetails.m
//  GooglePlacesDemo
//
//  Created by sudeep on 27/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import CoreGraphics;
#import "SJPlaceDetails.h"
#import "SJPlaceID.h"
#import "SJDetails+Create.h"

typedef void (^PlaceNameCallbackBlock)(SJResponseStatusCode, SJDetails *);
typedef void (^PlaceIDCallbackBlock)(SJResponseStatusCode, SJDetails *);

@interface SJPlaceDetails ()

@property (copy, nonatomic) NSString *placeName;
@property (copy, nonatomic) NSString *placeID;
@property (copy) PlaceNameCallbackBlock placeNameCallback;
@property (copy) PlaceIDCallbackBlock placeIDCallback;

- (void)fetchPlaceID;
- (void)fetchPlaceDetailsForPlaceID:(NSString *)placeID;
- (void)executePlaceIDRequest;
- (NSURL *)urlForPlaceDetailsByIDQuery;

@end

@implementation SJPlaceDetails


#pragma mark - Public: By place name

- (void)sjPlaceDetailsForPlaceNamed:(NSString *)place
					  completion:(void (^)(SJResponseStatusCode statusCode, SJDetails *placeDetails))completion {
	_placeName = place;
	_placeNameCallback = completion;
	[self fetchPlaceID];
}


#pragma mark - Private: By place name

- (void)fetchPlaceID {
	SJPlaceID *api = [[SJPlaceID alloc] init];
	[api sjPlaceIDForPlaceNamed:_placeName
					 completion:^(SJResponseStatusCode statusCode, NSString *placeID) {
                         [self fetchPlaceDetailsForPlaceID:placeID];
                     }];
}

- (void)fetchPlaceDetailsForPlaceID:(NSString *)placeID {
	
	[self sjPlaceDetailsForPlaceID:placeID completion:^(SJResponseStatusCode statusCode, SJDetails *placeDetails) {
		if (_placeNameCallback) {
			_placeNameCallback(statusCode, placeDetails);
		}
	}];
}


#pragma mark - Public: By place ID

- (void)sjPlaceDetailsForPlaceID:(NSString *)placeID
					  completion:(void (^)(SJResponseStatusCode statusCode, SJDetails *placeDetails))completion {
	_placeID = placeID;
	_placeIDCallback = completion;
	[self executePlaceIDRequest];
}


#pragma mark - Private: By place ID

- (void)executePlaceIDRequest {
	NSURL *url = [self urlForPlaceDetailsByIDQuery];
	[self executeRequestForURL:url
					completion:^(SJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
						
						SJDetails *placeDetails = [SJDetails placeDetailsFromResponse:response];
						if (_placeIDCallback) {
							_placeIDCallback(statusCode, placeDetails);
						}
					}];
}

- (NSURL *)urlForPlaceDetailsByIDQuery {
	NSString *stub = [NSString stringWithFormat:@"%@?placeid=%@&key=%@", kPlaceDetailsSubURL, _placeID, [SJConstants sharedInstance].apiKey];
	stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
	return queryURL;
}

@end
