//
//  MTFFlingView.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFFlingView.h"

@implementation MTFFlingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
        [self addGestureRecognizer:panRecognizer];
    }
    return self;
}

- (void) viewDidPan:(UIPanGestureRecognizer*)panRecognizer
{
    NSLog( @"viewDidPan: %@", panRecognizer.description );
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
