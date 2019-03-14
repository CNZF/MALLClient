//
//  UserInfoTitleCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "UserInfoTitleCell.h"


@interface UserInfoTitleCell()

@property (nonatomic, strong)UILabel * titleLab;

@property (nonatomic, strong)UIImageView * hookIgv;

@property (nonatomic, strong)UILabel * stateLab;

@end


@implementation UserInfoTitleCell

-(void)loadUIWithmodel:(UserInfoCellModel *)model
{
    if (model.titleStr)
    {
        self.titleLab.text = model.titleStr;
        self.titleLab.frame = CGRectMake(15, 13,[self.titleLab.text sizeWithAttributes:@{NSFontAttributeName:self.titleLab.font}].width + 5 , 13);
        self.titleLab.hidden = NO;
    }
    else
    {
        self.titleLab.hidden = YES;
    }

    
    if ([model.detailsStr isEqualToString:@"已完善"] || [model.detailsStr isEqualToString:@"审核通过"])
    {
        self.hookIgv.image = [UIImage imageNamed:[@"运力定制成功 copy" adS]];
        self.hookIgv.frame = CGRectMake(self.titleLab.right + 5, 13, 12, 12);

        self.stateLab.text = model.detailsStr;
        self.stateLab.frame = CGRectMake(self.hookIgv.right + 5, 13,[self.stateLab.text sizeWithAttributes:@{NSFontAttributeName:self.stateLab.font}].width + 5 , 13);
        self.stateLab.textColor = APP_COLOR_GREEN;

        self.hookIgv.hidden = NO;
        self.stateLab.hidden = NO;

    }
    else if ([model.detailsStr isEqualToString:@"待审核"])
    {
        self.hookIgv.image = [UIImage imageNamed:[@"运力定制审核 copy" adS]];
        self.hookIgv.frame = CGRectMake(self.titleLab.right + 5, 13, 12, 12);

        self.stateLab.text = model.detailsStr;
        self.stateLab.frame = CGRectMake(self.hookIgv.right + 5, 13,[self.stateLab.text sizeWithAttributes:@{NSFontAttributeName:self.stateLab.font}].width + 5 , 13);
        self.stateLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;

        self.hookIgv.hidden = NO;
        self.stateLab.hidden = NO;
    }
    else
    {
        self.hookIgv.hidden = YES;
        self.stateLab.hidden = YES;
    }
    
    self.modifyBtn.hidden = model.btnHidden;
}

-(void)bindView
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLab];
    [self addSubview:self.stateLab];
    [self addSubview:self.hookIgv];
    
    self.modifyBtn.frame = CGRectMake(SCREEN_W - 65, 0, 50, 35);
    [self addSubview:self.modifyBtn];
}

-(UILabel *)titleLab
{
    
    if (!_titleLab)
    {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _titleLab = lab;
    }
    return _titleLab;
}

-(UIImageView *)hookIgv
{
    if (!_hookIgv) {
        UIImageView * igv = [UIImageView new];
        _hookIgv = igv;
    }
    return _hookIgv;
}

-(UILabel *)stateLab
{
    
    if (!_stateLab)
    {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        _stateLab = lab;
    }
    return _stateLab;
}

-(UIButton *)modifyBtn {
    if (!_modifyBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"点击修改" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        
        _modifyBtn = btn;
    }
    return _modifyBtn;
}
@end
