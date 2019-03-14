//
//  EmptyContainerListCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "EmptyContainerListCell.h"
#import "UIImageView+WebCache.h"

@interface EmptyContainerListCell()

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * certificationState;
@property (nonatomic, strong)UILabel * containerName;
@property (nonatomic, strong)UILabel * unitPrice;
@property (nonatomic, strong)UILabel * cityName;
@property (nonatomic, strong)UILabel * inventory;

@property (nonatomic, strong)UIView * line_01;
@property (nonatomic, strong)UIView * line_02;
@end

@implementation EmptyContainerListCell

-(void)loadUIWithmodel:(ContainerModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASEIMGURL,model.imgurl]] placeholderImage:[UIImage imageNamed:[@"Placeholder figure" adS]]];
    
    if ([model.certificationState boolValue]) {
        self.certificationState.hidden = NO;
        self.containerName.frame = CGRectMake(42, CGRectGetMaxY(self.imageView.frame) + 10, SCREEN_W / 2 - 50, 19);
    }
    else
    {
        self.certificationState.hidden = YES;
        self.containerName.frame = CGRectMake(10, CGRectGetMaxY(self.imageView.frame) + 10, SCREEN_W / 2 - 20, 19);

    }
    
    self.containerName.text= model.containerName;
    
    self.cityName.text = model.cityName;
    self.inventory.text = [NSString stringWithFormat:@"库存:%@",model.inventory];

    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@/%@",[model.unitPrice NumberStringToMoneyString],model.unit]];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f]
                       range:NSMakeRange(0, attrString.length - model.unit.length - 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f]
                       range:NSMakeRange(attrString.length - model.unit.length - 1,model.unit.length + 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f]
                       range:[attrString.string rangeOfString:[model.unitPrice NumberStringToMoneyStringGetLastThree]]];
    // 设置颜色
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:APP_COLOR_RED_TEXT
                       range:NSMakeRange(0, attrString.length)];
    self.unitPrice.attributedText = attrString;
    
    if (CGRectGetMaxX(self.frame) > SCREEN_W / 2) {
        self.line_02.hidden = YES;
    }
    else
    {
        self.line_02.hidden = NO;
    }
    
    float width = MIN(SCREEN_W / 4 - 10, [self.inventory.text sizeWithAttributes:@{NSFontAttributeName:self.inventory.font}].width);
    self.inventory.frame = CGRectMake(SCREEN_W / 2 - 10 - width, CGRectGetMaxY(self.unitPrice.frame) + 10, width, 15);
    self.cityName.frame = CGRectMake(10,  CGRectGetMaxY(self.unitPrice.frame) + 10, SCREEN_W / 2 - width - 20, 15);
}
-(void)bindView
{
    self.backgroundColor = APP_COLOR_WHITE;
    self.imageView.frame = CGRectMake(10, 10, SCREEN_W / 2 - 20, 110);
    [self addSubview:self.imageView];
    
    self.certificationState.frame = CGRectMake(10,CGRectGetMaxY(self.imageView.frame) + 14, 26, 13);
    [self addSubview:self.certificationState];
    
    self.containerName.frame = CGRectMake(42, CGRectGetMaxY(self.imageView.frame) + 10, SCREEN_W / 2 - 50, 19);
    [self addSubview:self.containerName];
    
    self.unitPrice.frame = CGRectMake(10, CGRectGetMaxY(self.containerName.frame) + 10, SCREEN_W / 2 - 20, 16);
    [self addSubview:self.unitPrice];
    
    self.cityName.frame = CGRectMake(10,  CGRectGetMaxY(self.unitPrice.frame) + 10, SCREEN_W / 4 - 10, 15);
    [self addSubview:self.cityName];
    
    self.inventory.frame = CGRectMake(SCREEN_W / 4,  CGRectGetMaxY(self.unitPrice.frame) + 10, SCREEN_W / 4 - 10, 15);
    [self addSubview:self.inventory];
    
    self.line_01.frame = CGRectMake(0, 210, SCREEN_W / 2, 0.5);
    [self addSubview:self.line_01];
    
    self.line_02.frame = CGRectMake(SCREEN_W / 2 - 1, 0, 0.3, 211);
    [self addSubview:self.line_02];
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

-(UILabel *)certificationState
{
    if (!_certificationState) {
        
        UILabel * lab = [UILabel new];
        lab.text = @"认证";
        lab.font = [UIFont systemFontOfSize:8.f];
        lab.textColor = APP_COLOR_RED_TEXT;
        lab.textAlignment = NSTextAlignmentCenter;
        [lab.layer setMasksToBounds:YES];
        lab.layer.cornerRadius = 3.0;
        lab.layer.borderColor = [APP_COLOR_RED_TEXT CGColor];
        lab.layer.borderWidth = 0.5;
        
        _certificationState = lab;
    }
    return _certificationState;
}

-(UILabel *)containerName
{
    if (!_containerName) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        
        _containerName = lab;
    }
    return _containerName;
}
-(UILabel *)unitPrice
{
    if (!_unitPrice) {
        
        UILabel * lab = [UILabel new];
        _unitPrice = lab;
    }
    return _unitPrice;
}
-(UILabel *)cityName
{
    if (!_cityName) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _cityName = lab;
    }
    return _cityName;
}

-(UILabel *)inventory
{
    if (!_inventory) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.textAlignment = NSTextAlignmentRight;

        _inventory = lab;
    }
    return _inventory;
}

-(UIView *)line_01
{
    if (!_line_01) {
        
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        _line_01 = view;
    }
    return _line_01;
}

-(UIView *)line_02
{
    if (!_line_02) {
        
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        _line_02 = view;
        
    }
    return _line_02;
}@end
