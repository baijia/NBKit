//
//  NBButton.m
//  NBFramework
//
//  Created by MingLQ on 2015-10-21.
//  Copyright © 2015年 Baijiahulian. All rights reserved.
//

#import "NBButton.h"

#import <M9Dev/M9Dev.h>

@implementation NBImageButton

- (CGSize)sizeThatFits:(CGSize)size {
    size = [self.imageView sizeThatFits:size];
    size.width += (self.imageEdgeInsets.left + self.imageEdgeInsets.right
                   + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
    size.height += (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom
                    + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    return size;
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.contentEdgeInsets);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return UIEdgeInsetsInsetRect(contentRect, self.imageEdgeInsets);
}

@end

#pragma mark -

@implementation NBLeftBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alignmentRectInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    }
    return self;
}

@end

#pragma mark -

@implementation NBRightBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alignmentRectInsets = UIEdgeInsetsMake(0, 0, 0, 11);
    }
    return self;
}

@end
