//
//  ZLSegmentedPageController.h
//  Category
//
//  Created by long on 2018/4/13.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLPageController.h"
#import "ZLSegmentedPageHeader.h"


@interface ZLSegmentedPageController : ZLPageController

/** 标题 (没设置则获取viewcontroller的 title) */
@property (nonatomic, copy) NSArray *titles;

/** 点击标题转场是否有动画 defalut no */
@property (nonatomic, assign) BOOL itemSelectAnimated;

/** 底部线颜色 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/** 未选中颜色 */
@property (nonatomic, strong) UIColor *normalColor;
/** 未选中字体 */
@property (nonatomic, strong) UIFont *normalFont;

/** 选中颜色 */
@property (nonatomic, strong) UIColor *selectedColor;
/** 选中字体 */
@property (nonatomic, strong) UIFont *selectedFont;

/** item 是否均分 default no */
@property (nonatomic, assign) BOOL itemDivideEqually;

/** 动画效果 default ZLSegmentValueChangedStyleNone */
@property (nonatomic, assign) ZLSegmentValueChangedStyle segmentStyle;

@end
