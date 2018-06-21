//
//  NSString+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NSString+ZLExtension.h"

@implementation NSString (ZLExtension)

- (NSString *)stringWithoutWhitespaceBothSides {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)spellingOfChinese {
    
    CFMutableStringRef mutableString = (__bridge CFMutableStringRef)[NSMutableString stringWithString:self];
    CFRange range = CFRangeMake(0, self.length);
    if (!CFStringTransform(mutableString, &range, kCFStringTransformMandarinLatin, NO) || !CFStringTransform(mutableString, &range, kCFStringTransformStripDiacritics, NO)) {
        return @"";
    }
    return (__bridge NSString *)(mutableString);
}

- (NSString *)reverseString {
    NSMutableString *reverString = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

#pragma mark - date
- (NSDate *)dateWithFormat:(NSString *)format {
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = format;
    form.timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [form dateFromString:self];
    return date;
}
- (NSTimeInterval)timeIntervalWithFormat:(NSString *)format {
    NSDate *date = [self dateWithFormat:format];
    return [date timeIntervalSince1970];
}


#pragma mark - path
+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)cachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}


#pragma mark - regex
- (BOOL)isMobilePhoneNumber {
    
    return [self regexWithPattern:@"1\\d{10}"];
}

- (BOOL)isNike {
    return [self regexWithPattern:@"^(\\w|-|[\u4E00-\u9FA5])*$"];
}

- (BOOL)isEmail {
    return [self regexWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)isAccount {
    return [self regexWithPattern:@"^[A-Za-z0-9]{4,16}$"];
}
- (BOOL)isPassWord {
    return [self regexWithPattern:@"\\w{6,16}"];
}

- (BOOL)regexWithPattern:(NSString *)pattern {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

@end
