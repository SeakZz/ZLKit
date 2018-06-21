//
//  ZLCollectionReusableView.h
//  Category
//
//  Created by long on 2018/1/31.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 背景属性 */
@interface ZLCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) UIEdgeInsets imageInset;

@end


@interface ZLCollectionReusableView : UICollectionReusableView

@end
