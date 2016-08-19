//
//  NBProgressHUD.m
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import "NBProgressHUD.h"

@implementation NBProgressHUD

@synthesize passThroughTouches = _passThroughTouches;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.passThroughTouches = YES;
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

#pragma mark -

@implementation MBProgressHUD (NBKit)

@dynamic passThroughTouches;

- (BOOL)passThroughTouches {
    return NO;
}

+ (instancetype)hudWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [[self alloc] initWithView:superview];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    // hud.minShowTime = 0.5;
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
    [hud hide:animated afterDelay:MBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self hudWithSuperview:superview];
    hud.labelText = text;
    hud.detailsLabelText = details;
    [hud show:animated];
    [hud hide:animated afterDelay:MBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)showHUDWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self hudWithSuperview:superview];
    NSTimeInterval timeInterval = config ? config(hud) : MBProgressHUDTimeInterval;
    if (timeInterval > 0.0) {
        [hud show:animated];
        [hud hide:animated afterDelay:timeInterval];
    }
    else {
        [hud show:animated];
    }
    return hud;
}

@end
