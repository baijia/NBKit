//
//  NBTableViewController.m
//  NBFramework
//
//  Created by MingLQ on 2015-08-18.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <M9Dev/UIScrollView+M9.h>
#import <M9Dev/NSObject+AssociatedValues.h>
#import <SVPullToRefreshImprove/SVPullToRefresh.h>

#import "NBTableViewController.h"

//#import "BBS_BaseRefreshHeaderView.h"
#import "UIColor+NBConstant.h"

#import "UIViewController+NB.h"
#import "NBRefreshHeaderView.h"

@interface NBTableView : UITableView
@property (nonatomic, getter=isLoadingMoreEnabled) BOOL loadingMoreEnabled;
@property (nonatomic, copy) void (^loadingMoreCallback)(void);
@property (nonatomic, getter=isLoadingMore) BOOL loadingMore;
@property (nonatomic, getter=lsLoadedMoreForCurrentBouncing) BOOL loadedMoreForCurrentBouncing;
@end

@interface NBTableView ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingMoreView;
@end

// TODO: MingLQ - 放弃 iOS6 后改为 category 方式实现加载更多
@implementation NBTableView

static const CGFloat NBTableView_margin = 5.0;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        // iOS6
        if ([[UIDevice currentDevice].systemVersion hasPrefix:@"6."]) {
            self.backgroundView = nil;
        }
        self.loadingMoreView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self removeGroupedCellBackgroundViewForiOS6:cell];
    return cell;
}

- (void)setLoadingMore:(BOOL)loadingMore {
    if (_loadingMore == loadingMore
        || (loadingMore && !self.loadingMoreEnabled)) {
        return;
    }
    
    _loadingMore = loadingMore;
    
    UIEdgeInsets contentInset = self.contentInset;
    if (self.loadingMore) {
        contentInset.bottom += CGRectGetHeight(self.loadingMoreView.frame) + NBTableView_margin * 2;
        [self addSubview:self.loadingMoreView];
        // for iOS7
        self.loadingMoreView.frame = CGRectSetXY(self.loadingMoreView.frame,
                                                 (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.loadingMoreView.frame)) / 2,
                                                 self.contentSize.height + NBTableView_margin);
        /* [self.loadingMoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self);
         make.top.mas_equalTo(self.contentSize.height + NBTableView_margin);
         }]; */
        [self.loadingMoreView startAnimating];
    }
    else {
        contentInset.bottom -= CGRectGetHeight(self.loadingMoreView.frame) + NBTableView_margin * 2;
        [self.loadingMoreView stopAnimating];
        [self.loadingMoreView removeFromSuperview];
    }
    self.contentInset = contentInset;

    if (loadingMore) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.loadingMoreCallback) self.loadingMoreCallback();
        });
    }
}

@end

#pragma mark -

@interface SVPullToRefreshView (pullToRefreshActionHandler)
@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@end
@implementation SVPullToRefreshView (pullToRefreshActionHandler)
@dynamic pullToRefreshActionHandler;
@end

#pragma mark -

static CGFloat const RefreshHeaderViewHeight = 60;
static void *KVOContext_NBTableViewController = &KVOContext_NBTableViewController;

@interface NBTableViewController ()

@property(nonatomic, readwrite) UITableViewStyle style;
@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, readonly) NBTableView *nb_tableView; // for loading more

//@property(nonatomic, strong) BBS_BaseRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) NBRefreshHeaderView *refreshHeaderView;

@end

@implementation NBTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.style = style;
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (self.clearsSelectionOnViewWillAppear) {
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        for (NSIndexPath *indexPath in indexPaths) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
        }
    }
}

- (void)dealloc {
    //TODO:Tets-替换keyPath的值 Wang Haoyu
//    [_tableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:KVOContext_NBTableViewController];
    [_tableView removeObserver:self forKeyPath:@"contentOffset" context:KVOContext_NBTableViewController];
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

#pragma mark - tableView

@dynamic scrollView;
- (UIScrollView *)scrollView {
    return self.tableView;
}

@synthesize tableView = _tableView;
- (UITableView *)tableView {
    if (![self isViewLoaded]) {
        [self view];
    }
    if (_tableView) {
        return _tableView;
    }
    
    self.tableView = ({
        UITableView *tableView = [[NBTableView alloc] initWithFrame:CGRectZero style:self.style];
        // remove separator for empty rows for UITableViewStylePlain
        if (tableView.style == UITableViewStylePlain) {
            tableView.tableFooterView = [UIView new];
        }
        // backgroundColor for UITableViewStyleGrouped
        else {
            tableView.backgroundColor = [UIColor whiteColor];
        }
        // NO - tableView.delegate = self;
        // NO - tableView.dataSource = self;
        _RETURN tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self.view);
    }];
    
    //TODO:
    //设置下拉刷新和上拉加载更多
    {
        [self.tableView addPullToRefreshWithActionHandler:nil]; // !!!: MUST set this first
        //        self.refreshHeaderView = [[BBS_BaseRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), RefreshHeaderViewHeight)];
        self.refreshHeaderView = [[NBRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), RefreshHeaderViewHeight)];
        [self.tableView.pullToRefreshView setCustomView:self.refreshHeaderView forState:SVPullToRefreshStateAll];
        self.tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        [self.tableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:0 context:KVOContext_NBTableViewController];
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:KVOContext_NBTableViewController];
        
        self.tableView.showsPullToRefresh = NO;
    }
    // nb style
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor bj_gray_200];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);//for ios 6
    }
    
    return _tableView;
}

