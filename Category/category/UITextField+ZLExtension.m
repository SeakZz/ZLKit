//
//  UITextField+ZLExtension.m
//  Category
//
//  Created by long on 2018/2/5.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UITextField+ZLExtension.h"
#import <objc/runtime.h>

@implementation UITextField (ZLExtension)


#pragma mark -
#pragma mark - 解决iOS11 textfield不释放问题
- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (@available(iOS 11.0, *)) {
        NSString *keyPath = @"textContentView.provider";
        @try {
            if (self.window) {
                id provider = [self valueForKeyPath:keyPath];
                if (!provider && self) {
                    [self setValue:self forKeyPath:keyPath];
                }
            } else {
                [self setValue:nil forKeyPath:keyPath];
            }
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
}

#pragma mark - private
- (void)zl_dealloc {
    if (objc_getAssociatedObject(self, @selector(wordLimit))) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    }
    [self zl_dealloc];
}


- (void)zl_handleTextChanged:(NSNotification *)noti {
    UITextField *textField = (UITextField *)noti.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.wordLimit) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.wordLimit];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:self.wordLimit];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.wordLimit)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


#pragma mark - property
- (NSUInteger)wordLimit {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)setWordLimit:(NSUInteger)wordLimit {
    if (!objc_getAssociatedObject(self, @selector(wordLimit))) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zl_handleTextChanged:) name:UITextFieldTextDidChangeNotification object:self];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Method original_dealloc = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
            Method swizzled_dealloc = class_getInstanceMethod([self class], @selector(zl_dealloc));
            
            method_exchangeImplementations(original_dealloc, swizzled_dealloc);
        });
    }
    
    objc_setAssociatedObject(self, @selector(wordLimit), @(wordLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (!self.placeholder) self.placeholder = @" ";
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake([[self valueForKey:@"paddingTop"] floatValue], [[self valueForKey:@"paddingLeft"] floatValue], [[self valueForKey:@"paddingBottom"] floatValue], [[self valueForKey:@"paddingRight"] floatValue]);
}
- (void)setContentInset:(UIEdgeInsets)contentInset {
    [self setValue:@(contentInset.top) forKey:@"paddingTop"];
    [self setValue:@(contentInset.left) forKey:@"paddingLeft"];
    [self setValue:@(contentInset.bottom) forKey:@"paddingBottom"];
    [self setValue:@(contentInset.right) forKey:@"paddingRight"];
}

@end
