//
//  CXDatePicker.m
//  CXDatePicker
//
//  Created by 陈曦1 on 2018/9/17.
//  Copyright © 2018年 xi chen. All rights reserved.
//

#import "CXDatePicker.h"
#import "NSDate+CXExtension.h"

#define toolHight 40
#define pickerViewHight selfHight-toolHight
#define selfHight (self.frame.size.width == 320 ? 200:250)
#define buttonwidth 40
#define infinite49 (self.infiniteScroll ? 49 : 0)
#define infinite100 (self.infiniteScroll ? 100 : 0)

@interface CXDatePicker()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, strong) UIPickerView *pickerView;

//年月日时分
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minutesArray;

@property (nonatomic, strong) NSDate *maxDate; //显示的最大日期
@property (nonatomic, strong) NSDate *minDate; //显示的最小日期
@property (nonatomic, strong) NSString *format; //显示的 formater
@property (nonatomic, strong) NSDate *selectDate; //选中的日期

//数据字典
@property (nonatomic, strong) NSMutableDictionary *dateDict;

//确定和取消的 block
@property (nonatomic, strong) determineBlock determineBlock;
@property (nonatomic, strong) cancelBlock cancelBlock;



@end
@implementation CXDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.toolView addSubview:self.cancelButton];
    [self.toolView addSubview:self.determineButton];
    [self.toolView addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    self.titleLabel.center = self.toolView.center;
    [self addSubview:self.toolView];
}

-(void)showDatePicker:(UIView *)view maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate format:(NSString *)format selectDate:(NSDate *)selectDate determineBlock:(determineBlock)determineBlock cancelBlock:(cancelBlock)cancelBlock
{
    for (UIView *tmpview in view.subviews) {
        if([tmpview isKindOfClass:[CXDatePicker class]])
        {
            return;
        }
    }
    self.determineBlock = determineBlock;
    self.cancelBlock = cancelBlock;
    
    self.frame = CGRectMake(0, 0, view.frame.size.width, selfHight);
    self.pickerView.frame = CGRectMake(0, toolHight, view.frame.size.width, pickerViewHight);
    self.maxDate = maxDate;
    self.minDate = minDate;
    self.selectDate = selectDate ? : [NSDate date];
    self.format = format;
    [self initFormatIndex];
    [self initDataArray:format];
    [view addSubview:self];
    [self addSubview:self.pickerView];
    [self initSelectDate:format animated:NO];

    [self show];
}



- (void)initFormatIndex
{
    if(self.indexArray.count > 0)
    {
        return;
    }
    if([self.format containsString:@"yyyy"])
    {
        [self.indexArray addObject:@"yyyy"];
    }
    if([self.format containsString:@"MM"])
    {
        [self.indexArray addObject:@"MM"];
    }
    if([self.format containsString:@"dd"])
    {
        [self.indexArray addObject:@"dd"];
    }
    if([self.format containsString:@"HH"])
    {
        [self.indexArray addObject:@"HH"];
    }
    if([self.format containsString:@"mm"])
    {
        [self.indexArray addObject:@"mm"];
    }
}


- (void)initSelectDate:(NSString *)format animated:(BOOL)animated
{
    // 年
    if([format containsString:@"yyyy"])
    {
    NSString *selectYear = [NSDate stringWhitDate:self.selectDate withFormat:@"yyyy"];
    NSInteger selectYearIndex = [self.yearArray indexOfObject:selectYear] + self.yearArray.count * infinite49;
    [self.pickerView selectRow:selectYearIndex inComponent:[self.indexArray indexOfObject:@"yyyy"] animated:animated];
    }
    
    //月
    if([format containsString:@"MM"])
    {
        NSString *selectmonth = [NSDate stringWhitDate:self.selectDate withFormat:@"MM"];
        NSInteger selectmonthIndex = [self.monthArray indexOfObject:selectmonth] + self.monthArray.count * infinite49;
        [self.pickerView selectRow:selectmonthIndex inComponent:[self.indexArray indexOfObject:@"MM"] animated:animated];
    }
    //日
    
    if([format containsString:@"dd"])
    {
    NSString *selectDay = [NSDate stringWhitDate:self.selectDate withFormat:@"dd"];
    NSInteger selectDayIndex = [self.dayArray indexOfObject:selectDay] + self.dayArray.count * infinite49;
    [self.pickerView selectRow:selectDayIndex inComponent:[self.indexArray indexOfObject:@"dd"] animated:animated];
    }
    //时
    if([format containsString:@"HH"])
    {
    NSString *selecthours = [NSDate stringWhitDate:self.selectDate withFormat:@"HH"];
        NSInteger selecthoursIndex = [self.hoursArray indexOfObject:selecthours] + self.hoursArray.count * infinite49;
    [self.pickerView selectRow:selecthoursIndex inComponent:[self.indexArray indexOfObject:@"HH"] animated:animated];
    }
    
    //分
    if([format containsString:@"mm"])
    {
        NSString *selectminutes = [NSDate stringWhitDate:self.selectDate withFormat:@"mm"];
        NSInteger selectminutesIndex = [self.minutesArray indexOfObject:selectminutes] + self.minutesArray.count * infinite49;
        [self.pickerView selectRow:selectminutesIndex inComponent:[self.indexArray indexOfObject:@"mm"] animated:animated];
    }
}


