//
//  NBProgressHUD.m
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import "NBProgressHUD.h"

@implementation MBProgressHUD (NBKit)

+ (instancetype)hudWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [[self alloc] initWithView:superview];
    [superview addSubview:hud];
    return hud;
}

+ (instancetype)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self hudWithSuperview:superview];
    // hud.labelText = text;
    hud.detailsLabelFont = hud.labelFont;
    hud.detailsLabelColor = hud.labelColor;
    hud.detailsLabelText = text;
    [hud show:animated];
    [hud hide:animated afterDelay:NBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self hudWithSuperview:superview];
    hud.labelText = text;
    hud.detailsLabelText = details;
    [hud show:animated];
    [hud hide:animated afterDelay:NBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)showHUDWithConfig:(NBProgressHUDBlock)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self hudWithSuperview:superview];
    NSTimeInterval duration = config ? config(hud) : NBProgressHUDTimeInterval;
    if (duration > DBL_EPSILON) {
        [hud show:animated];
        [hud hide:animated afterDelay:duration];
    }
    else {
        [hud show:animated];
    }
    return hud;
}

@end

#pragma mark -

@implementation NBProgressHUD

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mode = MBProgressHUDModeText;
        self.passThroughTouches = YES;
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

@end
