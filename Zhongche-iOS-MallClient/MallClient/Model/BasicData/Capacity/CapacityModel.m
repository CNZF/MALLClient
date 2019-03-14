//
//  CapacityModel.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/25.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CapacityModel.h"

@implementation CapacityModel
-(NSString *)time
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_time longLongValue] / 1000.0]];
}
@end
