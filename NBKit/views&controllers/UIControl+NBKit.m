//
//  UIControl+NBKit.m
//  NBKit
//
//  Created by MingLQ on 2016-08-23.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import "UIControl+NBKit.h"

@implementation UIControl (NBKit)

- (RACSignal *)nb_signalOfStateChanges {
    return [[RACSignal
             combineLatest:@[ [self nb_signalOfSelectedChanges],
                              [self nb_signalOfHighlightedChanges],
                              [self nb_signalOfEnabledChanges] ]
             reduce:^id(NSNumber *selected, NSNumber *highlighted, NSNumber *enabled) {
                 return @(self.state);
             }]
            distinctUntilChanged];
}

- (RACSignal *)nb_signalOfSelectedChanges {
    RACSignal *signal = [[[self rac_signalForSelector:@selector(setSelected:)]
                          map:^id(RACTuple *tuple) {
                              RACTupleUnpack(NSNumber *selected) = tuple;
                              return selected;
                          }]
                         replayLast];
    self.selected = self.selected;
    return signal;
}

- (RACSignal *)nb_signalOfHighlightedChanges {
    RACSignal *signal = [[[self rac_signalForSelector:@selector(setHighlighted:)]
                          map:^id(RACTuple *tuple) {
                              RACTupleUnpack(NSNumber *highlighted) = tuple;
                              return highlighted;
                          }]
                         replayLast];
    self.highlighted = self.highlighted;
    return signal;
}

- (RACSignal *)nb_signalOfEnabledChanges {
    RACSignal *signal = [[[self rac_signalForSelector:@selector(setEnabled:)]
                          map:^id(RACTuple *tuple) {
                              RACTupleUnpack(NSNumber *enabled) = tuple;
                              return enabled;
                          }]
                         replayLast];
    self.enabled = self.enabled;
    return signal;
}

@end
