//
//  UIViewController+NB.m
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <JRSwizzle/JRSwizzle.h>
#import <YLGIFImage/YLGIFImage.h>
#import <YLGIFImage/YLImageView.h>
#import <LogStat/BJLogStat.h>

#import "UIViewController+NB.h"

#import "UIColor+NBConstant.h"

@interface UINavigationItem (iOS6)

@end

@implementation UINavigationItem (iOS6)

+ (void)load {
    if ([[UIDevice currentDevice].systemVersion hasPrefix:@"6."]) {
        [self jr_swizzleMethod:@selector(setTitle:)
                    withMethod:@selector(iOS6_setTitle:)
                         error:nil];
    }
}

- (void)iOS6_setTitle:(NSString *)title {
    [self iOS6_setTitle:title];
    self.titleView = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
        label.text = self.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        _RETURN label;
    });
}

@end

#pragma mark -

@implementation UIViewController (NB)

/* + (void)load {
    [self jr_swizzleMethod:@selector(viewWillAppear:)
                withMethod:@selector(nb_viewWillAppear:)
                     error:nil];
    [self jr_swizzleMethod:@selector(viewWillDisappear:)
                withMethod:@selector(nb_viewWillDisappear:)
                     error:nil];
} */

#pragma mark -

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                     target:(id)target
                                     action:(SEL)action {
    if ([[UIDevice currentDevice].systemVersion hasPrefix:@"6."]) {
        UIButton *backBarButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor bj_gray_600] forState:UIControlStateNormal];
            [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            _RETURN button;
        });
        return [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    }
    return [[UIBarButtonItem alloc] initWithTitle:title
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image
                                buttonClass:(Class)buttonClass
                                     target:(id)target
                                     action:(SEL)action {
    if (!buttonClass) {
        return [[UIBarButtonItem alloc] initWithImage:image
                                                style:UIBarButtonItemStylePlain
                                               target:target
                                               action:action];
    }
    
    NSAssert([buttonClass isSubclassOfClass:[UIButton class]],
             @"<#buttonClass#> must be a subclass of <#UIButton#>");
    if (![buttonClass isSubclassOfClass:[UIButton class]]) {
        return nil;
    }
    
    UIButton *backBarButton = ({
        UIButton *button = [[buttonClass alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
        button.tintColor = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil].tintColor;
        if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        _RETURN button;
    });
    return [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
}

- (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target action:(SEL)action {
    UIImage *image = [UIImage imageNamed:@"ic_nav_back"];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return [self barButtonItemWithImage:image
                            buttonClass:[NBLeftBarButton class]
                                 target:target
                                 action:action];
}

- (void)setupBackBarButtonItem {
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItemWithTarget:self
                                                                           action:@selector(popViewControllerAnimated)];
    }
}

- (UIBarButtonItem *)dismissBarButtonItemWithTarget:(id)target action:(SEL)action {
    UIImage *image = [UIImage imageNamed:@"ic_nav_back"];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return [self barButtonItemWithImage:image
                            buttonClass:[NBLeftBarButton class]
                                 target:target
                                 action:action];
}

- (void)setupDismissBarButtonItem {
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [self dismissBarButtonItemWithTarget:self
                                                                              action:@selector(dismissViewControllerAnimated)];
    }
}

#pragma mark - loading

- (UIView *)showLoading {
    [self hideLoading];
    return [self showLoadingInSuperview:self.view];
}

- (UIView *)showLoadingInSuperview:(UIView *)superview {
    return [NBProgressHUD showHUDWithConfigForLoading:^(NBProgressHUD *hud) {
        hud.mode = MBProgressHUDModeCustomView;
        YLImageView *imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        YLGIFImage *difImag = (YLGIFImage *)[YLGIFImage imageNamed:@"pageloading.gif"];
        imageView.image = difImag;
        hud.customView = imageView;
        hud.opacity = 0.0;
        hud.passThroughTouches = NO;
    }
                                            superview:superview OR self.view
                                             animated:YES];
}

- (void)hideLoading {
    [NBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)hideLoadingInSuperview:(UIView *)superview {
    [NBProgressHUD hideHUDForView:superview animated:NO];
}

#pragma mark - message

- (NBProgressHUD *)showHUDWithText:(NSString *)text animated:(BOOL)animated {
    return [NBProgressHUD showHUDWithText:text superview:self.view animated:animated];
}

- (NBProgressHUD *)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated {
    return [NBProgressHUD showHUDWithText:text superview:superview OR self.view animated:animated];
}

- (NBProgressHUD *)showHUDWithText:(NSString *)text details:(NSString *)details animated:(BOOL)animated {
    return [NBProgressHUD showHUDWithText:text details:details superview:self.view animated:animated];
}

- (NBProgressHUD *)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    return [NBProgressHUD showHUDWithText:text details:details superview:superview OR self.view animated:animated];
}

- (NBProgressHUD *)showHUDWithConfig:(NBProgressHUDCallback)config animated:(BOOL)animated {
    return [NBProgressHUD showHUDWithConfig:config superview:self.view animated:animated];
}

- (NBProgressHUD *)showHUDWithConfig:(NBProgressHUDCallback)config superview:(UIView *)superview animated:(BOOL)animated {
    return [NBProgressHUD showHUDWithConfig:config superview:superview OR self.view animated:animated];
}

#pragma mark - error

- (void)showErrorViewWithType:(NBErrorViewType)type callback:(NBErrorViewCallback)callback {
    [NBErrorView showErrorViewInViewController:self type:type callback:callback];
}

- (void)showErrorViewInView:(UIView *)view inset:(UIEdgeInsets)inset type:(NBErrorViewType)type callback:(NBErrorViewCallback)callback {
    [NBErrorView showErrorViewInView:view inset:inset type:type callback:callback];
}

- (void)removeErrorView {
    [NBErrorView removeErrorViewFromView:self.view];
}

#pragma mark - log

static BOOL NBLogStatEnabled = NO;

+ (BOOL)nb_logStatEnabled {
    return NBLogStatEnabled;
}

+ (void)nb_setLogStatEnabled:(BOOL)enabled {
    if (enabled == NBLogStatEnabled) {
        return;
    }
    
    NBLogStatEnabled = enabled;
    
    [self jr_swizzleMethod:@selector(viewWillAppear:)
                withMethod:@selector(nb_viewWillAppear:)
                     error:nil];
    [self jr_swizzleMethod:@selector(viewWillDisappear:)
                withMethod:@selector(nb_viewWillDisappear:)
                     error:nil];
}

- (NSString *)bj_sku {
    return nil;
}

- (void)nb_viewWillAppear:(BOOL)animated {
    [self nb_viewWillAppear:animated];
    
    Class clazz = [self class];
    if (clazz) {
        NSString *pageName = NSStringFromClass(clazz);
        [BJLogStat beginLogPageView:pageName pageType:nil sku:[self bj_sku]];
    }
}

- (void)nb_viewWillDisappear:(BOOL)animated {
    [self nb_viewWillDisappear:animated];
    
    Class clazz = [self class];
    if (clazz) {
        NSString *pageName = NSStringFromClass(clazz);
        BJLogPageAccessType navigateType = BJLogPageAccessTypeForward;
        BOOL beingDismissed = ([self isBeingDismissed]
                               || [self.navigationController isBeingDismissed]);
        BOOL beingPoped = ([self.parentViewController isKindOfClass:[UINavigationController class]] 
                           && ![[self.navigationController viewControllers] containsObject:self]);
        if (beingDismissed || beingPoped) {
            navigateType = BJLogPageAccessTypeBackward;
        }
        [BJLogStat endLogPageView:pageName accessType:navigateType];
    }
}

@end
