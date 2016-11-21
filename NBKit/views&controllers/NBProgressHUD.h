//
//  NBProgressHUD.h
//  NBKit
//
//  Created by MingLQ on 2015-11-11.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

static const NSTimeInterval MBProgressHUDTimeInterval = 2.0;

/**
 *  MBProgressHUDConfig     MBProgressHUD config block
 *  @param hud              hud instance to config
 *  @return return          hud display time interval
 */
typedef NSTimeInterval (^MBProgressHUDConfig)(__kindof MBProgressHUD *hud);

/**
 *  MBProgressHUD extention
 */
@interface MBProgressHUD (NBKit)

/**
 *  Always NO, @see NBProgressHUD
 */
@property (nonatomic, readonly) BOOL nb_passThroughTouches;

/**
 *  Create hud:
 *  removeFromSuperViewOnHide   YES
 */
+ (instancetype)nb_hudWithSuperview:(UIView *)superview;

/**
 *  Create hud for text:
 *  mode                        MBProgressHUDModeText
 *  removeFromSuperViewOnHide   YES
 */
+ (instancetype)nb_hudForTextWithSuperview:(UIView *)superview;

/**
 *  Create hud for loading:
 *  mode                        MBProgressHUDModeIndeterminate - UIActivityIndicatorView
 *  removeFromSuperViewOnHide   YES
 */
+ (instancetype)nb_hudForLoadingWithSuperview:(UIView *)superview;

@end

#pragma mark -

@interface MBProgressHUD (NBKitShowing)

/**
 *  Create hud for text with method `hudForTextWithSuperview:`.
 *  Support multiple line text - by displaying `text` in `detailsLabel`.
 *  Auto-hide after MBProgressHUDTimeInterval.
 *  The value of `nb_passThroughTouches` is YES(NBProgressHUD).
 */
+ (instancetype)nb_showHUDForText:(NSString *)text superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for text with method `hudForTextWithSuperview:`.
 *  Not support multiple line text.
 *  Auto-hide after MBProgressHUDTimeInterval.
 *  The value of `nb_passThroughTouches` is YES(NBProgressHUD).
 */
+ (instancetype)nb_showHUDForText:(NSString *)text details:(NSString *)details superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for text with method `hudForTextWithSuperview:`.
 *  Auto-hide if `timeInterval` greater than 0.0, not otherwise, `timeInterval` returned from config block.
 *  The value of `nb_passThroughTouches` is YES(NBProgressHUD) by default.
 */
+ (instancetype)nb_showHUDForTextWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for loading with method `hudForLoadingWithSuperview:`.
 *  The value of `nb_passThroughTouches` is NO.
 */
+ (instancetype)nb_showHUDForLoadingWithSuperview:(UIView *)superview animated:(BOOL)animated;

/**
 *  Create hud for loading with method `hudForLoadingWithSuperview:`.
 *  NOT to auto-hide, ignore `timeInterval` returned from config block.
 *  The value of `nb_passThroughTouches` is NO by default.
 */
+ (instancetype)nb_showHUDForLoadingWithConfig:(MBProgressHUDConfig)config superview:(UIView *)superview animated:(BOOL)animated;

@end

#pragma mark -

/**
 *  Support pass through touches if `nb_passThroughTouches` is YES.
 */
@interface NBProgressHUD : MBProgressHUD <MBProgressHUDDelegate>

@property (nonatomic, readwrite, setter=nb_setPassThroughTouches:) BOOL nb_passThroughTouches; // default: NO

@end
