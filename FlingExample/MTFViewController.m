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
#import "MTFFlingBucket.h"

@interface MTFViewController ()
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView* collectionView;

@end

@implementation MTFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MTFCollectionViewCell class] forCellWithReuseIdentifier:@"flingerCell"];
    [self.view addSubview:self.collectionView];
    
    UIView *topBucketView = [[UIView alloc] initWithFrame:CGRectMake(-10,10, 50,100)];
    UIView *bottomBucketView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50,120)];
    topBucketView.backgroundColor = [UIColor lightGrayColor];
    bottomBucketView.backgroundColor = [UIColor darkGrayColor];
    [[MTFFlingBucket sharedBucket] setTopView:topBucketView];
    [[MTFFlingBucket sharedBucket] setBottomView:bottomBucketView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.collectionView reloadData];
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
    MTFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flingerCell" forIndexPath:indexPath];
    if (!cell.targetView)
    {
        cell.targetView = self.view;
    }
    [cell setTitle:[NSString stringWithFormat:@"%i", indexPath.item]];
    return cell;
}

@end