- (void)initDataArray:(NSString *)format
{
    //初始化年份
    int max,min;
    if(self.maxDate && self.minDate)
    {
        max = [[NSDate stringWhitDate:self.maxDate withFormat:@"yyyy"] intValue];
        min = [[NSDate stringWhitDate:self.minDate withFormat:@"yyyy"] intValue];
        if(min > max)
        {
            @throw [NSException exceptionWithName:@"时间错误" reason:@"最小时间大于最大时间" userInfo:nil];
        }
    }
    else
    {
        max = 3000;
        min = 1900;
    }
    if([format containsString:@"yyyy"])
    {
        for (int i = min; i<max + 1; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.dateDict setObject:self.yearArray forKey:@"yyyy"];
    }

//    初始化月份
    if([format containsString:@"MM"])
    {
        for (int i = 1; i<13; i++) {
            [self.monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        [self.dateDict setObject:self.monthArray forKey:@"MM"];
    }
    
    if([format containsString:@"dd"])
    {
        for (int i = 1; i<32; i++) {
            [self.dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        [self.dateDict setObject:self.dayArray forKey:@"dd"];
    }

    
    if([format containsString:@"HH"])
    {
        for (int i = 0; i<24; i++) {
            [self.hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        [self.dateDict setObject:self.hoursArray forKey:@"HH"];
    }

    
    if([format containsString:@"mm"])
    {
        for (int i = 0; i<60; i++) {
            [self.minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        [self.dateDict setObject:self.minutesArray forKey:@"mm"
         ];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
 
    UILabel *label = (UILabel *)view;
    if(!label)
    {
        label = [[UILabel alloc] init];
    }
    
    NSArray *tmpArray = [self.dateDict objectForKey:self.indexArray[component]];
    NSString *tmpString = tmpArray[row%tmpArray.count];
    
    NSString *index = self.indexArray[component];
    NSString *unit = nil;
    if([index isEqualToString:@"yyyy"])
    {
        unit  = @"年";
    }else if ([index isEqualToString:@"MM"])
    {
        unit  = @"月";
    }else if ([index isEqualToString:@"dd"])
    {
        unit  = @"日";
    }else if([index isEqualToString:@"HH"])
    {
        unit  = @"时";
    }else if([index isEqualToString:@"mm"])
    {
        unit  = @"分";
    }
    
    label.text = [tmpString stringByAppendingString:unit];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.textFont ? : [UIFont systemFontOfSize:18];
    label.textColor = self.textColor ? : [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self maxMinConfig];
    NSInteger dayIndex = [self.indexArray indexOfObject:@"dd"];
    NSInteger yearIndex = [self.indexArray indexOfObject:@"yyyy"];
    NSInteger monthIndex = [self.indexArray indexOfObject:@"MM"];
    NSString *day = @"01";
    NSString *month = @"01";
    NSString *year = @"2019";
    
    if (dayIndex > -1 && dayIndex < 62) {
        day = self.dayArray[[self.pickerView selectedRowInComponent:dayIndex] %self.dayArray.count];
    }
    if (monthIndex > -1 && monthIndex < 62) {
        month = self.monthArray[[self.pickerView selectedRowInComponent:monthIndex] %self.monthArray.count];
    }
    if (yearIndex > -1 && yearIndex < 62) {
        month = self.yearArray[[self.pickerView selectedRowInComponent:yearIndex] %self.yearArray.count];
    }
    
    
    if(component == dayIndex || component == yearIndex || component == monthIndex)
    {
        //月份处理
        if([month isEqualToString:@"01"] ||
           [month isEqualToString:@"03"] ||
           [month isEqualToString:@"05"] ||
           [month isEqualToString:@"07"] ||
           [month isEqualToString:@"08"] ||
           [month isEqualToString:@"10"] ||
           [month isEqualToString:@"12"])
        {
            // 31天
        }
        else if ([month isEqualToString:@"02"])
        {
            if([day intValue] < 29)
            {
                return;
            }
            
            if([year intValue]%4 == 0)
            {
                //闰年.29天.
                if (self.infiniteScroll) {
                    [self.pickerView selectRow:[self.dayArray indexOfObject:day] + self.dayArray.count * infinite49 inComponent:dayIndex animated:NO];
                }
                
                [self.pickerView selectRow:[self.dayArray indexOfObject:@"29"] + self.dayArray.count * infinite49 inComponent:dayIndex animated:YES];
                
            }
            else
            {
                if(self.infiniteScroll)
                {
                    [self.pickerView selectRow:[self.dayArray indexOfObject:day] + self.dayArray.count * infinite49 inComponent:dayIndex animated:NO];
                }
                [self.pickerView selectRow:[self.dayArray indexOfObject:@"28"] + self.dayArray.count * infinite49 inComponent:dayIndex animated:YES];
                // 28天
            }
        }
        else
        {
            // 30天
            if([day intValue] == 31)
            {
                if (self.infiniteScroll) {
                    [self.pickerView selectRow:[self.dayArray indexOfObject:day] + self.dayArray.count * infinite49 inComponent:dayIndex animated:NO];
                }
            
                [self.pickerView selectRow:[self.dayArray indexOfObject:@"30"] + self.dayArray.count * infinite49 inComponent:dayIndex animated:YES];
            }
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *tmpArray = [self.dateDict objectForKey:self.indexArray[component]];
    return tmpArray.count + tmpArray.count * (infinite100);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.indexArray.count;
}

- (void)maxMinConfig
{
    NSInteger dayIndex = [self.indexArray indexOfObject:@"dd"];
    NSInteger yearIndex = [self.indexArray indexOfObject:@"yyyy"];
    NSInteger monthIndex = [self.indexArray indexOfObject:@"MM"];
    NSInteger hoursIndex = [self.indexArray indexOfObject:@"HH"];
    NSInteger minutesIndex = [self.indexArray indexOfObject:@"mm"];
    
    NSString *day = @"01";
    NSString *month = @"01";
    NSString *year = @"2019";
    NSString *minutes = @"00";
    NSString *hours = @"00";
    
    if (dayIndex > -1 && dayIndex < 62) {
        day = self.dayArray[[self.pickerView selectedRowInComponent:dayIndex] %self.dayArray.count];
    }
    if (monthIndex > -1 && monthIndex < 62) {
        month = self.monthArray[[self.pickerView selectedRowInComponent:monthIndex] %self.monthArray.count];
    }
    if (yearIndex > -1 && yearIndex < 62) {
        month = self.yearArray[[self.pickerView selectedRowInComponent:yearIndex] %self.yearArray.count];
    }
    
    
    
    if (hoursIndex > -1 && hoursIndex < 62)
    {
        hours = self.hoursArray[[self.pickerView selectedRowInComponent:hoursIndex] %self.hoursArray.count];
    }
    if (minutesIndex > -1 && minutesIndex < 62) {
        
        minutes = self.minutesArray[[self.pickerView selectedRowInComponent:minutesIndex] %self.minutesArray.count];
    }
    // 获取到当前选择的年月日
    NSDate *currentDate = [NSDate dateWithString:[NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hours,minutes] withFormat:@"yyyy-MM-dd HH:mm"];
    if (!currentDate) {
        return;
    }
    
    int maxResults = [NSDate compareday:self.maxDate withDate:currentDate];
    self.selectDate = currentDate;
    if(self.infiniteScroll)
    {
        [self initSelectDate:self.format animated:NO];
    }
    if (maxResults == 2)
    {
        self.selectDate = self.maxDate;
        [self initSelectDate:self.format animated:YES];
    }
    int minResults = [NSDate compareday:self.minDate withDate:currentDate];
    if (minResults == 1)
    {
        self.selectDate = self.minDate;
        [self initSelectDate:self.format animated:YES];
    }
}

- (NSMutableDictionary *)getSelectDate
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if([self.indexArray containsObject:@"yyyy"])
    {
        [dict setObject:self.yearArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"yyyy"]] %self.yearArray.count] forKey:@"yyyy"];
    }
    
    if([self.indexArray containsObject:@"MM"])
    {
        [dict setObject:self.monthArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"MM"]] %self.monthArray.count] forKey:@"MM"];
    }
    
    if([self.indexArray containsObject:@"dd"])
    {
        [dict setObject:self.dayArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"dd"]] %self.dayArray.count] forKey:@"dd"];
    }
    
    if([self.indexArray containsObject:@"HH"])
    {
        [dict setObject:self.hoursArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"HH"]] %self.hoursArray.count] forKey:@"HH"];
    }
    
    if([self.indexArray containsObject:@"mm"])
    {
        [dict setObject:self.minutesArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"mm"]] %self.minutesArray.count] forKey:@"mm"];
    }
    return dict;
}
/**
 确定
 */
