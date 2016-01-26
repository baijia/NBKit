//
//  NBErrorView.m
//  NBFramework
//
//  Created by MingLQ on 2015-09-22.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <M9Dev/M9Dev.h>
#import <Masonry/Masonry.h>

#import "NBErrorView.h"

#import "UIColor+NBConstant.h"

@interface NBErrorView ()

@property (nonatomic, copy) NBErrorViewCallback callback;

@end

@implementation NBErrorView

- (instancetype)initWithImage:(UIImage *)image message:(NSString *)message callback:(NBErrorViewCallback)callback {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor bj_gray_100];
        
        if (callback) {
            self.callback = callback;
            [self addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(didTapWithGestureRecognizer:)]];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).with.offset(- 60);
        }];
        
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor bj_gray_500];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = message;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self);
            make.top.equalTo(imageView.mas_bottom).with.offset(20);
            make.height.mas_greaterThanOrEqualTo(13);
        }];
    }
    return self;
}

- (void)didTapWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    [self removeFromSuperview];
    
    if (self.callback) self.callback(self);
}

- (void)showInView:(UIView *)superview inset:(UIEdgeInsets)inset {
    [[self class] removeErrorViewFromView:superview];
    
    if (superview) {
        [superview addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview).with.insets(inset);
        }];
    }
}

- (void)showInViewController:(UIViewController *)viewController {
    [[self class] removeErrorViewFromView:viewController.view];
    
    if (viewController) {
        [viewController.view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(viewController.view);
            if ([viewController respondsToSelector:@selector(topLayoutGuide)]) {
                make.top.equalTo(viewController.mas_topLayoutGuide);
            }
            else {
                make.top.equalTo(viewController.view);
            }
            if ([viewController respondsToSelector:@selector(bottomLayoutGuide)]) {
                make.bottom.equalTo(viewController.mas_bottomLayoutGuide);
            }
            else {
                make.bottom.equalTo(viewController.view);
            }
        }];
    }
}

+ (instancetype)errorViewOfType:(NBErrorViewType)type callback:(NBErrorViewCallback)callback {
    if (type == NBErrorViewTypeNoData
        && [Reachability currentReachabilityStatus] == NotReachable) {
        type = NBErrorViewTypeNetworkError;
    }
    
    UIImage *image = nil;
    NSString *message = nil;
    switch (type) {
        case NBErrorViewTypeNoData:
            message = @"暂无数据，点击重试";
            break;
        case NBErrorViewTypeNetworkError:
            message = @"网络异常，点击重试";
            image = [UIImage imageNamed:@"ic_find_wifi_n.png"];
        default:
            break;
    }
    return [[NBErrorView alloc] initWithImage:image OR [UIImage imageNamed:@"ic_emotion_faint_n.png"]
                                      message:message OR @""
                                     callback:callback];
}

+ (instancetype)errorViewWithImage:(UIImage *)image message:(NSString *)message callback:(NBErrorViewCallback)callback {
    return [[NBErrorView alloc] initWithImage:image OR [UIImage imageNamed:@"ic_emotion_faint_n.png"]
                                       message:message OR @""
                                      callback:callback];
}

+ (void)showErrorViewInView:(UIView *)superview inset:(UIEdgeInsets)inset type:(NBErrorViewType)type callback:(NBErrorViewCallback)callback {
    NBErrorView *errorView = [self errorViewOfType:type callback:callback];
    [errorView showInView:superview inset:inset];
}

+ (void)showErrorViewInView:(UIView *)superview inset:(UIEdgeInsets)inset image:(UIImage *)image message:(NSString *)message callback:(NBErrorViewCallback)callback {
    NBErrorView *errorView = [NBErrorView errorViewWithImage:image message:message callback:callback];
    [errorView showInView:superview inset:inset];
}

+ (void)showErrorViewInViewController:(UIViewController *)viewController type:(NBErrorViewType)type callback:(NBErrorViewCallback)callback {
    NBErrorView *errorView = [self errorViewOfType:type callback:callback];
    [errorView showInViewController:viewController];
}

+ (void)showErrorViewInViewController:(UIViewController *)viewController image:(UIImage *)image message:(NSString *)message callback:(NBErrorViewCallback)callback {
    NBErrorView *errorView = [NBErrorView errorViewWithImage:image message:message callback:callback];
    [errorView showInViewController:viewController];
}

+ (void)removeErrorViewFromView:(UIView *)superview {
    for (UIView *view in superview.subviews) {
        if ([view isKindOfClass:[NBErrorView class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
