//
//  OGCollectionViewFlowLayout.m
//  OGCoverFlow
//
//  Created by orange on 17/2/8.
//  Copyright © 2017年 Orange. All rights reserved.
//

#import "OGCollectionViewFlowLayout.h"
#import "UIView+Extension.h"

#define ITEM_WH (SCREEN_HEIGHT * 0.15)* 0.5
#define DISTANCE 70
#define ZOOM_FACTOR 0.6

@implementation OGCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat margin = (SCREEN_WIDTH - ITEM_WH)/2.0;
        self.itemSize = CGSizeMake(ITEM_WH, ITEM_WH);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, ABS(margin), 0, ABS(margin));
        self.minimumLineSpacing = 20;
    }
    return self;
}

///刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

///放大当前item
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    // 遍历array中所有的UICollectionViewLayoutAttributes
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            if (ABS(distance) < SCREEN_WIDTH) {
                //透明度
                CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
                CGFloat delta = ABS(attributes.center.x - centerX);
                CGFloat scale = 1.0 - delta / self.collectionView.frame.size.width;
                attributes.alpha = scale;
            }
            
            if (ABS(distance) < DISTANCE) {
                //大小缩放
                CGFloat normalizedDistance = distance / DISTANCE;
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
            }
        }
    }
    
    return array;
}

///自动对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    // proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat offsetAdjustment = MAXFLOAT;
    //理论上应cell停下来的中心点
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
