//
//  TOClassyAppRater.h
//
//  Copyright 2014 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

/* Notification that is posted whenever the ratings number is updated. */
extern NSString * const TOClassyAppRaterDidUpdateNotification;

@interface TOClassyAppRater : NSObject

/**
 Sets the App Store ID of this app that will be used for all furthur queries.
 
 @param appID The ID number of the app for this app.
 */
+ (void)setAppID:(NSString *)appID;

/**
 Once every 24 hours, will perform an asynchronous check to update the number of ratings this 
 app has received.
 
 It's best to call this method in both the 'applicationDidFinishLaunchingWithOptions' and 'applicationWillEnterForeground'
 app delegate methods.
 */
+ (void)checkForUpdates;

/**
 Returns a localized string stating how many users have rated the current app.
 */
+ (NSString *)localizedUsersRatedString;

/**
 Moves the user over to the 'Reviews' section of the specified app on the App Store.
 */
+ (void)rateApp;

@end
