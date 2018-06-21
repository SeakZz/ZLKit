//
//  ZLSegmentedPageController.m
//  Category
//
//  Created by long on 2018/4/13.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLSegmentedPageController.h"
#import "ZLPageTabView.h"
#import "NSString+ZLSize.h"
#import "UIView+ZLFrame.h"

@interface ZLSegmentedPageController ()

@property (nonatomic, strong) ZLPageTabView *segmentView;

@end

@implementation ZLSegmentedPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.segmentView];
    
    __weak __typeof(self) ws = self;
    self.segmentView.itemSelectedBlock = ^(NSUInteger idx) {
        __strong __typeof(ws) ss = ws;
        
        if (idx == ss.currentIndex) return ;
        [ss scrollToIndex:idx animated:ss.itemSelectAnimated];
        
        // 防止没有滚动到的item 显示高亮状态
        [ss.segmentView reloadData];
    };
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.segmentView.frame = CGRectMake(0, self.navigationController ? CGRectGetMaxY(self.navigationController.navigationBar.frame) : 0, CGRectGetWidth(self.view.bounds), ZLSegmentedPageControllerSegmentHeight);
    
    // 解决 父类问题 (解决横屏变竖屏contentsize变短导致 调scrollviewdidscroll时contentsize不正确问题) 时没有滚动到的item 显示高亮状态
    [self.segmentView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override
- (void)scrollCompletedToIndex:(NSUInteger)idx NS_REQUIRES_SUPER {
    [super scrollCompletedToIndex:idx];
    
    [self.segmentView scrollKeepCellPositionCenterToIndex:idx];
    self.segmentView.currentIndex = idx;
}
- (void)scrollProgressWhenScrolling:(CGFloat)progress NS_REQUIRES_SUPER {
    [super scrollProgressWhenScrolling:progress];
    
    if (progress < 0 || progress > 1) return;
    
    if (self.segmentStyle & ZLSegmentValueChangedStyleLine) {
        [self adjustPositionOfSelectedLineWithProgress:progress];
    }
    if (self.segmentStyle & ZLSegmentValueChangedStyleColor) {
        [self updateColorWhenValueChangedWithProgress:progress];
    }
    if (self.segmentStyle & ZLSegmentValueChangedStyleFont) {
        [self updateFontWhenValueChangedWithProgress:progress];
    }
}
- (void)startToScroll NS_REQUIRES_SUPER {
    [super startToScroll];
}

#pragma mark - private method
- (NSArray *)titlesOfControllers:(NSArray<UIViewController *> *)ctrlers {
    NSMutableArray *titles = [NSMutableArray array];
    [ctrlers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.title];
    }];
    return titles;
}
- (NSArray *)widthsOfTitles:(NSArray<NSString *> *)titles itemDivideEqually:(BOOL)equal {
    NSMutableArray *widths = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (equal) {
            [widths addObject:@(CGRectGetWidth(self.view.bounds) / titles.count)];
        } else {
            [widths addObject:@([obj sizeWithCustomFont:self.normalFont ?: [UIFont systemFontOfSize:ZLPageTabCellTitleFontSize]].width + ZLSegmentedPageControllerSegmentItemSpace)];
        }
    }];
    return widths;
}

// 根据进度调整选中线位置
- (void)adjustPositionOfSelectedLineWithProgress:(CGFloat)progress {
    
    CGFloat fidx = progress / (1.0 / (self.ctrlers.count - 1));
    NSUInteger idx = fidx;
    CGFloat x = [self.segmentView.widths.firstObject floatValue] / 2;
    if (idx != 0) {
        for (int i = 0; i < self.ctrlers.count; i ++) {
            if (i <= idx) {
                if (i == 0) {
                    x += [self.segmentView.widths[i] floatValue] / 2;
                } else if (idx == i) {
                    x += [self.segmentView.widths[i] floatValue] / 2;
                } else {
                    x += [self.segmentView.widths[i] floatValue];
                }
            } else {
                break;
            }
        }
    }
    if (idx != fidx) {
        x += ([self.segmentView.widths[idx] floatValue] / 2 + [self.segmentView.widths[idx + 1] floatValue] / 2) * (progress - idx * (1.0 / (self.ctrlers.count - 1))) * (self.ctrlers.count - 1);
    }
    
    [self.segmentView setLineCenterX:x];
}
// 根据进度改变标题颜色
- (void)updateColorWhenValueChangedWithProgress:(CGFloat)progress {
    
    NSUInteger idx = progress / (1.0 / (self.ctrlers.count - 1));
    CGFloat pro = (progress - idx * (1.0 / (self.ctrlers.count - 1))) * (self.ctrlers.count - 1);
    
    [self.segmentView setColorChangedWithIndex:idx progress:pro];
}
// 根据进度改变标题字体
- (void)updateFontWhenValueChangedWithProgress:(CGFloat)progress {
    
    NSUInteger idx = progress / (1.0 / (self.ctrlers.count - 1));
    CGFloat pro = (progress - idx * (1.0 / (self.ctrlers.count - 1))) * (self.ctrlers.count - 1);
    
    [self.segmentView setFontChangedWithIndex:idx progress:pro];
}

#pragma mark - setter
- (void)setTitles:(NSArray *)titles {
    _titles = [titles copy];
    
    self.segmentView.titles = _titles;
    self.segmentView.widths = [self widthsOfTitles:_titles itemDivideEqually:self.itemDivideEqually];
}
- (void)setCtrlers:(NSArray<__kindof UIViewController *> *)ctrlers {
    [super setCtrlers:ctrlers];
    
    if (!self.titles) {
        NSMutableArray *titles = [NSMutableArray array];
        [ctrlers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.title];
        }];
        self.titles = [titles copy];
    }
}
- (void)setItemDivideEqually:(BOOL)itemDivideEqually {
    _itemDivideEqually = itemDivideEqually;
    
    if (itemDivideEqually && self.titles) {
        self.segmentView.widths = [self widthsOfTitles:_titles itemDivideEqually:YES];
    }
}
- (void)setSegmentStyle:(ZLSegmentValueChangedStyle)segmentStyle {
    _segmentStyle = segmentStyle;
    
    self.segmentView.style = segmentStyle;
}
- (void)setInitialIndex:(NSUInteger)initialIndex {
    [super setInitialIndex:initialIndex];
    
    self.segmentView.currentIndex = initialIndex;
}
- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    
    self.segmentView.bottomLineColor = bottomLineColor;
}
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    
    self.segmentView.titleColor = normalColor;
}
- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    
    self.segmentView.selectedTitleFont = selectedFont;
}
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    
    self.segmentView.selectedTitleColor = selectedColor;
    self.segmentView.lineColor = selectedColor;
}


#pragma mark - property
- (ZLPageTabView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[ZLPageTabView alloc] init];
    }
    return _segmentView;
}

@end
