//
//  NBImageProgressView.h
//  NBFramework
//
//  Created by MingLQ on 2015-10-20.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBImageProgressView : UIView

@property (nonatomic, strong, readonly) UILabel *progressLabel;
@property (nonatomic, strong, readonly) UIView *progressView;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, getter=isCompleted) BOOL completed;
@property (nonatomic, assign) BOOL removeFromSuperViewOnCompleted;

@end
