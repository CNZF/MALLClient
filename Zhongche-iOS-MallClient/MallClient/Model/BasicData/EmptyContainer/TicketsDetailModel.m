//
//  TicketsDetailModel.m
//  MallClient
//
//  Created by Tim on 2018/5/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "TicketsDetailModel.h"
#import "ContainerModel.h"
#import "EntrepotModel.h"

@implementation TicketsDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"simpleTransportList" : [ContainerModel class],
             @"startEntrepotName" : EntrepotModel.class,
             @"endEntrepotName" : EntrepotModel.class
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID":@"id"
             };
}


@end
