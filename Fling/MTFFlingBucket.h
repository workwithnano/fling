//
//  MTFFlingBucket.h
//  
//
//  Created by Nano Anderson on 9/2/13.
//
//

#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------
// Public constants
//-----------------------------------------------------------------------

FOUNDATION_EXPORT CGFloat const BUCKET_WIDTH;
FOUNDATION_EXPORT CGFloat const BUCKET_HEIGHT;

//-----------------------------------------------------------------------
// Public types
//-----------------------------------------------------------------------

typedef void (^DecelerationCompletionBlock)();

//-----------------------------------------------------------------------
// Public protocols
//-----------------------------------------------------------------------

@interface MTFFlingBucket : UIView

//-----------------------------------------------------------------------
// Public properties
//-----------------------------------------------------------------------

@property (nonatomic, readonly) CGRect topViewFrame;
@property (nonatomic, readonly) CGRect bottomViewFrame;

//-----------------------------------------------------------------------
// Public methods
//-----------------------------------------------------------------------

+ (instancetype)sharedBucket;

- (void)setTopView:(UIView*)view;
- (void)setBottomView:(UIView*)view;

@end