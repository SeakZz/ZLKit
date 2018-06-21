//
//  ZLPageController.m
//  Category
//
//  Created by long on 2018/4/13.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLPageController.h"

@interface ZLPageController () <UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) NSUInteger currentIndex;

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *pan;

@end

@implementation ZLPageController


- (instancetype)init {
    if (self = [super init]) {
        self.initialIndex = 0;
        self.currentIndex = NSNotFound;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.initialIndex = 0;
        self.currentIndex = NSNotFound;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    self.pan = self.containerView.panGestureRecognizer;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 解决横屏变竖屏contentsize变短导致 调scrollviewdidscroll时contentsize不正确问题
    self.containerView.contentOffset = CGPointZero;
    
    self.containerView.contentSize = CGSizeMake(self.ctrlers.count * CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.containerView.frame = self.view.bounds;
    [self scrollToIndex:self.currentIndex == NSNotFound ? self.initialIndex : self.currentIndex animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - subclass override
- (void)scrollCompletedToIndex:(NSUInteger)idx NS_REQUIRES_SUPER {
    
    if ([self.delegate respondsToSelector:@selector(pageController:scrollCompletedToIndex:)]) {
        [self.delegate pageController:self scrollCompletedToIndex:idx];
    }
}
- (void)scrollProgressWhenScrolling:(CGFloat)progress NS_REQUIRES_SUPER {
    
    if ([self.delegate respondsToSelector:@selector(pageController:scrollProgress:)]) {
        [self.delegate pageController:self scrollProgress:progress];
    }
}
- (void)startToScroll NS_REQUIRES_SUPER {
    
    if ([self.delegate respondsToSelector:@selector(scrollStartInPageController:)]) {
        [self.delegate scrollStartInPageController:self];
    }
}


#pragma mark - public method
- (void)scrollToIndex:(NSUInteger)idx animated:(BOOL)animated {
    [self.containerView setContentOffset:CGPointMake(idx * CGRectGetWidth(self.view.bounds), 0) animated:animated];
    
    if (!animated) {
        // 添加新视图
        // setcontentoffset 会调用scrollviewdidscroll 添加
        
        // 删除原视图
        if (self.currentIndex != NSNotFound && self.currentIndex != idx) {
            UIViewController *oldCtrler = self.ctrlers[self.currentIndex];
            [self removePageViewWithController:oldCtrler];
        }
        
        self.currentIndex = idx;
        
        // 无动画转场完成
        [self scrollCompletedToIndex:idx];
    }
}


#pragma mark - private method
// 把视图添加到容器视图中
- (void)addPageViewWithController:(UIViewController *)ctrler {
    /*
     当我们调用addChildViewController方法时，在添加子视图控制器之前将自动调用willMoveToParentViewController方法。所以，就不需要我们显示调用了。
     */
    [self addChildViewController:ctrler];
    
    [self.containerView addSubview:ctrler.view];
    /*
     当我们向我们的视图控制器容器（就是父视图控制器，它调用addChildViewController方法加入子视图控制器，它就成为了视图控制器的容器）中添加（或者删除）子视图控制器后，必须调用didMoveToParentViewController方法，告诉iOS，已经完成添加（或删除）子控制器的操作。
     */
    // didMoveToParentViewController 需要动画完成调用
}
// 把视图在容器视图移除
- (void)removePageViewWithController:(UIViewController *)ctrler {
    [ctrler.view removeFromSuperview];
    /*
     当我们向我们的视图控制器容器中调用removeFromParentViewController方法时，必须要先调用该方法，且parent参数为nil
     */
    [ctrler willMoveToParentViewController:nil];
    /*
     removeFromParentViewController 方法会自动调用了didMoveToParentViewController方法，所以，删除子控制器后，不需要在显示的调用该方法了
     */
    [ctrler removeFromParentViewController];
}
// 动画结束时的索引
- (NSUInteger)indexWithContentOffsetX:(CGFloat)offsetX {
    return offsetX / CGRectGetWidth(self.view.bounds);
}
// 动画结束 移除所有不再显示的 view 并更新idx
- (void)removeAllShowedViewAfterAnimationWithCurrentIndex:(NSUInteger)newIdx {
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != self.ctrlers[self.currentIndex]) {
            [obj didMoveToParentViewController:self];
        }
        if (obj != self.ctrlers[newIdx]) {
            [self removePageViewWithController:obj];
        }
    }];
    
    self.currentIndex = newIdx;
}
- (void)addNonShowedPageViewWithIndex:(NSUInteger)idx {
    
    UIViewController *ctrler = self.ctrlers[idx];
    
    // 判断是否已显示
    if (![self.childViewControllers containsObject:ctrler]) {
        
        // 判断视图是否加载过
        if (!ctrler.viewLoaded) {

            ctrler.view.frame = (CGRect) {
                .origin = CGPointMake(idx * CGRectGetWidth(self.view.bounds), 0),
                .size = self.view.bounds.size
            };
        }
        
        [self addPageViewWithController:ctrler];
    }
    
    // 判断屏幕翻转 更新frame
    if (!CGRectEqualToRect(self.view.bounds, ctrler.view.bounds)) {
        ctrler.view.frame = (CGRect) {
            .origin = CGPointMake(idx * CGRectGetWidth(self.view.bounds), 0),
            .size = self.view.bounds.size
        };
    }
}

#pragma mark - scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollProgressWhenScrolling:scrollView.contentOffset.x / (scrollView.contentSize.width - CGRectGetWidth(self.view.bounds))];
    
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - CGRectGetWidth(self.view.bounds)) {
        return;
    }
    
    CGFloat i = scrollView.contentOffset.x / CGRectGetWidth(self.view.bounds);
    NSUInteger idx = i;
    
    
    // 添加所有显示的视图 (判断是否屏幕会显示两页)
    [self addNonShowedPageViewWithIndex:idx];
    if (i != idx) {
        [self addNonShowedPageViewWithIndex:idx + 1];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self startToScroll];
}

// interactive animation completed  交互动画专场完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger newIdx = [self indexWithContentOffsetX:scrollView.contentOffset.x];
    [self removeAllShowedViewAfterAnimationWithCurrentIndex:newIdx];
    
    [self scrollCompletedToIndex:newIdx];
}
// noninteractive animation completed  非交互动画转场完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ((NSInteger)scrollView.contentOffset.x % (NSInteger)CGRectGetWidth(self.view.bounds) != 0) return;
    
    NSUInteger newIdx = [self indexWithContentOffsetX:scrollView.contentOffset.x];
    [self removeAllShowedViewAfterAnimationWithCurrentIndex:newIdx];
    
    [self scrollCompletedToIndex:newIdx];
}

#pragma mark - property
- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] init];
        _containerView.contentOffset = CGPointZero;
        _containerView.delegate = self;
        _containerView.pagingEnabled = YES;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.backgroundColor = [UIColor whiteColor];
        
        _containerView.scrollsToTop = NO;
    }
    return _containerView;
}


@end
