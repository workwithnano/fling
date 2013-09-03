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

//-----------------------------------------------------------------------
#pragma mark - Private properties -
//-----------------------------------------------------------------------
@interface MTFFlingBucket ()

@end

#pragma mark -
@implementation MTFFlingBucket

//-----------------------------------------------------------------------
#pragma mark - Private types -
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
#pragma mark - Contruction and Destruction -
//-----------------------------------------------------------------------

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

- (id)init
{
    if (singleton)
        [NSException raise:@"Please call [MTFFlingBucket sharedBucket] instead." format:nil];
    return [self initWithFrame:CGRectMake(0,0,50,100)];
}

- (id)initWithFrame:(CGRect)frame
{
    if (singleton)
        [NSException raise:@"Please call [MTFFlingBucket sharedBucket] instead." format:nil];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (singleton)
        [NSException raise:@"Please call [MTFFlingBucket sharedBucket] instead." format:nil];
    return [self init];
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

//-----------------------------------------------------------------------
#pragma mark - Public methods -
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
#pragma mark - Private methods -
//-----------------------------------------------------------------------

@end
