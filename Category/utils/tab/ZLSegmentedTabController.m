//
//  ZLSegmentedTabController.m
//  Category
//
//  Created by long on 2018/4/11.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLSegmentedTabController.h"
#import "ZLPageTabView.h"

@interface ZLSegmentedTabController () <ZLTabControllerDelegate>

@property (nonatomic, strong) ZLPageTabView *segmentView;

@property (nonatomic, assign, readwrite) NSUInteger currentIndex;

@end

@implementation ZLSegmentedTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.segmentView];
    
    __weak __typeof(self) ws = self;
    
    self.segmentView.titles = self.titles;
    self.segmentView.currentIndex = self.initialIndex;
    self.segmentView.itemSelectedBlock = ^(NSUInteger idx) {
        
        if (idx == self.currentIndex) return ;
        [ws scrollToIndex:idx animated:ws.itemSelectAnimated];
        ws.currentIndex = idx;
    };
    
    self.itemSelectAnimated = YES;
    self.delegate = self;
}


#pragma mark - delegate
- (void)pageController:(ZLTabController *)pageCtrler slideStartToIndex:(NSUInteger)idx {
    self.segmentView.userInteractionEnabled = NO;
}
- (void)pageController:(ZLTabController *)pageCtrler slideCompletedToIndex:(NSUInteger)idx {
    self.segmentView.userInteractionEnabled = YES;
}
- (void)pageController:(ZLTabController *)pageCtrler slideProgress:(CGFloat)progress {
    NSLog(@"%f", progress);
}

#pragma mark - property
@dynamic currentIndex;
- (ZLPageTabView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[ZLPageTabView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    }
    return _segmentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
