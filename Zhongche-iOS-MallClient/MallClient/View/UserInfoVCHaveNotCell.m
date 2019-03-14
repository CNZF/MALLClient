//
//  UserInfoVCHaveNotCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "UserInfoVCHaveNotCell.h"

@interface UserInfoVCHaveNotCell()

@property (nonatomic, strong)UILabel * titleLab;

@property (nonatomic, strong)UIImageView * wrongIgv;

@property (nonatomic, strong)UILabel * unauthorizedLab;

@property (nonatomic, strong)UIButton * goCertificationBtn;//前往认证

@end

@implementation UserInfoVCHaveNotCell

-(void)loadUIWithmodel:(UserInfoCellModel*)model
{
    self.titleLab.text = model.titleStr;
    self.titleLab.frame = CGRectMake(15, 20,[self.titleLab.text sizeWithAttributes:@{NSFontAttributeName:self.titleLab.font}].width + 5 , 13);
    
    NSArray * arr = [model.detailsStr componentsSeparatedByString:@"-"];
    self.unauthorizedLab.text = arr[0];
    [self.goCertificationBtn setTitle:arr[arr.count - 1] forState:UIControlStateNormal];
    self.wrongIgv.frame = CGRectMake(5 + self.titleLab.right, 20, 12, 12);
    self.unauthorizedLab.frame = CGRectMake(10 + self.wrongIgv.right, 20, 100, 13);

}

-(void)bindView
{
    [super bindView];
    
    [self addSubview:self.titleLab];
    [self addSubview:self.wrongIgv];
    [self addSubview:self.unauthorizedLab];
    
    self.goCertificationBtn.frame = CGRectMake(SCREEN_W - 120, 9, 100, 32);
    [self addSubview:self.goCertificationBtn];
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

-(UIImageView *)wrongIgv
{
    if (!_wrongIgv) {
        UIImageView * igv = [UIImageView new];
        igv.image = [UIImage imageNamed:[@"Group 5 Copy 3" adS]];
        _wrongIgv = igv;
    }
    return _wrongIgv;
}

-(UILabel *)unauthorizedLab
{
    
    if (!_unauthorizedLab)
    {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_RED1;
        lab.text = @"未认证";
        _unauthorizedLab = lab;
    }
    return _unauthorizedLab;
}

-(UIButton *)goCertificationBtn
{
    if (!_goCertificationBtn) {
        
        UIButton * btn = [UIButton new];
        [btn setTitle:@"前往认证" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        btn.layer.borderWidth = 2.f;
        btn.layer.borderColor = APP_COLOR_BLUE_BTN.CGColor;
        btn.layer.cornerRadius = 16.f;
        btn.layer.masksToBounds = YES;
        
        [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _goCertificationBtn = btn;
    }
    return _goCertificationBtn;
}

-(void)buttonClick
{
    [self.cellDelegate cellButtonDidSelectRowAtIndexPath:self.cellIndexPath];
}

@end
