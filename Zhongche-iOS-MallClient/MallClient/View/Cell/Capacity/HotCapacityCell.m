//
//  HotCapacityCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/1/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "HotCapacityCell.h"

@interface HotCapacityCell()

@property (nonatomic, strong) UILabel     * startCity;
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, strong) UILabel     * endCity;
@property (nonatomic, strong) UILabel     * priceLab;

@property (nonatomic, strong) UIView      * lineVi;



@end

@implementation HotCapacityCell
-(void)loadUIWithmodel:(CapacityEntryModel *)model
{ 
    self.startCity.text = model.startPlace.name;
    
    self.endCity.text = model.endPlace.name;
    
    //[self.startCity.text sizeWithAttributes:@{NSFontAttributeName:self.startCity.font}].width
    
    self.startCity.frame = CGRectMake(self.startCity.left, self.startCity.top,80 , self.startCity.height);
    self.line.frame = CGRectMake(self.startCity.right + 7, self.line.top, self.line.width, self.line.height);
    self.endCity.frame = CGRectMake(self.line.right + 7, self.endCity.top, 80, self.endCity.height);
    
    self.boxName.text = model.businessTypeCode;
    
    CGFloat fix = [model.line_fix_price floatValue];
    CGFloat base  = [model.line_base_price floatValue];
    CGFloat all = fix + base;
    NSString * allPrice = [NSString stringWithFormat:@"%f",all];
    
    NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@起",[allPrice NumberStringToMoneyString]]];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED_TEXT range:NSMakeRange(0,price.length - 1)];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY2 range:NSMakeRange(price.length - 1,1)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 4)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 4,4)];
    self.priceLab.attributedText = price;


    self.lbDay.text = [NSString stringWithFormat:@"%@天",model.day];
    self.lbDistance.text = [NSString stringWithFormat:@"%@km",model.mileage];

    self.lbDay.frame = CGRectMake(15, 42, [self.lbDay.text sizeWithAttributes:@{NSFontAttributeName:self.lbDay.font}].width + 6, 16);
    [self addSubview:self.lbDay];

    self.lbDistance.frame = CGRectMake(self.lbDay.right + 20, 42, [self.lbDistance.text sizeWithAttributes:@{NSFontAttributeName:self.lbDistance.font}].width + 6, 16);
    [self addSubview:self.lbDistance];



}
-(void)bindView
{
    self.startCity.frame = CGRectMake(15, 15, 40, 20);
    [self addSubview:self.startCity];
    
    self.line.frame = CGRectMake(self.startCity.right + 10, 21, 43, 7);
    [self addSubview:self.line];
    
    self.endCity.frame = CGRectMake(self.line.right + 10, 15, 35, 20);
    [self addSubview:self.endCity];
    
//    self.priceLab.frame = CGRectMake(SCREEN_W / 2, 14, SCREEN_W / 2 - 20, 20);
    [self addSubview:self.priceLab];
    
//    self.boxName.frame = CGRectMake(15, 42, SCREEN_W / 2, 18);
//    [self addSubview:self.boxName];

    self.lbDay.frame = CGRectMake(15, 42, [self.lbDay.text sizeWithAttributes:@{NSFontAttributeName:self.lbDay.font}].width + 6, 16);
    [self addSubview:self.lbDay];

    self.lbDistance.frame = CGRectMake(self.lbDay.right + 20, 42, [self.lbDistance.text sizeWithAttributes:@{NSFontAttributeName:self.lbDistance.font}].width + 6, 16);
    [self addSubview:self.lbDistance];
    
    self.lineVi.frame = CGRectMake(15, 49.5, SCREEN_W-30, 0.5);
    [self addSubview:self.lineVi];
}

-(UILabel *)startCity
{
    if (!_startCity) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.textAlignment = NSTextAlignmentLeft;
        _startCity = lab;
    }
    return _startCity;
}

-(UILabel *)endCity
{
    if (!_endCity) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_BLACK_TEXT;
        _endCity = lab;
    }
    return _endCity;
}

-(UIImageView *)line
{
    if (!_line) {
        UIImageView * img = [UIImageView new];
        img.image = [UIImage imageNamed:[@"Group 19 Copy" adS]];
        _line = img;
    }
    return _line;
}

-(UILabel *)priceLab
{
    if (!_priceLab) {
        UILabel * lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentRight;
        _priceLab = lab;
    }
    return _priceLab;
}

-(UILabel *)boxName
{
    if (!_boxName) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        _boxName = lab;
    }
    return _boxName;
}

-(UIView *)lineVi
{
    if (!_lineVi) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        _lineVi = view;
    }
    return _lineVi;
}

- (UILabel *)lbDay
{
    if (!_lbDay) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY999;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.layer.borderColor = [APP_COLOR_GRAY999 CGColor];
        label.layer.borderWidth = 0.5;
        label.text = @"5天";
        label.textAlignment = NSTextAlignmentCenter;




        _lbDay = label;
    }
    return _lbDay;
}

- (UILabel *)lbDistance
{
    if (!_lbDistance) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY999;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.layer.borderColor = [APP_COLOR_GRAY999 CGColor];
        label.layer.borderWidth = 0.5;
        label.text = @"738km";
        label.textAlignment = NSTextAlignmentCenter;


        _lbDistance = label;
    }
    return _lbDistance;
}


@end
