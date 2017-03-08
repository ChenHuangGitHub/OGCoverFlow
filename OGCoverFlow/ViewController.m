//
//  ViewController.m
//  OGCoverFlow
//
//  Created by orange on 17/2/8.
//  Copyright © 2017年 Orange. All rights reserved.
//

#import "ViewController.h"
#import "OGCollectionViewFlowLayout.h"
#import "UIView+Extension.h"
#import "OGCollectionViewCell.h"

#define kCollectionViewH SCREEN_HEIGHT * 0.15

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) OGCollectionViewFlowLayout *lineLayout;

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"OGCollectionViewCell";

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectionView];
}


#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = kCollectionViewH * 0.5 *0.5;
    cell.layer.masksToBounds = YES;
    return cell;
}


#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = self.lineLayout.itemSize.width + self.lineLayout.minimumLineSpacing;
    NSInteger item = offsetX/width;
    NSString *imageName1 = [NSString stringWithFormat:@"bg%zi.jpg", item%2];
    [UIView animateWithDuration:.5f animations:^{
        self.imageView.image = [UIImage imageNamed:imageName1];
    }];
}

#pragma mark - Getter -

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _imageView.center = self.view.center;
    }
    return _imageView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _lineLayout = [[OGCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kCollectionViewH, SCREEN_WIDTH, kCollectionViewH) collectionViewLayout:_lineLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[OGCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    }
    return _collectionView;
}


@end
