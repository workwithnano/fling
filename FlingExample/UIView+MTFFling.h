//
//  UIView+MTFFling.h
//  FlingExample
//
//  Created by Nano Anderson on 8/30/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFFlingBehavior.h"

@interface UIView (MTFFling)
<MTFFlingBehaviorDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView* targetView;
@property (nonatomic, strong) MTFFlingBehavior *flingBehavior;
@property (nonatomic, strong) id<UIGestureRecognizerDelegate> gestureDelegate;

- (void) makeFlingable;
- (void) makeFlingableInView:(UIView*)targetView;

@end
