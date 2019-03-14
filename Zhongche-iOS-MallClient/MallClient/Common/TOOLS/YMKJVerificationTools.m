//
//  YMKJVerificationTools.m
//  TOOLCLASSES
//
//  Created by qinzhongzeng on 16/6/29.
//  Copyright © 2016年 qinzhongzeng. All rights reserved.
//

#import "YMKJVerificationTools.h"

@implementation YMKJVerificationTools

static id sharedInstance = nil;
+ (YMKJVerificationTools *)sharedVerificationTools
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}
+ (id)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }else
    {
        return NO;
    }
}

+ (BOOL)isValid6_Account:(NSString *)account
{
    if (account.length == 0) {
        return NO;
    }
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{8,20}$"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"];
    if ([pred evaluateWithObject:account]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isValid4_Account:(NSString *)account
{
    if (account.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{4,20}$"];
    if ([pred evaluateWithObject:account]) {
        return YES;
    }
    return NO;
}
//NSString *passWordRegex = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,20}$";

+ (BOOL)isAvailablePassWord:(NSString *)password
{
    if (password.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,16}$"];
    if ([pred evaluateWithObject:password]) {
        return YES;
    }
    return NO;
}


+ (BOOL)isAvailableNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9.]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAvailableA_Z:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[A-Za-z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAvailabLetterAndNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9A-Za-z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAvailabHasAndLatter:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
//    NSString *regex = @"^[\u4E00-\u9FA5a-zA-Z0-9]+$";//姓名数字字母
    NSString *regex = @"^[\u4E00-\u9FA5-a-z-A-Z]+$";//汉字字母
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAvailablePhoneNumber:(NSString *)PhoneNumber
{
    if (PhoneNumber.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^((13[0-9])|(15[^4,\\D])|(14[579])|(17[0-9])|(18[0,0-9]))\\d{8}$"];
    if ([pred evaluateWithObject:PhoneNumber]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAvailableEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isOnlyHaveChineseInString:(NSString *)string
{
    if (string.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[\u4E00-\u9FA5]+$"];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}


+ (BOOL)stringContrainsEmoji:(NSString *)string { __block BOOL returnValue = NO; [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) { const unichar hs = [substring characterAtIndex:0]; if (0xd800 <= hs && hs <= 0xdbff) { if (substring.length > 1) { const unichar ls = [substring characterAtIndex:1]; const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000; if (0x1d000 <= uc &&uc <= 0x1f77f) { returnValue = YES; } } } else if (substring.length > 1) { const unichar ls = [substring characterAtIndex:1]; if (ls == 0x20e3) { returnValue = YES; } } else { if (0x2100 <= hs && hs <= 0x27ff) { returnValue = YES; } else if (0x2B05 <= hs && hs <= 0x2b07) { returnValue = YES; } else if (0x2934 <= hs && hs <= 0x2935) { returnValue = YES; } else if (0x3297 <= hs && hs <= 0x3299) { returnValue = YES; } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) { returnValue = YES; } } }];
    return returnValue;
    
}
+ (BOOL)isHaveChineseInString:(NSString *)string
{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)checkIdentityCardNum:(NSString*)cardNum {
    cardNum = [cardNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSInteger length =0;
    
    if (!cardNum) {
        
        return NO;
        
    }else {
        
        length = cardNum.length;

        if (length !=15 && length !=18) {
            
            return NO;
        }
    }
    
    // 省份代码
    
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
   
    NSString *valueStart2 = [cardNum substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
            
        }
        
    }
    
    if (!areaFlag) {
        
        return false;
        
    }
 
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
  
    int year =0;
    
    switch (length) {
            
        case 15:
            
            year = [cardNum substringWithRange:NSMakeRange(6,2)].intValue +1900;
          
            if (year %4 ==0 || (year %100 !=0 && year %4 ==0)) {
              
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"  options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:cardNum  options:NSMatchingReportProgress  range:NSMakeRange(0, cardNum.length)];
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        case 18:
            year = [cardNum substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 !=0 && year %4 ==0)) {
        
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"   options:NSRegularExpressionCaseInsensitive   error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"  options:NSRegularExpressionCaseInsensitive  error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:cardNum   options:NSMatchingReportProgress  range:NSMakeRange(0, cardNum.length)];
            
            if(numberofMatch >0) {
                
                int S = ([cardNum substringWithRange:NSMakeRange(0,1)].intValue + [cardNum substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([cardNum substringWithRange:NSMakeRange(1,1)].intValue + [cardNum substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([cardNum substringWithRange:NSMakeRange(2,1)].intValue + [cardNum substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([cardNum substringWithRange:NSMakeRange(3,1)].intValue + [cardNum substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([cardNum substringWithRange:NSMakeRange(4,1)].intValue + [cardNum substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([cardNum substringWithRange:NSMakeRange(5,1)].intValue + [cardNum substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([cardNum substringWithRange:NSMakeRange(6,1)].intValue + [cardNum substringWithRange:NSMakeRange(16,1)].intValue) *2 + [cardNum substringWithRange:NSMakeRange(7,1)].intValue *1 + [cardNum substringWithRange:NSMakeRange(8,1)].intValue *6 + [cardNum substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[cardNum substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    
                    return NO;
                    
                }
         
            }else {
                
                return NO;
                
            }
            
        default:
            
            return false;
    }
}


@end
