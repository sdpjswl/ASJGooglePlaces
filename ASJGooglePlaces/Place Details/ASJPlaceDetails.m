//
//  ASJPlaceDetails.m
//  GooglePlacesDemo
//
//  Created by sudeep on 27/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import CoreGraphics;
#import "ASJPlaceDetails.h"
#import "ASJPlaceID.h"
#import "ASJDetails+Create.h"

typedef void (^PlaceNameCallbackBlock)(ASJResponseStatusCode, ASJDetails *);
typedef void (^PlaceIDCallbackBlock)(ASJResponseStatusCode, ASJDetails *);

@interface ASJPlaceDetails ()

@property (copy, nonatomic) NSString *placeName;
@property (copy, nonatomic) NSString *placeID;
@property (copy) PlaceNameCallbackBlock placeNameCallback;
@property (copy) PlaceIDCallbackBlock placeIDCallback;

- (void)fetchPlaceID;
- (void)fetchPlaceDetailsForPlaceID:(NSString *)placeID;
- (void)executePlaceIDRequest;
- (NSURL *)urlForPlaceDetailsByIDQuery;

@end

@implementation ASJPlaceDetails


#pragma mark - Public: By place name

- (void)asjPlaceDetailsForPlaceNamed:(NSString *)place
					  completion:(void (^)(ASJResponseStatusCode statusCode, ASJDetails *placeDetails))completion {
	_placeName = place;
	_placeNameCallback = completion;
	[self fetchPlaceID];
}


#pragma mark - Private: By place name

- (void)fetchPlaceID {
	ASJPlaceID *api = [[ASJPlaceID alloc] init];
	[api asjPlaceIDForPlaceNamed:_placeName
					 completion:^(ASJResponseStatusCode statusCode, NSString *placeID) {
                         [self fetchPlaceDetailsForPlaceID:placeID];
                     }];
}

- (void)fetchPlaceDetailsForPlaceID:(NSString *)placeID {
	
	[self asjPlaceDetailsForPlaceID:placeID completion:^(ASJResponseStatusCode statusCode, ASJDetails *placeDetails) {
		if (_placeNameCallback) {
			_placeNameCallback(statusCode, placeDetails);
		}
	}];
}


#pragma mark - Public: By place ID

- (void)asjPlaceDetailsForPlaceID:(NSString *)placeID
					  completion:(void (^)(ASJResponseStatusCode statusCode, ASJDetails *placeDetails))completion {
	_placeID = placeID;
	_placeIDCallback = completion;
	[self executePlaceIDRequest];
}


#pragma mark - Private: By place ID

- (void)executePlaceIDRequest {
	NSURL *url = [self urlForPlaceDetailsByIDQuery];
	[self executeRequestForURL:url
					completion:^(ASJResponseStatusCode statusCode, NSData *data, NSDictionary *response) {
						
						ASJDetails *placeDetails = [ASJDetails placeDetailsFromResponse:response];
						if (_placeIDCallback) {
							_placeIDCallback(statusCode, placeDetails);
						}
					}];
}

- (NSURL *)urlForPlaceDetailsByIDQuery {
	NSString *stub = [NSString stringWithFormat:@"%@?placeid=%@&key=%@", kPlaceDetailsSubURL, _placeID, [ASJConstants sharedInstance].apiKey];
	stub = [stub stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *queryURL = [NSURL URLWithString:stub relativeToURL:self.baseURL];
	return queryURL;
}

@end
