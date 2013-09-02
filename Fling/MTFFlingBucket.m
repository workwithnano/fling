//
//  MTFFlingBucket.m
//  
//
//  Created by Nano Anderson on 9/2/13.
//
//

#import "MTFFlingBucket.h"

static MTFFlingBucket* singleton;

@implementation MTFFlingBucket

+ (instancetype)sharedBucket
{
    if (!singleton)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [[self alloc] initWithFrame:CGRectMake(0,0,50,100)];
        });
    }
    return singleton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
