//
//  AleViewController.m
//  Category
//
//  Created by long on 2018/1/17.
//  Copyright © 2018年 long. All rights reserved.
//

#import "AleViewController.h"
#import "AlertView.h"
#import "CollectiViewController.h"

@interface AleViewController () <UITableViewDelegate, UITableViewDataSource>



@end

@implementation AleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AlertView *av = [[[UINib nibWithNibName:@"AlertView" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
//    av.frame = CGRectMake(0, self.view.frame.size.height - 400, self.view.frame.size.width, 400);
    av.frame = CGRectMake(0, 0, 300, 200);
    av.center = self.view.center;
    
    __weak __typeof(self) ws = self;
    av.nextBlock = ^{
        CollectiViewController *nvc = [[CollectiViewController alloc] init];
        nvc.view.backgroundColor = [UIColor whiteColor];
        [ws.navigationController pushViewController:nvc animated:YES];
    };

    ZLPopupAnimator *animator = [ZLPopupAnimator new];
    animator.alertView = av;
//    animator.maskColor = [UIColor colorWithRgbaHex:0x00000044];
//    animator.maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    animator.style = PopupAnimatorStyleAlert;
    self.animator = animator;
    
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(300, 80, 100, 220) style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    ZLPopupAnimator *animator = [ZLPopupAnimator new];
//    animator.alertView = tableView;
//    animator.style = PopupAnimatorStyleDropList;
//    animator.maskColor = [UIColor clearColor];
//    self.animator = animator;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

@end
