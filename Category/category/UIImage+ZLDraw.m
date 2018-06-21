//
//  UIImage+ZLDraw.m
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIImage+ZLDraw.h"

@implementation UIImage (ZLDraw)

- (UIImage *)drawImageWithSize:(CGSize)size
                  cornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (radius) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        CGContextAddPath(context, path.CGPath);
        CGContextClip(context);
    }
    [self drawInRect:rect];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [output imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)drawCircleImageWithWidth:(CGFloat)width {
    return [self drawImageWithSize:CGSizeMake(width, width) cornerRadius:width / 2];
}
- (UIImage *)drawSquareImageWithWidth:(CGFloat)width cornerRadius:(CGFloat)radius {
    return [self drawImageWithSize:CGSizeMake(width, width) cornerRadius:radius];
}

- (UIImage *)drawImage:(CGSize)size {
    return [self drawImageWithSize:size cornerRadius:0];
}


- (void)asyncDrawImageWithSize:(CGSize)size
                  cornerRadius:(CGFloat)radius
                    completion:(void (^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [self drawImageWithSize:size cornerRadius:radius];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(image);
        });
    });
}
- (void)asyncDrawCircleImageWithWidth:(CGFloat)width
                           completion:(void (^)(UIImage *image))completion {
    [self asyncDrawImageWithSize:CGSizeMake(width, width) cornerRadius:width / 2 completion:completion];
}


@end
