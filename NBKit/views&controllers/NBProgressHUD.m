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
        [super setDelegate:self];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.passThroughTouches && !self.completion) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

- (void)showAndAutoHideAnimated:(BOOL)animated {
    [self show:animated];
    [self hide:animated afterDelay:self.duration];
}

#pragma mark - <MBProgressHUDDelegate>

- (void)setDelegate:(id<MBProgressHUDDelegate>)delegate {
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.completion) self.completion(self);
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
    [hud showAndAutoHideAnimated:animated];
    return hud;
}

+ (NBProgressHUD *)showHUDWithConfigForLoading:(NBProgressHUDCallback)config superview:(UIView *)superview animated:(BOOL)animated {
    NBProgressHUD *hud = [self hudWithSuperview:superview];
    if (config) config(hud);
    [hud show:animated];
    return hud;
}
@end
