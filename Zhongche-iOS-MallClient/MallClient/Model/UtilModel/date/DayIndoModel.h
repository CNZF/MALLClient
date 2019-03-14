//
//  DayIndoModel.h
//  MallClient
//
//  Created by lxy on 2016/11/24.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface DayIndoModel : BaseModel

@property (nonatomic, assign) int day;
@property (nonatomic, assign) int weekday;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) int year;


- (void) modelWithDate:(NSDate *)senddate;

@end
