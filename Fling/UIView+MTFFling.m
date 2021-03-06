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
#import "MTFFlingBucket.h"

//-----------------------------------------------------------------------
#pragma mark - Static variables and constants -
//-----------------------------------------------------------------------

static CGFloat const BUCKET_TRIGGER_DISTANCE = 20.f;

static char const * const flingBehaviorKey = "flingBehavior";
static char const * const superViewKey = "superView";
static char const * const originalFrameKey = "originalFrame";
static char const * const gestureDelegateKey = "gestureDelegate";
static char const * const panGestureKey = "panGesture";

#pragma mark -
@implementation UIView (MTFFling)

//-----------------------------------------------------------------------
#pragma mark - Public properties -
//-----------------------------------------------------------------------

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

//-----------------------------------------------------------------------
#pragma mark - Private properties -
//-----------------------------------------------------------------------

- (id<UIGestureRecognizerDelegate>)gestureSuperview
{
    if ([self.superview conformsToProtocol:@protocol(UIGestureRecognizerDelegate)])
        return (id<UIGestureRecognizerDelegate>)self.superview;
    else
    {
        return nil;
    }
}

//-----------------------------------------------------------------------
#pragma mark - Public methods -
//-----------------------------------------------------------------------

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

//-----------------------------------------------------------------------
#pragma mark - UIGestureRecognizer methods -
//-----------------------------------------------------------------------

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
            [self.superview bringSubviewToFront:self];
            
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.targetView];
        self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self.targetView];
        [self updateFlingBucket];
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
                self.alpha = 0.f;
                [self returnToOriginalFrame];
                [UIView animateWithDuration:1.2 delay:0.8 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.alpha = 1;
                    [self bringFlingBucketToRest];
                } completion:nil];
            }];
        }
        else
        {
            [self.flingBehavior decelerateWithVelocity:[sender velocityInView:self.targetView] withCompletionBlock:^{
                [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.55f initialSpringVelocity:.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self returnToOriginalFrame];
                    [self bringFlingBucketToRest];
                } completion:nil];
            }];
        }
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

//-----------------------------------------------------------------------
#pragma mark - MTFFlingBucket calls -
//-----------------------------------------------------------------------

- (void)updateFlingBucket
{
    CGPoint originPoint = [self originInTarget];
    CGPoint centerPoint = [self centerInTarget];
    if (originPoint.x > BUCKET_WIDTH)
    {
        return;
    }
    [self updateFlingBucketFrameWithOriginPoint:originPoint centerPoint:centerPoint];
    [self updateFlingBucketMask];
}

- (void)updateFlingBucketFrameWithOriginPoint:(CGPoint)originPoint centerPoint:(CGPoint)centerPoint
{
    
    CGFloat bucketCenterX = MIN(([MTFFlingBucket sharedBucket].bounds.size.width/2.f), BUCKET_TRIGGER_DISTANCE - BUCKET_WIDTH - originPoint.x + ([MTFFlingBucket sharedBucket].bounds.size.width/2.f));
    CGFloat bucketCenterY = centerPoint.y;
    CGPoint newCenter = CGPointMake(bucketCenterX, bucketCenterY);
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionOverrideInheritedDuration|UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [MTFFlingBucket sharedBucket].center = newCenter;
        
    } completion:nil];
    
    if (![MTFFlingBucket sharedBucket].superview)
    {
        [self.targetView addSubview:[MTFFlingBucket sharedBucket]];
    }
}

- (void)updateFlingBucketMask
{
    CGRect topViewFrameInFlingBounds = [self convertRect:[MTFFlingBucket sharedBucket].topViewFrame fromView:[MTFFlingBucket sharedBucket]];
    
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = CGRectSetLeft(rectSubtract(self.bounds, topViewFrameInFlingBounds, CGRectMaxXEdge), CGRectGetWidth(topViewFrameInFlingBounds));
    NSLog( @"------- maskRect : %@", NSStringFromCGRect(maskRect) );
    
    // Create a path with the rectangle in it.
    CGAffineTransform transform = self.transform;
    CGPathRef path = CGPathCreateWithRect(maskRect, &transform);
    
    // Set the path to the mask layer.
    maskLayer.path = path;
    
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    
    // Set the mask of the view.
    self.layer.mask = maskLayer;
}

- (void)bringFlingBucketToRest
{
    [MTFFlingBucket sharedBucket].frame = CGRectMakeWith( CGPointMake(-(CGRectGetWidth([MTFFlingBucket sharedBucket].frame)),-(CGRectGetHeight([MTFFlingBucket sharedBucket].frame))), [MTFFlingBucket sharedBucket].frame.size );
}

//-----------------------------------------------------------------------
#pragma mark - UIView return to original form -
//-----------------------------------------------------------------------

- (void) returnToOriginalFrame
{
    NSValue *result = objc_getAssociatedObject(self, originalFrameKey);
    self.frame = [result CGRectValue];
    self.transform = CGAffineTransformIdentity;
    [self dropView];
}

//-----------------------------------------------------------------------
#pragma mark - UIView translations -
//-----------------------------------------------------------------------

- (void)addTranslation:(CGPoint)traslation
{
    CGRect slidingViewFrame = self.frame;
    slidingViewFrame.origin.x += traslation.x;
    slidingViewFrame.origin.y += traslation.y;
    
    self.frame = slidingViewFrame;
}

- (CGPoint)centerInTarget
{
    return [self.targetView convertPoint:self.center fromView:self.superview];
}
- (CGPoint)originInTarget
{
    return [self.targetView convertPoint:self.frame.origin fromView:self.superview];
}

- (CGPoint)centerInWindow
{
    return [self.window convertPoint:self.center toWindow:self.window];
}
- (CGPoint)originInWindow
{
    return [self.window convertPoint:self.frame.origin toWindow:self.window];
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
        
        self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
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


//-----------------------------------------------------------------------
#pragma mark - CGRect helpers -
//-----------------------------------------------------------------------

CGRect rectSubtract(CGRect r1, CGRect r2, CGRectEdge edge) {
    // Find how much r1 overlaps r2
    CGRect intersection = CGRectIntersection(r1, r2);
    
    // If they don't intersect, just return r1. No subtraction to be done
    if (CGRectIsNull(intersection)) {
        return r1;
    }
    
    // Figure out how much we chop off r1
    float chopAmount = (edge == CGRectMinXEdge || edge == CGRectMaxXEdge)
    ? intersection.size.width
    : intersection.size.height;
    
    CGRect r3, throwaway;
    // Chop
    CGRectDivide(r1, &throwaway, &r3, chopAmount, edge);
    return r3;
}

@end
