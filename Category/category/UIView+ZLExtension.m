//
//  UIView+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIView+ZLExtension.h"
#import <objc/runtime.h>

@implementation UIView (ZLExtension)

+ (instancetype)nibView {
    
    NSString *clsName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:clsName bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:nil options:nil];
    return [objects objectAtIndex:0];
}


#pragma mark - shadow
- (void)addRoundedShadow{
    [self addShadowWithColor:[UIColor grayColor]
                      offset:CGSizeMake(2, 2)
                     opacity:0.5
                shadowRadius:2
                cornerRadius:self.bounds.size.width / 2];
}
- (void)addRectangleShadow {
    [self addShadowWithColor:[UIColor grayColor]
                      offset:CGSizeMake(2, 2)
                     opacity:0.5
                shadowRadius:2
                cornerRadius:0];
}

- (void)addShadowWithColor:(UIColor *)color
                    offset:(CGSize)offset
                   opacity:(CGFloat)opacity
              shadowRadius:(CGFloat)shadowRadius
              cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = shadowRadius;
    UIBezierPath *path;
    if (cornerRadius) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    } else {
        path = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    [self.layer setShadowPath:path.CGPath];
}


#pragma mark - badge
- (void)setBadge:(BOOL)show withRect:(CGRect)rect {
    UIView *badgeView = (UIView *)[self viewWithTag:'badg'];
    
    if (!badgeView && show) {
        badgeView = [[UIView alloc] init];
        badgeView.tag = 'badg';
        badgeView.frame = rect;
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.layer.cornerRadius = rect.size.width / 2;
        [self addSubview:badgeView];
    }
    
    badgeView.hidden = !show;
}


- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


#pragma mark - gesturerecognizer
- (void)addTapGestureRecognizerWithAction:(void (^)(UITapGestureRecognizer *tap))action {
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zl_handleTap:)];
    [self addGestureRecognizer:tap];
    if (action) self.zl_tapBlock = action;
}
- (void)zl_handleTap:(UITapGestureRecognizer *)tap {
    if (self.zl_tapBlock) self.zl_tapBlock(tap);
}
- (void (^)(UITapGestureRecognizer *tap))zl_tapBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setZl_tapBlock:(void (^)(UITapGestureRecognizer *))zl_tapBlock {
    objc_setAssociatedObject(self, @selector(zl_tapBlock), zl_tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
