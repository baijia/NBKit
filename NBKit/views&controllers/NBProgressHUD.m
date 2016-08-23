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
        self.nb_passThroughTouches = YES;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.nb_passThroughTouches) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

+ (instancetype)nb_hudForTextWithSuperview:(UIView *)superview {
    NBProgressHUD *hud = [super nb_hudForTextWithSuperview:superview];
    hud.nb_passThroughTouches = YES;
    return hud;
}

@end

#pragma mark -

@implementation MBProgressHUD (NBKit)

@dynamic nb_passThroughTouches;

- (BOOL)nb_passThroughTouches {
    return NO;
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
    // hud.labelText = text;
    hud.detailsLabelFont = hud.labelFont;
    hud.detailsLabelColor = hud.labelColor;
    hud.detailsLabelText = text;
    [hud show:animated];
    [hud hide:animated afterDelay:MBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)nb_showHUDForText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForTextWithSuperview:superview];
    hud.labelText = text;
    hud.detailsLabelText = details;
    [hud show:animated];
    [hud hide:animated afterDelay:MBProgressHUDTimeInterval];
    return hud;
}

+ (instancetype)nb_showHUDForTextWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForTextWithSuperview:superview];
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

+ (instancetype)nb_showHUDForLoadingWithSuperview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForLoadingWithSuperview:superview];
    [hud show:animated];
    return hud;
}

+ (instancetype)nb_showHUDForLoadingWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated {
    MBProgressHUD *hud = [self nb_hudForLoadingWithSuperview:superview];
    if (config) config(hud);
    [hud show:animated];
    return hud;
}

@end

#pragma mark -

@implementation MBProgressHUD (DEPRECATED)

@dynamic passThroughTouches;
- (BOOL)passThroughTouches {
    return self.nb_passThroughTouches;
}

+ (instancetype)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated DEPRECATED_ATTRIBUTE {
    return [self nb_showHUDForText:text superview:superview animated:animated];
}

+ (instancetype)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated DEPRECATED_ATTRIBUTE {
    return [self nb_showHUDForText:text details:details superview:superview animated:animated];
}

+ (instancetype)showHUDWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated DEPRECATED_ATTRIBUTE {
    return [self nb_showHUDForTextWithConfig:config superview:superview animated:animated];
}

@end

@implementation NBProgressHUD (DEPRECATED)

@dynamic passThroughTouches;
- (void)setPassThroughTouches:(BOOL)passThroughTouches {
    [self setNb_passThroughTouches:passThroughTouches];
}

@end
