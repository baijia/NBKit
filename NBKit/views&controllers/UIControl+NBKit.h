//
//  UIControl+NBKit.h
//  NBKit
//
//  Created by MingLQ on 2016-08-23.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UIControl (NBKit)

- (RACSignal *)nb_signalOfStateChanges;         // NSNumber<UIControlState> *state

- (RACSignal *)nb_signalOfSelectedChanges;      // NSNumber<BOOL> *selected
- (RACSignal *)nb_signalOfHighlightedChanges;   // NSNumber<BOOL> *highlighted
- (RACSignal *)nb_signalOfEnabledChanges;       // NSNumber<BOOL> *enabled

@end
