//
//  SegmentViewController.m
//  Category
//
//  Created by long on 2018/4/15.
//  Copyright © 2018年 long. All rights reserved.
//

#import "SegmentViewController.h"
#import "CustomTableViewController.h"

@interface SegmentViewController ()

@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 3 * 2)];
    iv.image = [UIImage imageNamed:@"reba"];
//    self.headerView = iv;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        CustomTableViewController *vc = [[CustomTableViewController alloc] init];
        if (i == 1) {
            vc.title = [NSString stringWithFormat:@"titletitle-%i", i];
        } else {
            vc.title = [NSString stringWithFormat:@"title-%i", i];
        }
        [arr addObject:vc];
    }
    
    self.initialIndex = 2;
    self.ctrlers = arr;
    
//    self.titles = @[@"1", @"2", @"3", @"4"];
//    self.selectedColor = [UIColor greenColor];
//    self.bottomLineColor = [UIColor groupTableViewBackgroundColor];
    self.segmentStyle = ZLSegmentValueChangedStyleFont | ZLSegmentValueChangedStyleLine | ZLSegmentValueChangedStyleColor;
//    self.itemDivideEqually = YES;
//    self.itemSelectAnimated = YES;
//    self.normalColor = [UIColor blueColor];
//    self.normalFont = [UIFont systemFontOfSize:15];
//    self.selectedFont = [UIFont systemFontOfSize:20];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"titi" style:UIBarButtonItemStylePlain target:self action:@selector(hancleright)];
}
- (void)hancleright {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
