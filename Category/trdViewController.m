//
//  trdViewController.m
//  Category
//
//  Created by long on 2018/2/8.
//  Copyright © 2018年 long. All rights reserved.
//

#import "trdViewController.h"
#import "CustomTF.h"

@interface trdViewController ()
@property (strong, nonatomic) CustomTF *tf;
@property (nonatomic, strong) UITextView *tv;

@end

@implementation trdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tf = [[CustomTF alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    self.tf.wordLimit = 10;
    [self.view addSubview:self.tf];
    
    self.tv = [[UITextView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [self.view addSubview:self.tv];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
