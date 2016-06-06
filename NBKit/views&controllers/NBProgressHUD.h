//
//  NBProgressHUD.h
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@class NBProgressHUD;

static const NSTimeInterval NBProgressHUDTimeInterval = 2.0;
typedef void (^NBProgressHUDCallback)(NBProgressHUD *hud);

@interface NBProgressHUD : MBProgressHUD <MBProgressHUDDelegate>

@property (nonatomic) BOOL passThroughTouches; // default: NO
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, copy) NBProgressHUDCallback completion DEPRECATED_ATTRIBUTE; // @see completionBlock

/**
 *  mode:                       MBProgressHUDModeText
 *  passThroughTouches:         YES
 *  duration:                   NBProgressHUDTimeInterval
 *  removeFromSuperViewOnHide:  YES
 */
+ (NBProgressHUD *)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated;
+ (NBProgressHUD *)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated;
+ (NBProgressHUD *)showHUDWithConfig:(NBProgressHUDCallback)config superview:(UIView *)superview animated:(BOOL)animated;

@end
