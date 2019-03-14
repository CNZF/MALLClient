
//
//  OftenUseCityAndBranchesCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/5/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OftenUseCityAndBranchesCell.h"
#import "CityModel.h"
#define BUTTONTAG_KEY 1024


@implementation OftenUseCityAndBranchesCell

-(void)loadUIWithmodel:(NSArray *)citys
{
    for (UIView * view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    CityModel * model;
    UIButton * btn;
    UIButton * lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20 ,0, 30)];
    NSString * text;
    float width;
    for (int i = 0; i < citys.count; i ++) {
        model = citys[i];
        switch (model.modelType) {
            case city:
                text = model.name;
                break;
            case branches:
                text = [NSString stringWithFormat:@"%@(%@)",model.name,model.regionName];
                break;
        }
        width = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]}].width + 30;
        if (40 + lastBtn.right + width < SCREEN_W) {
            btn = [[UIButton alloc]initWithFrame:CGRectMake(20 + lastBtn.right, lastBtn.top, width, 30)];
        } else {
            btn = [[UIButton alloc]initWithFrame:CGRectMake(20, lastBtn.top + 50, width, 30)];
        }
        [btn setTitle:text forState:UIControlStateNormal];
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
        
        lastBtn = btn;
    }
}

-(void)btuClick:(UIButton *)btn
{
    [self.cellDelegate getClickBtnNum:btn.tag - BUTTONTAG_KEY];
}

+(float)getCellHeightWithmodel:(NSArray *)citys {
    
    CityModel * model;
    CGRect  btnRect;
    CGRect  lastBtnRect = CGRectMake(0, 20 ,0, 30);
    NSString * text;
    float width;
    for (int i = 0; i < citys.count; i ++) {
        model = citys[i];
        switch (model.modelType) {
            case city:
                text = model.name;
                break;
            case branches:
                text = [NSString stringWithFormat:@"%@(%@)",model.name,model.regionName];
                break;
        }
        width = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]}].width + 30;
        if (40 + lastBtnRect.origin.x +  lastBtnRect.size.width + width < SCREEN_W) {
            btnRect = CGRectMake(20 + lastBtnRect.origin.x +  lastBtnRect.size.width, lastBtnRect.origin.y, width, 30);
        } else {
            btnRect = CGRectMake(20, lastBtnRect.origin.y + 50, width, 30);
        }
        lastBtnRect = btnRect;
    }
    return lastBtnRect.origin.y + 50;
}
@end
