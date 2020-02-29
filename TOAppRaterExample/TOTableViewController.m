//
//  TOTableViewController.m
//  TOClassyAppRaterExample
//
//  Created by Tim Oliver on 12/13/14.
//  Copyright (c) 2014 Tim Oliver. All rights reserved.
//

#import "TOTableViewController.h"
#import "TOClassyAppRater.h"

@interface TOTableViewController ()

- (void)didUpdateRatings;

@end

@implementation TOTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateRatings) name:TOClassyAppRaterDidUpdateNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TOClassyAppRaterDidUpdateNotification object:nil];
}

- (void)didUpdateRatings
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Rate this app";
    
    if ([TOClassyAppRater localizedUsersRatedString])
        cell.detailTextLabel.text = [TOClassyAppRater localizedUsersRatedString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [TOClassyAppRater rateApp];
}

@end
