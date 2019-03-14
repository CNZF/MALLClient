//
//  NSString+NumberStringToMoneyString.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/2/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "NSString+NumberStringToMoneyString.h"

@implementation NSString (NumberStringToMoneyString)
-(NSString *)NumberStringToMoneyString
{
    if (self.floatValue <= 0) {
        return @"0.00";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    float f = self.floatValue - self.integerValue;
    [numberFormatter setPositiveFormat:@"###,###.00;"];

    NSString * str1 = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self floatValue]]];
    NSString * str2 = [NSString stringWithFormat:@"%.2f",f];
    NSArray * arr1 = [str1 componentsSeparatedByString:@"."];
    NSArray * arr2 = [str2 componentsSeparatedByString:@"."];
    return [NSString stringWithFormat:@"%@.%@",arr1[0],arr2[1]];
}
-(NSString *)NumberStringToMoneyStringGetLastThree
{
    if (self.floatValue <= 0) {
        return @".00";
    }
    float f = self.floatValue - self.integerValue;
    NSString * str2 = [NSString stringWithFormat:@"%.2f",f];
    NSArray * arr2 = [str2 componentsSeparatedByString:@"."];
    return [NSString stringWithFormat:@".%@",arr2[1]];
}
//NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//if (self.floatValue == self.integerValue) {
//    [numberFormatter setPositiveFormat:@"###,###.00;"];
//}
//else if (self.floatValue * 10 == (int)(self.floatValue * 10)) {
//    [numberFormatter setPositiveFormat:@"###,###.#0;"];
//}
//else
//{
//    [numberFormatter setPositiveFormat:@"###,###.##;"];
//}
//return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self floatValue]]];
////NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
////float f = self.floatValue - self.integerValue;
////if (self.floatValue == self.integerValue) {
////    [numberFormatter setPositiveFormat:@"###,###.00;"];
////}
////NSString * str1 = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self floatValue]]];
////NSString * str2 = [NSString stringWithFormat:@"%.2f",f];
////NSArray * arr1 = [str1 componentsSeparatedByString:@"."];
////NSArray * arr2 = [str2 componentsSeparatedByString:@"."];
////return [NSString stringWithFormat:@"%@.%@",arr1[0],arr2[1]];
@end
