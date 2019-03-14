//
//  DayIndoModel.m
//  MallClient
//
//  Created by lxy on 2016/11/24.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "DayIndoModel.h"

@implementation DayIndoModel

- (void) modelWithDate:(NSDate *)senddate {


    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    NSString *  yearString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"dd"];
    NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];

    NSString *weekString = [dateformatter stringFromDate:senddate];
    self.year  = [yearString intValue];
    self.month = [monthString intValue];
    self.day = [dayString intValue];


    if([weekString isEqualToString:@"周日"]||[weekString isEqualToString:@"Sun"]){
        self.weekday = 0;
    }
    if([weekString isEqualToString:@"周一"]||[weekString isEqualToString:@"Mon"]){
        self.weekday = 1;
    }
    if([weekString isEqualToString:@"周二"]||[weekString isEqualToString:@"Tue"]){
        self.weekday = 2;
    }
    if([weekString isEqualToString:@"周三"]||[weekString isEqualToString:@"Wed"]){
        self.weekday = 3;
    }
    if([weekString isEqualToString:@"周四"]||[weekString isEqualToString:@"Thu"]){
        self.weekday = 4;
    }
    if([weekString isEqualToString:@"周五"]||[weekString isEqualToString:@"Fri"]){
        self.weekday = 5;
    }
    if([weekString isEqualToString:@"周六"]||[weekString isEqualToString:@"Sat"]){
        self.weekday = 6;
    }


}


@end
