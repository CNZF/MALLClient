//
//  ZSEquipmentAttribute.m
//  LogisticsAssistant
//
//  Created by 中车_LL_iMac on 16/8/28.
//  Copyright © 2016年 com.chongche.cn. All rights reserved.
//

#import "ZSEquipmentAttribute.h"
#import <SDVersion/SDVersion.h>

@implementation ZSEquipmentAttribute
/**
 *  获取设备型号名称
 *
 *  @return return value description
 */
+ (NSString *)getDeviceName{
    
    NSDictionary * dict = @{
                            @"i386":@"iPhone Simulator",
                            @"x86_64":@"iPhone Simulator",
                            @"Simulator":@"模拟器",
                            
                            @"iPhone1,1":@"iPhone 2G",
                            @"iPhone1,2":@"iPhone 3G",
                            @"iPhone2,1":@"iPhone 3GS",
                            @"iPhone3,1":@"iPhone 4(GSM)",
                            @"iPhone3,2":@"iPhone 4(GSM Rev A)",
                            @"iPhone3,3":@"iPhone 4(CDMA)",
                            @"iPhone4,1":@"iPhone 4S",
                            @"iPhone5,1":@"iPhone 5(GSM)",
                            @"iPhone5,2":@"iPhone 5(GSM+CDMA)",
                            @"iPhone5,3":@"iPhone 5c(GSM)",
                            @"iPhone5,4":@"iPhone 5c(Global)",
                            @"iPhone6,1":@"iphone 5s(GSM)",
                            @"iPhone6,2":@"iphone 5s(Global)",
                            @"iPhone7,2":@"iPhone 6",
                            @"iPhone7,1":@"iPhone 6 Plus",
                            @"iPhone8,1":@"iPhone 6s",
                            @"iPhone8,2":@"iPhone 6s Plus",
                            @"iPhone8,4":@"iPhone SE",
                            @"iPhone9,1":@"iPhone 7",
                            @"iPhone9,2":@"iPhone 7 Plus",
                            
                            @"iPod1,1":@"iPod Touch 1G",
                            @"iPod2,1":@"iPod Touch 2G",
                            @"iPod3,1":@"iPod Touch 3G",
                            @"iPod4,1":@"iPod Touch 4G",
                            @"iPod5,1":@"iPod Touch 5G",
                            
                            
                            @"iPad1,1":@"iPad",
                            @"iPad2,1":@"iPad 2(WiFi)",
                            @"iPad2,2":@"iPad 2(GSM)",
                            @"iPad2,3":@"iPad 2(CDMA)",
                            @"iPad2,4":@"iPad 2(WiFi + New Chip)",
                            @"iPad3,1":@"iPad 3(WiFi)",
                            @"iPad3,2":@"iPad 3(GSM+CDMA)",
                            @"iPad3,3":@"iPad 3(GSM)",
                            @"iPad3,4":@"iPad 4(WiFi)",
                            @"iPad3,5":@"iPad 4(GSM)",
                            @"iPad3,6":@"iPad 4(GSM+CDMA)",
                            
                            @"iPad2,5":@"iPad mini (WiFi)",
                            @"iPad2,6":@"iPad mini (GSM)",
                            @"iPad2,7":@"ipad mini (GSM+CDMA)",
                            };
    if(dict[[SDVersion deviceName]] != nil)
    {
        return dict[[SDVersion deviceName]];
    }
    else
    {
        return @"未知设备";
    }
}
+ (NSString *)getPriceSuffix
{
    return [NSString stringWithFormat:@"@%dx",[ZSEquipmentAttribute getRetina]];
}
+(int)getRetina
{
    int retina = 2;
    if([[ZSEquipmentAttribute getDeviceName] rangeOfString:@"Plus"].location != NSNotFound)
    {
        retina = 3;
    }
    return retina;
}
@end
