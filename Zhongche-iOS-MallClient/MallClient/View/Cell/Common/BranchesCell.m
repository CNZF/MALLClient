//
//  BranchesCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/5/26.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BranchesCell.h"
#import "CityModel.h"

@interface BranchesCell()

@property (nonatomic, strong)UIImageView * igv;
@property (nonatomic, strong)UILabel * lab;
@property (nonatomic, strong)UIView * line;

@end

@implementation BranchesCell
-(void)loadUIWithmodel:(CityModel *)model {

    switch (model.modelType) {
        case city:
            self.igv.image = [UIImage imageNamed:[@"city" adS]];
            self.lab.text = model.name;

            break;
        case branches:
            self.igv.image = [UIImage imageNamed:[@"branches" adS]];
            self.lab.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.regionName];

            break;
    }
}

-(void)bindView {
    self.igv.frame = CGRectMake(14, 17, 24, 14);
    [self addSubview:self.igv];
    
    self.lab.frame = CGRectMake(47, 0, SCREEN_W - 67, 43);
    [self addSubview:self.lab];

    self.line.frame = CGRectMake(20, 43, SCREEN_W - 20, 0.5);
    [self addSubview:self.line];

}

-(UIImageView *)igv {
    if (!_igv) {
        _igv = [UIImageView new];
    }
    return _igv;
}

-(UILabel *)lab {
    if (!_lab) {
        UILabel * lab = [UILabel new];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.font = [UIFont systemFontOfSize:16.f];
        _lab = lab;
    }
    return _lab;
}

-(UIView *)line {
    if (!_line) {
        UIView * vi =[UIView new];
        vi.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        _line = vi;
    }
    return _line;
}
@end
