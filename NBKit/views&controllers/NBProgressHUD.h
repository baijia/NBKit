//
//  NBProgressHUD.h
//  NBFramework
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

/**
 *  The default value of the following properties are different from MBProgressHUD.
 *  Support pass through touches if `passThroughTouches` is YES.
 */
@interface NBProgressHUD : MBProgressHUD <MBProgressHUDDelegate>

@property (nonatomic, readwrite) BOOL passThroughTouches; // default: YES

@end

#pragma mark -

static const NSTimeInterval MBProgressHUDTimeInterval = 2.0;

/**
 *  MBProgressHUDConfig     MBProgressHUD config block
 *  @param hud              hud instance to config
 *  @return return          hud display time interval
 */
typedef NSTimeInterval (^MBProgressHUDConfig)(MBProgressHUD *hud);

/**
 *  MBProgressHUD extention
 *
 *  TODO: nb_prefix
 */
@interface MBProgressHUD (NBKit)

/**
 *  NO for MBProgressHUD, YES for NBProgressHUD
 */
@property (nonatomic, readonly) BOOL passThroughTouches;

/**
 *  Create hud with default configurations.
 *  mode:                       MBProgressHUDModeText
 *  passThroughTouches:         NO for MBProgressHUD, YES for NBProgressHUD
 *  removeFromSuperViewOnHide:  YES
 */
+ (instancetype)hudWithSuperview:(UIView *)superview;

/**
 *  Create hud with method `hudWithSuperview:`.
 *  Support multiple line text - by displaying `text` in `detailsLabel`
 *  Auto-hide after MBProgressHUDTimeInterval
 */
+ (instancetype)showHUDWithText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud with method `hudWithSuperview:`.
 *  Not support multiple line text
 *  Auto-hide after MBProgressHUDTimeInterval
 */
+ (instancetype)showHUDWithText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud with method `hudWithSuperview:`.
 *  Auto-hide if `timeInterval` greater than 0.0, not otherwise, `timeInterval` returned from config block.
 */
+ (instancetype)showHUDWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated;

@end
