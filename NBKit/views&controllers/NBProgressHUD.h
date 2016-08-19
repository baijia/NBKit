//
//  NBProgressHUD.h
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

static const NSTimeInterval NBProgressHUDTimeInterval = 2.0;
typedef NSTimeInterval (^NBProgressHUDBlock)(MBProgressHUD *hud);

/**
 *  duration:                   NBProgressHUDTimeInterval
 */
@interface MBProgressHUD (NBKit)

+ (instancetype)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated;
+ (instancetype)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated;
+ (instancetype)showHUDWithConfig:(NBProgressHUDBlock)config superview:(UIView *)superview animated:(BOOL)animated;

@end

#pragma mark -

/**
 *  mode:                       MBProgressHUDModeText
 *  passThroughTouches:         YES
 *  removeFromSuperViewOnHide:  YES
 */
@interface NBProgressHUD : MBProgressHUD <MBProgressHUDDelegate>

@property (nonatomic) BOOL passThroughTouches; // default: YES

@end
