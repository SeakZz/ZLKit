//
//  ViewController.m
//  Category
//
//  Created by long on 2018/1/3.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ViewController.h"
#import "ZLAlertController.h"
#import "AlertView.h"
#import "AleViewController.h"
#import "ZLSegmentedTabController.h"
#import "ZLSegmentedPageController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tv.wordLimit = 10;
//    self.tv.containerInsetZero = YES;
//    self.tv.tintColor = [UIColor clearColor];
    
    
    __weak __typeof(self) ws = self;
    [self.view addTapGestureRecognizerWithAction:^(UITapGestureRecognizer *tap) {
        NSLog(@"123");
        [ws.view endEditing:YES];
    }];
    
    
    self.view.backgroundColor = [UIColor colorWithRgbHex:0x00ff00];
    
//    NSMutableArray *imageArr = [NSMutableArray array];
//    for (int i = 1; i<16; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%02d",i+1]];
//        [imageArr addObject:image];
//    }
//    [HintTool sharedManager].animatedImages = imageArr;
    [HintTool sharedManager].hudColor = [UIColor colorWithRed:111/255.f green:96/255.f blue:86/255.f alpha:.9];
    [HintTool sharedManager].hudSize = CGSizeMake(50, 50);
    [HintTool sharedManager].loadingText = @"123";
    [HintTool sharedManager].hintText = @"等待";
//    [HintTool sharedManager].maskColor = [UIColor colorWithWhite:0 alpha:0.3];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"carGif" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [HintTool sharedManager].gifImage = [UIImage sd_animatedGIFWithData:data];
    
    
//    UILabel *l = [[UILabel alloc] init];
//    l.text = @"1是的浪费科技时代六块腹肌的酸辣粉";
//    l.numberOfLines = 0;
//    l.contentInset = UIEdgeInsetsMake(20, 20, 0, 0);
//    l.backgroundColor = [UIColor whiteColor];
//    [l sizeToFitWithMaxWidth:100];
//    l.center = self.view.center;
//    [self.view addSubview:l];
    
//    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
//    v.center = self.view.center;
//    [self.view addSubview:v];
//
//    v.image = [[UIImage imageNamed:@"rb.jpg"] boxblurImageWithBlur:0.5];
    
    
    [self.nextBtn setImage:[[UIImage imageNamed:@"reba"] drawImage:CGSizeMake(20, 20)] title:@"下一步" gap:0 location: UIButtonContentLocationNormal];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (IBAction)btn:(id)sender {
    
    
//    [sender setBadge:YES withRect:CGRectMake(((UIButton *)sender).bounds.size.width, 0, 9, 9)];
    
//    [HintTool showLoading];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [HintTool hide];
//            [HintTool showHintWithText:@"完成" completion:^{
//                NSLog(@"1");
//            }];
//        });
//    });
    
//    NSLog(@"%i", [RegexTool isMobilePhoneNumber:self.tf.text]);
//
//    NSArray<NSTextCheckingResult *> *arr = [RegexTool resultsOfTopic:@"#sdfdsf#sdf wer@489#lsdkjf#"];
//    [arr enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@", NSStringFromRange(obj.range));
//    }];
//
//
    
    
    AleViewController *vc = [[AleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    
//    AlertView *av = [[[UINib nibWithNibName:@"AlertView" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
//    av.frame = CGRectMake(0, self.view.frame.size.height - 400, self.view.frame.size.width, 400);
//    ZLPopupAnimator *animator = [ZLPopupAnimator new];
//    animator.alertView = av;
//    ZLAlertController *vc = [ZLAlertController alertControllerWithAnimator:animator];
//    av.nextBlock = ^{
//        [self dismissViewControllerAnimated:YES completion:^{
//            UIViewController *nvc = [[UIViewController alloc] init];
//            nvc.view.backgroundColor = [UIColor whiteColor];
//            [self.navigationController pushViewController:nvc animated:YES];
//        }];
//    };
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
