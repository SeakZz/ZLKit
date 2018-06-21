//
//  TestTableViewController.m
//  Category
//
//  Created by long on 2018/4/17.
//  Copyright © 2018年 long. All rights reserved.
//

#import "TestTableViewController.h"
#import "UITableView+ZLRefresh.h"
#import <MJRefresh/MJRefresh.h>

@interface TestTableViewController ()

@property (nonatomic, assign) NSUInteger count;


@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.rowHeight = 100;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData:YES completion:^(BOOL success, BOOL more) {
            [self.tableView reloadAndHeaderEndRefreshing];
        }];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData:NO completion:^(BOOL success, BOOL more) {
            [self.tableView reloadAndFooterEndRefreshingWithMore:YES];
        }];
    }];
    
    self.tableView.footerHideOffScreen = YES;
}

- (void)getData:(BOOL)refresh completion:(void (^)(BOOL success, BOOL more))completion {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//        BOOL suc = arc4random_uniform(2);
//        NSLog(@"%i", suc);
//
//        if (suc) {
            if (refresh) {
                self.count = 10;
            } else {
                self.count += 10;
            }
        completion(YES, YES);
//        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%li", indexPath.row];
    
    return cell;
}



@end
