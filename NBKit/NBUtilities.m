//
//  NBUtilities.m
//  NBKit
//
//  Created by MingLQ on 2016-01-26.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import "NBUtilities.h"

@implementation NBUtilities

@end

#pragma mark - bundle

@implementation UIImage (NBKit)

+ (UIImage *)imageNamed_NBKit:(NSString *)name {
    return [self imageNamed:[NSString stringWithFormat:NBKit_bundle_"%@", name]];
}

@end
