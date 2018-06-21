//
//  ZLTabController.m
//  Category
//
//  Created by long on 2018/4/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLTabController.h"
#import "ZLPageContext.h"

@interface ZLTabController ()

@property (nonatomic, assign, readwrite) NSUInteger currentIndex;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) ZLPageContext *context;


/** 拖拽手势方向是否向右 (用来记录初始拖拽方向) */
@property (nonatomic, assign) BOOL panRight;

@end

@implementation ZLTabController

- (instancetype)init {
    if (self = [super init]) {
        self.initialIndex = 0;
        self.currentIndex = NSNotFound;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self setupInteractionGesture];
    
    __weak __typeof(self) ws = self;
    
    self.context.containerView = self.containerView;
    self.context.pageCtrler = self;
    self.context.transitCompletionBlock = ^(BOOL finish, UIViewController *currentCtrler) {
        
        NSUInteger idx = [ws.ctrlers indexOfObject:currentCtrler];
        if (!finish) {
            
            // 如果取消 重置index
            ws.currentIndex = idx;
        }
        if ([ws.delegate respondsToSelector:@selector(pageController:slideCompletedToIndex:)]) {
            [ws.delegate pageController:ws slideCompletedToIndex:idx];
        }
    };
    
    [self slideNonInteractiveToIndex:self.initialIndex animated:NO];
}


#pragma mark - public method
// 无交互跳转
- (void)scrollToIndex:(NSUInteger)idx animated:(BOOL)animated {
    [self slideNonInteractiveToIndex:idx animated:animated];
}

#pragma mark - private method
- (ZLSlideAnimatorDirection)transitionViewControllerFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx {
    UIViewController *fromVC = self.ctrlers[fromIdx];
    UIViewController *toVC = self.ctrlers[toIdx];
    
    self.context.fromCtrler = fromVC;
    self.context.toCtrler = toVC;
    ZLSlideAnimatorDirection direction = fromIdx > toIdx ? ZLSlideAnimatorDirectionLeft : ZLSlideAnimatorDirectionRight;
    
    self.currentIndex = toIdx;
    
    if ([self.delegate respondsToSelector:@selector(pageController:slideStartToIndex:)]) {
        [self.delegate pageController:self slideStartToIndex:self.currentIndex];
    }
    
    return direction;
}
// 交互
- (void)slideInteractiveToIndex:(NSInteger)idx {
    if (!self.ctrlers.count || self.currentIndex == idx || idx < 0 || idx > self.ctrlers.count || (self.currentIndex > self.ctrlers.count && self.currentIndex != NSNotFound)) {
        return;
    }
    
    ZLSlideAnimatorDirection direction = [self transitionViewControllerFromIndex:self.currentIndex toIndex:idx];
    [self.context startInteractiveTransitionWithDirection:direction];
}
// 非交互
- (void)slideNonInteractiveToIndex:(NSUInteger)idx animated:(BOOL)animated {
    
    if (self.currentIndex == idx) return;
    if (animated) {
        ZLSlideAnimatorDirection direction = [self transitionViewControllerFromIndex:self.currentIndex toIndex:idx];
        
        [self.context startNonInteractiveTransitionWithDirection:direction];
    }
    else {
        UIViewController *selVC = self.ctrlers[idx];
        [self addChildViewController:selVC];
        
        if (self.containerView.subviews.count) {
            [self.containerView.subviews.lastObject removeFromSuperview];
            [self.childViewControllers.lastObject removeFromParentViewController];
        }
        [self.containerView addSubview:selVC.view];
        [selVC didMoveToParentViewController:selVC];
        
        self.currentIndex = idx;
    }
}


#pragma mark - 交互手势
// 添加 交互手势 (左右滑动切换控制器)
- (void)setupInteractionGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}
// 交互方法
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGFloat translationX = [pan translationInView:self.view].x;
    CGFloat translationAbs = fabs(translationX);
    CGFloat progress = translationAbs / self.view.bounds.size.width;
    
    
    CGFloat velocityX = [pan velocityInView:self.view].x;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if (velocityX < 0) { //下一页
                if (self.currentIndex < self.ctrlers.count - 1) {
                    [self slideInteractiveToIndex:self.currentIndex + 1];
                }
            } else {
                if (self.currentIndex > 0) {
                    [self slideInteractiveToIndex:self.currentIndex - 1];
                }
            }
            // 记录初始滑动方向
            self.panRight = velocityX < 0;
            break;
        case UIGestureRecognizerStateChanged:
            
            // 没有找到更新转场的方法 只能在需要更新时停止滑动
            if ((translationX < 0 && !self.panRight) || (translationX > 0 && self.panRight)) {
                progress = 0;
            }
            [self.context updateInteractiveTransition:progress];
            
            if ([self.delegate respondsToSelector:@selector(pageController:slideProgress:)]) {
                [self.delegate pageController:self slideProgress:progress];
            }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
            if (progress > 0.5 || (fabs(velocityX) > 300 && ((self.panRight && velocityX < 0) || (!self.panRight && velocityX > 0)))) {
                [self.context finishInteractiveTransition];
            } else {
                [self.context cancelInteractiveTransition];
            }
            
            break;
            
        default:
            break;
    }
    
}


#pragma mark - property
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _containerView;
}
- (ZLPageContext *)context {
    if (!_context) {
        _context = [ZLPageContext new];
    }
    return _context;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
