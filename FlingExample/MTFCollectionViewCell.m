//
//  MTFCollectionViewCell.m
//  FlingExample
//
//  Created by Nano Anderson on 8/30/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFCollectionViewCell.h"
#import "UIView+MTFFling.h"

@implementation MTFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        [self makeFlingable];
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
