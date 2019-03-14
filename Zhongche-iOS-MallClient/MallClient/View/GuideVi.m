//
//  GuideVi.m
//  MallClient
//
//  Created by iOS_Developers_LL on 06/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "GuideVi.h"

@interface GuideVi()
@property (nonatomic, strong)UIImageView * bgIgv;

@end

@implementation GuideVi

-(instancetype)init
{
    if (self == [super init])
    {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        self.bgIgv.frame = CGRectMake(SCREEN_W / 2 - 166, SCREEN_H / 2 - 228, 333, 455);
        [self addSubview:self.bgIgv];
        
        self.validationBtn.frame = CGRectMake(58, 323, 216, 46);
        [self.bgIgv addSubview:self.validationBtn];
        
        self.cancleBtn.frame = CGRectMake(146, 425, 40, 30);
        [self.bgIgv addSubview:self.cancleBtn];

    }
    return self;
}

-(UIImageView *)bgIgv
{
    if (!_bgIgv) {
        UIImageView * igv = [UIImageView new];
        igv.image = [UIImage imageNamed:[@"Group 6 Copy" adS]];
        igv.userInteractionEnabled = YES;
        _bgIgv = igv;
    }
    return _bgIgv;
}

-(UIButton *)validationBtn
{
    if (!_validationBtn) {
        UIButton * btn = [UIButton new];

        
        _validationBtn = btn;
    }
    return _validationBtn;
}

-(UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        UIButton * btn = [UIButton new];
        
        _cancleBtn = btn;
    }
    return _cancleBtn;
}
@end
