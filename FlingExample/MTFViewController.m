//
//  MTFViewController.m
//  FlingExample
//
//  Created by Nano Anderson on 8/27/13.
//  Copyright (c) 2013 Nano Anderson. All rights reserved.
//

#import "MTFViewController.h"
#import "MTFFlingBehavior.h"
#import "MTFCollectionViewCell.h"
#import "UIView+MTFFling.h"

@interface MTFViewController ()
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView* flingView;

@end

@implementation MTFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.flingView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.flingView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.flingView.backgroundColor = [UIColor whiteColor];
    self.flingView.delegate = self;
    self.flingView.dataSource = self;
    [self.flingView registerClass:[MTFCollectionViewCell class] forCellWithReuseIdentifier:@"flingerCell"];
    [self.view addSubview:self.flingView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.flingView reloadData];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( 100.f, 100.f );
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flingerCell" forIndexPath:indexPath];
    if (!cell.targetView)
    {
        cell.targetView = self.view;
    }
    return cell;
}

@end
