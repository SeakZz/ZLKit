//
//  ZLSlideAnimator.m
//  Category
//
//  Created by long on 2018/4/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLSlideAnimator.h"

// page 间距离
static CGFloat const kChildViewPadding = 0;

@implementation ZLSlideAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    
    CGFloat translation = CGRectGetWidth(containerView.frame) + kChildViewPadding;
    
    translation = self.direction ==  ZLSlideAnimatorDirectionLeft ? translation : -translation;
    
    CGAffineTransform toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
    CGAffineTransform fromViewTransform =  CGAffineTransformMakeTranslation(translation, 0);
    
    [containerView addSubview:toView];
    
    toView.transform = toViewTransform;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.transform = fromViewTransform;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        toView.transform = CGAffineTransformIdentity;
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
