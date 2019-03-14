//
//  NSString+Money.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/6/4.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "NSString+Money.h"

@implementation NSString (Money)

/*
 NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,
 
 NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,
 
 NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,
 
 NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,
 
 NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,
 
 NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
 
 
 123456789
 
 123,456,789
 
 ￥123,456,789.00
 
 -539,222,988%
 
 1.23456789E8
 
 */

+ (NSAttributedString *)getFormartPrice:(float)price
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =kCFNumberFormatterCurrencyStyle;
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:newAmount];
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"."].location + 1;
    NSUInteger secondLoc = noteStr.length;
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:12] range:range];
    return noteStr;
}
@end
