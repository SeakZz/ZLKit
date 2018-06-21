//
//  ZLAlertController.m
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLAlertController.h"
#import "ZLPopupAnimator.h"

@interface ZLAlertController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL shouldDismiss;

@end

@implementation ZLAlertController

+ (instancetype)alertControllerWithAnimator:(ZLPopupAnimator *)animator {
    ZLAlertController *alert = [[self alloc] init];
    alert.animator = animator;
    
    return alert;
}

- (instancetype)init {
    if (self = [super init]) {
        // 当 UIViewController 的modalPresentationStyle属性为.Custom 或.FullScreen时，我们就有机会定制转场效果，此时modalTransitionStyle指定的转场动画将会被忽略。
        // 保持 presentingView 可见
        // 或者 UIModalPresentationCustom
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    if (!self.navigationController) {
        self.transitioningDelegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController && self.navigationController.viewControllers.count != 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (self.navigationController) {
        self.navigationController.transitioningDelegate = self;
        self.navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [self.navigationController setNavigationBarHidden:YES];
    }
}

#pragma makr - setter
- (void)setAnimator:(ZLPopupAnimator *)animator {
    _animator = animator;
    
    if (animator.alertView) {
        [self.view addSubview:self.animator.alertView];
    }
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint p = [[touches anyObject] locationInView:self.view];
    if (!CGRectContainsPoint(self.animator.alertView.frame, p)) {
        self.shouldDismiss = YES;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.shouldDismiss = NO;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint p = [[touches anyObject] locationInView:self.view];
    if (!CGRectContainsPoint(self.animator.alertView.frame, p) && self.shouldDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    if (self.navigationController) self.view.backgroundColor = self.view.backgroundColor;
    return self.animator;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self.animator;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
