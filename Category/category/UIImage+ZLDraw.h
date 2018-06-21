//
//  UIImage+ZLDraw.h
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZLDraw)

/** 获取圆角图片 */
- (UIImage *)drawImageWithSize:(CGSize)size
                  cornerRadius:(CGFloat)radius;
/** 获取圆形图片 */
- (UIImage *)drawCircleImageWithWidth:(CGFloat)width;
/** 获取正方形圆角图片 */
- (UIImage *)drawSquareImageWithWidth:(CGFloat)width cornerRadius:(CGFloat)radius;
/** 获取指定大小图片 */
- (UIImage *)drawImage:(CGSize)size;


/** 异步获取圆角图片 */
- (void)asyncDrawImageWithSize:(CGSize)size
                  cornerRadius:(CGFloat)radius
                    completion:(void (^)(UIImage *image))completion;
/** 异步获取圆形图片 */
- (void)asyncDrawCircleImageWithWidth:(CGFloat)width
                           completion:(void (^)(UIImage *image))completion;

@end
