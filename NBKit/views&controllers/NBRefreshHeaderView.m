//
//  NBRefreshHeaderView.m
//  BJEducation
//
//  Created by wanghaoyu on 15/12/21.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import "NBRefreshHeaderView.h"
#import <YLGIFImage/YLGIFImage.h>

@interface NBGifView : YLImageView

@end

@implementation NBGifView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
}


#define BJRefreshLabelTextColor [UIColor colorWithWhite:150.0/255 alpha:1]

NSString *const NB_RefreshHeaderPullToRefresh = @"下拉刷新...";
NSString *const NB_RefreshHeaderReleaseToRefresh = @"松开刷新...";
NSString *const NB_RefreshHeaderRefreshing = @"正在刷新...";
@end


@interface NBRefreshHeaderView ()

@property (nonatomic, strong) NSMutableArray *imageArrays;

@end

@implementation NBRefreshHeaderView

#pragma mark - getter

//状态标签
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = BJRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

// 箭头图片
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImage *image = [UIImage imageNamed:@"laodinga0001.png"];
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:image];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
    }
    
    return _arrowImage;
}

//任意GIF图片
- (UIImageView*)emojiGifImageView {
    
    if (!_emojiGifImageView) {
        _emojiGifImageView = [[NBGifView alloc] initWithFrame:CGRectMake( (self.frame.size.width - 43)/2 - 40 , (self.frame.size.height - 33)/2, 43, 33)];
        _emojiGifImageView.image = [YLGIFImage imageNamed:@"ic_mascot_refresh.gif"];
        _emojiGifImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _emojiGifImageView;
}

//refreshImageView
- (UIImageView *)refreshImageView {
    if (!_refreshImageView) {
        _refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 32)/2 - 40, (self.frame.size.height - 33)/2, 32, 32)];
        _refreshImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _refreshImageView.animationImages = self.imageArrays;
    }
    return _refreshImageView;
}

- (NSMutableArray *)imageArrays {
    if (!_imageArrays) {
        _imageArrays = [NSMutableArray array];
        for (NSInteger i = 1; i <= 39 ; i = i+2) {
            NSString *fileName = nil;
            if (i< 10) {
                fileName = [NSString stringWithFormat:@"laodinga000%ld.png",(long)i];
            }
            else {
                fileName = [NSString stringWithFormat:@"laodinga00%ld.png",(long)i];
            }
            UIImage *image = [UIImage imageNamed:fileName];
            [_imageArrays addObjectOrNil:image];
        }
    }
    return _imageArrays;
}
#pragma mark - setter

//设置headerView当前的状态

- (void)setState:(SVPullToRefreshState)state {
    
    // 2.根据状态执行不同的操作
    switch (state) {
        case SVPullToRefreshStateStopped: // 普通状态
        {
            // 显示箭头
            self.arrowImage.hidden = NO;
            // 隐藏动态gif
            [_emojiGifImageView removeFromSuperview];
            // 隐藏动画
            [self stopAnimation];
            break;
        }
        case SVPullToRefreshStateTriggered:
            // 显示箭头
            self.arrowImage.hidden = NO;
            // 隐藏动态gif
            [_emojiGifImageView removeFromSuperview];
            //隐藏动画
            [self stopAnimation];
            break;
            
        case SVPullToRefreshStateLoading:
        {
//            [self addSubview:self.emojiGifImageView];
            if (self.state != SVPullToRefreshStateLoading) {
                [self startAnimation];
            }
            // 隐藏箭头
            _arrowImage.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    // 3.存储状态
    _state = state;
    
    // 4.设置文字
    [self settingLabelText];
}

#pragma mark - system method

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1.箭头
    CGFloat arrowX = self.frame.size.width * 0.5 - 32/2;
    _arrowImage.center = CGPointMake(arrowX, self.frame.size.height * 0.5);
    
    // 2.指示器
    _emojiGifImageView.center = CGPointMake(arrowX, self.frame.size.height * 0.5);
    // 3.自定义ImageView
    _refreshImageView.center = CGPointMake(arrowX, self.frame.size.height * 0.5);
    CGFloat statusY = 20;
    CGFloat statusHeight = self.frame.size.height * 0.3;
    CGFloat statusWidth = self.frame.size.width;
    // 1.状态标签
    self.statusLabel.frame = CGRectMake(self.frame.size.width * 0.5 + 10, statusY, statusWidth, statusHeight);
}

#pragma mark - change titleLabel text

- (void)settingLabelText
{
    switch (self.state) {
        case SVPullToRefreshStateStopped:
            // 设置文字
            self.statusLabel.text = NB_RefreshHeaderPullToRefresh;
            break;
        case SVPullToRefreshStateTriggered:
            // 设置文字
            self.statusLabel.text = NB_RefreshHeaderReleaseToRefresh;
            break;
        case SVPullToRefreshStateLoading:
            // 设置文字
            self.statusLabel.text = NB_RefreshHeaderRefreshing;
            break;
        default:
            break;
    }
}

#pragma  mark - image start OR stop

- (void)startAnimation {
    [self addSubview:self.refreshImageView];
    self.refreshImageView.animationRepeatCount = 0;
//    self.refreshImageView.animationDuration = self.imageArrays.count *0.08;
    [self.refreshImageView startAnimating];
}

- (void)stopAnimation {
    [self.refreshImageView stopAnimating];
    [self.refreshImageView removeFromSuperview];
}

@end
