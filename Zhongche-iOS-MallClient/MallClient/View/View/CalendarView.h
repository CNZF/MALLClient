//
//  CalendarView.h
//  MallClient
//
//  Created by lxy on 2016/11/24.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@protocol chooseDateDelegate <NSObject>

- (void)chooseDateActionWithDate:(NSDate *)date;

@end

@interface CalendarView : BaseView

+(CalendarView *)shareCalendarView;

@property (nonatomic, assign) id<chooseDateDelegate>chooseDateInfo;
@property (nonatomic, assign) float backgroundAlpha;
@property (nonatomic, assign) BOOL isFour;
@end
