//
//  TOClassyAppRater.m
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

#import "TOClassyAppRater.h"
#import <UIKit/UIKit.h>

NSString * const kAppRaterSettingsNumberOfRatings = @"TOAppRaterSettingsNumberOfRatings";
NSString * const kAppRaterSettingsLastUpdated = @"TOAppRaterSettingsNumberLastUpdated";

NSString * const kAppRaterSearchAPIURL = @"https://itunes.apple.com/lookup?id={APPID}&country={COUNTRY}";

//Thanks to Appirater for determining the necessary App Store URLs per iOS version
//https://github.com/arashpayan/appirater/issues/131
//https://github.com/arashpayan/appirater/issues/182

NSString * const kAppRaterReviewURL     = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id={APPID}";
NSString * const kAppRaterReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/id{APPID}";
NSString * const kAppRaterReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id={APPID}&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";

NSString * const TOClassyAppRaterDidUpdateNotification = @"TOClassyAppRaterDidUpdateNotification";

#define APP_RATER_CHECK_INTERVAL 24*60*60 //24 hours
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

/* App Store ID for this app. */
static NSString *_appID;

/* Cached copy of the localized message. */
static NSString *_localizedMessage = nil;

@implementation TOClassyAppRater

+ (void)setAppID:(NSString *)appID
{
    _appID = appID;
}

+ (void)checkForUpdates
{
    if (_appID == nil)
        [NSException raise:NSObjectNotAvailableException format:@"An app ID must be specified before calling this method."];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval previousUpdateTime = [USER_DEFAULTS floatForKey:kAppRaterSettingsLastUpdated];
    
    if (currentTime < previousUpdateTime + APP_RATER_CHECK_INTERVAL)
        return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        NSString *searchURL = kAppRaterSearchAPIURL;
        searchURL = [searchURL stringByReplacingOccurrencesOfString:@"{APPID}" withString:_appID];
        searchURL = [searchURL stringByReplacingOccurrencesOfString:@"{COUNTRY}" withString:countryCode ? countryCode : @"US"];
        
        
        NSData *jsonStream = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]];
        if (jsonStream.length == 0) {
#ifdef DEBUG
            NSLog(@"TOClassyAppRater: Unable to load JSON data from iTunes Search API.");
#endif
            return;
        }
        
        NSError *error = nil;
        NSDictionary *searchJSON = [NSJSONSerialization JSONObjectWithData:jsonStream options:NSJSONReadingMutableContainers error:&error];
        if (searchJSON == nil || error != nil) {
#ifdef DEBUG
            NSLog(@"%@", error.localizedDescription);
#endif
            return;
        }
        
        NSInteger numberOfRatings = [[searchJSON[@"results"] firstObject][@"userRatingCountForCurrentVersion"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            _localizedMessage = nil;
            
            [USER_DEFAULTS setInteger:numberOfRatings forKey:kAppRaterSettingsNumberOfRatings];
            [USER_DEFAULTS setFloat:currentTime forKey:kAppRaterSettingsLastUpdated];
            [USER_DEFAULTS synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TOClassyAppRaterDidUpdateNotification object:nil];
        });
    });
}

+ (NSString *)localizedUsersRatedString
{
    if ([USER_DEFAULTS objectForKey:kAppRaterSettingsNumberOfRatings] == nil)
        return nil;
    
    if (_localizedMessage)
        return _localizedMessage;
    
    NSInteger numberOfRatings = MAX([USER_DEFAULTS integerForKey:kAppRaterSettingsNumberOfRatings], 0);
    
    NSString *ratedString = nil;
    if (numberOfRatings == 0)
        ratedString = NSLocalizedStringFromTable(@"No one has rated this version yet", @"AppRaterLocalizable", nil);
    else if (numberOfRatings == 1)
        ratedString = NSLocalizedStringFromTable(@"Only 1 person has rated this version", @"AppRaterLocalizable", nil);
    else if (numberOfRatings < 50)
        ratedString = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Only %d people have rated this version", @"AppRaterLocalizable", nil), numberOfRatings];
    else
        ratedString = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%d people have rated this version", @"AppRaterLocalizable", nil), numberOfRatings];
    
    _localizedMessage = ratedString;
    
    return ratedString;
}

+ (void)rateApp
{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"TOClassyAppRater: Cannot open App Store on iOS Simulator");
    return;
#endif
    
    NSString *rateURL = [kAppRaterSearchAPIURL stringByReplacingOccurrencesOfString:@"{APPID}" withString:_appID];
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion >= 7.0 && systemVersion < 7.1)
        rateURL = [kAppRaterReviewURLiOS7 stringByReplacingOccurrencesOfString:@"{APPID}" withString:_appID];
    else if (systemVersion >= 8.0)
        rateURL = [kAppRaterReviewURLiOS8 stringByReplacingOccurrencesOfString:@"{APPID}" withString:_appID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateURL]];
}

@end
