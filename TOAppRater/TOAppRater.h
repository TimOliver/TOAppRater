//
//  TOAppRater.h
//
//  Copyright 2014-2020 Timothy Oliver. All rights reserved.
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

NS_ASSUME_NONNULL_BEGIN

/**
 A notification that is posted whenever the ratings number is updated.
 Use this notification to update any UI currently displaying the users rating string.
 */
extern NSString * const TOAppRaterDidUpdateNotification;

/**
 A class that tries to encourage users to rate the
 app in a more "classy" way than disrupting their
 experience with a poorly timed, obnoxious modal popup.
 */
NS_SWIFT_NAME(AppRater)
@interface TOAppRater : NSObject

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
+ (nullable NSString *)localizedUsersRatedString;

/**
 Moves the user over to the 'Reviews' section of the specified app on the App Store.
 */
+ (void)rateApp;

/**
 On iOS 10.3 and above, use the official system prompt to ask for a review.
 
 The system controls the frequency that the prompt is displayed, and may not
 even show it at all depending on the users preferences. As such, it should not
 be used in response to a button tap, and can be called multiple times without
 any detriments.
 
 It is highly recommended to call this prompt at times where the user would not
 feel inconvenienced by its appearence (eg, they just completed a task with the app etc)
 */
+ (void)promptForRating;

@end

NS_ASSUME_NONNULL_END
