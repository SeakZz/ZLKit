//
//  NSDate+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NSDate+ZLExtension.h"

@implementation NSDate (ZLExtension)

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = format;
    form.timeZone = [NSTimeZone systemTimeZone];
    form.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateStr = [form stringFromDate:self];
    return dateStr;
}


- (NSUInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:self];
    return [dayComponents day];
}
- (NSUInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitMonth fromDate:self];
    return [dayComponents month];
}
- (NSUInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitYear fromDate:self];
    return [dayComponents year];
}
- (NSUInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitHour fromDate:self];
    return [dayComponents hour];
}
- (NSUInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitMinute fromDate:self];
    return [dayComponents minute];
}
- (NSUInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitSecond fromDate:self];
    return [dayComponents second];
}
- (NSUInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return [dayComponents weekday];
}

- (NSString *)stringOfWeekday:(BOOL)simple {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = simple ? @"EEE" : @"EEEE";
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [formatter stringFromDate:self];
}

- (BOOL)isLeapYear {
    NSUInteger year = [self year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

- (NSDate *)dateAfterDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}


- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return self.day == [NSDate new].day;
}
- (BOOL)isYesterday {
    NSDate *added = [self dateAfterDay:-1];
    return [added isToday];
}

- (NSString *)stringFromTimelineDateToNow {
    
    NSDateFormatter *formatterYesterday = [[NSDateFormatter alloc] init];
    [formatterYesterday setDateFormat:@"昨天 HH:mm"];
    [formatterYesterday setLocale:[NSLocale currentLocale]];
    
    NSDateFormatter *formatterSameYear = [[NSDateFormatter alloc] init];
    [formatterSameYear setDateFormat:@"M-d"];
    [formatterSameYear setLocale:[NSLocale currentLocale]];
    
    NSDateFormatter *formatterFullDate = [[NSDateFormatter alloc] init];
    [formatterFullDate setDateFormat:@"yy-M-dd"];
    [formatterFullDate setLocale:[NSLocale currentLocale]];
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - self.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [formatterFullDate stringFromDate:self];
    } else if (delta < 60 * 10) { // 10分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (self.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else if (self.isYesterday) {
        return [formatterYesterday stringFromDate:self];
    } else if (self.year == now.year) {
        return [formatterSameYear stringFromDate:self];
    } else {
        return [formatterFullDate stringFromDate:self];
    }
}

@end
