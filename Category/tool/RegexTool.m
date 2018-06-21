//
//  RegexTool.m
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "RegexTool.h"

@implementation RegexTool


+ (BOOL)isMobilePhoneNumber:(NSString *)number {
    
    NSString *pattern = @"^1[3|4|5|6|7|8][0-9]\\d{8}$";
    return [self adjustWithPattern:pattern text:number];
}
+ (BOOL)isEmail:(NSString *)email {
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self adjustWithPattern:pattern text:email];
}
+ (BOOL)isAccount:(NSString *)account {
    
    NSString *pattern = @"^[a-zA-Z][a-zA-Z0-9_]{5,15}$";
    return [self adjustWithPattern:pattern text:account];
}

+ (NSArray<NSTextCheckingResult *> *)resultsOfTopic:(NSString *)text {
    NSString *pattern = @"#([^@]+?)#";
    
    return [self resultsWithPattern:pattern text:text];
}


// 谓词判断正确性
+ (BOOL)adjustWithPattern:(NSString *)pattern text:(NSString *)text {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:text];
}
// 正则筛选符合项
+ (NSArray<NSTextCheckingResult *> *)resultsWithPattern:(NSString *)pattern text:(NSString *)text {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:text options:kNilOptions range:NSMakeRange(0, text.length)];
    
    return result;
}


@end
