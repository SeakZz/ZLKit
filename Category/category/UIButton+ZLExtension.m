//
//  UIButton+ZLExtension.m
//  Category
//
//  Created by long on 2018/2/7.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIButton+ZLExtension.h"
#import <objc/runtime.h>

@implementation UIButton (ZLExtension)

- (void)setImage:(UIImage *)image title:(NSString *)title gap:(CGFloat)gap location:(UIButtonContentLocation)location {
    
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    
    if (location == UIButtonContentLocationNormal) {
        if (gap) {
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, -gap / 2, 0, gap / 2)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, gap / 2, 0, -gap / 2)];
        }
    } else if (location == UIButtonContentLocationReverse) {
        
        [self.titleLabel sizeToFit];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + gap / 2, 0, -(self.titleLabel.bounds.size.width + gap / 2))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.imageView.bounds.size.width + gap / 2), 0, self.imageView.bounds.size.width + gap / 2)];
    }
}


- (void)zl_handleTouchUpInside:(UIButton *)btn {
    if (self.touchUpInsideBlock) self.touchUpInsideBlock();
}

#pragma mark - property
- (void (^)(void))touchUpInsideBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTouchUpInsideBlock:(void (^)(void))touchUpInsideBlock {

    objc_setAssociatedObject(self, @selector(touchUpInsideBlock), touchUpInsideBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (self.touchUpInsideBlock) {
        [self addTarget:self action:@selector(zl_handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
