//
//  UIView+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZLExtension)

/** 从nib创建实例 */
+ (instancetype)nibView;


/** 添加圆形阴影 */
- (void)addRoundedShadow;
/** 添加矩形阴影 */
- (void)addRectangleShadow;

/** 添加阴影效果 */
- (void)addShadowWithColor:(UIColor *)color
                    offset:(CGSize)offset
                   opacity:(CGFloat)opacity
              shadowRadius:(CGFloat)shadowRadius
              cornerRadius:(CGFloat)cornerRadius;


/** 添加新消息提示圆点 */
- (void)setBadge:(BOOL)show withRect:(CGRect)rect;


/** 添加点击事件 */
- (void)addTapGestureRecognizerWithAction:(void (^)(UITapGestureRecognizer *tap))action;


/** 获取当前视图的控制器 */
- (UIViewController *)viewController;

@end