- (void)determineButtonClick
{
    if(self.determineBlock)
    {
        NSDictionary *dateDict = [self getSelectDate];
        
        NSString *yyyy = dateDict[@"yyyy"];
        NSString *MM = dateDict[@"MM"];
        NSString *dd = dateDict[@"dd"];
        NSString *HH = dateDict[@"HH"];
        NSString *mm = dateDict[@"mm"];
        NSString *ss = dateDict[@"ss"];
        if (yyyy.length == 0) {
            yyyy = @"2019";
        }
        if (MM.length == 0) {
            MM = @"01";
        }
        if (dd.length == 0) {
            dd = @"01";
        }
        if (HH.length == 0) {
            HH = @"12";
        }
        if (mm.length == 0) {
            mm = @"12";
        }
        if (ss.length == 0) {
            ss = @"12";
        }
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",yyyy,MM,dd,HH,mm,ss];
    self.determineBlock(self, [self getSelectDate],[NSDate dateWithString:dateString withFormat:nil]);
    }
    [self hidden];
}
//取消
- (void)cancelButtonClick
{

    if(self.cancelBlock)
    {
        self.cancelBlock(self);
    }
    [self hidden];
}

- (void)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    self.frame = CGRectMake(0, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.superview.frame.size.height - selfHight, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {

    }];
}

