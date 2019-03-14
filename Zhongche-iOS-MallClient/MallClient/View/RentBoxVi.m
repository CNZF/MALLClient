//
//  RentBoxVi.m
//  MallClient
//
//  Created by lxy on 2017/3/20.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "RentBoxVi.h"


@interface RentBoxVi()<UITextFieldDelegate>


@end

@implementation RentBoxVi

//定义一个静态变量用于接收实例对象，初始化为nil
static RentBoxVi *singleInstance=nil;


+(RentBoxVi *)shareRentBoxVi{
    @synchronized(self){//线程保护，增加同步锁
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    [singleInstance rssetAction];
    return singleInstance;
}

- (void)binView {

    self.num = 1;

    self.viBackground.frame = CGRectMake(0, - SCREEN_H, SCREEN_W,2 * SCREEN_H);
    [self addSubview:self.viBackground];

    self.btnCancle.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 260);
    [self addSubview:self.btnCancle];

    self.viShow.frame = CGRectMake(0, SCREEN_H - 260, SCREEN_W, 260);
    [self addSubview:self.viShow];

    self.ivTransport.frame = CGRectMake(18, -30, 104, 104);
    [self.viShow addSubview:self.ivTransport];

    self.lbGoodsStatuse.frame = CGRectMake(self.ivTransport.right + 10, 15, 26, 13);
    [self.viShow addSubview:self.lbGoodsStatuse];

    self.lbGoodsName.frame = CGRectMake(self.lbGoodsStatuse.right + 10, 12, SCREEN_W - self.lbGoodsStatuse.right + 10, 20);
    [self.viShow addSubview:self.lbGoodsName];

    self.lbPrice.frame = CGRectMake(self.ivTransport.right + 10, self.lbGoodsName.bottom + 10, 200, 20);
    [self.viShow addSubview:self.lbPrice];

    self.lbDeposit.frame =  CGRectMake(self.ivTransport.right + 10, self.lbPrice.bottom + 10, 100, 20);
    [self.viShow addSubview:self.lbDeposit];

    self.lbNum.frame =  CGRectMake(self.lbDeposit.right + 10, self.lbPrice.bottom + 10, 100, 20);
    [self.viShow addSubview:self.lbNum];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, self.lbNum.bottom + 10, SCREEN_W, 1);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viShow addSubview:lbLine];

    UILabel *lbSentType = [UILabel new];
    lbSentType.text = @"配送方式:";
    lbSentType.frame = CGRectMake(18, lbLine.bottom + 10, 100, 20);
    lbSentType.font = [UIFont systemFontOfSize:14];
    lbSentType.hidden = YES;
    [self.viShow addSubview:lbSentType];

    self.btnSelfCarry.frame = CGRectMake(18, lbSentType.bottom + 10, 60, 20);
    self.btnSentToHome.frame = CGRectMake(self.btnSelfCarry.right + 10, lbSentType.bottom + 10, 60, 20);
    [self.viShow addSubview:self.btnSelfCarry];
    [self.viShow addSubview:self.btnSentToHome];

    UILabel *lbNum = [UILabel new];
    lbNum.text = @"数量：";
    lbNum.frame = CGRectMake(18, self.btnSelfCarry.bottom + 15 - 40, 100, 20);
    lbNum.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:lbNum];


    self.ivAddAndReduce.frame = CGRectMake(SCREEN_W - 118, self.btnSelfCarry.bottom + 12 - 40, 98, 30);
    [self.viShow addSubview:self.ivAddAndReduce];

    self.btnReduce.frame = CGRectMake(SCREEN_W - 118, self.btnSelfCarry.bottom + 12 - 40, 34, 30);
    self.tfNum.frame = CGRectMake(self.btnReduce.right, self.btnSelfCarry.bottom + 12 - 40, 30, 30);
    self.btnAdd.frame = CGRectMake(self.tfNum.right, self.btnSelfCarry.bottom + 12 - 40, 34, 30);


    [self.viShow addSubview:self.tfNum];
    [self.viShow addSubview:self.btnAdd];
    [self.viShow addSubview:self.btnReduce];

    self.btnboom.frame = CGRectMake(0,260 - 44 , SCREEN_W, 44);
    [self.viShow addSubview:self.btnboom];


}

- (void) rssetAction {
}

- (void) cancleAction {

    [self removeFromSuperview];
}

- (void)addAction {

    self.num++;
    self.ivAddAndReduce.image = [UIImage imageNamed:@"Add2"];
    self.tfNum.text = [NSString stringWithFormat:@"%i",self.num];

}

