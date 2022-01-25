//
//  AppDelegate.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 12/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "AppDelegate.h"
#import "ASJGooglePlaces.h"
#import <GoogleMaps/GMSServices.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#warning API key(s) needed
    /**
     *  Google Places API needs an API key to authorize requests. You will need one to run the example project. To get one, go to: https://console.cloud.google.com/
     */
    [ASJConstants sharedInstance].apiKey = @"AIzaSyA4P7Yl9425BDClBqo_Gvxt7Mw1RWpJJrY";
    
    /**
     *  Language key for Google Services API for correct translation response.
     */
    [ASJConstants sharedInstance].languageKey = @"en";
    
    /**
     *  Google Maps SDK requires a separate key. This is being used here to show directions between two places.
     */
    [GMSServices provideAPIKey:@"AIzaSyAYgIBV4d2xGc24Hq144GYT4R204tNFRQY"];
    
    return YES;
}

@end
