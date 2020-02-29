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
    [self.tableView reloadData];
}

#pragma mark - Table View Presentation -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Rate This App";
    
    if ([TOAppRater localizedUsersRatedString]) {
        cell.detailTextLabel.text = [TOAppRater localizedUsersRatedString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [TOAppRater rateApp];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 1; }

@end
