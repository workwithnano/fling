//
//  MTFFlingView.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFFlingBehavior.h"

//-----------------------------------------------------------------------
#pragma mark - Static variables and constants -
//-----------------------------------------------------------------------

const CGFloat kTimerInterval = 0.005;

@interface MTFFlingBehavior ()

//-----------------------------------------------------------------------
#pragma mark - Private properties -
//-----------------------------------------------------------------------

@property (nonatomic) NSTimer *timer;
@property (nonatomic) id<MTFFlingBehaviorDelegate> strongTarget;

@end

#pragma mark -
@implementation MTFFlingBehavior

//-----------------------------------------------------------------------
#pragma mark - Private types -
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
#pragma mark - Contruction and Destruction -
//-----------------------------------------------------------------------

- (id)initWithTarget:(id <MTFFlingBehaviorDelegate>)target
{
    if (!(self = [super init])) return nil;
    if (!target) return nil;
    _target = target;
    self.smoothnessFactor = 0.8;
    return self;
}

+ (id)instanceWithTarget:(id<MTFFlingBehaviorDelegate>)target
{
    return [[self alloc] initWithTarget:target];
}

- (id)init
{
    [NSException raise:@"Should use initWithTarget: or instanceWithTarget: methods" format:@"Should use initWithTarget: or instanceWithTarget: methods"];
    return nil;
}

//-----------------------------------------------------------------------
#pragma mark - Public properties -
//-----------------------------------------------------------------------

- (BOOL)decelerating
{
    return self.timer.isValid;
}

//-----------------------------------------------------------------------
#pragma mark - Public methods -
//-----------------------------------------------------------------------


- (void)decelerateWithVelocity:(CGPoint)velocity withCompletionBlock:(DecelerationCompletionBlock)completionBlock
{
    NSMutableDictionary *userInfo = [@{@"velocity" : [NSValue valueWithCGPoint:velocity]} mutableCopy];
    if (completionBlock)
    {
        userInfo[@"completionBlock"] = completionBlock;
    }
    [self.timer invalidate];
    self.strongTarget = _target;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(step:) userInfo:userInfo repeats:YES];
}

- (void)cancelDeceleration
{
    [self.timer invalidate];
}

//-----------------------------------------------------------------------
#pragma mark - Private methods -
//-----------------------------------------------------------------------

- (void)step:(NSTimer *)timer
{
    CGPoint velocity = [timer.userInfo[@"velocity"] CGPointValue];
    velocity.x *= self.smoothnessFactor;
    velocity.y *= self.smoothnessFactor;
    timer.userInfo[@"velocity"] = [NSValue valueWithCGPoint:velocity];
    
    CGPoint distance;
    distance.x = velocity.x * kTimerInterval;
    distance.y = velocity.y * kTimerInterval;
    
    if((ABS(velocity.x) <= 0.01 && ABS(velocity.y) <= 0.01))
    {
        if (timer.userInfo[@"completionBlock"])
        {
            DecelerationCompletionBlock completionBlock = timer.userInfo[@"completionBlock"];
            completionBlock();
        }
        [timer invalidate];
        self.strongTarget = nil;
        return;
    }
    
    if (self.strongTarget)
        [self.strongTarget addTranslation:distance];
    else
    {
        [timer invalidate];
        return;
    }
}


@end
