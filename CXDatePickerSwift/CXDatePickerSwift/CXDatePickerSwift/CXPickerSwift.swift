//
//  CXPickerSwift.swift
//  CXDatePickerSwift
//
//  Created by 陈曦1 on 2018/9/20.
//  Copyright © 2018年 xi chen. All rights reserved.
//

import UIKit


class CXPickerSwift: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{
    /// 工具栏高度
   private  let toolHight :CGFloat = 40
    ///本view 高度
  private  let selfHight:CGFloat = UIScreen.main.bounds.size.width == 320 ? 250 : 300
    /// 选择器高度
    /// - Returns: NSInteger
   private func pickerViewHight() -> NSInteger {
        return NSInteger(selfHight - toolHight)
    }
    /// 按钮高度
   private let buttonwidth = 40
    
    /// 循环49
    ///
    /// - Returns: NSInteger
   private func infinite49() -> NSInteger {
        return (self.infiniteScroll == true) ? 49 : 0
    }
    
    /// 循环100
    ///
    /// - Returns: NSInteger
   private func infinite100() -> NSInteger {
        return (self.infiniteScroll == true) ? 100 : 0
    }

    ///确认按钮回调
    typealias swiftDetermineBlock = (_ picker: CXPickerSwift,_ selectDareDict:NSDictionary) -> Void
    ///取消按钮回调
    typealias swiftCancelBlock = (_ picker: CXPickerSwift) -> Void
    
    // 开放属性
   open var infiniteScroll:Bool? //是否无限滚动
   open var indexArray = NSMutableArray.init() //index数组
   open var textColor:UIColor? //文字颜色
   open var textFont:UIFont? //文字字体
    
    // 内部属性
   private var internalDetermineBlock:swiftDetermineBlock?
   private var internalCancelBlock:swiftCancelBlock?
    
    
   private var pickerView : UIPickerView {
        let picker = UIPickerView.init()
        picker.backgroundColor = UIColor.white
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        return picker
    }
//    @property (nonatomic, strong) NSMutableArray *yearArray;
   private var yearArray = NSMutableArray.init()
//    @property (nonatomic, strong) NSMutableArray *monthArray;
   private var monthArray = NSMutableArray.init()
//    @property (nonatomic, strong) NSMutableArray *dayArray;
   private var dayArray = NSMutableArray.init()
//    @property (nonatomic, strong) NSMutableArray *hoursArray;
   private var hoursArray = NSMutableArray.init()
//    @property (nonatomic, strong) NSMutableArray *minutesArray;
   private var minutesArray = NSMutableArray.init()

