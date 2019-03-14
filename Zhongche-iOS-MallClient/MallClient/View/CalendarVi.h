//
//  CalendarVi.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/26.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"
typedef enum
{
    radio,
    interval
}CalendarViewType;

@protocol CalendarViDelegate <NSObject>

-(void)calendarViGetSelectedDate:(NSDate *)selectedDate;
-(void)calendarViGetStartDate:(NSDate *)startDate WithEndDate:(NSDate *)date;

@end

@interface CalendarVi : BaseView

@property (nonatomic, strong)UIView * titleView;

@property (nonatomic, strong)NSDate * selectedDate;
@property (nonatomic, strong)NSDate * startDate;
@property (nonatomic, strong)NSDate * endDate;

@property (nonatomic, assign)CalendarViewType type;

@property (nonatomic, weak)id<CalendarViDelegate>viDelegate;
+(CalendarVi *)shareCalendarView;
@end
