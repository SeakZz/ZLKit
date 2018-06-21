//
//  ZLAlertController.h
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPopupAnimator.h"

@interface ZLAlertController : UIViewController

+ (instancetype)alertControllerWithAnimator:(ZLPopupAnimator *)animator;

@property (nonatomic, strong) ZLPopupAnimator *animator;

@end
