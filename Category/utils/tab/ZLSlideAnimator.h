//
//  ZLSlideAnimator.h
//  Category
//
//  Created by long on 2018/4/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZLSlideAnimatorDirection) {
    ZLSlideAnimatorDirectionRight,
    ZLSlideAnimatorDirectionLeft
};

@interface ZLSlideAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ZLSlideAnimatorDirection direction;


@end
