//
//  UILabel+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/26.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UILabel+ZLExtension.h"
#import <objc/runtime.h>

@implementation UILabel (ZLExtension)


#pragma mark - animate
- (void)animateToFont:(UIFont *)font {
    if ([self.font isEqual:font]) return;
    
    CGFloat scale = self.font.lineHeight / font.lineHeight;
    self.transform = CGAffineTransformScale(self.transform, scale , scale);
    
    self.font = font;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformScale(self.transform, 1/scale, 1/scale);
    }];
}

#pragma mark -
#pragma mark - content
- (CGSize)sizeOfLabel {
    return [self sizeOfLabelWithMaxWidth:0];
}
- (CGSize)sizeOfLabelWithMaxWidth:(CGFloat)width {
    CGSize s;
    CGSize maxSize = CGSizeMake(width ? width - self.contentInset.left - self.contentInset.right : FLT_MAX, FLT_MAX);
    NSDictionary *attrs = @{NSFontAttributeName : self.font};
    
    if (!self.numberOfLines) {
        s = [self.text
             boundingRectWithSize:maxSize
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:attrs
             context:nil].size;
    } else {
        NSMutableString *insteadString = [NSMutableString string];
        if (width) {
            for (int i = 0; i < self.numberOfLines - 1; i ++) {
                [insteadString appendString:@"\n"];
            }
        } else {
            insteadString = [self.text mutableCopy];
        }
        s = [insteadString
             boundingRectWithSize:maxSize
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:attrs
             context:nil].size;
    }
    s = CGSizeMake(width ? width : s.width + self.contentInset.left + self.contentInset.right, s.height + self.contentInset.top + self.contentInset.bottom);
    return s;
}

- (void)sizeToFitWithCurrentContentInset {
    [self sizeToFitWithMaxWidth:0];
}
- (void)sizeToFitWithMaxWidth:(CGFloat)width {
    CGSize s = [self sizeOfLabelWithMaxWidth:width];
    self.frame = (CGRect) {
        .origin = self.frame.origin,
        .size = s
    };
}

- (void)zl_drawTextInRect:(CGRect)rect {

    if (objc_getAssociatedObject(self, @selector(contentInset))) {
        
        [self zl_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInset)];
    } else {
        [self zl_drawTextInRect:rect];
    }
}


#pragma mark - property
- (UIEdgeInsets)contentInset {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}
- (void)setContentInset:(UIEdgeInsets)contentInset {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method original_draw = class_getInstanceMethod([self class], @selector(drawTextInRect:));
        Method swizzled_draw = class_getInstanceMethod([self class], @selector(zl_drawTextInRect:));
        
        method_exchangeImplementations(original_draw, swizzled_draw);
    });
    
    objc_setAssociatedObject(self, @selector(contentInset), [NSValue valueWithUIEdgeInsets:contentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
