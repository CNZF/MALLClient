//
//  UserInfoCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "UserInfoCell.h"
#import "UIImageView+WebCache.h"

@interface UserInfoCell()

@property (nonatomic, strong)UILabel * titleLab;

@property (nonatomic, strong)UIImageView * headIgv;

@property (nonatomic, strong)UILabel * detailsLab;

@property (nonatomic, strong)UIView * line;

@end

@implementation UserInfoCell

-(void)loadUIWithmodel:(UserInfoCellModel *)model
{
    self.titleLab.text = model.titleStr;
    self.titleLab.frame = CGRectMake(self.titleLab.left, model.cellHeight / 2 - self.titleLab.height / 2, self.titleLab.width, self.titleLab.height);
    if (model.imgStr) {
        self.detailsLab.text = @"";
        [self.headIgv sd_setImageWithURL:[NSURL URLWithString:model.imgStr] placeholderImage:[UIImage imageNamed:[@"user_head" adS]]];
        self.headIgv.hidden = NO;
    }
    else
    {
        self.headIgv.hidden = YES;
        self.detailsLab.text = model.detailsStr;
    }
    self.line.hidden = model.cellLineHidden;
}

-(void)bindView
{
    [super bindView];
    
    self.titleLab.frame = CGRectMake(15, 15, SCREEN_W - 30, 13);
    [self addSubview:self.titleLab];
    
    self.headIgv.frame = CGRectMake(SCREEN_W - 76, 15, 40, 40);
    [self addSubview:self.headIgv];
    
    self.line.frame = CGRectMake(20, 43,SCREEN_W - 20, 1);
    [self addSubview:self.line];
    
    self.detailsLab.frame = CGRectMake(15, 10, SCREEN_W - 30, 23);
    [self addSubview:self.detailsLab];
}

-(UILabel *)titleLab
{
    
    if (!_titleLab)
    {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _titleLab = lab;
    }
    return _titleLab;
}

-(UILabel *)detailsLab
{
    
    if (!_detailsLab)
    {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.textAlignment = NSTextAlignmentRight;
        
        _detailsLab = lab;
    }
    return _detailsLab;
}

-(UIImageView *)headIgv
{
    if (!_headIgv) {
        UIImageView * igv = [UIImageView new];
        igv.layer.masksToBounds = YES;
        igv.layer.cornerRadius = 20.f;
        _headIgv = igv;
    }
    return _headIgv;
}

-(UIView *)line
{
    if (!_line) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_WHITEBG;
        _line = vi;
    }
    return _line;
}
@end
