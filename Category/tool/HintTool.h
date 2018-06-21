//
//  HintTool.h
//  Category
//
//  Created by long on 2018/2/1.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HintTool : NSObject

+ (instancetype)sharedManager;

/** hud背景色 */
@property (nonatomic, strong) UIColor *hudColor;
/** 蒙版背景色 */
@property (nonatomic, strong) UIColor *maskColor;
/** hud最小大小 */
@property (nonatomic, assign) CGSize hudSize;

/** 加载时显示的文字 */
@property (nonatomic, copy) NSString *loadingText;
/** 设置多图实现动画 */
@property (nonatomic, strong) NSArray *animatedImages;
/** gif图实现动画 */
@property (nonatomic, strong) UIImage *gifImage;
/** 展示加载视图 */
+ (void)showLoading;
+ (void)showLoadingIn:(UIView *)view;
+ (void)showLoadingIn:(UIView *)view text:(NSString *)text;
+ (void)showLoadingIn:(UIView *)view text:(NSString *)text animated:(BOOL)animated;

/** 隐藏 */
+ (void)hide;
+ (void)hideIn:(UIView *)view;
+ (void)hideIn:(UIView *)view animated:(BOOL)animated;


/** 提示持续时间 */
@property (nonatomic, assign) NSTimeInterval delay;
/** 提示文字 */
@property (nonatomic, copy) NSString *hintText;
/** 展示提示文字 */
+ (void)showHint;
+ (void)showHintWithText:(NSString *)text completion:(void (^)(void))completion;
+ (void)showHintIn:(UIView *)view;
+ (void)showHintIn:(UIView *)view hint:(NSString *)text completion:(void (^)(void))completion;
+ (void)showHintIn:(UIView *)view hint:(NSString *)text delay:(NSTimeInterval)delay animated:(BOOL)animated completion:(void (^)(void))completion;


@end
