//
//  NSAttributedString+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NSAttributedString+ZLExtension.h"

@implementation NSAttributedString (ZLExtension)

+ (NSAttributedString *)attributedStringWithText:(NSString *)text
                                            font:(UIFont *)font
                                           color:(UIColor *)color {
    return [self attributedStringWithText:text
                                     font:font
                                    color:color
                                lineSpace:0
                      firstLineHeadIndent:0];
}

+ (NSAttributedString *)attributedStringWithText:(NSString *)text
                                            font:(UIFont *)font
                                           color:(UIColor *)color
                                       lineSpace:(CGFloat)lineSpace
                             firstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    if (color) [attr setObject:color forKey:NSForegroundColorAttributeName];
    if (font) [attr setObject:font forKey:NSFontAttributeName];
    if (lineSpace || firstLineHeadIndent) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if (lineSpace) style.lineSpacing = lineSpace;
        if (firstLineHeadIndent) style.firstLineHeadIndent = firstLineHeadIndent;
        [attr setObject:style forKey:NSParagraphStyleAttributeName];
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text
                                                                  attributes:attr];
    return attrStr;
}


@end
