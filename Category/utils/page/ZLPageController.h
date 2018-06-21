//
//  ZLPageController.h
//  Category
//
//  Created by long on 2018/4/13.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLPageController;

@protocol ZLPageControllerDelegate <NSObject>

@optional
/** 滑动完成 (无动画完成  交互动画完成  非交互动画完成) */
- (void)pageController:(ZLPageController *)pageCtrler scrollCompletedToIndex:(NSUInteger)idx;
/** 滑动开始 */
- (void)scrollStartInPageController:(ZLPageController *)pageCtrler;
/** 滑动进度 */
- (void)pageController:(ZLPageController *)pageCtrler scrollProgress:(CGFloat)progress;

@end


@interface ZLPageController : UIViewController

/** 显示的 控制器集合 */
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *ctrlers;
/** 初始显示的控制器索引  default 0 */
@property (nonatomic, assign) NSUInteger initialIndex;
/** 当前显示索引 */
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

/** 拖拽手势 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *pan;

@property (nonatomic, weak) id<ZLPageControllerDelegate> delegate;


- (void)scrollToIndex:(NSUInteger)idx animated:(BOOL)animated;



#pragma mark - subclass override
/** 滑动完成 (无动画完成  交互动画完成  非交互动画完成) */
- (void)scrollCompletedToIndex:(NSUInteger)idx NS_REQUIRES_SUPER;
/** 滑动进度 */
- (void)scrollProgressWhenScrolling:(CGFloat)progress NS_REQUIRES_SUPER;
/** 滑动开始 */
- (void)startToScroll NS_REQUIRES_SUPER;

@end
