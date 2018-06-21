//
//  HintTool.m
//  Category
//
//  Created by long on 2018/2/1.
//  Copyright © 2018年 long. All rights reserved.
//

#import "HintTool.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface HintTool ()

@end


@implementation HintTool

+ (instancetype)sharedManager {
    static HintTool *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HintTool alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.hudSize = CGSizeMake(50, 50);
        self.delay = 1.5f;
    }
    return self;
}


#pragma mark -
#pragma mark - showloading
+ (void)showLoading {
    [[self sharedManager] showLoadingIn:[UIApplication sharedApplication].keyWindow text:nil animated:YES];
}
+ (void)showLoadingIn:(UIView *)view {
    [[self sharedManager] showLoadingIn:view text:nil animated:YES];
}
+ (void)showLoadingIn:(UIView *)view text:(NSString *)text {
    [[self sharedManager] showLoadingIn:view text:text animated:YES];
}
+ (void)showLoadingIn:(UIView *)view text:(NSString *)text animated:(BOOL)animated {
    [[self sharedManager] showLoadingIn:view text:text animated:animated];
}

#pragma mark - hide
+ (void)hide {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
+ (void)hideIn:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}
+ (void)hideIn:(UIView *)view animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:view animated:animated];
}

#pragma mark - showhint
+ (void)showHint {
    [[self sharedManager] showHintIn:[UIApplication sharedApplication].keyWindow hint:nil delay:0 animated:YES completion:nil];
}
+ (void)showHintWithText:(NSString *)text completion:(void (^)(void))completion {
    [[self sharedManager] showHintIn:[UIApplication sharedApplication].keyWindow hint:text delay:0 animated:YES completion:completion];
}
+ (void)showHintIn:(UIView *)view {
    [[self sharedManager] showHintIn:view hint:nil delay:0 animated:YES completion:nil];
}
+ (void)showHintIn:(UIView *)view hint:(NSString *)text completion:(void (^)(void))completion {
    [[self sharedManager] showHintIn:view hint:text delay:0 animated:YES completion:completion];
}
+ (void)showHintIn:(UIView *)view hint:(NSString *)text delay:(NSTimeInterval)delay animated:(BOOL)animated completion:(void (^)(void))completion {
    
    [[self sharedManager] showHintIn:view hint:text delay:delay animated:animated completion:completion];
}

#pragma mark - 
#pragma mark - private
- (void)showLoadingIn:(UIView *)view text:(NSString *)text animated:(BOOL)animated {
    MBProgressHUD *hud = [self currentHUDIn:view withText:text ? text : self.loadingText animated:animated];
    
    if (!self.animatedImages && !self.gifImage) return;
    
    UIImageView *animatedImageView;
    if (self.animatedImages) {
        animatedImageView = [[UIImageView alloc] init];
        animatedImageView.animationImages = self.animatedImages;
        animatedImageView.animationDuration = 1.5;
        [animatedImageView startAnimating];
    } else if (self.gifImage) {
        animatedImageView = [[UIImageView alloc] initWithImage:self.gifImage];
    }
    if (self.maskColor) hud.backgroundColor = self.maskColor;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = animatedImageView;
    hud.minSize = self.hudSize;
}
- (void)showHintIn:(UIView *)view hint:(NSString *)text delay:(NSTimeInterval)delay animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!text && !self.hintText) return;
    
    MBProgressHUD *hud = [self currentHUDIn:view withText:text ? text : self.hintText animated:animated];
    
    if (self.maskColor) hud.backgroundColor = [UIColor clearColor];
    if (completion) hud.completionBlock = completion;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:animated afterDelay:delay ? delay : self.delay];
}
- (MBProgressHUD *)currentHUDIn:(UIView *)view withText:(NSString *)text animated:(BOOL)animated {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        
        hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    }
    if (self.hudColor) hud.bezelView.color = self.hudColor;
    if (text) {
        hud.label.text = text;
    }
    
    return hud;
}

@end
