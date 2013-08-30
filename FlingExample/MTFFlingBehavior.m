//
//  MTFFlingView.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFFlingBehavior.h"

const CGFloat kTimerInterval = 0.005;

@interface MTFFlingBehavior ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MTFFlingBehavior

- (id)initWithTarget:(id <MTFFlingBehaviorDelegate>)target
{
    if (!(self = [super init])) return nil;
    if (!target) return nil;
    _target = target;
    self.smoothnessFactor = 0.8;
    return self;
}

- (id)init
{
    [NSException raise:@"Should use initWithTarget: or instanceWithTarget: methods" format:@"Should use initWithTarget: or instanceWithTarget: methods"];
    return nil;
}

+ (id)instanceWithTarget:(id<MTFFlingBehaviorDelegate>)target
{
    return [[self alloc] initWithTarget:target];
}

- (BOOL)decelerating
{
    return self.timer.isValid;
}

- (void)decelerateWithVelocity:(CGPoint)velocity withCompletionBlock:(DecelerationCompletionBlock)completionBlock
{
    NSMutableDictionary *userInfo = [@{@"velocity" : [NSValue valueWithCGPoint:velocity]} mutableCopy];
    if (completionBlock)
    {
        userInfo[@"completionBlock"] = completionBlock;
    }
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(step:) userInfo:userInfo repeats:YES];
}

- (void)decelerateWithVelocity:(CGPoint)velocity inView:(UIView*)boundingView withCompletionBlock:(DecelerationCompletionBlock)completionBlock
{
    NSMutableDictionary *userInfo = [@{@"velocity" : [NSValue valueWithCGPoint:velocity]} mutableCopy];
    if (completionBlock)
    {
        userInfo[@"completionBlock"] = completionBlock;
    }
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(step:) userInfo:userInfo repeats:YES];
}

- (void)cancelDeceleration
{
    [self.timer invalidate];
}

- (void)step:(NSTimer *)timer
{
    CGPoint velocity = [timer.userInfo[@"velocity"] CGPointValue];
    velocity.x *= self.smoothnessFactor;
    velocity.y *= self.smoothnessFactor;
    timer.userInfo[@"velocity"] = [NSValue valueWithCGPoint:velocity];
    
    CGPoint distance;
    distance.x = velocity.x * kTimerInterval;
    distance.y = velocity.y * kTimerInterval;
    
    if((ABS(velocity.x) <= 0.001 && ABS(velocity.y) <= 0.001))
    {
        if (timer.userInfo[@"completionBlock"])
        {
            DecelerationCompletionBlock completionBlock = timer.userInfo[@"completionBlock"];
            completionBlock();
        }
        [timer invalidate];
        return;
    }
    [self.target addTranslation:distance];
}

@end