- (void)viewDidLayoutSubviews {
    
}

@dynamic nb_tableView;
- (NBTableView *)nb_tableView {
    return [self.tableView as:[NBTableView class]];
}

#pragma mark - reloading

@dynamic reloadingEnabled;
- (BOOL)isReloadingEnabled {
    return self.tableView.showsPullToRefresh;
}
- (void)setReloadingEnabled:(BOOL)reloadingEnabled {
    self.tableView.showsPullToRefresh = reloadingEnabled;
}

@dynamic reloadingCallback;
- (void (^)(void))reloadingCallback {
    if ([self.tableView.pullToRefreshView respondsToSelector:@selector(pullToRefreshActionHandler)]) {
        return [self.tableView.pullToRefreshView performSelector:@selector(pullToRefreshActionHandler)];
    }
    return nil;
}
- (void)setReloadingCallback:(void (^)(void))reloadingCallback {
    [self.tableView addPullToRefreshWithActionHandler:reloadingCallback];
}

@dynamic reloading;
- (BOOL)isReloading {
    return (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading
            || self.tableView.pullToRefreshView.state == SVPullToRefreshStateTriggered);
}
- (void)startReloading {
    if (self.tableView.showsPullToRefresh
        && !self.reloading) {
        [self.tableView triggerPullToRefresh];
    }
}
- (void)stopReloading {
    [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark - loadingMore

@dynamic loadingMoreEnabled;
- (BOOL)isLoadingMoreEnabled {
    return self.nb_tableView.loadingMoreEnabled;
}
- (void)setLoadingMoreEnabled:(BOOL)loadingMoreEnabled {
    self.nb_tableView.loadingMoreEnabled = loadingMoreEnabled;
}

@dynamic loadingMoreCallback;
- (void (^)(void))loadMoreCallback {
    return self.nb_tableView.loadingMoreCallback;
}
- (void)setLoadingMoreCallback:(void (^)(void))loadingMoreCallback {
    self.nb_tableView.loadingMoreCallback = loadingMoreCallback;
}

@dynamic loadingMore;
- (BOOL)isLoadingMore {
    return self.nb_tableView.loadingMore;
}
- (void)startLoadingMore {
    if (self.nb_tableView.loadingMoreEnabled
        && !self.nb_tableView.loadingMore) {
        self.nb_tableView.loadingMore = YES;
    }
}
- (void)stopLoadingMore {
    self.nb_tableView.loadingMore = NO;
}

#pragma mark - KVO

- (void)updatePullToRefreshState {
    
    if (self.tableView.showsPullToRefresh) {
        //实时切换自定义视图中的view和字体
        //TODO:
//        NSLog(@"%ld",(long)self.tableView.pullToRefreshView.state);
        self.refreshHeaderView.state = self.tableView.pullToRefreshView.state;
        if (self.refreshHeaderView.state == SVPullToRefreshStateStopped
            && self.tableView.dragging) {
            /* 实现图片随着偏移量的增大，而放大或者缩小
            CGFloat scrollOffsetThreshold = self.tableView.pullToRefreshView.frame.origin.y - self.tableView.contentInset.top;
            if (self.tableView.contentOffset.y >= scrollOffsetThreshold) {
                CGFloat defalutScale = 0.6;
                CGFloat scalePercents = (- self.tableView.contentInset.top - self.tableView.contentOffset.y) / self.tableView.pullToRefreshView.frame.size.height;
                CGFloat scale = defalutScale + ((1.0 - defalutScale) * scalePercents);
                self.refreshHeaderView.arrowImage.transform = CGAffineTransformMakeScale(scale, scale);
            }
             */
            //new 需要随着偏移量来切换箭头方向
        }
        else {
            self.refreshHeaderView.arrowImage.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != KVOContext_NBTableViewController) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (object == self.tableView
        && self.tableView.window
        && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        CGFloat bouncingOffsetY = [self.tableView bouncingOffsetY];
        
        // bouncing down
        if (bouncingOffsetY < 0) {
            // NSLog(@"bouncing down: %f", bouncingOffsetY);
            
            // reset loadedMoreForCurrentBouncing
            self.nb_tableView.loadedMoreForCurrentBouncing = NO;
            
            // pull to refresh TODO:delay for call - Wang Haoyu
            weakdef(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongdef(self);
                [self updatePullToRefreshState];
            });
            
        }
        
        
        // bouncing up
        else if (bouncingOffsetY > 0) {
            // NSLog(@"bouncing up: %f", bouncingOffsetY);
            
            if (!self.nb_tableView.loadingMoreEnabled
                || self.nb_tableView.loadingMore
                || self.nb_tableView.loadedMoreForCurrentBouncing) {
                return;
            }
            self.nb_tableView.loadingMore = YES;
            self.nb_tableView.loadedMoreForCurrentBouncing = YES;
        }
        
        // scrolling
        else {
            // NSLog(@"--: %f", bouncingOffsetY);
            
            // reset loadedMoreForCurrentBouncing
            self.nb_tableView.loadedMoreForCurrentBouncing = NO;
        }
    }
}

@end

#pragma mark -

@implementation UITableView (iOS6UITableViewStyleGrouped)

- (void)removeGroupedCellBackgroundViewForiOS6:(UITableViewCell *)cell {
    // UITableViewCell: iOS6
    if (self.style == UITableViewStyleGrouped
        && [[UIDevice currentDevice].systemVersion hasPrefix:@"6."]) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    }
}


@end
