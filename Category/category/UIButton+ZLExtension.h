//
//  UIButton+ZLExtension.h
//  Category
//
//  Created by long on 2018/2/7.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonContentLocation) {
    /** 左侧图片 右侧文字 */
    UIButtonContentLocationNormal,
    /** 左侧文字 右侧图片 */
    UIButtonContentLocationReverse
};

@interface UIButton (ZLExtension)

/** 点击事件 */
@property (nonatomic, copy) void (^touchUpInsideBlock)(void);

/** 设置文字图片间距方位 */
- (void)setImage:(UIImage *)image title:(NSString *)title gap:(CGFloat)gap location:(UIButtonContentLocation)location;

@end
