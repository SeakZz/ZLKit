//
//  UITextView+ZLExtension.h
//  Category
//
//  Created by long on 2018/2/5.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ZLExtension)

/** 字数限制 */
@property (nonatomic, assign) NSUInteger wordLimit;

/** 内外边距0 */
@property (nonatomic, assign) BOOL containerInsetZero;

@end
