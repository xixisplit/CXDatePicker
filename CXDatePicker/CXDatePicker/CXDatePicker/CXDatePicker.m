//
//  CXDatePicker.m
//  CXDatePicker
//
//  Created by 陈曦1 on 2018/9/17.
//  Copyright © 2018年 xi chen. All rights reserved.
//

#import "CXDatePicker.h"
#import "NSDate+Extension.h"

#define toolHight 40
#define pickerViewHight selfHight-toolHight
#define selfHight 300
#define buttonwidth 40

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
    [view addSubview:self];
    [self addSubview:self.pickerView];
    [self initFormatIndex];
    [self initDataArray:format];
    [self initSelectDate:format];

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


- (void)initSelectDate:(NSString *)format
{
    // 年
    if([format containsString:@"yyyy"])
    {
    NSString *selectYear = [NSDate stringWhitDate:self.selectDate withFormat:@"yyyy"];
    NSUInteger selectYearIndex = [self.yearArray indexOfObject:selectYear];
    [self.pickerView selectRow:selectYearIndex inComponent:[self.indexArray indexOfObject:@"yyyy"] animated:NO];
    }
    
    //月
    if([format containsString:@"MM"])
    {
        NSString *selectmonth = [NSDate stringWhitDate:self.selectDate withFormat:@"MM"];
        NSUInteger selectmonthIndex = [self.monthArray indexOfObject:selectmonth];
        [self.pickerView selectRow:selectmonthIndex inComponent:[self.indexArray indexOfObject:@"MM"] animated:NO];
    }
    //日
    
    if([format containsString:@"dd"])
    {
    NSString *selectDay = [NSDate stringWhitDate:self.selectDate withFormat:@"dd"];
    NSUInteger selectDayIndex = [self.dayArray indexOfObject:selectDay];
    [self.pickerView selectRow:selectDayIndex inComponent:[self.indexArray indexOfObject:@"dd"] animated:NO];
    }
    //时
    if([format containsString:@"HH"])
    {
    NSString *selecthours = [NSDate stringWhitDate:self.selectDate withFormat:@"HH"];
    NSUInteger selecthoursIndex = [self.hoursArray indexOfObject:selecthours];
    [self.pickerView selectRow:selecthoursIndex inComponent:[self.indexArray indexOfObject:@"HH"] animated:NO];
    }
    
    //分
    if([format containsString:@"mm"])
    {
        NSString *selectminutes = [NSDate stringWhitDate:self.selectDate withFormat:@"mm"];
        NSUInteger selectminutesIndex = [self.minutesArray indexOfObject:selectminutes];
        [self.pickerView selectRow:selectminutesIndex inComponent:[self.indexArray indexOfObject:@"mm"] animated:NO];
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
    }
    else
    {
        max = 3000;
        min = 1900;
    }
    if([format containsString:@"yyyy"])
    {
        for (int i = min; i<max; i++) {
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
    NSString *tmpString = tmpArray[row];
    
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
    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger dayIndex = [self.indexArray indexOfObject:@"dd"];
    NSUInteger yearIndex = [self.indexArray indexOfObject:@"yyyy"];
    NSUInteger monthIndex = [self.indexArray indexOfObject:@"MM"];

    NSString *day = self.dayArray[[pickerView selectedRowInComponent:dayIndex]];
    
    if(component == dayIndex || component == yearIndex || component == monthIndex)
    {
        //月份处理
        NSString *month = self.monthArray[[pickerView selectedRowInComponent:monthIndex]];
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
            
          NSString *year = self.yearArray[[pickerView selectedRowInComponent:yearIndex]];
            
            if([year intValue]%4 == 0)
            {
                //闰年.29天.
                [self.pickerView selectRow:[self.dayArray indexOfObject:@"29"] inComponent:dayIndex animated:YES];
                
            }
            else
            {
                [self.pickerView selectRow:[self.dayArray indexOfObject:@"28"] inComponent:dayIndex animated:YES];
                // 28天
            }
        }
        else
        {
            // 30天
            if([day intValue] == 31)
            {
            [self.pickerView selectRow:[self.dayArray indexOfObject:@"30"] inComponent:dayIndex animated:YES];
            }
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *tmpArray = [self.dateDict objectForKey:self.indexArray[component]];
    return tmpArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.indexArray.count;
}



/**
 确定
 */
- (void)determineButtonClick
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if([self.indexArray containsObject:@"yyyy"])
    {
        [dict setObject:self.yearArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"yyyy"]]] forKey:@"yyyy"];
    }

    if([self.indexArray containsObject:@"MM"])
    {
        [dict setObject:self.monthArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"MM"]]] forKey:@"MM"];
    }

    if([self.indexArray containsObject:@"dd"])
    {
        [dict setObject:self.dayArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"dd"]]] forKey:@"dd"];
    }

    if([self.indexArray containsObject:@"HH"])
    {
        [dict setObject:self.hoursArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"HH"]]] forKey:@"HH"];
    }

    if([self.indexArray containsObject:@"mm"])
    {
        [dict setObject:self.minutesArray[[self.pickerView selectedRowInComponent:[self.indexArray indexOfObject:@"mm"]]] forKey:@"mm"];
    }
    self.determineBlock(self, dict);
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
