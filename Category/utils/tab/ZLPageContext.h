//
//  ZLPageContext.h
//  Category
//
//  Created by long on 2018/4/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLSlideAnimator.h"

@interface ZLPageContext : NSObject <UIViewControllerContextTransitioning>

/** 容器视图  delegate 实现属性 */
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIViewController *toCtrler;
@property (nonatomic, strong) UIViewController *fromCtrler;
@property (nonatomic, strong) UIViewController *pageCtrler;


/** 动画完成回调   (完成/取消  最终显示的控制器) */
@property (nonatomic, copy) void (^transitCompletionBlock)(BOOL finish, UIViewController *currentCtrler);

/** 非交互动画 */
- (void)startNonInteractiveTransitionWithDirection:(ZLSlideAnimatorDirection)direction;
/** 交互动画 */
- (void)startInteractiveTransitionWithDirection:(ZLSlideAnimatorDirection)direction;


@end
