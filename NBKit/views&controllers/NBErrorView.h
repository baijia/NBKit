//
//  NBErrorView.h
//  NBFramework
//
//  Created by MingLQ on 2015-09-22.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBErrorView;

typedef NS_ENUM(NSInteger, NBErrorViewType) {
    NBErrorViewTypeNoData, // auto switch to NBErrorViewTypeNetworkError if network NotReachable
    NBErrorViewTypeNetworkError,
    NBErrorViewTypeDefault = NBErrorViewTypeNoData
};

typedef void (^NBErrorViewCallback)(NBErrorView *errorView);

@interface NBErrorView : UIView

+ (void)showErrorViewInView:(UIView *)superview inset:(UIEdgeInsets)inset type:(NBErrorViewType)type callback:(NBErrorViewCallback)callback;
+ (void)showErrorViewInView:(UIView *)superview inset:(UIEdgeInsets)inset image:(UIImage *)image message:(NSString *)message callback:(NBErrorViewCallback)callback;

+ (void)showErrorViewInViewController:(UIViewController *)viewController type:(NBErrorViewType)type callback:(NBErrorViewCallback)callback;
+ (void)showErrorViewInViewController:(UIViewController *)viewController image:(UIImage *)image message:(NSString *)message callback:(NBErrorViewCallback)callback;

+ (void)removeErrorViewFromView:(UIView *)superview;

@end