   private var maxDate:NSDate? //显示的最大日期
   private var minDate:NSDate? //显示的最小日期
   private var format:NSString? //显示的 formater
    
    
   private var selectDate:NSDate?//选中的日期
   private var dateDict = NSMutableDictionary.init()//数据字典
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func showDatePicker(view withView:UIView, maxDate:NSDate? ,minDate:NSDate?,format:NSString?,selectDate:NSDate? ,determineBlock:swiftDetermineBlock?,cancelBlock:swiftCancelBlock?) {
        for view in withView.subviews {
            if (view.isKind(of:CXPickerSwift.classForCoder()))
            {
                return
            }
        }
        
        self.internalDetermineBlock = determineBlock
        self.internalCancelBlock = cancelBlock
        self.frame = CGRect.init(x: 0, y: 0, width: withView.frame.size.width, height: selfHight)

        self.maxDate = maxDate
        self.minDate = minDate
        self.selectDate = selectDate
        if self.selectDate == nil {
            self.selectDate = NSDate.init()
        }
        self.format = format
        self.initFormatIndex()
        self.initDateFormat(format: self.format)
        
        self.pickerView.frame = CGRect.init(x: 0, y: Int(toolHight), width: Int(withView.frame.size.width), height: pickerViewHight())

        withView.addSubview(self)
        self.addSubview(self.pickerView)
        self.show()
        self.initSelect(format: self.format!, animated: false)
        
    }
    
    
    /// 消失
    private func Hidden(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect.init(x: 0, y: (self.superview?.frame.size.height)!, width: self.frame.size.width, height: self.frame.size.height)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    /// 显示
    private func show(){
        self.frame = CGRect.init(x: 0, y: (self.superview?.frame.size.height)!, width: self.frame.size.width, height: self.frame.size.height)
        UIView.animate(withDuration: 0.25, animations: {
        
            self.frame = CGRect.init(x: 0, y: (self.superview?.frame.size.height)! - self.selfHight, width: self.frame.size.width, height: self.frame.size.height)
            
        }) { (finished) in
         
            self.initSelect(format: self.format!, animated: false)
            
        }
    }
    
    /// 选中指定时间
    ///
    /// - Parameters:
    ///   - date: 时间
    ///   - animated: 是否过渡动画
    private func initSelect(format:NSString,animated:Bool)
    {
        if (format.contains("yyyy")) {
            
            let selectYear:NSString = NSDate.stringWhitDate(self.selectDate! as Date?, withFormat: "yyyy")! as NSString
            let selectYearIndex:NSInteger = self.yearArray.index(of: selectYear) + self.yearArray.count * infinite49()
            self.pickerView.selectRow(selectYearIndex, inComponent:self.indexArray.index(of: "yyyy"), animated: animated)
        }
        if (format.contains("MM")) {
            
            let selectmonth:NSString = NSDate.stringWhitDate(self.selectDate! as Date, withFormat: "MM")! as NSString
            let selectmonthIndex:NSInteger = self.monthArray.index(of: selectmonth) + self.monthArray.count * infinite49()
            self.pickerView.selectRow(selectmonthIndex, inComponent: self.indexArray.index(of: "MM"), animated: animated)
        }
        
        if (format.contains("dd")) {
            
            let selectDay:NSString = NSDate.stringWhitDate(self.selectDate! as Date, withFormat: "dd")! as NSString
            let selectDayIndex:NSInteger = self.dayArray.index(of: selectDay) + self.dayArray.count * infinite49()
            self.pickerView.selectRow(selectDayIndex, inComponent: self.indexArray.index(of: "dd"), animated: animated)
        }
        
        if (format.contains("HH")) {
            
            let selecthours:NSString = NSDate.stringWhitDate(self.selectDate! as Date, withFormat: "HH")! as NSString
            let selecthoursIndex:NSInteger = self.hoursArray.index(of: selecthours) + self.hoursArray.count * infinite49()
            self.pickerView.selectRow(selecthoursIndex, inComponent: self.indexArray.index(of: "HH"), animated: animated)
        }
        
        if (format.contains("mm")) {
            
            let selectminutes:NSString = NSDate.stringWhitDate(self.selectDate! as Date, withFormat: "mm")! as NSString
            let selectminutesIndex:NSInteger = self.minutesArray.index(of: selectminutes) + self.minutesArray.count * infinite49()
            self.pickerView.selectRow(selectminutesIndex, inComponent: self.indexArray.index(of: "mm"), animated: animated)
        }
    }
    
    /// 初始化展示的 format
    private func initFormatIndex() {
        
        if self.indexArray.count > 0 {
            return
        }
        
        if (self.format?.contains("yyyy"))! {
            self.indexArray.add("yyyy")
        }
        if (self.format?.contains("MM"))! {
            self.indexArray.add("MM")
        }
        if (self.format?.contains("dd"))! {
            self.indexArray.add("dd")
        }
        if (self.format?.contains("HH"))! {
            self.indexArray.add("HH")
        }
        if (self.format?.contains("mm"))! {
            self.indexArray.add("mm")
        }
    }
    
   private func initDateFormat(format:NSString?){
        
        var max:Int,min:Int

        if self.maxDate != nil && self.minDate != nil {
            let maxStr:NSString = NSDate.stringWhitDate(self.maxDate! as Date, withFormat: "yyyy")! as NSString
            let minStr:NSString = NSDate.stringWhitDate(self.minDate! as Date, withFormat: "yyyy")! as NSString

            max = Int(maxStr.intValue);
            min = Int(minStr.intValue);
        }
        else
        {
            max = 3000
            min = 1900
        }
        
        if (format?.contains("yyyy"))! {
            for i in min...max{
                self.yearArray.add(NSString.init(format: "%d", i))
            }
            self.dateDict.setObject(self.yearArray, forKey: "yyyy" as NSCopying)
        }
        
        
        if (format?.contains("MM"))! {
            for i in 1...12{
                self.monthArray.add(NSString.init(format: "%02d", i))
            }
            self.dateDict.setObject(self.monthArray, forKey: "MM" as NSCopying)
        }
        
        if (format?.contains("dd"))! {
            for i in 1...31{
                self.dayArray.add(NSString.init(format: "%02d", i))
            }
            self.dateDict.setObject(self.dayArray, forKey: "dd" as NSCopying)
        }
        
        if (format?.contains("HH"))! {
            for i in 0...59{
                self.hoursArray.add(NSString.init(format: "%02d", i))
            }
            self.dateDict.setObject(self.hoursArray, forKey: "HH" as NSCopying)
        }
        if (format?.contains("mm"))! {
            for i in 0...59{
                self.minutesArray.add(NSString.init(format: "%02d", i))
            }
            self.dateDict.setObject(self.minutesArray, forKey: "mm" as NSCopying)
        }
    }
    
    /// 限制每个月的时间显示
    private func dateLimit(picker:UIPickerView,component:Int) {
        let dayIndex:NSInteger = self.indexArray.index(of: "dd")
        let yearIndex:NSInteger = self.indexArray.index(of: "yyyy")
        let monthIndex:NSInteger = self.indexArray.index(of: "MM")
        let day:NSString = self.dayArray[picker.selectedRow(inComponent: dayIndex)%self.dayArray.count] as! NSString
        let month:NSString = self.monthArray[picker.selectedRow(inComponent: monthIndex)%self.monthArray.count] as! NSString
        let year:NSString = self.yearArray[picker.selectedRow(inComponent: yearIndex)%self.yearArray.count] as! NSString
        
        switch component {
        case yearIndex,monthIndex,dayIndex:
            
            switch month {
            case "01","03","05","07","08","10","12":
                // 31天
                break
                
            case "02":
                if day.intValue < 29 {
                    return;
                }
                if year.intValue & 4 == 0 {
                    
                    if self.infiniteScroll == true {
                        self.pickerView.selectRow(self.dayArray.index(of: day) + self.dayArray.count * infinite49(), inComponent: dayIndex, animated: false)
                    }
                    self.pickerView.selectRow(self.dayArray.index(of: "29") + self.dayArray.count * infinite49(), inComponent: dayIndex, animated: true)
                }else{
                    
                    
                    if self.infiniteScroll == true {
                        self.pickerView.selectRow(self.dayArray.index(of: day) + self.dayArray.count * infinite49(), inComponent: dayIndex, animated: false)
                    }
            
                    self.pickerView.selectRow(self.dayArray.index(of: "28") + self.dayArray.count * infinite49(), inComponent: dayIndex, animated: true)
                    
                }
                break
            default:
                // 30天
                
                if day.intValue == 31 {
                    
                    if self.infiniteScroll == true {
                        self.pickerView.selectRow(self.dayArray.index(of: day) + self.dayArray.count * infinite49(), inComponent: dayIndex, animated: false)
                        self.pickerView.reloadInputViews()
                    }
                    self.pickerView.selectRow(self.dayArray.index(of: "30") + self.dayArray.count * infinite49(), inComponent: dayIndex, animated: true)
                    self.pickerView.reloadInputViews()
                }
                break
            }
            break
        default: break
            
        }
    }
    
    
    /// 最大最小日期限制
    private func maxMinConfig(){
        
        let dayIndex:NSInteger = self.indexArray.index(of: "dd")
        let yearIndex:NSInteger = self.indexArray.index(of: "yyyy")
        let monthIndex:NSInteger = self.indexArray.index(of: "MM")
        let hoursIndex:NSInteger = self.indexArray.index(of: "HH")
        let minutesIndex:NSInteger = self.indexArray.index(of: "mm")
        
        
        let day:NSString = self.dayArray[self.pickerView.selectedRow(inComponent: dayIndex)%self.dayArray.count] as! NSString
        let month:NSString = self.monthArray[self.pickerView.selectedRow(inComponent: monthIndex)%self.monthArray.count] as! NSString
        let year:NSString = self.yearArray[self.pickerView.selectedRow(inComponent: yearIndex)%self.yearArray.count] as! NSString
        
        
        var hours:NSString = "00"
        var minutes:NSString = "00"
    
        
        
        if (hoursIndex > -1 && hoursIndex < 62) {
            
            hours = self.hoursArray[self.pickerView.selectedRow(inComponent: hoursIndex)%self.hoursArray.count] as! NSString
        }
        
        if(minutesIndex > -1 && minutesIndex < 62){
            
            minutes = self.minutesArray[self.pickerView.selectedRow(inComponent: minutesIndex)%self.minutesArray.count] as! NSString
        }
        
        let currentDate = NSDate.init(string: NSString.init(format: "%@-%@-%@ %@:%@", year,month,day,hours,minutes) as String?, withFormat: "yyyy-MM-dd HH:mm")
        if currentDate == nil {
            return;
        }
        let maxResults = NSDate.compareday(self.maxDate! as Date, with: currentDate! as Date)
        self.selectDate = currentDate
        if self.infiniteScroll == true {
            self.initSelect(format: self.format!, animated: false)
        }
        
        if maxResults == 2 {
            self.selectDate = self.maxDate
            self.initSelect(format: self.format!, animated: true)
        }
        let minResults = NSDate.compareday(self.minDate! as Date, with: currentDate! as Date)
        if minResults == 1 {
        self.selectDate = currentDate
            self.initSelect(format: self.format!, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.maxMinConfig()
        self.dateLimit(picker: pickerView, component: component)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label:UILabel?
        label = view as? UILabel
        if (label == nil) {
            label = UILabel.init()
        }
        let tmpArray:NSArray = self.dateDict.object(forKey: self.indexArray[component]) as! NSArray
        let tmpStr:NSString = tmpArray[row % tmpArray.count] as! NSString
        let index:NSString = self.indexArray[component] as! NSString
        
        var unit:NSString
        switch index {
        case "yyyy":
            unit = "年"
            break
        case "MM":
            unit = "月"
            break
        case "dd":
            unit = "日"
            break
        case "HH":
            unit = "时"
            break
        case "mm":
            unit = "分"
            break
        default:
            unit = ""
        }
        
        label?.text = tmpStr.appending(unit as String)
        label?.textAlignment = NSTextAlignment.center
        label?.font = (self.textFont != nil) ? self.textFont : UIFont.systemFont(ofSize: 18)
        label?.textColor = (self.textColor != nil) ? self.textColor : UIColor.black
        label?.lineBreakMode = NSLineBreakMode.byCharWrapping
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tmparray:NSArray = self.dateDict.object(forKey: self.indexArray[component]) as! NSArray
        
        return tmparray.count + tmparray.count * infinite100()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dateDict.count
    }

}
