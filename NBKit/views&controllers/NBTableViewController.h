//
//  NBTableViewController.h
//  NBFramework
//
//  Created by MingLQ on 2015-08-18.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <M9Dev/M9ScrollViewController.h>

#import "NBTableViewCell.h"

/**
 * Setup:
 *  self.tableView.dataSource = <#(id<UITableViewDelegate>)#>;
 *  self.tableView.delegate = <#(id<UITableViewDataSource>)#>;
 *
 * Enable pull to refresh:
 *  self.tableView.showsPullToRefresh = YES;
 *  [self.tableView addPullToRefreshWithActionHandler:^{
 *      [self loadData:^(id data){
 *          [self.tableView.pullToRefreshView stopAnimating];
 *      }];
 *  }];
 */
@interface NBTableViewController : M9ScrollViewController {
@protected
    UITableView *_tableView;
}

// UITableViewStyleGrouped by default
@property(nonatomic, readonly) UITableViewStyle style;
// !!!: dataSource & delegate are nil by default
@property(nonatomic, strong, readonly) UITableView *tableView;

@property(nonatomic) BOOL clearsSelectionOnViewWillAppear; // YES

- (instancetype)init; // UITableViewStyleGrouped
- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (nonatomic, getter=isReloadingEnabled) BOOL reloadingEnabled;
@property (nonatomic, copy) void (^reloadingCallback)(void);
@property (nonatomic, readonly, getter=isReloading) BOOL reloading;
- (void)startReloading;
- (void)stopReloading;

@property (nonatomic, getter=isLoadingMoreEnabled) BOOL loadingMoreEnabled;
@property (nonatomic, copy) void (^loadingMoreCallback)(void);
@property (nonatomic, readonly, getter=isLoadingMore) BOOL loadingMore;
- (void)startLoadingMore;
- (void)stopLoadingMore;

@end

#pragma mark -

// iOS6: remove tableView.backgroundView and cell.backgroundView for UITableViewStyleGrouped
@interface UITableView (iOS6UITableViewStyleGrouped)
- (void)removeGroupedCellBackgroundViewForiOS6:(UITableViewCell *)cell;
@end
