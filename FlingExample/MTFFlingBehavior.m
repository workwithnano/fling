//
//  MTFFlingView.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFFlingBehavior.h"

const CGFloat kTimerInterval = 0.025;

@interface MTFFlingBehavior ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MTFFlingBehavior

- (id)initWithTarget:(id <MTFFlingBehaviorDelegate>)target
{
    if (!(self = [super init])) return nil;
    if (!target) return nil;
    _target = target;
    _smoothnessFactor = 0.8;
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
    return _timer.isValid;
}

- (void)decelerateWithVelocity:(CGPoint)velocity withCompletionBlock:(DecelerationCompletionBlock)completionBlock
{
    NSMutableDictionary *userInfo = [@{@"velocity" : [NSValue valueWithCGPoint:velocity]} mutableCopy];
    if (completionBlock)
    {
        userInfo[@"completionBlock"] = completionBlock;
    }
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(step:) userInfo:userInfo repeats:YES];
}

- (void)cancelDeceleration
{
    [_timer invalidate];
}

- (void)step:(NSTimer *)timer
{
    CGPoint velocity = [timer.userInfo[@"velocity"] CGPointValue];
    velocity.x *= _smoothnessFactor;
    velocity.y *= _smoothnessFactor;
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
    [_target addTranslation:distance];
}

@end
