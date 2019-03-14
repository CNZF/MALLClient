//
//  NSString+addPictureSuffix.m
//  LogisticsAssistant
//
//  Created by 中车_LL_iMac on 16/8/28.
//  Copyright © 2016年 com.chongche.cn. All rights reserved.
//

#import "NSString+addPictureSuffix.h"

@implementation NSString (addPictureSuffix)
- (NSString *)adS
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [NSString stringWithFormat:@"%@%@.png",self,app.priceSuffix];
}
@end
