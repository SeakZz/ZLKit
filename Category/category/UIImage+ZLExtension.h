//
//  UIImage+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIImage (ZLExtension)

- (NSString *)base64String;

/** 高斯模糊 */
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end
