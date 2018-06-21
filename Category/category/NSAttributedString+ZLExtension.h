//
//  NSAttributedString+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (ZLExtension)

+ (NSAttributedString *)attributedStringWithText:(NSString *)text
                                            font:(UIFont *)font
                                           color:(UIColor *)color;



+ (NSAttributedString *)attributedStringWithText:(NSString *)text
                                            font:(UIFont *)font
                                           color:(UIColor *)color
                                       lineSpace:(CGFloat)lineSpace
                             firstLineHeadIndent:(CGFloat)firstLineHeadIndent;


@end
