//
//  UIViewController+ZLNotice.h
//  Category
//
//  Created by long on 2018/4/23.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZLNotice)

/** 提示视图 (无网、无数据) */
@property (nonatomic, strong) UIView *noticeView;

/** 展示视图 */
- (void)showNoticeView:(BOOL)show;

@end
