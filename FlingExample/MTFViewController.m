//
//  MTFViewController.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFViewController.h"
#import "MTFFlingBehavior.h"
#import "UIView+MTFFling.h"

@interface MTFViewController ()

@property (nonatomic) UIView* flingView;

@end

@implementation MTFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.flingView = [[UIView alloc] initWithFrame:CGRectMake(20.f,20.f, 100.f, 100.f)];
    self.flingView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.flingView];
    
    [self.flingView makeFlingable];
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
