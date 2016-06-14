//
//  AppDelegate.m
//  ASJGooglePlacesExample
//
//  Created by sudeep on 12/04/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "AppDelegate.h"
#import "ASJConstants.h"
#import <GoogleMaps/GMSServices.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#warning Provide keys for app to work correctly. If you don't have one, go to: https://console.developers.google.com
  // key for Google Places API requests
  [ASJConstants sharedInstance].apiKey = @"AIzaSyAoXVbnsD_AV8ejPliFjT3vIEtEXsv1lPc";
  
  // key for Google Maps SDK
  [GMSServices provideAPIKey:@"AIzaSyAYgIBV4d2xGc24Hq144GYT4R204tNFRQY"];
  
  return YES;
}

@end
