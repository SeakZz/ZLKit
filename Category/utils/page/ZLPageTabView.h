//
//  ZLPageTabView.h
//  Category
//
//  Created by long on 2018/4/11.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSegmentedPageHeader.h"


@interface ZLPageTabView : UIView

/** 标题数组 */
@property (nonatomic, copy) NSArray *titles;

/** 设置当前索引 */
@property (nonatomic, assign) NSUInteger currentIndex;

/** 标题点击回调 */
@property (nonatomic, copy) void (^itemSelectedBlock)(NSUInteger idx);

/** 标题宽度数组 */
@property (nonatomic, copy) NSArray *widths;


/** 标题文字颜色 default 0x666666 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题文字字体 default [UIFont systemFontOfSize:15] */
@property (nonatomic, strong) UIFont *titleFont;


- (void)reloadData;
/** 滚动到索引 */
- (void)scrollKeepCellPositionCenterToIndex:(NSUInteger)idx;

/** 底部线颜色 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/** 选中样式 */
@property (nonatomic, assign) ZLSegmentValueChangedStyle style;

/** 选中线颜色 default red */
@property (nonatomic, strong) UIColor *lineColor;
/** 更新选中线中心位置 */
- (void)setLineCenterX:(CGFloat)centerX;


/** 选中文字颜色 default red */
@property (nonatomic, strong) UIColor *selectedTitleColor;
/** 更新选中文字颜色 */
- (void)setColorChangedWithIndex:(NSUInteger)idx progress:(CGFloat)progress;


/** 选中文字字体 default [UIFont systemFontOfSize:17] */
@property (nonatomic, strong) UIFont *selectedTitleFont;
/** 更新选中文字字体 */
- (void)setFontChangedWithIndex:(NSUInteger)idx progress:(CGFloat)progress;


@end
