//
//  ZLCollectionViewFlowLayout.h
//  Category
//
//  Created by long on 2018/1/31.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZLCollectionViewFlowLayoutItemAlignment) {
    // uicollectionviewflowlayout 自动对齐
    ZLCollectionViewFlowLayoutItemAlignmentAuto,
    // item 左对齐
    ZLCollectionViewFlowLayoutItemAlignmentLeft,
    // item 居中对齐
    ZLCollectionViewFlowLayoutItemAlignmentCenter,
    // item 右对齐
    ZLCollectionViewFlowLayoutItemAlignmentRight
};


@protocol ZLCollectionDecorationViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
/** 分区背景色 */
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;
/** 分区背景图 */
- (UIImage *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundImageForSection:(NSInteger)section;
/** 分区背景图四周内边距 */
- (UIEdgeInsets)imageInsetOfcollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundImageForSection:(NSInteger)section;

@end

@interface ZLCollectionViewFlowLayout : UICollectionViewFlowLayout

/** item 对齐方式 */
@property (nonatomic, assign) ZLCollectionViewFlowLayoutItemAlignment itemAlignment;

/** 背景图内边距 */
@property (nonatomic, assign) UIEdgeInsets backgroundImageInset;

@end
