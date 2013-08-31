//
//  MTFFlingView.h
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------
// Public constants
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
// Public types
//-----------------------------------------------------------------------

typedef void (^DecelerationCompletionBlock)();

//-----------------------------------------------------------------------
// Public protocols
//-----------------------------------------------------------------------

@protocol MTFFlingBehaviorDelegate <NSObject>

@required
- (void)addTranslation:(CGPoint)traslation;

@end

#pragma mark -
@interface MTFFlingBehavior : NSObject

//-----------------------------------------------------------------------
// Public properties
//-----------------------------------------------------------------------

@property (nonatomic, weak, readonly) id<MTFFlingBehaviorDelegate> target;

//smoothnessFactor decides how smooth the deceleration will be
//smoothnessFactor's range should be between 0 and < 1 if its beyond those range then behaviour is unexpected
//defaults to 0.8
@property (nonatomic, assign) CGFloat smoothnessFactor;

//-----------------------------------------------------------------------
// Public methods
//-----------------------------------------------------------------------

+ (id)instanceWithTarget:(id<MTFFlingBehaviorDelegate>)target;
- (id)initWithTarget:(id<MTFFlingBehaviorDelegate>)target;

- (void)decelerateWithVelocity:(CGPoint)velocity withCompletionBlock:(DecelerationCompletionBlock)completionBlock;
- (void)cancelDeceleration; //cancelling will not invoke completion block
- (BOOL)decelerating;

@end
