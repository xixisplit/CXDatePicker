//
//  NSDate+Extension.m
//  TransfarFinancialPayment
//
//  Created by 陈曦 on 16/9/20.
//  Copyright © 2016年 Transfar. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    
    NSString *currentYear;
    currentYear = [NSString stringWithFormat:@"%ld", (long)comps.year];
    
    NSString *currentmMonth;
    if (comps.month < 10)
    {
        currentmMonth = [NSString stringWithFormat:@"%@%ld", @"0", (long)comps.month];
    }
    else
    {
        currentmMonth = [NSString stringWithFormat:@"%ld", (long)comps.month];
    }
    
    NSString *currentmDay;
    if (comps.day < 10)
    {
        currentmDay = [NSString stringWithFormat:@"%@%ld", @"0", (long)comps.day];
    }
    else
    {
        currentmDay = [NSString stringWithFormat:@"%ld", (long)comps.day];
    }
    
    NSString *currentHour;
    if (comps.hour < 10)
    {
        currentHour = [NSString stringWithFormat:@"%@%ld", @"0", (long)comps.hour];
    }
    else
    {
        currentHour = [NSString stringWithFormat:@"%ld", (long)comps.hour];
    }
    
    NSString *currentMinute;
    if (comps.minute < 10)
    {
        currentMinute = [NSString stringWithFormat:@"%@%ld", @"0", (long)comps.minute];
    }
    else
    {
        currentMinute = [NSString stringWithFormat:@"%ld", (long)comps.minute];
    }
    
    NSString *currentSecond;
    if (comps.second < 10)
    {
        currentSecond = [NSString stringWithFormat:@"%@%ld", @"0", (long)comps.second];
    }
    else
    {
        currentSecond = [NSString stringWithFormat:@"%ld", (long)comps.second];
    }
    
    NSString *currentTime = [NSString stringWithFormat:@"%@%@%@%@%@%@", currentYear, currentmMonth, currentmDay, currentHour, currentMinute, currentSecond];
    
    return currentTime;
}

+ (NSDate *)dateWithString:(NSString *)dateString withFormat:(NSString *)format
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format.length > 0 ? format :@"yyyy-MM-dd HH:mm:ss"];
    
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *GMTDate = [formatter dateFromString:dateString];
    
    return GMTDate;

}



+ (NSString *)stringWhitDate:(NSDate *)date withFormat:(NSString *)format
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; //格式化
    
    [formatter setDateFormat:format.length > 0 ? format :@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSString *s1 = [formatter stringFromDate:date];
    
    return s1;

}



+(NSString *)weekWithDate:(NSDate *)inputDate

{

    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    [calendar setTimeZone:timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];


}

+(NSString *)weekWithDateString:(NSString *)dateString
{

    NSDate *inputDate = [self dateWithString:dateString withFormat:@"yyyy-MM-dd HH:mm:ss"];

    return [NSDate weekWithDate:inputDate];

}


+ (NSString *)compareDate:(NSDate *)date withFormat:(NSString *)format
{
    //今天
    NSDate *today = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[NSDate date]];
    //昨天
    NSDate *yesterday = [[NSDate alloc] initWithTimeInterval:-24 * 60 * 60 sinceDate:today];
    //明天时间
    NSDate *Tomorrow = [[NSDate alloc] initWithTimeInterval:+24 * 60 * 60 sinceDate:today];
    // 10 first characters of description is the calendar date:
    NSString *todayString = [self stringWhitDate:today withFormat:@"yyyy-MM-dd"];
    NSString *yesterdayString = [self stringWhitDate:yesterday withFormat:@"yyyy-MM-dd"];
    NSString *TomorrowString = [self stringWhitDate:Tomorrow withFormat:@"yyyy-MM-dd"];
    NSString *dateString = [self stringWhitDate:date withFormat:@"yyyy-MM-dd"];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    }
    else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }
    if ([dateString isEqualToString:TomorrowString])
    {
        return @"明天";
    }
    else
        
    {
        return  [NSDate stringWhitDate:date withFormat:format.length > 0? format :@"MM-dd"];

    }
}


+(NSString *)compareDateString:(NSString *)date withFormat:(NSString *)format
{
    NSDate *date1 = [NSDate dateWithString:date withFormat:nil];
    return [NSDate compareDate:date1 withFormat:format];

}

+(int)compareday:(NSDate *)date1 withDate:(NSDate *)date2
{
   NSComparisonResult result = [date1 compare:date2];
 
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return 2;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


@end
