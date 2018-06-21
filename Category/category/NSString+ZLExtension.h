//
//  NSString+ZLExtension.h
//  Category
//
//  Created by long on 2018/1/4.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZLExtension)

/** 去除首尾空格及回车 */
- (NSString *)stringWithoutWhitespaceBothSides;

/** 获取汉字的拼音 */
- (NSString *)spellingOfChinese;

/** 反转字符串 */
- (NSString *)reverseString;


/** 获取日期 */
- (NSDate *)dateWithFormat:(NSString *)format;
/** 获取时间戳 */
- (NSTimeInterval)timeIntervalWithFormat:(NSString *)format;


/** 获取document路径 */
+ (NSString *)documentPath;
/** 获取缓存路径 */
+ (NSString *)cachePath;
/** 获取临时路径 */
+ (NSString *)tempPath;



/** 判断是否手机号 */
- (BOOL)isMobilePhoneNumber;

/** 判断昵称  只允许中文，英文，数字，字母，横杠，下划线 */
- (BOOL)isNike;

/** 判断用户名  在4－16位 */
- (BOOL)isAccount;

/** 判断密码  6－16位 */
- (BOOL)isPassWord;

/** 判断是否电子邮箱 */
- (BOOL)isEmail;

@end
