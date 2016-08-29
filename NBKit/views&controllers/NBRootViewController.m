//
//  NBRootViewController.m
//  NBKit
//
//  Created by MingLQ on 2016-08-22.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <M9Dev/M9Dev.h>

#import "NBRootViewController.h"

@interface NBRootViewController ()

@property (nonatomic, readwrite) UIViewController *activeViewController;

@end

@implementation NBRootViewController

@singleton_synthesize(sharedInstance);

- (void)switchViewController:(UIViewController *)viewController
                  completion:(void (^)(BOOL finished))completion {
    [self.activeViewController removeFromParentViewControllerAndSuperiew];
    [self addChildViewController:viewController superview:self.view];
    self.activeViewController = viewController;
    [self setNeedsStatusBarAppearanceUpdate];
    
    /* if (!self.activeViewController) {
        [self addChildViewController:viewController superview:self.view];
        self.activeViewController = viewController;
        [self setNeedsStatusBarAppearanceUpdate];
        return;
    }
    
    [UIView transitionFromView:self.activeViewController.view
                        toView:viewController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        [self.activeViewController removeFromParentViewControllerAndSuperiew];
                        [self addChildViewController:viewController superview:self.view];
                        self.activeViewController = viewController;
                        [self setNeedsStatusBarAppearanceUpdate];
                    }]; */
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.activeViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.activeViewController;
}

@end
