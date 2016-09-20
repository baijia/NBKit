//
//  NBLabel.m
//  Pods
//
//  Created by MingLQ on 2016-09-20.
//
//

#import "NBLabel.h"

@implementation NBLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    return UIEdgeInsetsInsetRect(textRect, self.textInsets);
}

@end
