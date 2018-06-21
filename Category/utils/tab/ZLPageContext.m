//
//  ZLPageContext.m
//  Category
//
//  Created by long on 2018/4/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLPageContext.h"

@interface ZLPageContext ()

// delegate
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
@property (nonatomic, assign) BOOL transitionWasCancelled;

// privite property
@property (nonatomic, strong) ZLSlideAnimator *animator;

@end


@implementation ZLPageContext


#pragma mark - public method
// 无交互动画
- (void)startNonInteractiveTransitionWithDirection:(ZLSlideAnimatorDirection)direction {
    self.animator.direction = direction;
    [self.animator animateTransition:self];
}
// 交互动画
- (void)startInteractiveTransitionWithDirection:(ZLSlideAnimatorDirection)direction {
    
    self.animator.direction = direction;
    [self activateInteractiveTransition];
}

// 进行交互动画
- (void)activateInteractiveTransition {
    self.interactive = YES;
    self.transitionWasCancelled = NO;
    
    [self.pageCtrler addChildViewController:self.toCtrler];
    self.containerView.layer.speed = 0;
    [self.animator animateTransition:self];
    // 界面外的 视图 控制器 在completeTransition 方法中移除
}


#pragma mark - private method
- (void)_transitionEnd {
    
    if ([self.animator respondsToSelector:@selector(animationEnded:)]) {
        [self.animator animationEnded:!self.transitionWasCancelled];
    }
    
    if (self.transitionWasCancelled) {
        self.transitionWasCancelled = NO;
    }
}
// 动画取消时返回动画
- (void)handleReconversion:(CADisplayLink *)displayLink {
    
    CFTimeInterval timeOffset = self.containerView.layer.timeOffset - displayLink.duration;
    if (timeOffset > 0) {
        
        self.containerView.layer.timeOffset = timeOffset;
    } else {
        [displayLink invalidate];
        
        self.containerView.layer.timeOffset = 0;
        self.containerView.layer.speed = 1;
        
        // 解决闪屏问题 (截屏 短暂时间后删除)
        UIView *fakeFromView = [self.fromCtrler.view snapshotViewAfterScreenUpdates:NO];
        [self.containerView addSubview:fakeFromView];
        [self performSelector:@selector(removeFakeView:) withObject:fakeFromView afterDelay:1/60];
    }
}
- (void)removeFakeView:(UIView *)fakeView {
    [fakeView removeFromSuperview];
}


#pragma mark - delegate UIViewControllerContextTransitioning
// 动画完成  在update finish cancel 之后
- (void)completeTransition:(BOOL)didComplete {
    
    // 交互完成 移除离开界面的控制器 及视图
    if (didComplete) {
        // 交互完成
        [self.toCtrler didMoveToParentViewController:self.pageCtrler];
        [self.fromCtrler willMoveToParentViewController:nil];
        [self.fromCtrler.view removeFromSuperview];
        [self.fromCtrler removeFromParentViewController];
    } else {
        // 交互取消
        [self.toCtrler didMoveToParentViewController:self.pageCtrler];
        [self.toCtrler willMoveToParentViewController:nil];
        [self.toCtrler.view removeFromSuperview];
        [self.toCtrler removeFromParentViewController];
    }
    
    if (self.transitCompletionBlock) self.transitCompletionBlock(didComplete, didComplete ? self.toCtrler : self.fromCtrler);
    [self _transitionEnd];
}


// 交互相关
// 交互进度
- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    
    self.containerView.layer.timeOffset = (CFTimeInterval)percentComplete * (CFTimeInterval)[self.animator transitionDuration:self];
}

// 交互完成
- (void)finishInteractiveTransition {
    self.interactive = NO;
    
    CFTimeInterval pausedTime = self.containerView.layer.timeOffset;
    self.containerView.layer.speed = 1.0;
    self.containerView.layer.timeOffset = 0.0;
    self.containerView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.containerView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.containerView.layer.beginTime = timeSincePause;
}

// 交互取消 动画返回
- (void)cancelInteractiveTransition {
    self.interactive = NO;
    self.transitionWasCancelled = YES;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleReconversion:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


// 默认属性
- (UIModalPresentationStyle)presentationStyle {
    return UIModalPresentationCustom;
}
- (CGAffineTransform)targetTransform {
    return CGAffineTransformIdentity;
}
- (BOOL)isAnimated {
    return YES;
}
- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    return CGRectZero;
}
- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    return viewController.view.frame;
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        return self.toCtrler;
    } else if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromCtrler;
    } else {
        return nil;
    }
}
- (nullable __kindof UIView *)viewForKey:(nonnull UITransitionContextViewKey)key {
    if ([key isEqualToString:UITransitionContextFromViewKey]) {
        return self.fromCtrler.view;
    } else if ([key isEqualToString:UITransitionContextToViewKey]) {
        return self.toCtrler.view;
    }
    else {
        return nil;
    }
}


#pragma mark - property
- (ZLSlideAnimator *)animator {
    if (!_animator) {
        _animator = [ZLSlideAnimator new];
    }
    return _animator;
}


@end
