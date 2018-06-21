//
//  NSString+ZLSize.h
//  Category
//
//  Created by long on 2018/1/3.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZLSize)

- (CGSize)sizeWithFont:(UIFont *)font
                  maxW:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font
                  maxW:(CGFloat)width
          maxLineCount:(NSUInteger)count;

- (CGSize)sizeWithCustomFont:(UIFont *)font;

@end
