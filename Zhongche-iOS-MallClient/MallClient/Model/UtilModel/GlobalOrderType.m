//
//  GlobalOrderType.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/14.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "GlobalOrderType.h"
static GlobalOrderType * orderType = nil;

@implementation GlobalOrderType
+(GlobalOrderType *)shareGlobalOrderType{
    @synchronized(self){
        if (orderType ==nil ) {
            orderType = [[self alloc] init];
            orderType.whetherTheAvailable = YES;
            orderType.orderType = @"我要运力";
        }
    }
    return orderType;
}

@end
