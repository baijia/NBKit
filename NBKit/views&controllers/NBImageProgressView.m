//
//  NBImageProgressView.m
//  NBKit
//
//  Created by MingLQ on 2015-10-20.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <M9Dev/M9Dev.h>

#import "NBImageProgressView.h"

@interface NBImageProgressView ()

@property (nonatomic, strong, readwrite) UILabel *progressLabel;
@property (nonatomic, strong, readwrite) UIView *progressView;

@end

@implementation NBImageProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
        
        self.progressView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
            _RETURN view;
        });
        [self addSubview:self.progressView];
        
        self.progressLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            _RETURN label;
        });
        [self addSubview:self.progressLabel];
        
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.hidden = YES;
    }
    return self;
}

- (void)updateConstraints {
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.progress * CGRectGetHeight(self.bounds));
        make.left.right.and.bottom.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)setProgress:(CGFloat)progress {
    self.completed = NO;
    
    progress = MIN(MAX(progress, 0.0), 1.0);
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@" %ld%%", (long)floor(progress * 100)];
    
    [self setNeedsUpdateConstraints];
}

@dynamic completed;

- (BOOL)isCompleted {
    return self.hidden;
}

- (void)setCompleted:(BOOL)completed {
    if (completed) {
        self.progress = 0.0;
    }
    
    BOOL removeFromSuperView = (self.removeFromSuperViewOnCompleted
                                && (!self.completed && completed));
    
    self.hidden = completed;
    
    if (removeFromSuperView) {
        [self removeFromSuperview];
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
}

@end
