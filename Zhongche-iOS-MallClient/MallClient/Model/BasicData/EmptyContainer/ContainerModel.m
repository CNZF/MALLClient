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
//             @"containerName":@"containerType",
             @"certificationState":@"authenticationStatus",
             @"inventory":@"storageNumber",
             @"unitPrice":@[@"rentPrice",@"salePrice"],
             @"ID":@"id",
             @"cityName":@"locationName"
             };
}

-(void)setUnitPrice:(NSString *)unitPrice {
    _unitPrice = [NSString stringWithFormat:@"%.2f",[unitPrice doubleValue]];
}

- (void)setVolume:(NSString *)volume {

    _volume = [NSString stringWithFormat:@"%.2f",[volume doubleValue]];
}

-(void)setImgurl:(NSString *)imgurl {
    NSArray * imgurlArray = [imgurl componentsSeparatedByString:@"☼"];
    if (imgurlArray.count > 0) {
        _imgurl = [imgurlArray[0] copy];
    }
}

-(void)setRentPrice:(NSString *)rentPrice {

    _rentPrice = [NSString stringWithFormat:@"%.2f",[rentPrice doubleValue]];
}

@end
