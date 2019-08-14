//
//  NSDate+Extension.h
//  TransfarFinancialPayment
//
//  Created by 陈曦 on 16/9/20.
//  Copyright © 2016年 Transfar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CXExtension)

/***
 * 获取当前时间
 */
+ (NSString *)getCurrentTime;

/**
 *  根据时间字符串 与 格式 返回时间对象
 *
 *  @param dateString 时间字符串
 *  @param format     @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return nsdate
 */
+ (NSDate *)dateWithString:(NSString *)dateString withFormat:(NSString *)format;

/**
 *  根据NSDate  返回指定格式的字符串
 *
 *  @param date   时间
 *  @param string  format 格式  如:yyyy-MM-dd HH:mm:ss
 *
 *  @return <#return value description#>
 */
+ (NSString *)stringWhitDate:(NSDate *)date withFormat:(NSString *)format;


/**
 *  根据日期 date 返回当天星期几
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)weekWithDate:(NSDate *)inputDate;

/**
 *  根据日期 string 返回当天星期几
 *
 *  @param dateString <#dateString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)weekWithDateString:(NSString *)dateString;


/**
 *  与当前时间对比.返回今天.昨天或者具体日期
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)compareDate:(NSDate *)date withFormat:(NSString *)format;

/**
 *  根据时间字符串与当前时间对比.返回今天.昨天或者具体日期
 *
 *  @param date 2015-11-15 11:11:11
 *
 *  @return <#return value description#>
 */
+ (NSString *)compareDateString:(NSString *)date withFormat:(NSString *)format;



/**
 对比2个时间是否谁大

 @param date1
 @param date2
 @return 1 第一个大.2.第二个大.0.相同
 */
+ (int)compareday:(NSDate *)date1 withDate:(NSDate *)date2;
@end
