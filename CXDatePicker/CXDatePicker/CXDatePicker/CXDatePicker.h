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

-(void)showDatePicker:(UIView *)view maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate format:(NSString *)format selectDate:(NSDate *)selectDate determineBlock:(determineBlock)determineBlock cancelBlock:(cancelBlock)cancelBlock;

/**
indexArray @[@"yyyy","MM",@"dd",@"HH",@"mm"]; 自由错乱顺序组合 默认正常顺序
 */
@property (nonatomic, strong)  NSMutableArray*indexArray;

@property (nonatomic, strong) UIFont *textFont; // 文字字体
@property (nonatomic, strong) UIColor *textColor; //文字颜色

@property (nonatomic, strong) UIButton *determineButton; //确定按钮 right
@property (nonatomic, strong) UIButton *cancelButton; //取消按钮lefy

@property (nonatomic, strong) UIView *toolView; //工具栏
@property (nonatomic, strong) UILabel *titleLabel; //@"请选择日期"
@end
