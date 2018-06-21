//
//  ZLSegmentedTabController.h
//  Category
//
//  Created by long on 2018/4/11.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLTabController.h"

@interface ZLSegmentedTabController : ZLTabController

/** 标题 */
@property (nonatomic, copy) NSArray *titles;

/** 点击标题转场是否有动画 */
@property (nonatomic, assign) BOOL itemSelectAnimated;

@end
