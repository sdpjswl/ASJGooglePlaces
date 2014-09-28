//
//  GooglePlaceDetails.m
//  Golopo
//
//  Created by Sudeep Jaiswal on 14/09/14.
//  Copyright (c) 2014 Sudeep Jaiswal. All rights reserved.
//

#import "GooglePlaceDetails.h"
#import "Reachability.h"

#define API_KEY @"xxxxx"
#define REQUEST_PLACEHOLDER @"https://maps.googleapis.com/maps/api/place/"
#define PLACE_DETAILS @"details/json"
#define PHOTO_REFERENCE @"photo"
#define MAX_HEIGHT @"336"

@implementation GooglePlaceDetails

-(void)getPlaceDetailsForPlaceID:(NSString *)placeID {
    
    NSString *queryWithPercentEscapes = [placeID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?placeid=%@&key=%@", REQUEST_PLACEHOLDER, PLACE_DETAILS, queryWithPercentEscapes, API_KEY];
    [self fireSearchQueryGETRequest:urlString];
}

-(void)fireSearchQueryGETRequest:(NSString *)name {
    
    NSURL *linkToHit = [NSURL URLWithString:name];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:linkToHit];
    
    if([GooglePlaceDetails checkForInternetConnection]) {
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                
                if (data != nil) {
                    NSArray *array = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    [self parseSearchQueryResponse:array];
                }
            }
            else {
                NSLog(@"error running query:\n%@", [connectionError localizedDescription]);
            }
        }];
    }
    else {
        
    }
}

-(void)parseSearchQueryResponse:(NSArray *)array {
    
    // if there is at least one search result
    if (![[array valueForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"]) {
        
        if (![[array valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            
            CLLocationDegrees latitude = [[[[[array valueForKey:@"result"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
            CLLocationDegrees longitude = [[[[[array valueForKey:@"result"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
            fetchedCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            // downloading a photo
            NSString *onePhotoReference = [[[[array valueForKey:@"result"] valueForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0];
            [self getPhotoFromPhotoReference:onePhotoReference];
        }
        
        else {
            NSLog(@"zero results");
        }
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Daily limit reached. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Photo reference methods

-(void)getPhotoFromPhotoReference:(NSString *)photoReference {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?photoreference=%@&maxheight=%@&key=%@", REQUEST_PLACEHOLDER, PHOTO_REFERENCE, photoReference, MAX_HEIGHT, API_KEY];
    [self firePhotoReferenceGETRequest:urlString];
}

-(void)firePhotoReferenceGETRequest:(NSString *)name {
    
    NSURL *linkToHit = [NSURL URLWithString:name];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:linkToHit];
    
    if([GooglePlaceDetails checkForInternetConnection]) {
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                
                if (data != nil) {
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    // calling the delegate
                    if ([self.delegate respondsToSelector:@selector(didFetchPlaceDetailsWithCoordinate:andImage:)]) {
                        [self.delegate didFetchPlaceDetailsWithCoordinate:fetchedCoordinate andImage:image];
                    }
                }
            }
            else {
                NSLog(@"error running query:\n%@", [connectionError localizedDescription]);
            }
        }];
    }
    else {
        
    }
}


#pragma mark - Internet check method

+(BOOL)checkForInternetConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    NSLog(@"net status: %ld", netStatus);
    if (netStatus) {
        return YES;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

@end
