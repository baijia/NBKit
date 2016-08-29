//
//  NBRootViewController.h
//  NBKit
//
//  Created by MingLQ on 2016-08-22.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBRootViewController : UIViewController

+ (instancetype)sharedInstance;

- (void)switchViewController:(UIViewController *)viewController
                  completion:(void (^)(BOOL finished))completion;

@end
