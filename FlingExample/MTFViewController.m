//
//  MTFViewController.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFViewController.h"
#import "MTFFlingView.h"

@interface MTFViewController ()

@end

@implementation MTFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MTFFlingView* view = [[MTFFlingView alloc] initWithFrame:CGRectMake(20.f,20.f, 100.f, 100.f)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
