//
//  OrderProgressModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/1/4.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderProgressModel.h"

@implementation OrderProgressModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"name":@"STATUS",
             @"time":@"create_time"};
}
@end
