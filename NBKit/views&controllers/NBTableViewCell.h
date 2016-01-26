//
//  NBTableViewCell.h
//  BJEducation
//
//  Created by MingLQ on 2015-12-17.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBTableViewCellModel <NSObject>

@property (nonatomic, readonly) NSString *cellTitle, *cellSubtitle;
@property (nonatomic, readonly) NSURL *cellIconURL;

@end

#pragma mark -

@interface NBTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *titleLabel, *subtitleLabel;

- (void)updateWithCellModel:(id<NBTableViewCellModel>)cellModel;

@end
