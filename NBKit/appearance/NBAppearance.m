//
//  NBAppearance.m
//  BJEducation
//
//  Created by MingLQ on 2015-12-10.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import "NBAppearance.h"

@implementation UINavigationBar (NBAppearance)

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunchingWithNotification:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)applicationDidFinishLaunchingWithNotification:(NSNotification *)notification {
    [self setupNavigationBarAppearanceWithTintColor:[UIColor bj_gray_600] // barButtonItem color
                                titleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:17],
                                                       NSForegroundColorAttributeName: [UIColor bj_gray_600] } // title color
                        barButtonItemTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:15] }];
}

+ (void)setupNavigationBarAppearanceWithTintColor:(UIColor *)tintColor
                              titleTextAttributes:(NSDictionary *)titleTextAttributes
                      barButtonItemTextAttributes:(NSDictionary *)barButtonItemTextAttributes {
    UINavigationBar<UIAppearance> *navigationBar = [UINavigationBar appearance];
    if ([[UIDevice currentDevice].systemVersion hasPrefix:@"6."]) {
        [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                            forBarMetrics:UIBarMetricsDefault];
        [navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
        
        NSMutableDictionary *mutableTitleTextAttributes = [titleTextAttributes OR @{} mutableCopy];
        if (!titleTextAttributes[NSForegroundColorAttributeName]) {
            [mutableTitleTextAttributes setObject:tintColor OR [UIColor blackColor]
                                           forKey:NSForegroundColorAttributeName];
        }
        [mutableTitleTextAttributes setObject:[UIColor clearColor]
                                       forKey:UITextAttributeTextShadowColor];
        [mutableTitleTextAttributes setObject:[NSValue valueWithUIOffset:UIOffsetZero]
                                       forKey:UITextAttributeTextShadowOffset];
        titleTextAttributes = mutableTitleTextAttributes;
    }
    
    navigationBar.tintColor = tintColor;
    navigationBar.titleTextAttributes = titleTextAttributes;
    if ([navigationBar respondsToSelector:@selector(setBackIndicatorImage:)]) {
        navigationBar.backIndicatorImage = [UIImage imageNamed:@"ic_nav_back"];
    }
    if ([navigationBar respondsToSelector:@selector(setBackIndicatorTransitionMaskImage:)]) {
        navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"ic_nav_back"];
    }
    
    UIBarButtonItem<UIAppearance> *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    if ([[UIDevice currentDevice].systemVersion hasPrefix:@"6."]) {
        [barButtonItem setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                                 forState:UIControlStateNormal
                               barMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *mutableTitleTextAttributes = [barButtonItemTextAttributes OR @{} mutableCopy];
        if (!barButtonItemTextAttributes[NSForegroundColorAttributeName]) {
            [mutableTitleTextAttributes setObject:[UIColor blackColor]
                                           forKey:NSForegroundColorAttributeName];
        }
        [mutableTitleTextAttributes setObject:[UIColor clearColor]
                                       forKey:UITextAttributeTextShadowColor];
        [mutableTitleTextAttributes setObject:[NSValue valueWithUIOffset:UIOffsetZero]
                                       forKey:UITextAttributeTextShadowOffset];
        barButtonItemTextAttributes = mutableTitleTextAttributes;
    }
    
    // barButtonItem.tintColor = tintColor;
    [barButtonItem setTitleTextAttributes:barButtonItemTextAttributes forState:UIControlStateNormal];
}

@end
