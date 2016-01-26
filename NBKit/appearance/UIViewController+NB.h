//
//  UIViewController+NB.h
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <M9Dev/M9Dev.h>

#import "NBButton.h"
#import "NBProgressHUD.h"
#import "NBErrorView.h"

@interface UIViewController (NB)

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                     target:(id)target
                                     action:(SEL)action;
- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image
                                buttonClass:(Class)buttonClass
                                     target:(id)target
                                     action:(SEL)action;

// self.navigationItem.<#left#>BarButtonItem = ...
- (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target action:(SEL)action;
- (void)setupBackBarButtonItem;

// self.navigationItem.<#left#>BarButtonItem = ...
- (UIBarButtonItem *)dismissBarButtonItemWithTarget:(id)target action:(SEL)action;
- (void)setupDismissBarButtonItem;

#pragma mark - loading

- (UIView *)showLoading;
- (UIView *)showLoadingInSuperview:(UIView *)superview;
- (void)hideLoading;
- (void)hideLoadingInSuperview:(UIView *)superview;

#pragma mark - message

- (NBProgressHUD *)showHUDWithText:(NSString *)text animated:(BOOL)animated;
- (NBProgressHUD *)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated;

- (NBProgressHUD *)showHUDWithText:(NSString *)text details:(NSString *)details animated:(BOOL)animated;
- (NBProgressHUD *)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated;

- (NBProgressHUD *)showHUDWithConfig:(NBProgressHUDCallback)config animated:(BOOL)animated;
- (NBProgressHUD *)showHUDWithConfig:(NBProgressHUDCallback)config superview:(UIView *)superview animated:(BOOL)animated;

#pragma mark - error

- (void)showErrorViewWithType:(NBErrorViewType)type callback:(NBErrorViewCallback)callback;
- (void)showErrorViewInView:(UIView *)view inset:(UIEdgeInsets)inset type:(NBErrorViewType)type callback:(NBErrorViewCallback)callback;
- (void)removeErrorView;

#pragma mark - log

+ (BOOL)nb_logStatEnabled;
+ (void)nb_setLogStatEnabled:(BOOL)enabled;
- (NSString *)bj_sku;

@end
