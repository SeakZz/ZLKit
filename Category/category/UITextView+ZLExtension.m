//
//  UITextView+ZLExtension.m
//  Category
//
//  Created by long on 2018/2/5.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UITextView+ZLExtension.h"
#import <objc/runtime.h>

@implementation UITextView (ZLExtension)


- (void)zl_dealloc {
    if (objc_getAssociatedObject(self, @selector(wordLimit))) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    }
    [self zl_dealloc];
}


- (void)zl_handleTextChanged:(NSNotification *)noti {
    UITextView *textView = (UITextView *)noti.object;
    NSString *toBeString = textView.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.wordLimit) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.wordLimit];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:self.wordLimit];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.wordLimit)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


@dynamic containerInsetZero;
- (void)setContainerInsetZero:(BOOL)containerInsetZero {
    if (containerInsetZero) {
        self.textContainer.lineFragmentPadding = 0;
        self.textContainerInset = UIEdgeInsetsZero;
    }
}

#pragma mark - property
- (NSUInteger)wordLimit {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)setWordLimit:(NSUInteger)wordLimit {
    if (!objc_getAssociatedObject(self, @selector(wordLimit))) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zl_handleTextChanged:) name:UITextViewTextDidChangeNotification object:self];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Method original_dealloc = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
            Method swizzled_dealloc = class_getInstanceMethod([self class], @selector(zl_dealloc));
            
            method_exchangeImplementations(original_dealloc, swizzled_dealloc);
        });
    }
    
    objc_setAssociatedObject(self, @selector(wordLimit), @(wordLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
