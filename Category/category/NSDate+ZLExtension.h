//
//  NSDate+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZLExtension)

/** 获取文字日期 */
- (NSString *)stringWithFormat:(NSString *)format;

/** 获取日 */
- (NSUInteger)day;
/** 获取月 */
- (NSUInteger)month;
/** 获取年 */
- (NSUInteger)year;
/** 获取小时 */
- (NSUInteger)hour;
/** 获取分钟 */
- (NSUInteger)minute;
/** 获取秒 */
- (NSUInteger)second;
/** 获取星期 (1为周日) */
- (NSUInteger)weekday;

/** 获取中文星期 */
- (NSString *)stringOfWeekday:(BOOL)simple;

/** 是否闰年 */
- (BOOL)isLeapYear;

/** 获取几天后的日期 (负数为几天前) */
- (NSDate *)dateAfterDay:(NSInteger)day;

/** 是否是今天 */
- (BOOL)isToday;
/** 是否是昨天 */
- (BOOL)isYesterday;

/** 距离现在时间长度 */
- (NSString *)stringFromTimelineDateToNow;

@end
