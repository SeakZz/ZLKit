//
//  NSString+ZLSize.m
//  Category
//
//  Created by long on 2018/1/3.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NSString+ZLSize.h"

@implementation NSString (ZLSize)

- (CGSize)sizeWithFont:(UIFont *)font
                  maxW:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(width, FLT_MAX);
    
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
                  maxW:(CGFloat)width
          maxLineCount:(NSUInteger)count {
    CGSize size = [self sizeWithFont:font maxW:width];
    return CGSizeMake(size.width, MIN(size.height, font.lineHeight * count));
}

- (CGSize)sizeWithCustomFont:(UIFont *)font {
    return [self sizeWithFont:font maxW:FLT_MAX];
}

@end
