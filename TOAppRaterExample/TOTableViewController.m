//
//  TOTableViewController.m
//  TOClassyAppRaterExample
//
//  Created by Tim Oliver on 12/13/14.
//  Copyright (c) 2014 Tim Oliver. All rights reserved.
//

#import "TOTableViewController.h"
#import "TOAppRater.h"

@interface TOTableViewController ()

- (void)didUpdateRatings;

@end

@implementation TOTableViewController

#pragma mark - Register for Notifications -

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateRatings)
                                                     name:TOAppRaterDidUpdateNotification
                                                   object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TOAppRaterDidUpdateNotification
                                                  object:nil];
}

- (void)didUpdateRatings
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - View Set-up -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // On iPad, make the large title match the inset of the table
    self.navigationController.navigationBar.layoutMargins = self.tableView.layoutMargins;
    
    // Position the table a little lower than the navigation bar
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 10.0f;
    self.tableView.contentInset = insets;
}

#pragma mark - Table View Presentation -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Rate This App on The App Store";
        
        NSString *localizedMessage = [TOAppRater localizedUsersRatedString];
        if (localizedMessage) { cell.detailTextLabel.text = localizedMessage; }
    }
    else {
        cell.textLabel.text = @"Show the In-App Review Prompt";
        cell.detailTextLabel.text = nil;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [TOAppRater rateApp];
    }
    else {
        [TOAppRater promptForRating];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 2; }

@end
