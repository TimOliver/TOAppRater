//
//  TOAppRaterTests.m
//  TOAppRaterTests
//
//  Created by Tim Oliver on 2020/03/21.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOAppRater.h"

// -----------------------------------------------------
// In order to avoid calling our demo logic in the sample app,
// create a dummy testing delegate, and use that while unit testing.

@interface TOTestingAppDelegate : UIResponder<UIApplicationDelegate>
@end

@implementation TOTestingAppDelegate
@end

// -----------------------------------------------------

// User defaults key for storing when last chceked
extern NSString * const kAppRaterLastUpdatedSettingsKey;

// User defaults key for number of reviews received
extern NSString * const kAppRaterNumberOfRatingsSettingsKey;

// Private interface for methods not normally exposed publically
@interface TOAppRater (UnitTest)

+ (NSString *)appID;
+ (NSURL *)searchAPIURL;
+ (BOOL)timeIntervalHasPassed;
+ (void)updateRatingsCountWithAPIData:(NSData *)data;

@end

@interface TOAppRaterTests : XCTestCase

@property (nonatomic, strong) NSUserDefaults *standardUserDefaults;
@property (nonatomic, copy) NSString *appID;

@end

@implementation TOAppRaterTests

- (void)setUp
{
    self.standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    self.appID = @"493845493";
    [TOAppRater setAppID:self.appID];
}

- (void)tearDown
{
    [self.standardUserDefaults removeObjectForKey:kAppRaterLastUpdatedSettingsKey];
}

- (void)testAppID
{
    XCTAssertEqual([TOAppRater appID], self.appID);
}

- (void)testSearchAPIURL
{
    // The test scheme has been set to ensure the locale always returns one for the US.
    NSURL *searchURL = [TOAppRater searchAPIURL];
    NSString *searchURLString = @"https://itunes.apple.com/lookup?id=493845493&country=US";
    XCTAssertTrue([searchURL isEqual:[NSURL URLWithString:searchURLString]]);
}

- (void)testTimeIntervalPassing
{
    // Set the date to outside 24 hours
    NSTimeInterval oneDay = (24.0f * 60.0f * 60.0f);
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval oneDayAgo = currentTime - (oneDay * 2.0f);
    [self.standardUserDefaults setFloat:oneDayAgo forKey:kAppRaterLastUpdatedSettingsKey];
    
    XCTAssertTrue([TOAppRater timeIntervalHasPassed]);
    
    // Set the time interval to within 24 hours
    NSTimeInterval halfDayAgo = currentTime - (oneDay * 0.5f);
    [self.standardUserDefaults setFloat:halfDayAgo forKey:kAppRaterLastUpdatedSettingsKey];
    
    XCTAssertFalse([TOAppRater timeIntervalHasPassed]);
}

- (void)testResponseJSONSuccess
{
    NSString *responseJSON = @"{ \"results\": [{ \"userRatingCountForCurrentVersion\": 999 }] }";
    NSData *data = [responseJSON dataUsingEncoding:NSUTF8StringEncoding];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for the app rater to update defaults"];

    [TOAppRater updateRatingsCountWithAPIData:data];
    
    // This method asynchronously defers updating the defaults value to the main queue, so we can't
    // check the value in this loop. Perform the update, and then call the check in a subsequent operation.
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSInteger numberOfReviews = [self.standardUserDefaults integerForKey:kAppRaterNumberOfRatingsSettingsKey];
        XCTAssertEqual(numberOfReviews, 999);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0f];
}

- (void)testResponseJSONFailure
{
    // Set a default value we can test won't change
    [self.standardUserDefaults setInteger:123 forKey:kAppRaterNumberOfRatingsSettingsKey];
    
    NSString *responseJSON = @"{ \"results\": [] }";
    NSData *data = [responseJSON dataUsingEncoding:NSUTF8StringEncoding];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait for the app rater to process data"];

    [TOAppRater updateRatingsCountWithAPIData:data];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSInteger numberOfReviews = [self.standardUserDefaults integerForKey:kAppRaterNumberOfRatingsSettingsKey];
        XCTAssertEqual(numberOfReviews, 123);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1.0f];
}

@end
