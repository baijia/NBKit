//
//  NBUtilities.h
//  NBKitDev
//
//  Created by MingLQ on 2016-01-26.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef NBUtilities_h
#define NBUtilities_h

// @see UIViewContentModeScaleAspectFit
static inline NSString *NBImageURLStringScaleAspectFit(NSString *urlString, NSInteger width, NSInteger height) {
    if ([urlString rangeOfString:@"@"].location != NSNotFound) {
        return urlString;
    }
    return [urlString stringByAppendingFormat:@"@0e_%ldw_%ldh_1c_0i_1o_90Q_%ldx.png",
            (long)width, (long)height, (long)[UIScreen mainScreen].scale];
}
static inline NSURL *NBImageURLScaleAspectFit(NSURL *url, NSInteger width, NSInteger height) {
    return [NSURL URLWithString:NBImageURLStringScaleAspectFit(url.absoluteString, width, height)];
}
// @see UIViewContentModeScaleAspectFill
static inline NSString *NBImageURLStringScaleAspectFill(NSString *urlString, NSInteger width, NSInteger height) {
    if ([urlString rangeOfString:@"@"].location != NSNotFound) {
        return urlString;
    }
    return [urlString stringByAppendingFormat:@"@1e_%ldw_%ldh_1c_0i_1o_90Q_%ldx.png",
            (long)width, (long)height, (long)[UIScreen mainScreen].scale];
}
static inline NSURL *NBImageURLScaleAspectFill(NSURL *url, NSInteger width, NSInteger height) {
    return [NSURL URLWithString:NBImageURLStringScaleAspectFill(url.absoluteString, width, height)];
}

@interface NBUtilities : NSObject

@end

#endif
