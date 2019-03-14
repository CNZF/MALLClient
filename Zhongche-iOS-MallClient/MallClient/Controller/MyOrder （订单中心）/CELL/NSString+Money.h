//
//  NSString+Money.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/6/4.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Money)

//获取价钱格式   123,123.00

+ (NSAttributedString *)getFormartPrice:(float)price;

@end
