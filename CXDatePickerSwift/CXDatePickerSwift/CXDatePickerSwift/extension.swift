//
//  extension.swift
//  CXDatePickerSwift
//
//  Created by 陈曦1 on 2018/9/20.
//  Copyright © 2018年 xi chen. All rights reserved.
//

import Foundation


extension NSDate {
    /// 根据时间字符串返回 nsdate
    /// - Parameters:
    ///   - dateString:
    ///   - format:
    /// - Returns:
    class func dateWithStr(date dateString:NSString,format:NSString)->(NSDate) {
        
        let formatter:DateFormatter = DateFormatter.init()
        formatter.dateFormat = format.length > 0 ? format as String : "yyyy-MM-dd HH:mm:ss" as String
        let gmtDate:NSDate = formatter.date(from: dateString as String)! as NSDate
        return gmtDate
    }
    
    
    /// 根据时间 date 返回字符串
    ///
    /// - Parameters:
    ///   - date:
    ///   - format:
    /// - Returns:
    class func stringwithDate(date:NSDate ,format:NSString)->NSString{
        
        let formatter:DateFormatter = DateFormatter.init()
        formatter.dateFormat = format.length > 0 ? format as String : "yyyy-MM-dd HH:mm:ss" as String
        let dateStr:NSString = formatter.string(from: date as Date) as NSString
        return dateStr
    }
    
    /// 根据日期返回星期几
    ///
    /// - Parameter date:
    /// - Returns:
    class func weekwithDate(date:NSDate)->NSString{
        let weekDays:NSArray = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        let interval = Int(NSDate.init().timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekDays.object(at: weekday == 0 ? 7 : weekday) as! NSString
    }
    
    
    /// 根据 date 返回今天昨天明天
    ///
    /// - Parameter date:
    /// - Returns:
    class func compareDate(date:NSDate)->NSString{
        let dateFormat:DateFormatter = DateFormatter.init()
        dateFormat.dateFormat = "yyyy-MM-dd"
        //        //今天
        let toStr:NSString = dateFormat.string(from: NSDate.init() as Date) as NSString
        //        //昨天
        let yestterStr:NSString = dateFormat.string(from: NSDate.init(timeInterval: -24*3600, since: NSDate.init() as Date) as Date) as NSString
        //        //明天时间
        let tomorrowStr:NSString = dateFormat.string(from: NSDate.init(timeInterval: 24*3600, since: NSDate.init() as Date) as Date) as NSString
        
        let dateStr:NSString = dateFormat.string(from: date as Date) as NSString
        
        switch dateStr {
        case toStr: return "今天"
        case yestterStr: return "昨天"
        case tomorrowStr: return "明天"
        default: return "错误"
        }
    }
    
}
