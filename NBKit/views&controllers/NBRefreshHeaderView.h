//
//  NBRefreshHeaderView.h
//  BJEducation
//
//  Created by wanghaoyu on 15/12/21.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVPullToRefreshImprove/SVPullToRefresh.h>
#import <YLGIFImage/YLImageView.h>

@interface NBRefreshHeaderView : UIView

@property (nonatomic, strong, readwrite) UILabel *statusLabel;
@property (nonatomic, strong, readwrite) UIImageView *arrowImage;
//gif动态图
@property (nonatomic, strong, readwrite) YLImageView *emojiGifImageView;
//imageView生成动画
@property (nonatomic, strong) UIImageView *refreshImageView;

@property (assign, nonatomic) SVPullToRefreshState state;

@end
