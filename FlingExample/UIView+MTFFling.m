//
//  UIView+MTFFling.m
//  FlingExample
//
//  Created by Nano Anderson on 8/30/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+MTFFling.h"

static void *flingBehavior; // store the reference to the flingBehavior as if it were a property
static void *superView; // store the ref to the superView target as if it were a property

@implementation UIView (MTFFling)

- (void)makeFlingable
{
    [self makeFlingableInView:self.superview];
}

- (void)makeFlingableInView:(UIView *)targetView
{
    self.targetView = targetView;
    
    self.flingBehavior = [MTFFlingBehavior instanceWithTarget:self];
    self.flingBehavior.smoothnessFactor = 0.95f;
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    [self addGestureRecognizer:panRecognizer];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if ([self.superview.subviews indexOfObject:self] > 0)
        {
            [self.superview bringSubviewToFront:self];
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.superview];
        self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.superview];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled ||
        sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateFailed)
    {
        if ([sender velocityInView:self.superview].x < -600.f)
        {
            CGPoint velo = [sender velocityInView:self.superview];
            NSLog( @"fast negative velo!" );
            // Calculate the ending frame's y value
            CGFloat endingX = -1.f * CGRectGetWidth(self.bounds);
            CGFloat xDistance = ABS(endingX) + CGRectGetMinX(self.frame);
            CGFloat startingY = CGRectGetMinY(self.frame);
            CGFloat ratio = xDistance/ABS(velo.x);
            CGFloat endingY = (ratio * velo.y) + startingY;
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = CGRectMake(endingX, MIN(MAX(0.f, endingY), (CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(self.bounds))), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.2 delay:0.8 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.frame = CGRectMake( 100.f, 100.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) );
                } completion:nil];
            }];
        }
        else
        {
            [self.flingBehavior decelerateWithVelocity:[sender velocityInView:self.superview] withCompletionBlock:nil];
        }
    }
}

- (void)addTranslation:(CGPoint)traslation
{
    CGRect slidingViewFrame = self.frame;
    slidingViewFrame.origin.x += traslation.x;
    slidingViewFrame.origin.y += traslation.y;
    if(CGRectContainsRect(self.targetView.bounds, slidingViewFrame))
    {
        self.frame = slidingViewFrame;
    }
    else
    {
        //make it stop at the boundary
        if (CGRectGetMinX(slidingViewFrame) < 0 || CGRectGetMaxX(slidingViewFrame) > self.targetView.bounds.size.width)
        {
            slidingViewFrame.origin.x = (CGRectGetMinX(slidingViewFrame) < 0) ? 0 : (CGRectGetMaxX(self.targetView.bounds) - slidingViewFrame.size.width);
        }
        
        if (CGRectGetMinY(slidingViewFrame) < 0 || CGRectGetMaxY(slidingViewFrame) > self.targetView.bounds.size.height)
        {
            slidingViewFrame.origin.y = (CGRectGetMinY(slidingViewFrame) < 0) ? 0 : (CGRectGetMaxY(self.targetView.bounds) - slidingViewFrame.size.height);
        }
        self.frame = slidingViewFrame;
        [self.flingBehavior cancelDeceleration];
    }
}


- (MTFFlingBehavior *)flingBehavior
{
    MTFFlingBehavior *result = objc_getAssociatedObject(self, &flingBehavior);
    return result;
}
- (void)setFlingBehavior:(MTFFlingBehavior *)flingBehavior
{
    objc_setAssociatedObject(self, &flingBehavior, flingBehavior, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)targetView
{
    UIView *result = objc_getAssociatedObject(self, &superView);
    return result;
}
- (void)setTargetView:(UIView *)targetView
{
    objc_setAssociatedObject(self, &superView, targetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
