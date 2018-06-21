//
//  ZLPopupAnimator.h
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopupAnimatorStyle) {
    /** 底部弹出动画 */
    PopupAnimatorStyleActionSheet,
    /** 提示框动画 */
    PopupAnimatorStyleAlert,
    /** 顶部右侧下拉菜单 */
    PopupAnimatorStyleDropList,
    
    
    /** 自定义动画 */
    PopupAnimatorStyleCustom,
};


/** 弹出视图动画 */
@interface ZLPopupAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/** 弹出视图 */
@property (nonatomic, strong) UIView *alertView;

/** 动画类型 */
@property (nonatomic, assign) PopupAnimatorStyle style;

/** 动画时间 */
@property (nonatomic, assign) NSTimeInterval duration;

/** 蒙板颜色 */
@property (nonatomic, strong) UIColor *maskColor;


/** 动画完成 */
@property (nonatomic, copy) void (^completeBlock)(void);

/** 自定义动画效果 (PopupAnimatorStyleCustom 时实现) */
@property (nonatomic, copy) void (^animateBlock)(BOOL show);

@end
