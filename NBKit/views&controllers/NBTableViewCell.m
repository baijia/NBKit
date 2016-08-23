//
//  NBTableViewCell.m
//  NBKit
//
//  Created by MingLQ on 2015-12-17.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "NBTableViewCell.h"

@interface NBTableViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *iconView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel, *subtitleLabel;

@end

@implementation NBTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self prepareForReuse];
    }
    return self;
}

- (void)setupSubviews {
    self.iconView = [UIImageView new];
    [self.contentView addSubview:self.iconView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel];
    
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.textAlignment = NSTextAlignmentRight;
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.subtitleLabel];
    
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
                                                     forAxis:UILayoutConstraintAxisHorizontal];
    [self.subtitleLabel setContentHuggingPriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisHorizontal];
    [self.subtitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                        forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 0));
        make.width.equalTo(self.iconView.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right);
        make.right.equalTo(self.contentView).with.offset(- 10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)prepareForReuse {
    self.iconView.image = nil;
    self.iconView.hidden = YES;
    self.titleLabel.text = nil;
    self.subtitleLabel.text = nil;
    self.subtitleLabel.hidden = YES;
}

- (void)updateWithCellModel:(id<NBTableViewCellModel>)cellModel {
    if (cellModel.cellIconURL) {
        self.iconView.hidden = NO;
        [self.iconView sd_setImageWithURL:cellModel.cellIconURL];
    }
    
    self.titleLabel.text = cellModel.cellTitle;
    
    self.subtitleLabel.text = cellModel.cellSubtitle;
    self.subtitleLabel.hidden = !self.subtitleLabel.text.length;
}

@end
