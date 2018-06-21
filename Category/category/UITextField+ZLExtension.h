//
//  UITextField+ZLExtension.h
//  Category
//
//  Created by long on 2018/2/5.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ZLExtension)

/** 字数限制 */
@property (nonatomic, assign) NSUInteger wordLimit;

/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;


/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets contentInset;


@end
