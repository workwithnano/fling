//
//  MTFViewController.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFViewController.h"
#import "MTFFlingBehavior.h"

@interface MTFViewController ()
<MTFFlingBehaviorDelegate>

@property (nonatomic) UIView* flingView;
@property (nonatomic) MTFFlingBehavior* flingBehavior;

@end

@implementation MTFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.flingView = [[UIView alloc] initWithFrame:CGRectMake(20.f,20.f, 100.f, 100.f)];
    self.flingView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.flingView];
    
    self.flingBehavior = [MTFFlingBehavior instanceWithTarget:self];
    self.flingBehavior.smoothnessFactor = 0.95f;
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    [self.flingView addGestureRecognizer:panRecognizer];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self.view];
//    NSLog( @"Origin: %@ ||||| Translation: %@", NSStringFromCGPoint(self.flingView.frame.origin), NSStringFromCGPoint(translation));
    self.flingView.center = CGPointMake(self.flingView.center.x + translation.x, self.flingView.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:self.view];
    if (sender.state == UIGestureRecognizerStateCancelled ||
        sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateFailed)
    {
        if ([sender velocityInView:self.view].x < -600.f)
        {
            CGPoint velo = [sender velocityInView:self.view];
            NSLog( @"fast negative velo!" );
            // Calculate the ending frame's y value
            CGFloat endingX = -1.f * CGRectGetWidth(self.flingView.bounds);
            CGFloat xDistance = ABS(endingX) + CGRectGetMinX(self.flingView.frame);
            CGFloat startingY = CGRectGetMinY(self.flingView.frame);
            CGFloat ratio = xDistance/ABS(velo.x);
            CGFloat endingY = (ratio * velo.y) + startingY;
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.flingView.frame = CGRectMake(endingX, MIN(MAX(0.f, endingY), (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.flingView.bounds))), CGRectGetWidth(self.flingView.frame), CGRectGetHeight(self.flingView.frame));
            } completion:^(BOOL finished) {
                
            }];
        }
//        [self.flingBehavior decelerateWithVelocity:[sender velocityInView:self.view] withCompletionBlock:nil];
    }
}

- (void)addTranslation:(CGPoint)traslation
{
    CGRect slidingViewFrame = self.flingView.frame;
    slidingViewFrame.origin.x += traslation.x;
    slidingViewFrame.origin.y += traslation.y;
    if(CGRectContainsRect(self.view.bounds, slidingViewFrame))
    {
        self.flingView.frame = slidingViewFrame;
    }
    else
    {
        //make it stop at the boundary
        if (CGRectGetMinX(slidingViewFrame) < 0 || CGRectGetMaxX(slidingViewFrame) > self.view.bounds.size.width)
        {
            slidingViewFrame.origin.x = (CGRectGetMinX(slidingViewFrame) < 0) ? 0 : (CGRectGetMaxX(self.view.bounds) - slidingViewFrame.size.width);
        }
        
        if (CGRectGetMinY(slidingViewFrame) < 0 || CGRectGetMaxY(slidingViewFrame) > self.view.bounds.size.height)
        {
            slidingViewFrame.origin.y = (CGRectGetMinY(slidingViewFrame) < 0) ? 0 : (CGRectGetMaxY(self.view.bounds) - slidingViewFrame.size.height);
        }
        self.flingView.frame = slidingViewFrame;
        [self.flingBehavior cancelDeceleration];
    }
}

@end
