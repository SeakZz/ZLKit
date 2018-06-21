//
//  UIColor+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIColor+ZLExtension.h"

@implementation UIColor (ZLExtension)

+ (UIColor *)colorWithRgbaHex:(long long)rgbValue {
    return [UIColor colorWithRed:((long long)((rgbValue & 0xFF000000) >> 24))/255.0 \
                           green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            blue:((float)((rgbValue & 0xFF00) >> 8))/255.0
                           alpha:((float)((long long)rgbValue & 0xFF))/255.0];
}

+ (UIColor *)colorWithRgbHex:(NSInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}


+ (UIColor *)mixColor1:(UIColor *)color1
                color2:(UIColor *)color2
                 ratio:(CGFloat)ratio
{
    if(ratio > 1) ratio = 1;
    const CGFloat *components1 = CGColorGetComponents(color1.CGColor);
    const CGFloat *components2 = CGColorGetComponents(color2.CGColor);
    
    /*
        UIExtendedGrayColorSpace 0.3 1
        UIExtendedSRGBColorSpace 0.42 0.7 0.35 1
        判断为UIExtendedGrayColorSpace (灰度分量)
        时转成UIExtendedSRGBColorSpace
        否则计算rgb出错
     */
    if (CGColorGetNumberOfComponents(color1.CGColor) != 4) {
        color1 = [UIColor colorWithRed:components1[0] green:components1[0] blue:components1[0] alpha:components1[1]];
        components1 = CGColorGetComponents(color1.CGColor);
    } else if (CGColorGetNumberOfComponents(color2.CGColor) != 4) {
        color2 = [UIColor colorWithRed:components2[0] green:components2[0] blue:components2[0] alpha:components2[1]];
        components2 = CGColorGetComponents(color2.CGColor);
    }
    
    CGFloat r = components1[0] * ratio + components2[0] * (1-ratio);
    CGFloat g = components1[1] * ratio + components2[1] * (1-ratio);
    CGFloat b = components1[2] * ratio + components2[2] * (1-ratio);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(255) / 255.0
                           green:arc4random_uniform(255) / 255.0
                            blue:arc4random_uniform(255) / 255.0
                           alpha:1];
}

@end
