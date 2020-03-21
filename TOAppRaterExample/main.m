//
//  main.m
//  TOClassyAppRater
//
//  Created by Tim Oliver on 12/12/14.
//  Copyright (c) 2014 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOAppDelegate.h"

int main(int argc, char * argv[]) {
    // Borrowed from Jon Reid's fantastic insight on unit testing:
    // https://qualitycoding.org/ios-app-delegate-testing/
    // Since we don't want to trigger the normal sample code inside a unit
    // test and un-necessarily ping Apple's servers, replace the normal delegate
    // with a dummy one when unit testing.
    Class appDelegateClass = NSClassFromString(@"TOTestingAppDelegate");
    if (!appDelegateClass) { appDelegateClass = [TOAppDelegate class]; }
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
