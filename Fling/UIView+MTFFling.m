//
//  UIView+MTFFling.m
//  FlingExample
//
//  Created by Nano Anderson on 8/30/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+MTFFling.h"

static char const * const flingBehaviorKey = "flingBehavior";
static char const * const superViewKey = "superView";
static char const * const originalFrameKey = "originalFrame";
static char const * const gestureDelegateKey = "gestureDelegate";
static char const * const panGestureKey = "panGesture";

@implementation UIView (MTFFling)

- (void)makeFlingable
{
    [self makeFlingableInView:(UIView*)[self gestureSuperview]];
}

- (void)makeFlingableInView:(UIView*)targetView
{
    self.targetView = targetView;
    
    self.flingBehavior = [MTFFlingBehavior instanceWithTarget:self];
    self.flingBehavior.smoothnessFactor = 0.95f;
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    objc_setAssociatedObject(self, panGestureKey, panRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.gestureDelegate = self;
    [self addGestureRecognizer:panRecognizer];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
        if (![self.gestureDelegate conformsToProtocol:@protocol(UIGestureRecognizerDelegate)])
        {
            [NSException raise:@"Flinging view's gestureDelegate does not conform to <UIGestureRecognizerDelegate> protocol." format:nil];
        }
        
        [self liftView];
        if ([self.targetView.subviews indexOfObject:self] > 0)
        {
            objc_setAssociatedObject(self, originalFrameKey, [NSValue valueWithCGRect:self.frame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.backgroundColor = [UIColor yellowColor];
            [self.superview bringSubviewToFront:self];
            
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.targetView];
        self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.targetView];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled ||
        sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateFailed)
    {
        if ([sender velocityInView:self.targetView].x < -600.f)
        {
            CGPoint velo = [sender velocityInView:self.targetView];
            // Calculate the ending frame's y value
            CGFloat endingX = -1.f * CGRectGetWidth(self.bounds);
            CGFloat xDistance = ABS(endingX) + CGRectGetMinX(self.frame);
            CGFloat startingY = CGRectGetMinY(self.frame);
            CGFloat ratio = xDistance/ABS(velo.x);
            CGFloat endingY = (ratio * velo.y) + startingY;
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect newFrame = [self.targetView convertRect:CGRectMake(endingX, MIN(MAX(0.f, endingY), (CGRectGetHeight(self.targetView.bounds) - CGRectGetHeight(self.bounds))), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) toView:self.superview];
                self.frame = newFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.2 delay:0.8 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    NSValue *result = objc_getAssociatedObject(self, originalFrameKey);
                    self.frame = [result CGRectValue];
                    self.backgroundColor = [UIColor blueColor];
                    [self dropView];
                } completion:nil];
            }];
        }
        else
        {
            [self.flingBehavior decelerateWithVelocity:[sender velocityInView:self.targetView] withCompletionBlock:^{
                [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    NSValue *result = objc_getAssociatedObject(self, originalFrameKey);
                    self.frame = [result CGRectValue];
                    self.backgroundColor = [UIColor blueColor];
                    [self dropView];
                } completion:nil];
            }];
        }
    }
}

- (void)addTranslation:(CGPoint)traslation
{
    CGRect slidingViewFrame = self.frame;
    slidingViewFrame.origin.x += traslation.x;
    slidingViewFrame.origin.y += traslation.y;
    
    self.frame = slidingViewFrame;
}


- (MTFFlingBehavior *)flingBehavior
{
    MTFFlingBehavior *result = objc_getAssociatedObject(self, flingBehaviorKey);
    return result;
}
- (void)setFlingBehavior:(MTFFlingBehavior *)flingBehavior
{
    objc_setAssociatedObject(self, flingBehaviorKey, flingBehavior, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)targetView
{
    UIView *result = objc_getAssociatedObject(self, superViewKey);
    return result;
}
- (void)setTargetView:(UIView *)targetView
{
    objc_setAssociatedObject(self, superViewKey, targetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIGestureRecognizerDelegate>)gestureDelegate
{
    id<UIGestureRecognizerDelegate> result = objc_getAssociatedObject(self, gestureDelegateKey);
    return result;
}
- (void)setGestureDelegate:(id<UIGestureRecognizerDelegate>)gestureDelegate
{
    UIPanGestureRecognizer *panRecognizer = objc_getAssociatedObject(self, panGestureKey);
    panRecognizer.delegate = gestureDelegate;
    objc_setAssociatedObject(self, gestureDelegateKey, gestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIGestureRecognizerDelegate>)gestureSuperview
{
    if ([self.superview conformsToProtocol:@protocol(UIGestureRecognizerDelegate)])
        return (id<UIGestureRecognizerDelegate>)self.superview;
    else
    {
        return nil;
    }
}

// Only allow horizontal swiping…
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:objc_getAssociatedObject(self, panGestureKey)])
    {
        UIPanGestureRecognizer* panRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint velo = [panRecognizer velocityInView:self.targetView];
        return (ABS(velo.x)/ABS(velo.y) > 3.f);
    }
    else
    {
        return YES;
    }
}

- (void)liftView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowOffset = CGSizeMake(3.f, 3.f);
        self.layer.shadowRadius = 5.0f;
        self.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.shadowPath = path.CGPath;
        self.layer.transform = CATransform3DMakeTranslation(-4.f, -4.f, 0.f);
    }];
}
- (void)dropView
{
    self.layer.shadowOpacity = 0.f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 0.f;
    self.layer.masksToBounds = YES;
    self.layer.transform = CATransform3DIdentity;
}

@end
