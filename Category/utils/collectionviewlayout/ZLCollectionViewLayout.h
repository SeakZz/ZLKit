//
//  ZLCollectionViewLayout.h
//  Category
//
//  Created by long on 2018/5/17.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZLCollectionViewDelegateLayout <UICollectionViewDelegateFlowLayout>

@optional
/** 分区背景色 */
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;
/** 分区背景图 */
- (UIImage *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundImageForSection:(NSInteger)section;
/** 分区背景图四周内边距 */
- (UIEdgeInsets)imageInsetOfcollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundImageForSection:(NSInteger)section;

@end

@interface ZLCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

/** 背景图内边距 */
@property (nonatomic, assign) UIEdgeInsets backgroundImageInset;

@end
