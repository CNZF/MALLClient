//
//  CityModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+(instancetype)yy_modelWithJSON:(id)json
{
    CityModel * obj =  [super yy_modelWithJSON:json];
    NSMutableString * position = [NSMutableString stringWithString:obj.name];
    CFStringTransform((CFMutableStringRef)position,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)position,NULL, kCFStringTransformStripDiacritics,NO);
    obj.startPinyin = [[position substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    return obj;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"startPositionCode":@"region_code",@"startPosition":@"name"};
}



@end
