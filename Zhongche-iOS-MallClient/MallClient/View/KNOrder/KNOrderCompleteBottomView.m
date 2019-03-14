//
//  KNOrderCompleteBottomView.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNOrderCompleteBottomView.h"

@implementation KNOrderCompleteBottomView

- (void)setPrice:(NSString *)price{
    double pricedb = [price doubleValue];
    NSString *str = [NSString stringWithFormat:@"￥%.2f",pricedb];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSUInteger loc = str.length;
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 2, 2)];
    self.priceLabel.attributedText = AttributedStr;
}

@end
