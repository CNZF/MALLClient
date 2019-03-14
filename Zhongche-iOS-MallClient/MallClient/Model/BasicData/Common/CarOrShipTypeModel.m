//
//  CarOrShipTypeModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "CarOrShipTypeModel.h"

@implementation CarOrShipTypeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name":@"vehicleTypeName",
             @"code":@"vehicleTypeCode"
             };
}
@end
