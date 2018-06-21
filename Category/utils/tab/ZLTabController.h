//
//  ZLTabController.h
//  Category
//
//  Created by long on 2018/4/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLTabController;

@protocol ZLTabControllerDelegate <NSObject>

@optional
/** 完成切换动画 */
- (void)pageController:(ZLTabController *)pageCtrler slideCompletedToIndex:(NSUInteger)idx;
/** 切换开始 */
- (void)pageController:(ZLTabController *)pageCtrler slideStartToIndex:(NSUInteger)idx;
/** 切换进度 */
- (void)pageController:(ZLTabController *)pageCtrler slideProgress:(CGFloat)progress;

@end


@interface ZLTabController : UIViewController

/** 显示的 控制器集合 */
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *ctrlers;
/** 初始显示的控制器索引  default 0 */
@property (nonatomic, assign) NSUInteger initialIndex;
/** 当前显示索引 */
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

@property (nonatomic, weak) id<ZLTabControllerDelegate> delegate;



// 非交互
/** 滚动到索引 */
- (void)scrollToIndex:(NSUInteger)idx animated:(BOOL)animated;

@end
