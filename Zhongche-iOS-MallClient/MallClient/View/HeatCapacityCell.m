//
//  HeatCapacityCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/25.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "HeatCapacityCell.h"
#import "UIImageView+WebCache.h"

@interface HeatCapacityCell()

@property (nonatomic, strong)UIImageView * image1;
@property (nonatomic, strong)UILabel * lineLab1;
@property (nonatomic, strong)UILabel * priceLab1;
@property (nonatomic, strong)UILabel * timeLab1;

@property (nonatomic, strong)UIImageView * image2;
@property (nonatomic, strong)UILabel * lineLab2;
@property (nonatomic, strong)UILabel * priceLab2;
@property (nonatomic, strong)UILabel * timeLab2;

@end

@implementation HeatCapacityCell

-(void)loadUIWithmodel:(id)model
{
    if ([model isKindOfClass:[NSArray class]]) {
        NSArray * models = model;
        if (models.count >= 1)
        {
            CapacityModel * model1 = models[0];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:model1.imageurl]  placeholderImage:[UIImage imageNamed:@"2.png"]];
            self.lineLab1.text = model1.line;
            self.priceLab1.text = [NSString stringWithFormat:@"¥%@",model1.price];
            self.timeLab1.text = model1.time;
            
            if (models.count == 2) {
                CapacityModel * model2 = models[1];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:model2.imageurl] placeholderImage:[UIImage imageNamed:@"1.png"]];
                self.lineLab2.text = model2.line;
                self.priceLab2.text = [NSString stringWithFormat:@"¥%@",model2.price];
                self.timeLab2.text = model2.time;
                
                self.image2.hidden = NO;
                self.lineLab2.hidden = NO;
                self.priceLab2.hidden = NO;
                self.timeLab2.hidden = NO;
            }
            else
            {
                self.image2.hidden = YES;
                self.lineLab2.hidden = YES;
                self.priceLab2.hidden = YES;
                self.timeLab2.hidden = YES;
            }
        }
    }
}

-(void)bindView
{
    self.image1.frame = CGRectMake(15, 5, (SCREEN_W - 45) / 2, 105);
    [self addSubview:self.image1];
    
    self.lineLab1.frame = CGRectMake(self.image1.left, self.image1.bottom + 5, self.image1.width, 20);
    [self addSubview:self.lineLab1];
    
    self.priceLab1.frame = CGRectMake(self.image1.left, self.lineLab1.bottom + 10, self.image1.width / 2, 20);
    [self addSubview:self.priceLab1];
    
    self.timeLab1.frame = CGRectMake(self.priceLab1.right, self.lineLab1.bottom + 10, self.image1.width / 2, 20);
    [self addSubview:self.timeLab1];
    
    
    self.image2.frame = CGRectMake(self.image1.right + 15, 5, (SCREEN_W - 45) / 2, 105);
    [self addSubview:self.image2];
    
    self.lineLab2.frame = CGRectMake(self.image2.left, self.image2.bottom + 5, self.image2.width, 20);
    [self addSubview:self.lineLab2];
    
    self.priceLab2.frame = CGRectMake(self.image2.left, self.lineLab2.bottom + 10, self.image2.width / 2, 20);
    [self addSubview:self.priceLab2];
    
    self.timeLab2.frame = CGRectMake(self.priceLab2.right, self.lineLab2.bottom + 10, self.image2.width / 2, 20);
    [self addSubview:self.timeLab2];
}

-(UIImageView *)image1
{
    if (!_image1) {
        _image1 = [UIImageView new];
    }
    return _image1;
}

-(UILabel *)lineLab1
{
    if (!_lineLab1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentLeft;
        _lineLab1 = label;
    }
    return _lineLab1;
}

-(UILabel *)priceLab1
{
    if (!_priceLab1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentLeft;
        _priceLab1 = label;
    }
    return _priceLab1;
}

-(UILabel *)timeLab1
{
    if (!_timeLab1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = NSTextAlignmentRight;
        _timeLab1 = label;
    }
    return _timeLab1;
}

-(UIImageView *)image2
{
    if (!_image2) {
        _image2 = [UIImageView new];
    }
    return _image2;
}

-(UILabel *)lineLab2
{
    if (!_lineLab2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentLeft;
        _lineLab2 = label;
    }
    return _lineLab2;
}

-(UILabel *)priceLab2
{
    if (!_priceLab2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentLeft;
        _priceLab2 = label;
    }
    return _priceLab2;
}

-(UILabel *)timeLab2
{
    if (!_timeLab2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = NSTextAlignmentRight;
        _timeLab2 = label;
    }
    return _timeLab2;
}

@end