- (void)reduceAction {

    if (self.num == 2) {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add1"];
    }

    if (self.num >1) {
        self.num --;
        self.tfNum.text = [NSString stringWithFormat:@"%i",self.num];
    }
    
}

- (void) typeStyeChooseAction: (UIButton *)btn {

    self.btnStyleChoose.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnStyleChoose setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    btn.layer.borderColor = APP_COLOR_ORANGE_BTN.CGColor;
    [btn setTitleColor:APP_COLOR_ORANGE_BTN forState:UIControlStateNormal];
    self.btnStyleChoose = btn;

    [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];

}

/**
 *  UITextFiledDelegate
 *
 */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    self.viShow.frame = CGRectMake(0,0, SCREEN_W, 400);
    [self addSubview:self.viShow];

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    self.viShow.frame = CGRectMake(0, SCREEN_H - 260, SCREEN_W, 260);
    [self addSubview:self.viShow];

    self.num = [textField.text intValue];
    if (self.num == 0) {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add1"];
    }else {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add2"];

    }
    
    
    
    
    return YES;
}

/**
 *  getting
 */

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.backgroundColor = [UIColor blackColor];
        _viBackground.alpha = 0.4;
    }
    return _viBackground;
}

- (UIView *)viShow {
    if (!_viShow) {
        _viShow = [UIView new];
        _viShow.backgroundColor = [UIColor whiteColor];

    }
    return _viShow;
}

- (UIImageView *)ivTransport {
    if (!_ivTransport) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"s1"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;

        _ivTransport = imageView;
    }
    return _ivTransport;
}

- (UIButton *)btnCancle {
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];



        _btnCancle = button;
    }
    return _btnCancle;
}

- (UILabel *)lbGoodsStatuse {
    if (!_lbGoodsStatuse) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        label.layer.borderWidth = 1;
        label.layer.borderColor = APP_COLOR_RED_TEXT.CGColor;
        label.text  = @"认证";
        label.textAlignment = NSTextAlignmentCenter;


        _lbGoodsStatuse = label;
    }
    return _lbGoodsStatuse;
}

- (UILabel *)lbGoodsName {
    if (!_lbGoodsName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"25英尺板架式汽车集装箱";



        _lbGoodsName = label;
    }
    return _lbGoodsName;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"￥120 /天/个";
        NSRange range;
        range = [label.text rangeOfString:@"/天/个"];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


        [AttributedStr addAttribute:NSFontAttributeName

                              value:[UIFont systemFontOfSize:12]

                              range:NSMakeRange(range.location,label.text.length - range.location)];
        label.attributedText = AttributedStr;



        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbDeposit {

    if (!_lbDeposit) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];

        label.text = @"押金：¥7000";
        label.frame = CGRectMake(0, self.lbPrice.bottom + 15, SCREEN_W/3, 15);


        _lbDeposit = label;
    }
    return _lbDeposit;
}

- (UILabel *)lbNum {
    if (!_lbNum) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];

        label.text = @"库存：99个";
        label.frame = CGRectMake(SCREEN_W/3, self.lbPrice.bottom + 15, SCREEN_W/3, 15);


        _lbNum = label;
    }
    return _lbNum;
}

- (UIButton *)btnSelfCarry {
    if (!_btnSelfCarry) {
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 1;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"自取" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(typeStyeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 21;
        button.hidden = YES;


        _btnSelfCarry = button;
    }
    return _btnSelfCarry;
}

- (UIButton *)btnSentToHome {
    if (!_btnSentToHome) {
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 1;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"送箱上门" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(typeStyeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 22;
        button.hidden = YES;

        _btnSentToHome = button;
    }
    return _btnSentToHome;
}

- (UIImageView *)ivAddAndReduce {
    if (!_ivAddAndReduce) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"Add1"];


        _ivAddAndReduce = imageView;
    }
    return _ivAddAndReduce;
}

- (UITextField *)tfNum {

    if (!_tfNum) {
        _tfNum = [UITextField new];
        _tfNum.text = @"1";
        _tfNum.textAlignment = NSTextAlignmentCenter;
        _tfNum.delegate = self;
        _tfNum.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _tfNum;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];



        _btnAdd = button;
    }
    return _btnAdd;
}

- (UIButton *)btnReduce {
    if (!_btnReduce) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(reduceAction) forControlEvents:UIControlEventTouchUpInside];


        _btnReduce = button;
    }
    return _btnReduce;
}

- (UIButton *)btnboom {
    if (!_btnboom) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];




        _btnboom = button;
    }
    return _btnboom;
}

@end
