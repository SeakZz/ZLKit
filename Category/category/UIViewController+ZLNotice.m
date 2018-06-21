//
//  UIViewController+ZLNotice.m
//  Category
//
//  Created by long on 2018/4/23.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIViewController+ZLNotice.h"
#import <objc/runtime.h>


@implementation UIViewController (ZLNotice)


- (void)showNoticeView:(BOOL)show {
    if (!self.noticeView) return;
    
    if (show) {
        if (!self.originalView) {
            self.originalView = self.view;
        }
        self.view = self.noticeView;
    } else {
        if (!self.originalView) return;
        
        self.view = self.originalView;
    }
}


#pragma mark - property
- (UIView *)noticeView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNoticeView:(UIView *)noticeView {
    objc_setAssociatedObject(self, @selector(noticeView), noticeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 用来保存Viewcontroller 中的 view
- (UIView *)originalView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setOriginalView:(UIView *)originalView {
    objc_setAssociatedObject(self, @selector(originalView), originalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