-(NSMutableArray *)yearArray
{
    if(_yearArray == nil)
    {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

-(NSMutableArray *)monthArray
{
    if(_monthArray == nil)
    {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

-(NSMutableArray *)dayArray
{
    if(_dayArray == nil)
    {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

-(NSMutableArray *)hoursArray
{
    if(_hoursArray == nil)
    {
        _hoursArray = [NSMutableArray array];
    }
    return _hoursArray;
}

-(NSMutableArray *)minutesArray
{
    if(_minutesArray == nil)
    {
        _minutesArray = [NSMutableArray array];
    }
    return _minutesArray;
}


- (NSMutableDictionary *)dateDict
{
    if(_dateDict == nil)
    {
        _dateDict = [NSMutableDictionary dictionary];
    }
    return _dateDict;
}

- (NSMutableArray *)indexArray
{
    if(!_indexArray)
    {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (UIPickerView *)pickerView
{
    if(!_pickerView)
    {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView *)toolView
{
    if(!_toolView)
    {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolHight)];
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}

- (UIButton *)determineButton
{
    if(_determineButton == nil)
    {
        _determineButton = [[UIButton alloc] init];
        [_determineButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_determineButton setTitle:@"确定" forState:(UIControlStateNormal)];
    }
    _determineButton.frame = CGRectMake(self.frame.size.width - buttonwidth - 10, 0, buttonwidth, toolHight);
    [_determineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    return _determineButton;
}

-(UIButton *)cancelButton
{
    if(!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    }
    _cancelButton.frame = CGRectMake(10, 0, buttonwidth, toolHight);
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    return _cancelButton;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

@end
