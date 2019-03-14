//
//  OftenUseCityCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/1.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OftenUseCityCell.h"
#import "CityModel.h"
#define BUTTONTAG_KEY 1024

@implementation OftenUseCityCell
-(void)loadUIWithmodel:(NSArray *)citys
{
    for (UIView * view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    CityModel * city;
    UIButton * btn;
    CGFloat width = (SCREEN_W - 210 - 90) / 2;
    for (int i = 0; i < citys.count; i ++) {
        city = citys[i];
        btn = [[UIButton alloc]initWithFrame:CGRectMake(20 + (i%3)* (width + 70), 20 + (i / 3)*50 , 70, 30)];
        [btn setTitle:city.name
             forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        btn.tag = BUTTONTAG_KEY + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btn addTarget:self action:@selector(btuClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:15];//设置矩形四个圆角半径
        [btn.layer setMasksToBounds:YES];
        btn.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
        btn.layer.borderWidth = 0.5;
        [self addSubview:btn];
    }
}
-(void)btuClick:(UIButton *)btn
{
    [self.cellDelegate getClickBtnNum:btn.tag - BUTTONTAG_KEY];
}
@end
