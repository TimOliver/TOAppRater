//
//  AppDelegate.m
//  TOClassyAppRater
//
//  Created by Tim Oliver on 12/12/14.
//  Copyright (c) 2014 Tim Oliver. All rights reserved.
//

#import "AppDelegate.h"
#import "TOAppRater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Upon app launch, configure the app rater with this app's own App Store ID.
    [TOAppRater setAppID:@"493845493"];
    
    // Perform arequest to get the initial number of app reviews this app has.
    [TOAppRater checkForUpdates];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // When returning from being suspended, attempt to perform another request to see
    // if the number of reviews has since been updated.
    [TOAppRater checkForUpdates];
}

@end
