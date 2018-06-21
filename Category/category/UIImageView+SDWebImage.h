//
//  UIImageView+SDWebImage.h
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SDWebImage)

/** 加载网络图片 */
- (void)sd_loadImageWithUrlString:(NSString *)urlString
                 placeholderImage:(UIImage *)placeholder;

/** 加载圆形图片 */
- (void)sd_loadCircleImageWithUrlString:(NSString *)urlString
                       placeholderImage:(UIImage *)placeholder;

/** 加载圆角图片 */
- (void)sd_loadImageWithUrlString:(NSString *)urlString
                 placeholderImage:(UIImage *)placeholder
                     cornerRadius:(CGFloat)radius;

@end
