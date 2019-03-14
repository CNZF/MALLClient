
//
//  EmptyCarCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarCell.h"

@interface EmptyCarCell()

@property (nonatomic, strong) UIImageView * transportTypeIgv;//运输类型
@property (nonatomic, strong) UILabel * transportLineLab;//运输路线
@property (nonatomic, strong) UILabel * certificationLab;//认证情况
@property (nonatomic, strong) UILabel * detailsLab;//运输详情
@property (nonatomic, strong) UILabel * timeLab;//发布时间
@property (nonatomic, strong) UILabel * carTypeLab;//铁运方式
@property (nonatomic, strong) UILabel * priceLab;//价格
@property (nonatomic, strong) UIButton * phoneBtn;//电询
@property (nonatomic, strong) UIView * lastLine;

@end

@implementation EmptyCarCell

-(void)loadUIWithmodel:(EmptyCarModel *)model {
    float width = 95;
    switch (model.transportTypeEnum) {
        case landTransportation:
            self.transportTypeIgv.image = [UIImage imageNamed:[@"车" adS]];
            self.carTypeLab.text = model.type;
            
            break;
        case trainsTransportation:
            width = 20;
            self.transportTypeIgv.image = [UIImage imageNamed:[@"火车" adS]];
            self.carTypeLab.text = model.trainsType;
            break;
        case shipTransportation:
            self.transportTypeIgv.image = [UIImage imageNamed:[@"轮船" adS]];
            self.carTypeLab.text = @"班轮";
            break;
    }
    
    self.timeLab.text = model.timeStr;
    float timeLabWidth = [self.timeLab.text sizeWithAttributes:@{NSFontAttributeName:self.timeLab.font}].width;
    self.timeLab.frame = CGRectMake(SCREEN_W - 15 - timeLabWidth, self.timeLab.top, timeLabWidth, self.timeLab.height);
    
    self.transportLineLab.text = [NSString stringWithFormat:@"%@%@ - %@%@",model.startParentAddress,model.startAddress,model.endParentAddress,model.endAddress];
    self.transportLineLab.frame = CGRectMake(self.transportLineLab.left, self.transportLineLab.top, self.timeLab.left - self.transportLineLab.left , self.transportLineLab.height);
    

    
    float haveCertification = 0;
    if (model.certification) {
        self.certificationLab.hidden = NO;
        self.certificationLab.text = model.certification;
        self.certificationLab.frame = CGRectMake(self.certificationLab.left , self.certificationLab.top, 45, self.certificationLab.height);
        haveCertification = 1;
    } else {
        self.certificationLab.hidden = YES;
        self.certificationLab.frame = CGRectMake(self.certificationLab.left , self.certificationLab.top, 0, self.certificationLab.height);
        haveCertification = 0;
    }
    
    self.detailsLab.text = model.details;
    self.detailsLab.frame = CGRectMake(self.certificationLab.right + 7 * haveCertification, self.detailsLab.top,MIN([self.detailsLab.text sizeWithAttributes:@{NSFontAttributeName:self.detailsLab.font}].width, SCREEN_W - 120) , self.detailsLab.height);
    
    
    if ([model.price floatValue]>0) {
        NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@%@",[model.price NumberStringToMoneyString],model.priceUnit]];   
        [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(0,[model.price NumberStringToMoneyString].length + 1)];
        [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY2 range:NSMakeRange([model.price NumberStringToMoneyString].length + 1,model.priceUnit.length)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,[model.price NumberStringToMoneyString].length + 1)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange([model.price NumberStringToMoneyString].length + 1,model.priceUnit.length)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[price.string rangeOfString:[model.price NumberStringToMoneyStringGetLastThree]]];


        self.priceLab.attributedText = price;
        
        self.priceLab.hidden = NO;
        self.phoneBtn.hidden = YES;
    } else {
        self.priceLab.hidden = YES;
        self.phoneBtn.hidden = NO;
    }
}

-(void)bindView {
    
    self.transportTypeIgv.frame = CGRectMake(15, 17, 14, 14);
    [self addSubview:self.transportTypeIgv];
    
    self.transportLineLab.frame = CGRectMake(38, 15, 0, 16);
    [self addSubview:self.transportLineLab];

    
    self.carTypeLab.frame = CGRectMake(38, 66, 100, 19);
    [self addSubview:self.carTypeLab];
    
    self.detailsLab.frame = CGRectMake(0, 38, SCREEN_W - 64, 15);
    [self addSubview:self.detailsLab];
    
    self.certificationLab.frame = CGRectMake(38, self.detailsLab.top, 45, 15);
    [self addSubview:self.certificationLab];
    
    self.timeLab.frame = CGRectMake(0, 16 , 0, 15);
    [self addSubview:self.timeLab];
    
    self.priceLab.frame = CGRectMake(15, 65, SCREEN_W - 30, 19);
    [self addSubview:self.priceLab];
    
    self.phoneBtn.frame = CGRectMake(SCREEN_W - 52, 50, 37, 44);
    [self addSubview:self.phoneBtn];
    
    self.lastLine.frame = CGRectMake(0, 99, SCREEN_W, 0.5);
    [self addSubview:self.lastLine];
}

-(UIImageView *)transportTypeIgv {
    if (!_transportTypeIgv) {
        UIImageView * igv = [UIImageView new];
        _transportTypeIgv = igv;
    }
    return _transportTypeIgv;
}

-(UILabel *)transportLineLab {
    if (!_transportLineLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        _transportLineLab = lab;
    }
    return _transportLineLab;
}

-(UILabel *)detailsLab {
    if (!_detailsLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        _detailsLab = lab;
    }
    return _detailsLab;
}

-(UILabel *)timeLab {
    if (!_timeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textAlignment = NSTextAlignmentRight;
        lab.textColor = APP_COLOR_GRAY2;
        _timeLab = lab;
    }
    return _timeLab;
}

-(UILabel *)certificationLab {
    if (!_certificationLab) {
        UILabel * lab = [UILabel new];
        lab.backgroundColor = APP_COLOR_ORANGE_BG;
        lab.font = [UIFont systemFontOfSize:8.f];
        lab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        lab.text = @"资质认证";
        lab.textAlignment = NSTextAlignmentCenter;
        [lab.layer setMasksToBounds:YES];
        lab.layer.cornerRadius = 3.0;
        lab.layer.borderColor = [APP_COLOR_ORANGE_BTN_TEXT CGColor];
        lab.layer.borderWidth = 0.5;
        lab.hidden = YES;
        _certificationLab = lab;
    }
    return _certificationLab;
}

-(UILabel *)carTypeLab {
    if (!_carTypeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        _carTypeLab = lab;
    }
    return _carTypeLab;
}

-(UILabel *)priceLab {
    if (!_priceLab) {
        UILabel * lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentRight;
        _priceLab = lab;
    }
    return _priceLab;
}

-(UIButton *)phoneBtn {
    if (!_phoneBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"电询" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        btn.hidden = YES;
        _phoneBtn = btn;
    }
    return _phoneBtn;
}

-(UIView *)lastLine {
    if (!_lastLine) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        
        _lastLine = vi;
    }
    return _lastLine;
}
@end
