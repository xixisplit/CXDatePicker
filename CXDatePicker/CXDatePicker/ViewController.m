//
//  ViewController.m
//  CXDatePicker
//
//  Created by 陈曦1 on 2018/9/17.
//  Copyright © 2018年 xi chen. All rights reserved.
//

#import "ViewController.h"
#import "CXDatePicker.h"
#import "NSDate+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"按钮" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
}

-(void)buttonClick
{
    CXDatePicker *picker = [[CXDatePicker alloc] init];
    picker.titleLabel.text = @"请选择时间";
    picker.infiniteScroll = YES;
//    picker.indexArray = [@[@"MM",@"dd",@"yyyy"] mutableCopy];
    [picker showDatePicker:self.view maxDate:[NSDate dateWithString:@"2021-01-02 15:59:53" withFormat:nil] minDate:[NSDate dateWithString:@"2001-09-10 00:00:00" withFormat:nil] format:@"yyyy-MM-dd HH:mm" selectDate:[NSDate date] determineBlock:^(CXDatePicker *datePicker, NSDictionary *selectDate) {
        
        NSLog(@"%@",selectDate);
        
    } cancelBlock:^(CXDatePicker *datePicker) {
        
    }];
    
}




@end
