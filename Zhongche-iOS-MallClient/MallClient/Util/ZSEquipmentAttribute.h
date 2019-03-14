//
//  ZSEquipmentAttribute.h
//  LogisticsAssistant
//
//  Created by 中车_LL_iMac on 16/8/28.
//  Copyright © 2016年 com.chongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSEquipmentAttribute : NSObject
/**
 *  获取设备型号名称
 *
 *  @return return value description
 */
+ (NSString *)getDeviceName;
/**
 *  获取图片适配后缀
 *
 */
+ (NSString *)getPriceSuffix;
//获取屏幕
+(int)getRetina;
@end
