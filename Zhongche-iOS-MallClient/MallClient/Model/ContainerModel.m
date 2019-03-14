//
//  ContainerModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "ContainerModel.h"

@implementation ContainerModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"imgurl":@"photoUrl",
             @"containerName":@"containerType",
             @"certificationState":@"authenticationStatus",
             @"inventory":@"storageNumber",
             @"unitPrice":@[@"rentPrice",@"salePrice"],
             @"ID":@"id",
             @"cityName":@"locationName"
             };
}
@end
