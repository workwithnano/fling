//
//  MTFFlingView.h
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTFFlingViewDelegate <NSObject>

@required

@end

@interface MTFFlingView : UIView
<MTFFlingViewDelegate>

@end
