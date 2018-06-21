//
//  UITableView+ZLExtension.h
//  Category
//
//  Created by long on 2018/2/7.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZLExtension)


/** 手势覆盖后移动是否可拖动 */
@property (nonatomic, assign) BOOL touchCancelWhenLeave;
/** 点击空白区域是否停止编辑 */
@property (nonatomic, assign) BOOL endEditingByTap;

@end
