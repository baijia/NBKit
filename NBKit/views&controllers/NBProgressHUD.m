//
//  NBProgressHUD.m
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import "NBProgressHUD.h"

@implementation NBProgressHUD

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mode = MBProgressHUDModeText;
        self.passThroughTouches = YES;
        self.duration = NBProgressHUDTimeInterval;
        self.removeFromSuperViewOnHide = YES;
        // self.minShowTime = 0.5;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.passThroughTouches) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

- (void)showAndAutoHideAnimated:(BOOL)animated {
    [self show:animated];
    [self hide:animated afterDelay:self.duration];
}

- (void)setCompletion:(NBProgressHUDCallback)completion {
    __weak typeof(self) __self = self;
    self.completionBlock = ^{
        __strong typeof(self) self = __self;
        if (completion) completion(self);
    };
}

#pragma mark -

+ (NBProgressHUD *)hudWithSuperview:(UIView *)superview {
    NBProgressHUD *hud = [[self alloc] initWithView:superview];
    [superview addSubview:hud];
    return hud;
}

+ (NBProgressHUD *)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated {
    NBProgressHUD *hud = [self hudWithSuperview:superview];
    // hud.labelText = text;
    hud.detailsLabelFont = hud.labelFont;
    hud.detailsLabelColor = hud.labelColor;
    hud.detailsLabelText = text;
    [hud showAndAutoHideAnimated:animated];
    return hud;
}

+ (NBProgressHUD *)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    NBProgressHUD *hud = [self hudWithSuperview:superview];
    hud.labelText = text;
    hud.detailsLabelText = details;
    [hud showAndAutoHideAnimated:animated];
    return hud;
}

+ (NBProgressHUD *)showHUDWithConfig:(NBProgressHUDCallback)config superview:(UIView *)superview animated:(BOOL)animated {
    NBProgressHUD *hud = [self hudWithSuperview:superview];
    if (config) config(hud);
    if (hud.duration > DBL_EPSILON) {
        [hud showAndAutoHideAnimated:animated];
    }
    else {
        [hud show:animated];
    }
    return hud;
}

// TODO: remove
+ (NBProgressHUD *)showHUDWithConfigForLoading:(NBProgressHUDCallback)config superview:(UIView *)superview animated:(BOOL)animated {
    return [self showHUDWithConfig:^(NBProgressHUD *hud) {
        if (config) {
            config(hud);
        }
        hud.duration = 0.0;
    } superview:superview animated:animated];
}

@end
