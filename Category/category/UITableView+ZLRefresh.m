//
//  UITableView+ZLRefresh.m
//  Category
//
//  Created by long on 2018/4/26.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UITableView+ZLRefresh.h"
#import <MJRefresh/MJRefresh.h>
#import <objc/runtime.h>

@implementation UITableView (ZLRefresh)

- (void)reloadAndHeaderEndRefreshing {
    [self reloadData];
    [self.mj_header endRefreshing];
    if (self.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.mj_footer resetNoMoreData];
    }
}
- (void)reloadAndFooterEndRefreshingWithMore:(BOOL)more {
    [self reloadData];
    if (more) {
        [self.mj_footer endRefreshing];
    } else {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - private method
- (void)zl_refresh_reloadData {
    [self zl_refresh_reloadData];
    
    if (self.footerHideOffScreen) {
        self.mj_footer.hidden = ![self tableViewDisplayOffScreen];;
    }
    if (self.footerHideCount) {
        self.mj_footer.hidden = self.mj_totalDataCount <= self.footerHideCount;
    }
}

- (void)_exchangeMethodReloadData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method original_reload = class_getInstanceMethod([self class], @selector(reloadData));
        Method swizzled_reload = class_getInstanceMethod([self class], @selector(zl_refresh_reloadData));
        method_exchangeImplementations(original_reload, swizzled_reload);
    });
}

- (BOOL)tableViewDisplayOffScreen {
    CGFloat h = 0;
    for (int i = 0; i < self.numberOfSections; i ++) {
        h += [self.delegate tableView:self heightForHeaderInSection:i];
        h += [self.delegate tableView:self heightForFooterInSection:i];
        for (int j = 0; j < [self.dataSource tableView:self numberOfRowsInSection:i]; j ++) {
            h += [self.delegate tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
    return h > [UIScreen mainScreen].bounds.size.height;
}

#pragma mark - property
- (NSUInteger)footerHideCount {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)setFooterHideCount:(NSUInteger)footerHideCount {
    
    if (footerHideCount) {
        [self _exchangeMethodReloadData];
    }
    
    objc_setAssociatedObject(self, @selector(footerHideCount), @(footerHideCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)footerHideOffScreen {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setFooterHideOffScreen:(BOOL)footerHideOffScreen {
    
    if (footerHideOffScreen) {
        [self _exchangeMethodReloadData];
    }
    objc_setAssociatedObject(self, @selector(footerHideOffScreen), @(footerHideOffScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

