//
//  AddressInfo.m
//  MallClient
//
//  Created by lxy on 2016/12/8.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
   
//    return @{@"ID":@"id"};
    return @{
             @"contactsPhone" : @"contacts_Phone",
             @"address" : @"detailAddress",
             @"ID" : @"id",
             };

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSelect = NO;
    }
    return self;
}

@end
