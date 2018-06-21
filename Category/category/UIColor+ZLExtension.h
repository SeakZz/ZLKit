//
//  UIColor+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZLExtension)

/** rgba颜色  (0xrrggbbaa) */
+ (UIColor *)colorWithRgbaHex:(long long)rgbValue;

/** rgb颜色 */
+ (UIColor *)colorWithRgbHex:(NSInteger)rgbValue;

/** 获取两种颜色的混合色 */
+ (UIColor *)mixColor1:(UIColor *)color1
                color2:(UIColor *)color2
                 ratio:(CGFloat)ratio;

/** 随机颜色 */
+ (UIColor *)randomColor;

@end
