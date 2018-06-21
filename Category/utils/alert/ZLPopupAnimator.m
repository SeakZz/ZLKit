//
//  ZLPopupAnimator.m
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLPopupAnimator.h"

@implementation ZLPopupAnimator

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.25;
        self.maskColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning
// 动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}
// 执行动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tvc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    UIView *fv, *tv;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        // iOS 8 以上 中通过 key 获取参与转场的视图
        fv = [transitionContext viewForKey:UITransitionContextFromViewKey];
        tv = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    //  iOS 7 中需要通过对应的视图控制器来获取参与转场的视图
    if (!fv) fv = fvc.view;
    if (!tv) tv = tvc.view;
    
    if (tvc.beingPresented) [containerView addSubview:tv];
    
    [self transitionFromView:fv
                      toView:tv
                      isShow:tvc.isBeingPresented
                  completion:^{
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}
// 动画完成
- (void)animationEnded:(BOOL)transitionCompleted {
    if (transitionCompleted) {
        if (self.completeBlock) self.completeBlock();
    }
}


#pragma mark - private
- (void)transitionFromView:(UIView *)fv
                    toView:(UIView *)tv
                    isShow:(BOOL)isShow
                completion:(void (^)(void))completion {
    
    switch (self.style) {
        case PopupAnimatorStyleActionSheet:
            [self animateActionSheetFromView:fv toView:tv isShow:isShow completion:completion];
            break;
        case PopupAnimatorStyleAlert:
            [self animateAlertFromView:fv toView:tv isShow:isShow completion:completion];
            break;
        case PopupAnimatorStyleDropList:
            [self animateDropListFromView:fv toView:tv isShow:isShow completion:completion];
            break;
            
        case PopupAnimatorStyleCustom:
            [self animateCustomFromView:fv toView:tv isShow:isShow completion:completion];
            break;
    }
}

#pragma mark - baseanimate
// 基础动画
- (void)animateFromView:(UIView *)fv toView:(UIView *)tv isShow:(BOOL)isShow animations:(void (^)(void))animations  completion:(void (^)(void))completion {
    if (isShow) {
        tv.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } else {
        fv.backgroundColor = self.maskColor;
    }
    
    [UIView animateWithDuration:self.duration animations:^{
        if (animations) animations();
        
        if (isShow) {
            tv.backgroundColor = self.maskColor;
        } else {
            fv.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        }
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

#pragma mark - animate
// 底部弹出动画
- (void)animateActionSheetFromView:(UIView *)fv toView:(UIView *)tv isShow:(BOOL)isShow completion:(void (^)(void))completion {
    if (isShow) {
        self.alertView.frame = CGRectOffset(self.alertView.frame, 0, CGRectGetHeight(self.alertView.frame));
    }
    [self animateFromView:fv toView:tv isShow:isShow animations:^{
        
        if (isShow) {
            self.alertView.frame = CGRectOffset(self.alertView.frame, 0, -CGRectGetHeight(self.alertView.frame));
        } else {
            self.alertView.frame = CGRectOffset(self.alertView.frame, 0, CGRectGetHeight(self.alertView.frame));
        }
    } completion:^{
        if (completion) completion();
    }];
}
// 提示框动画
- (void)animateAlertFromView:(UIView *)fv toView:(UIView *)tv isShow:(BOOL)isShow completion:(void (^)(void))completion {
    if (isShow) {
        tv.alpha = 0;
    } else {
        fv.alpha = 1;
    }
    [self animateFromView:fv toView:tv isShow:isShow animations:^{
        
        if (isShow) {
            tv.alpha = 1;
        } else {
            fv.alpha = 0;
        }
    } completion:^{
        if (completion) completion();
    }];
}
// 下拉菜单动画
- (void)animateDropListFromView:(UIView *)fv toView:(UIView *)tv isShow:(BOOL)isShow completion:(void (^)(void))completion {
    
    CGRect rect = self.alertView.frame;
    if (isShow) {
        tv.alpha = 0;
        self.alertView.frame = CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), 0, 0);
    } else {
        fv.alpha = 1;
    }
    [self animateFromView:fv toView:tv isShow:isShow animations:^{
        
        if (isShow) {
            tv.alpha = 1;
            self.alertView.frame = rect;
        } else {
            fv.alpha = 0;
            self.alertView.frame = CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), 0, 0);
        }
    } completion:^{
        if (completion) completion();
    }];
    
}
// 自定义动画
- (void)animateCustomFromView:(UIView *)fv toView:(UIView *)tv isShow:(BOOL)isShow completion:(void (^)(void))completion {
    if (self.animateBlock) self.animateBlock(isShow);
    [self animateFromView:fv toView:tv isShow:isShow animations:nil completion:^{
        if (completion) completion();
    }];
}


@end
