//
//  UITableView+ZLRefresh.h
//  Category
//
//  Created by long on 2018/4/26.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZLRefresh)

/** 少于数量隐藏mjfooter */
@property (nonatomic, assign) NSUInteger footerHideCount;

/** 超出屏幕隐藏mjfooter */
@property (nonatomic, assign) BOOL footerHideOffScreen;


- (void)reloadAndHeaderEndRefreshing;
- (void)reloadAndFooterEndRefreshingWithMore:(BOOL)more;

@end
