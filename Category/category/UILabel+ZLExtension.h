//
//  UILabel+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/26.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZLExtension)

/** 文字变大/缩小 */
- (void)animateToFont:(UIFont *)font;




/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/** 获取根据内容适应的大小 */
- (CGSize)sizeOfLabel;
/** 获取根据内容及宽度适应的大小 */
- (CGSize)sizeOfLabelWithMaxWidth:(CGFloat)width;

/** 根据内边距调整大小 */
- (void)sizeToFitWithCurrentContentInset;
/** 根据内边距及设定宽度调整大小 */
- (void)sizeToFitWithMaxWidth:(CGFloat)width;

@end
