//
//  UITableView+ZLExtension.m
//  Category
//
//  Created by long on 2018/2/7.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UITableView+ZLExtension.h"
#import <objc/runtime.h>

@implementation UITableView (ZLExtension)


#pragma mark -
#pragma mark - resolve touch cover
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if (self.touchCancelWhenLeave && [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return  [super touchesShouldCancelInContentView:view];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.endEditingByTap) {
        [self endEditing:YES];
    }
    
    return [super hitTest:point withEvent:event];
}


#pragma mark - property
- (BOOL)touchCancelWhenLeave {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setTouchCancelWhenLeave:(BOOL)touchCancelWhenLeave {
    objc_setAssociatedObject(self, @selector(touchCancelWhenLeave), @(touchCancelWhenLeave), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)endEditingByTap {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setEndEditingByTap:(BOOL)endEditingByTap {
    objc_setAssociatedObject(self, @selector(endEditingByTap), @(endEditingByTap), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
