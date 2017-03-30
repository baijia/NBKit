//
//  NBProgressHUD.m
//  NBKit
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import "NBProgressHUD.h"

@implementation NBProgressHUD

@synthesize nb_passThroughTouches = _nb_passThroughTouches;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // NOTE: associated object
        self.nb_passThroughTouches = NO;
    }
    return self;
}

// NOTE: swizzled method
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.nb_passThroughTouches) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

@end

#pragma mark -

@implementation MBProgressHUD (NBKit)

@dynamic nb_passThroughTouches;

- (BOOL)nb_passThroughTouches {
    return NO;
}

- (void)nb_setPassThroughTouches:(BOOL)passThroughTouches {
}

+ (instancetype)nb_hudWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [[self alloc] initWithView:superview];
    hud.removeFromSuperViewOnHide = YES;
    // hud.minShowTime = 0.5;
    [superview addSubview:hud];
    return hud;
}

+ (instancetype)nb_hudForTextWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [self nb_hudWithSuperview:superview];
    hud.mode = MBProgressHUDModeText;
    return hud;
}

+ (instancetype)nb_hudForLoadingWithSuperview:(UIView *)superview {
    MBProgressHUD *hud = [self nb_hudWithSuperview:superview];
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}

@end

#pragma mark -

@implementation MBProgressHUD (NBKitShowing)

+ (instancetype)nb_showHUDForText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForTextWithSuperview:superview];
    [hud nb_setPassThroughTouches:YES];
    // hud.labelText = text;
    hud.detailsLabel.font = hud.label.font;
    hud.detailsLabel.textColor = hud.label.textColor;
    hud.detailsLabel.text = text;
    [hud showAnimated:animated];
    [hud hideAnimated:animated afterDelay:MBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)nb_showHUDForText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForTextWithSuperview:superview];
    [hud nb_setPassThroughTouches:YES];
    hud.label.text = text;
    hud.detailsLabel.text = details;
    [hud showAnimated:animated];
    [hud hideAnimated:animated afterDelay:MBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)nb_showHUDForTextWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForTextWithSuperview:superview];
    [hud nb_setPassThroughTouches:YES];
    NSTimeInterval timeInterval = config ? config(hud) : MBProgressHUDTimeInterval;
    if (timeInterval > 0.0) {
        [hud showAnimated:animated];
        [hud hideAnimated:animated afterDelay:timeInterval];
    }
    else {
        [hud showAnimated:animated];
    }
    return hud;
}

+ (instancetype)nb_showHUDForLoadingWithSuperview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForLoadingWithSuperview:superview];
    [hud showAnimated:animated];
    return hud;
}

+ (instancetype)nb_showHUDForLoadingWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForLoadingWithSuperview:superview];
    if (config) config(hud);
    [hud showAnimated:animated];
    return hud;
}

@end
