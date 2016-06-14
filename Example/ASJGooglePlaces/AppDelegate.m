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
#warning Provide keys for app tp work correctly. Go to: https://code.google.com/apis/console
  // key for Google Places API requests
  [ASJConstants sharedInstance].apiKey = @"<#set API key#>";
  
  // key for Google Maps SDK
  [GMSServices provideAPIKey:@"<#set API key#>"];
  
  return YES;
}

@end
