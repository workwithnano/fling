//
//  MTFFlingBucket.m
//  
//
//  Created by Nano Anderson on 9/2/13.
//
//

#import "MTFFlingBucket.h"

//-----------------------------------------------------------------------
#pragma mark - Static variables and constants -
//-----------------------------------------------------------------------

CGFloat const BUCKET_WIDTH = 50.f;
CGFloat const BUCKET_HEIGHT = 100.f;

static MTFFlingBucket* singleton;
static dispatch_queue_t serialQueue;

//-----------------------------------------------------------------------
#pragma mark - Private properties -
//-----------------------------------------------------------------------
@interface MTFFlingBucket ()

@property (nonatomic) UIView* topView;
@property (nonatomic) UIView* bottomView;

@end

#pragma mark -
@implementation MTFFlingBucket

//-----------------------------------------------------------------------
#pragma mark - Private types -
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
#pragma mark - Contruction and Destruction -
//-----------------------------------------------------------------------

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.multi-touchy-feely.fling.SerialQueue", NULL);
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
        }
    });
    
    return singleton;
}

- (id)init {
    id __block obj;
    
    dispatch_sync(serialQueue, ^{
        obj = [super init];
        if (obj) {
            
        }
    });
    
    self = obj;
    return self;
}

+ (instancetype)sharedBucket
{
    if (!singleton)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [[self alloc] init];
        });
    }
    return singleton;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [NSException raise:@"Please call [MTFFlingBucket sharedBucket] instead." format:nil];
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

//-----------------------------------------------------------------------
#pragma mark - Public properties -
//-----------------------------------------------------------------------

- (CGRect)topViewFrame
{
    if (!self.topView)
        return CGRectZero;
    
    return self.topView.frame;
}
- (CGRect)bottomViewFrame
{
    if (!self.bottomView)
        return CGRectZero;
    
    return self.bottomView.frame;
}

//-----------------------------------------------------------------------
#pragma mark - Public methods -
//-----------------------------------------------------------------------

- (void)setTopView:(UIView *)view
{
    if (_topView && _topView.superview)
    {
        [_topView removeFromSuperview];
        _topView = nil;
    }
    
    _topView = view;
    [self addSubview:_topView];
    [self bringSubviewToFront:_topView];
    [self updateBounds];
}
- (void)setBottomView:(UIView *)view
{
    if (_bottomView && _bottomView.superview)
    {
        [_bottomView removeFromSuperview];
        _bottomView = nil;
    }
    
    _bottomView = view;
    [self addSubview:_bottomView];
    [self bringSubviewToFront:_topView];
    [self updateBounds];
}

//-----------------------------------------------------------------------
#pragma mark - Private methods -
//-----------------------------------------------------------------------

- (void)updateBounds
{
    CGRect unionRect = CGRectUnion(self.topView.bounds,self.bottomView.bounds);
    self.frame = CGRectMakeWith(self.frame.origin, unionRect.size);
}

//-----------------------------------------------------------------------
#pragma mark - Protected methods -
//-----------------------------------------------------------------------

- (void)setCenter:(CGPoint)center
{
    if (!self.topView || !self.bottomView || !self.topView.superview || !self.bottomView.superview)
        [NSException raise:@"You must set the top and bottom views for the bucket before using it." format:nil];
    
    [super setCenter:center];
}

@end
