//
//  CXDatePicker.h
//  CXDatePicker
//
//  Created by 陈曦1 on 2018/9/17.
//  Copyright © 2018年 xi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXDatePicker;
typedef void(^determineBlock)(CXDatePicker *datePicker, NSDictionary *selectDate);
typedef void(^cancelBlock)(CXDatePicker *datePicker);


@interface CXDatePicker : UIView

/**
 显示 pickerView
 @param view add 到当前控制器的 self.view
 @param maxDate 最大可选日期.精确到日
 @param minDate 最小可选日期.精确到日
 @param format @"yyyy-MM-dd HH:mm" 支持到分钟
 @param selectDate 默认选择的时间.不填默认为当天
 @param determineBlock 确定回调
 @param cancelBlock 取消回调
 */
-(void)showDatePicker:(UIView *)view maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate format:(NSString *)format selectDate:(NSDate *)selectDate determineBlock:(determineBlock)determineBlock cancelBlock:(cancelBlock)cancelBlock;

/**
indexArray @[@"yyyy","MM",@"dd",@"HH",@"mm"]; 自由错乱顺序组合 默认正常顺序
 //通过配置此数组.可以打乱顺序进行时间展示
 */

@property (nonatomic, strong)  NSMutableArray*indexArray;

@property (nonatomic, strong) UIFont *textFont; // 文字字体
@property (nonatomic, strong) UIColor *textColor; //文字颜色

@property (nonatomic, strong) UIButton *determineButton; //确定按钮 right
@property (nonatomic, strong) UIButton *cancelButton; //取消按钮lefy
@property (nonatomic, strong) UIView *toolView; //工具栏
@property (nonatomic, strong) UILabel *titleLabel; //@"请选择日期"
@end
