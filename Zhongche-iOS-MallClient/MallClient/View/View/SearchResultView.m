//
//  SearchResultView.m
//  MallClient
//
//  Created by lxy on 2016/11/30.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SearchResultView.h"

@interface SearchResultView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lbStyle;

@end

@implementation SearchResultView

//定义一个静态变量用于接收实例对象，初始化为nil
static SearchResultView *singleInstance=nil;


+(SearchResultView *)shareSearchResultView{
    @synchronized(self){//线程保护，增加同步锁
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    [singleInstance rssetAction];
    return singleInstance;
}


- (void)setWithModel:(TransportationModel *)info {

}

- (void)binView {

    self.num = 1;

    self.viBackground.frame = CGRectMake(0, - SCREEN_H, SCREEN_W,2 * SCREEN_H);
    [self addSubview:self.viBackground];

    self.btnCancle.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 400);
    [self addSubview:self.btnCancle];

    self.viShow.frame = CGRectMake(0, SCREEN_H - 400, SCREEN_W, 400);
    [self addSubview:self.viShow];

    [self viewMake:self.info];


}

- (void) rssetAction {

    self.num = 1;
    self.tfNum.text = @"1";
    self.ivAddAndReduce.image = [UIImage imageNamed:@"Add1"];

    self.btnYes.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnYes setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];

    self.btnNo.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnNo setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];

    self.btnMTM.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnMTM setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];

    self.btnMTD.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnMTD setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];

    self.btnDTD.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnDTD setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];

    self.btnDTM.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnDTM setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];

    [self.btnboom setBackgroundColor:APP_COLOR_GRAY_BTN_1];


    self.btnYesOrNo = nil;

    self.btnStyleChoose = nil;

}

- (void)viewMake:(TransportationModel *)info {

    self.ivTransport.frame = CGRectMake(18, -30, 104, 104);
    [self.viShow addSubview:self.ivTransport];

    _lb1 = [UILabel new];
//    _lb1.text = info.capacityType;
    _lb1.font = [UIFont systemFontOfSize:18];
    _lb1.frame = CGRectMake(self.ivTransport.right + 10, 20, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:_lb1];

    _lb2 = [UILabel new];
    _lb2.text = [NSString stringWithFormat:@"￥%.2f起",[info.ticketTotal floatValue]];
    
    _lb2.font = [UIFont systemFontOfSize:20];
    _lb2.textColor = APP_COLOR_RED1;

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_lb2.text];

    NSUInteger loc = _lb2.text.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    _lb2.attributedText = AttributedStr;

    _lb2.frame  = CGRectMake(self.ivTransport.right + 10, _lb1.bottom + 10, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:_lb2];

    _lb3 = [UILabel new];
    _lb3.frame = CGRectMake(SCREEN_W - 70, _lb2.bottom - 20, 70, 20);
    _lb3.textColor = APP_COLOR_GRAY2;
    _lb3.text = [NSString stringWithFormat:@"%i日送达",[info.expectTime intValue]/1440];
    _lb3.font = [UIFont systemFontOfSize:12];
    [self.viShow addSubview:_lb3];

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, _lb2.bottom + 20, SCREEN_W, 0.5);
    viLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viShow addSubview:viLine];

//    UILabel *lb4 = [UILabel new];
//    lb4.frame = CGRectMake(20, viLine.bottom + 20, SCREEN_W - 20, 20);
//    lb4.text = @"是否有自备箱";
//    lb4.font = [UIFont systemFontOfSize:14];
//    lb4.textColor = APP_COLOR_GRAY2;
//    [self.viShow addSubview:lb4];


//    self.btnYes.frame = CGRectMake(20, lb4.bottom + 10, 66, 33);
//
//
//    [self.viShow addSubview:self.btnYes];
//
//
//    self.btnNo.frame = CGRectMake(self.btnYes.right + 20, lb4.bottom + 10, 66, 33);
//
//
//    [self.viShow addSubview:self.btnNo];

    self.lb5 = [UILabel new];
    self.lb5.frame = CGRectMake(20, viLine.bottom + 20, SCREEN_W - 20, 20);
    self.lb5.text = @"用箱数量";
    self.lb5.font = [UIFont systemFontOfSize:14];
    self.lb5.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:self.lb5];

    self.ivAddAndReduce.frame = CGRectMake(SCREEN_W - 118, viLine.bottom + 15, 98, 30);
    [self.viShow addSubview:self.ivAddAndReduce];

    self.btnReduce.frame = CGRectMake(SCREEN_W - 118, viLine.bottom + 15, 34, 30);
    self.tfNum.frame = CGRectMake(self.btnReduce.right, viLine.bottom + 15, 30, 30);
    self.btnAdd.frame = CGRectMake(self.tfNum.right, viLine.bottom + 15, 34, 30);


    [self.viShow addSubview:self.tfNum];
    [self.viShow addSubview:self.btnAdd];
    [self.viShow addSubview:self.btnReduce];


    UILabel *lb6 = [UILabel new];
    lb6.frame = CGRectMake(20, self.lb5.bottom + 20, SCREEN_W - 20, 20);
    lb6.text = @"服务方式";
    lb6.font = [UIFont systemFontOfSize:14];
    lb6.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb6];

    self.btnMTM.frame =CGRectMake(20, lb6.bottom + 60, 110, 33);
    self.btnDTD.frame =CGRectMake(20, lb6.bottom + 10, 80, 33);
    self.btnMTD.frame =CGRectMake(self.btnDTD.right + 20, lb6.bottom + 10, 80, 33);
    self.btnDTM.frame =CGRectMake(self.btnMTD.right + 20, lb6.bottom + 10, 80, 33);

    [self.viShow addSubview:self.btnMTM];
    [self.viShow addSubview:self.btnMTD];
    [self.viShow addSubview:self.btnDTM];
    [self.viShow addSubview:self.btnDTD];

    self.lbStyle = [UILabel new];
    self.lbStyle.frame = CGRectMake(0, self.btnDTD.bottom + 10, SCREEN_W , 20);
    self.lbStyle.text = @"起运地、抵运地地址已确定";
    self.lbStyle.font = [UIFont systemFontOfSize:14];
    self.lbStyle.textColor = APP_COLOR_GRAY2;
    self.lbStyle.textAlignment = NSTextAlignmentCenter;
//    [self.viShow addSubview:self.lbStyle];

    UILabel *lb1 = [UILabel new];
    lb1.frame = CGRectMake(0,300, 200, 20);
    lb1.textAlignment = NSTextAlignmentRight;
    lb1.font = [UIFont systemFontOfSize:10];
    lb1.text = @"*箱子来源：平台供箱，如有疑问，请";
    lb1.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb1];

    UILabel *lb2 = [UILabel new];
    lb2.frame = CGRectMake(lb1.right + 2,300, 90, 20);
    lb2.font = [UIFont systemFontOfSize:10];
    lb2.text = @"联系客服";
    lb2.textColor = APP_COLOR_BLUE_BTN_;
    [self.viShow addSubview:lb2];

    self.btnCall = [UIButton new];
    self.btnCall.frame = CGRectMake(lb1.right + 2,300, 90, 20);
    [self.viShow addSubview:self.btnCall];



    self.btnboom.frame = CGRectMake(0, 356, SCREEN_W, 44);
    [self.viShow addSubview:self.btnboom];


}

- (void)ViewWithModel:(TransportationModel *)info{
//    _lb1.text = @"集装箱运力";
    _lb2.text = [NSString stringWithFormat:@"￥%.2f起",[info.ticketTotal floatValue]];
    NSUInteger loc = _lb2.text.length;

     NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_lb2.text];

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    _lb2.attributedText = AttributedStr;

    _lb2.frame  = CGRectMake(self.ivTransport.right + 10, _lb1.bottom + 10, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:_lb2];
    _lb3.text = [NSString stringWithFormat:@"%i日送达",[info.expectTime intValue]/1440];
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

- (void) boomAction {

    [self removeFromSuperview];

}

- (void) yesOrNoAction: (UIButton *)btn {

    self.btnYesOrNo.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnYesOrNo setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    btn.layer.borderColor = APP_COLOR_ORANGE_BTN.CGColor;
    [btn setTitleColor:APP_COLOR_ORANGE_BTN forState:UIControlStateNormal];
    self.btnYesOrNo = btn;

    if(self.btnStyleChoose) {

        [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];
    }
}

- (void) typeStyeChooseAction: (UIButton *)btn {

    self.btnStyleChoose.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnStyleChoose setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    btn.layer.borderColor = APP_COLOR_ORANGE_BTN.CGColor;
    [btn setTitleColor:APP_COLOR_ORANGE_BTN forState:UIControlStateNormal];
    self.btnStyleChoose = btn;

    [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];

    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货+送货上门"]) {

        self.lbStyle.text = @"需完善起运地、抵运地地址信息";
    }

    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货"]) {

        self.lbStyle.text = @"需完善起运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"送货上门"]) {

        self.lbStyle.text = @"需完善抵运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"无"]) {

        self.lbStyle.text = @"起运地、抵运地地址信息已确定";
    }
    
    
}


/**
 *  UITextFiledDelegate
 *
 */



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {


    self.num = [textField.text intValue];
    if (self.num == 1) {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add1"];
    }else {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add2"];

    }

    if ([textField isEqual:self.tfBulk]||[textField isEqual:self.tfWeight]) {

        if (self.tfBulk.text.length >0 && self.tfWeight.text.length >0 && self.btnStyleChoose) {

            [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];


        }else {

            [self.btnboom setBackgroundColor:APP_COLOR_GRAY_BTN_1];

        }
    }




    return YES;
}


//APP_COLOR_ORANGE_BTN


/**
 *  getting
 */

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.backgroundColor = [UIColor blackColor];
    }
    return _viBackground;
}

-(void)setBackgroundAlpha:(float)backgroundAlpha {
    self.viBackground.alpha = backgroundAlpha;
    _backgroundAlpha = backgroundAlpha;
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

- (UIButton *)btnYes {
    if (!_btnYes) {
        UIButton *button = [[UIButton alloc]init];

        //[button addTarget:self action:@selector(<#action#>) forControlEvents:UIControlEventTouchUpInside];

        button.layer.masksToBounds = YES;
        button.layer.cornerRadius =16.5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"是" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(yesOrNoAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 11;

        _btnYes = button;
    }
    return _btnYes;
}

- (UIButton *)btnNo {
    if (!_btnNo) {
        UIButton *button = [[UIButton alloc]init];

        button.layer.masksToBounds = YES;
        button.layer.cornerRadius =16.5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"否" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(yesOrNoAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 12;

        _btnNo = button;
    }
    return _btnNo;
}

- (UIButton *)btnMTM {
    if (!_btnMTM) {
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius =16.5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"上门取货+送货上门" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(typeStyeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 21;

        _btnMTM = button;
    }
    return _btnMTM;
}

- (UIButton *)btnMTD {
    if (!_btnMTD) {
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius =16.5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"上门取货" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(typeStyeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 22;


        _btnMTD = button;
    }
    return _btnMTD;
}

- (UIButton *)btnDTM {
    if (!_btnDTM) {
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius =16.5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"送货上门" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(typeStyeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 23;


        _btnDTM = button;
    }
    return _btnDTM;
}

- (UIButton *)btnDTD {
    if (!_btnDTD) {
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius =16.5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = APP_COLOR_GRAY2.CGColor;
        [button setTitle:@"无" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(typeStyeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 24;


        _btnDTD = button;
    }
    return _btnDTD;
}

- (UIButton *)btnboom {
    if (!_btnboom) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_GRAY_BTN_1];
        

        
        
        _btnboom = button;
    }
    return _btnboom;
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
        _tfNum.keyboardType = UIKeyboardTypeDecimalPad;
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

- (UIButton *)btnCancle {
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

        

        _btnCancle = button;
    }
    return _btnCancle;
}

- (UITextField *)tfWeight{
    if (!_tfWeight) {
        _tfWeight = [UITextField new];
        _tfWeight.placeholder  =@"单位（吨）";
        _tfWeight.keyboardType = UIKeyboardTypeDecimalPad;
        _tfWeight.delegate = self;
    }
    return _tfWeight;
}

- (UITextField *)tfBulk {
    if (!_tfBulk) {
        _tfBulk = [UITextField new];
        _tfBulk.placeholder = @"单位（m³）";
        _tfBulk.keyboardType = UIKeyboardTypeDecimalPad;
        _tfBulk.delegate = self;

    }
    return _tfBulk;
}

- (UITextField *)tfLargestWeight {
    if (!_tfLargestWeight) {
        _tfLargestWeight = [UITextField new];
        _tfLargestWeight.placeholder  =@"单位（吨）";
        _tfLargestWeight.keyboardType = UIKeyboardTypeDecimalPad;
        _tfLargestWeight.delegate = self;

    }
    return _tfLargestWeight;
}

- (UITextField *)tfLong {
    if (!_tfLong) {
        _tfLong = [UITextField new];
        _tfLong.placeholder  =@"长(cm)";
        _tfLong.keyboardType = UIKeyboardTypeDecimalPad;
        _tfLong.delegate = self;

    }
    return _tfLong;
}

- (UITextField *)tfWeith {
    if (!_tfWeith) {
        _tfWeith = [UITextField new];
        _tfWeith.placeholder  =@"宽(cm)";
        _tfWeith.keyboardType = UIKeyboardTypeDecimalPad;
        _tfWeith.delegate = self;
    }
    return _tfWeith;
}

- (UITextField *)tfHeight {
    if (!_tfHeight) {
        _tfHeight = [UITextField new];
        _tfHeight.placeholder  =@"高(cm)";
        _tfHeight.keyboardType = UIKeyboardTypeDecimalPad;
        _tfHeight.delegate = self;

    }
    return _tfHeight;
}



- (void)setInfo:(TransportationModel *)info {

    [self ViewWithModel:info];


}




@end


@implementation SearchResultView1

- (void)viewMake:(TransportationModel *)info {

    self.ivTransport.frame = CGRectMake(18, -30, 104, 104);
    [self.viShow addSubview:self.ivTransport];

     self.lb1 = [UILabel new];
    //    _lb1.text = info.capacityType;
    self.lb1.font = [UIFont systemFontOfSize:18];
    self.lb1.frame = CGRectMake(self.ivTransport.right + 10, 20, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:self.lb1];

    self.lb2 = [UILabel new];
    self.lb2.text = [NSString stringWithFormat:@"￥%.2f起",[info.ticketTotal floatValue]];

    self.lb2.font = [UIFont systemFontOfSize:20];
    self.lb2.textColor = APP_COLOR_RED1;

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lb2.text];

    NSUInteger loc = self.lb2.text.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    self.lb2.attributedText = AttributedStr;

    self.lb2.frame  = CGRectMake(self.ivTransport.right + 10, self.lb1.bottom + 10, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:self.lb2];

    self.lb3 = [UILabel new];
    self.lb3.frame = CGRectMake(SCREEN_W - 70, self.lb2.bottom - 20, 70, 20);
    self.lb3.textColor = APP_COLOR_GRAY2;
    self.lb3.text = [NSString stringWithFormat:@"%i日送达",[info.expectTime intValue]/1440];
    self.lb3.font = [UIFont systemFontOfSize:12];
    [self.viShow addSubview:self.lb3];

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, self.lb2.bottom + 20, SCREEN_W, 0.5);
    viLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viShow addSubview:viLine];

    //    UILabel *lb4 = [UILabel new];
    //    lb4.frame = CGRectMake(20, viLine.bottom + 20, SCREEN_W - 20, 20);
    //    lb4.text = @"是否有自备箱";
    //    lb4.font = [UIFont systemFontOfSize:14];
    //    lb4.textColor = APP_COLOR_GRAY2;
    //    [self.viShow addSubview:lb4];


    //    self.btnYes.frame = CGRectMake(20, lb4.bottom + 10, 66, 33);
    //
    //
    //    [self.viShow addSubview:self.btnYes];
    //
    //
    //    self.btnNo.frame = CGRectMake(self.btnYes.right + 20, lb4.bottom + 10, 66, 33);
    //
    //
    //    [self.viShow addSubview:self.btnNo];

    UILabel *lb5 = [UILabel new];
    lb5.frame = CGRectMake(20, viLine.bottom + 20, 50, 20);
    lb5.text = @"总重量";
    lb5.font = [UIFont systemFontOfSize:14];
    lb5.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb5];

    self.tfWeight.frame = CGRectMake(lb5.right, viLine.bottom + 20, 80 ,20);

    self.tfWeight.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfWeight];

    self.lb7 = [UILabel new];
    self.lb7.frame = CGRectMake(self.tfWeight.right + 10, viLine.bottom + 20, 50, 20);
    self.lb7.text = @"总体积";
    self.lb7.font = [UIFont systemFontOfSize:14];
    self.lb7.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:self.lb7];

    self.tfBulk.frame = CGRectMake(self.lb7.right, viLine.bottom + 20, 80 ,20);

    self.tfBulk.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfBulk];


    UILabel *lb6 = [UILabel new];
    lb6.frame = CGRectMake(20, lb5.bottom + 20, SCREEN_W - 20, 20);
    lb6.text = @"服务方式";
    lb6.font = [UIFont systemFontOfSize:14];
    lb6.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb6];

    self.btnMTM.frame =CGRectMake(20, lb6.bottom + 60, 110, 33);
    self.btnDTD.frame =CGRectMake(20, lb6.bottom + 10, 80, 33);
    self.btnMTD.frame =CGRectMake(self.btnDTD.right + 20, lb6.bottom + 10, 80, 33);
    self.btnDTM.frame =CGRectMake(self.btnMTD.right + 20, lb6.bottom + 10, 80, 33);

    [self.viShow addSubview:self.btnMTM];
    [self.viShow addSubview:self.btnMTD];
    [self.viShow addSubview:self.btnDTM];
    [self.viShow addSubview:self.btnDTD];

    self.lbStyle = [UILabel new];
    self.lbStyle.frame = CGRectMake(0, self.btnDTD.bottom + 10, SCREEN_W , 20);
    self.lbStyle.text = @"起运地、抵运地地址已确定";
    self.lbStyle.font = [UIFont systemFontOfSize:14];
    self.lbStyle.textColor = APP_COLOR_GRAY2;
    self.lbStyle.textAlignment = NSTextAlignmentCenter;
    //    [self.viShow addSubview:self.lbStyle];

    UILabel *lb1 = [UILabel new];
    lb1.frame = CGRectMake(0,300, 200, 20);
    lb1.textAlignment = NSTextAlignmentRight;
    lb1.font = [UIFont systemFontOfSize:10];
    lb1.text = @"*箱子来源：平台供箱，如有疑问，请";
    lb1.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb1];

    UILabel *lb2 = [UILabel new];
    lb2.frame = CGRectMake(lb1.right + 2,300, 90, 20);
    lb2.font = [UIFont systemFontOfSize:10];
    lb2.text = @"联系客服";
    lb2.textColor = APP_COLOR_BLUE_BTN_;
    [self.viShow addSubview:lb2];

    self.btnCall = [UIButton new];
    self.btnCall.frame = CGRectMake(lb1.right + 2,300, 90, 20);
    [self.viShow addSubview:self.btnCall];
    
    
    
    self.btnboom.frame = CGRectMake(0, 356, SCREEN_W, 44);
    [self.viShow addSubview:self.btnboom];
    
    
}

- (void) typeStyeChooseAction: (UIButton *)btn {

    self.btnStyleChoose.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnStyleChoose setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    btn.layer.borderColor = APP_COLOR_ORANGE_BTN.CGColor;
    [btn setTitleColor:APP_COLOR_ORANGE_BTN forState:UIControlStateNormal];
    self.btnStyleChoose = btn;

    if(self.tfWeight.text.length >0||self.tfBulk.text.length >0){

        [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];

    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货+送货上门"]) {

        self.lbStyle.text = @"需完善起运地、抵运地地址信息";
    }

    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货"]) {

        self.lbStyle.text = @"需完善起运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"送货上门"]) {

        self.lbStyle.text = @"需完善抵运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"无"]) {
        
        self.lbStyle.text = @"起运地、抵运地地址信息已确定";
    }

    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {



    if ([textField isEqual:self.tfBulk]||[textField isEqual:self.tfWeight]) {

        if ((self.tfBulk.text.length >0 || self.tfWeight.text.length >0 )&& self.btnStyleChoose) {

            [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];


        }else {

            [self.btnboom setBackgroundColor:APP_COLOR_GRAY_BTN_1];
            
        }
    }
    
    
    
    
    return YES;
}




@end

@implementation SearchResultView2

- (void)viewMake:(TransportationModel *)info {

    self.ivTransport.frame = CGRectMake(18, -30, 104, 104);
    [self.viShow addSubview:self.ivTransport];

    self.lb1 = [UILabel new];
    //    _lb1.text = info.capacityType;
    self.lb1.font = [UIFont systemFontOfSize:18];
    self.lb1.frame = CGRectMake(self.ivTransport.right + 10, 20, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:self.lb1];

    self.lb2 = [UILabel new];
    self.lb2.text = [NSString stringWithFormat:@"￥%.2f起",[info.ticketTotal floatValue]];

    self.lb2.font = [UIFont systemFontOfSize:20];
    self.lb2.textColor = APP_COLOR_RED1;

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lb2.text];

    NSUInteger loc = self.lb2.text.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    self.lb2.attributedText = AttributedStr;

    self.lb2.frame  = CGRectMake(self.ivTransport.right + 10, self.lb1.bottom + 10, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:self.lb2];

    self.lb3 = [UILabel new];
    self.lb3.frame = CGRectMake(SCREEN_W - 70, self.lb2.bottom - 20, 70, 20);
    self.lb3.textColor = APP_COLOR_GRAY2;
    self.lb3.text = [NSString stringWithFormat:@"%i日送达",[info.expectTime intValue]/1440];
    self.lb3.font = [UIFont systemFontOfSize:12];
    [self.viShow addSubview:self.lb3];

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, self.lb2.bottom + 20, SCREEN_W, 0.5);
    viLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viShow addSubview:viLine];

    //    UILabel *lb4 = [UILabel new];
    //    lb4.frame = CGRectMake(20, viLine.bottom + 20, SCREEN_W - 20, 20);
    //    lb4.text = @"是否有自备箱";
    //    lb4.font = [UIFont systemFontOfSize:14];
    //    lb4.textColor = APP_COLOR_GRAY2;
    //    [self.viShow addSubview:lb4];


    //    self.btnYes.frame = CGRectMake(20, lb4.bottom + 10, 66, 33);
    //
    //
    //    [self.viShow addSubview:self.btnYes];
    //
    //
    //    self.btnNo.frame = CGRectMake(self.btnYes.right + 20, lb4.bottom + 10, 66, 33);
    //
    //
    //    [self.viShow addSubview:self.btnNo];

    UILabel *lb5 = [UILabel new];
    lb5.frame = CGRectMake(20, viLine.bottom + 20, 50, 20);
    lb5.text = @"总重量";
    lb5.font = [UIFont systemFontOfSize:14];
    lb5.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb5];

    self.tfWeight.frame = CGRectMake(lb5.right, viLine.bottom + 20, 80 ,20);

    self.tfWeight.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfWeight];

    UILabel *lb6 = [UILabel new];
    lb6.frame = CGRectMake(20, lb5.bottom + 20, SCREEN_W - 20, 20);
    lb6.text = @"服务方式";
    lb6.font = [UIFont systemFontOfSize:14];
    lb6.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb6];

    self.btnMTM.frame =CGRectMake(20, lb6.bottom + 60, 110, 33);
    self.btnDTD.frame =CGRectMake(20, lb6.bottom + 10, 80, 33);
    self.btnMTD.frame =CGRectMake(self.btnDTD.right + 20, lb6.bottom + 10, 80, 33);
    self.btnDTM.frame =CGRectMake(self.btnMTD.right + 20, lb6.bottom + 10, 80, 33);

    [self.viShow addSubview:self.btnMTM];
    [self.viShow addSubview:self.btnMTD];
    [self.viShow addSubview:self.btnDTM];
    [self.viShow addSubview:self.btnDTD];

    self.lbStyle = [UILabel new];
    self.lbStyle.frame = CGRectMake(0, self.btnDTD.bottom + 10, SCREEN_W , 20);
    self.lbStyle.text = @"起运地、抵运地地址已确定";
    self.lbStyle.font = [UIFont systemFontOfSize:14];
    self.lbStyle.textColor = APP_COLOR_GRAY2;
    self.lbStyle.textAlignment = NSTextAlignmentCenter;
    //    [self.viShow addSubview:self.lbStyle];

    UILabel *lb1 = [UILabel new];
    lb1.frame = CGRectMake(0,300, 200, 20);
    lb1.textAlignment = NSTextAlignmentRight;
    lb1.font = [UIFont systemFontOfSize:10];
    lb1.text = @"*箱子来源：平台供箱，如有疑问，请";
    lb1.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb1];

    UILabel *lb2 = [UILabel new];
    lb2.frame = CGRectMake(lb1.right + 2,300, 90, 20);
    lb2.font = [UIFont systemFontOfSize:10];
    lb2.text = @"联系客服";
    lb2.textColor = APP_COLOR_BLUE_BTN_;
    [self.viShow addSubview:lb2];

    self.btnCall = [UIButton new];
    self.btnCall.frame = CGRectMake(lb1.right + 2,300, 90, 20);
    [self.viShow addSubview:self.btnCall];



    self.btnboom.frame = CGRectMake(0, 356, SCREEN_W, 44);
    [self.viShow addSubview:self.btnboom];


}

- (void) typeStyeChooseAction: (UIButton *)btn {

    self.btnStyleChoose.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnStyleChoose setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    btn.layer.borderColor = APP_COLOR_ORANGE_BTN.CGColor;
    [btn setTitleColor:APP_COLOR_ORANGE_BTN forState:UIControlStateNormal];
    self.btnStyleChoose = btn;

    if(self.tfWeight.text.length >0){

        [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];

    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货+送货上门"]) {

        self.lbStyle.text = @"需完善起运地、抵运地地址信息";
    }

    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货"]) {

        self.lbStyle.text = @"需完善起运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"送货上门"]) {

        self.lbStyle.text = @"需完善抵运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"无"]) {

        self.lbStyle.text = @"起运地、抵运地地址信息已确定";
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {



    if ([textField isEqual:self.tfWeight]) {

        if ( self.tfWeight.text.length >0 && self.btnStyleChoose) {

            [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];


        }else {

            [self.btnboom setBackgroundColor:APP_COLOR_GRAY_BTN_1];
            
        }
    }
    
    
    
    
    return YES;
}

@end


@implementation SearchResultView4


- (void)binView {

    self.num = 1;

    self.viBackground.frame = CGRectMake(0, - SCREEN_H, SCREEN_W,2 * SCREEN_H);
    [self addSubview:self.viBackground];

    self.btnCancle.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 500);
    [self addSubview:self.btnCancle];

    self.viShow.frame = CGRectMake(0, SCREEN_H - 500, SCREEN_W, 500);
    [self addSubview:self.viShow];

    [self viewMake:self.info];
    
    
}

- (void)viewMake:(TransportationModel *)info {

    self.ivTransport.frame = CGRectMake(18, -30, 104, 104);
    [self.viShow addSubview:self.ivTransport];

    self.lb1 = [UILabel new];
    //    _lb1.text = info.capacityType;
    self.lb1.font = [UIFont systemFontOfSize:18];
    self.lb1.frame = CGRectMake(self.ivTransport.right + 10, 20, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:self.lb1];

    self.lb2 = [UILabel new];
    self.lb2.text = [NSString stringWithFormat:@"￥%.2f起",[info.ticketTotal floatValue]];

    self.lb2.font = [UIFont systemFontOfSize:20];
    self.lb2.textColor = APP_COLOR_RED1;

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lb2.text];

    NSUInteger loc = self.lb2.text.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    self.lb2.attributedText = AttributedStr;

    self.lb2.frame  = CGRectMake(self.ivTransport.right + 10, self.lb1.bottom + 10, SCREEN_W - self.ivTransport.right - 10, 20);
    [self.viShow addSubview:self.lb2];

    self.lb3 = [UILabel new];
    self.lb3.frame = CGRectMake(SCREEN_W - 70, self.lb2.bottom - 20, 70, 20);
    self.lb3.textColor = APP_COLOR_GRAY2;
    self.lb3.text = [NSString stringWithFormat:@"%i日送达",[info.expectTime intValue]/1440];
    self.lb3.font = [UIFont systemFontOfSize:12];
    [self.viShow addSubview:self.lb3];

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, self.lb2.bottom + 20, SCREEN_W, 0.5);
    viLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viShow addSubview:viLine];

    //    UILabel *lb4 = [UILabel new];
    //    lb4.frame = CGRectMake(20, viLine.bottom + 20, SCREEN_W - 20, 20);
    //    lb4.text = @"是否有自备箱";
    //    lb4.font = [UIFont systemFontOfSize:14];
    //    lb4.textColor = APP_COLOR_GRAY2;
    //    [self.viShow addSubview:lb4];


    //    self.btnYes.frame = CGRectMake(20, lb4.bottom + 10, 66, 33);
    //
    //
    //    [self.viShow addSubview:self.btnYes];
    //
    //
    //    self.btnNo.frame = CGRectMake(self.btnYes.right + 20, lb4.bottom + 10, 66, 33);
    //
    //
    //    [self.viShow addSubview:self.btnNo];

    UILabel *lb5 = [UILabel new];
    lb5.frame = CGRectMake(20, viLine.bottom + 20, 50, 20);
    lb5.text = @"总重量";
    lb5.font = [UIFont systemFontOfSize:14];
    lb5.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb5];

    self.tfWeight.frame = CGRectMake(lb5.right, viLine.bottom + 20, 80 ,20);

    self.tfWeight.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfWeight];

    UILabel *lb51 = [UILabel new];
    lb51.frame = CGRectMake(20, lb5.bottom + 20, 100, 20);
    lb51.text = @"最大单件重量";
    lb51.font = [UIFont systemFontOfSize:14];
    lb51.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb51];

    self.tfLargestWeight.frame = CGRectMake(lb51.right, lb5.bottom + 20, 80 ,20);

    self.tfLargestWeight.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfLargestWeight];

    UILabel *lb52 = [UILabel new];
    lb52.frame = CGRectMake(self.tfLargestWeight.right + 10, lb5.bottom + 20, 30, 20);
    lb52.text = @"件数";
    lb52.font = [UIFont systemFontOfSize:14];
    lb52.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb52];

    self.tfNum.frame = CGRectMake(lb52.right, lb5.bottom + 20, 80 ,20);

    self.tfNum.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfNum];

    UILabel *lb53 = [UILabel new];
    lb53.frame = CGRectMake(20, lb52.bottom + 5, 150, 20);
    lb53.text = @"最大单件尺寸";
    lb53.font = [UIFont systemFontOfSize:14];
    lb53.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb53];

    self.tfLong.frame = CGRectMake(20, lb53.bottom + 20 , 60, 20);
    self.tfLong.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfLong];

    self.tfWeith.frame = CGRectMake(self.tfLong.right + 10, lb53.bottom + 20 , 60, 20);
    self.tfWeith.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfWeith];

    self.tfHeight.frame = CGRectMake(self.tfWeith.right + 10, lb53.bottom + 20 , 60, 20);
    self.tfHeight.font = [UIFont systemFontOfSize:14];
    [self.viShow addSubview:self.tfHeight];


    UILabel *lb6 = [UILabel new];
    lb6.frame = CGRectMake(20, self.tfHeight.bottom + 20, SCREEN_W - 20, 20);
    lb6.text = @"服务方式";
    lb6.font = [UIFont systemFontOfSize:14];
    lb6.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb6];

    self.btnMTM.frame =CGRectMake(20, lb6.bottom + 60, 110, 33);
    self.btnDTD.frame =CGRectMake(20, lb6.bottom + 10, 80, 33);
    self.btnMTD.frame =CGRectMake(self.btnDTD.right + 20, lb6.bottom + 10, 80, 33);
    self.btnDTM.frame =CGRectMake(self.btnMTD.right + 20, lb6.bottom + 10, 80, 33);

    [self.viShow addSubview:self.btnMTM];
    [self.viShow addSubview:self.btnMTD];
    [self.viShow addSubview:self.btnDTM];
    [self.viShow addSubview:self.btnDTD];

    self.lbStyle = [UILabel new];
    self.lbStyle.frame = CGRectMake(0, self.btnDTD.bottom + 10, SCREEN_W , 20);
    self.lbStyle.text = @"起运地、抵运地地址已确定";
    self.lbStyle.font = [UIFont systemFontOfSize:14];
    self.lbStyle.textColor = APP_COLOR_GRAY2;
    self.lbStyle.textAlignment = NSTextAlignmentCenter;
    //    [self.viShow addSubview:self.lbStyle];

    UILabel *lb1 = [UILabel new];
    lb1.frame = CGRectMake(0,400, 200, 20);
    lb1.textAlignment = NSTextAlignmentRight;
    lb1.font = [UIFont systemFontOfSize:10];
    lb1.text = @"*箱子来源：平台供箱，如有疑问，请";
    lb1.textColor = APP_COLOR_GRAY2;
    [self.viShow addSubview:lb1];

    UILabel *lb2 = [UILabel new];
    lb2.frame = CGRectMake(lb1.right + 2,400, 90, 20);
    lb2.font = [UIFont systemFontOfSize:10];
    lb2.text = @"联系客服";
    lb2.textColor = APP_COLOR_BLUE_BTN_;
    [self.viShow addSubview:lb2];

    self.btnCall = [UIButton new];
    self.btnCall.frame = CGRectMake(lb1.right + 2,400, 90, 20);
    [self.viShow addSubview:self.btnCall];



    self.btnboom.frame = CGRectMake(0, 456, SCREEN_W, 44);
    [self.viShow addSubview:self.btnboom];



}

- (void) typeStyeChooseAction: (UIButton *)btn {

    self.btnStyleChoose.layer.borderColor = APP_COLOR_GRAY2.CGColor;
    [self.btnStyleChoose setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    btn.layer.borderColor = APP_COLOR_ORANGE_BTN.CGColor;
    [btn setTitleColor:APP_COLOR_ORANGE_BTN forState:UIControlStateNormal];
    self.btnStyleChoose = btn;

    if(self.tfWeight.text.length >0){

        [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];

    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货+送货上门"]) {

        self.lbStyle.text = @"需完善起运地、抵运地地址信息";
    }

    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"上门取货"]) {

        self.lbStyle.text = @"需完善起运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"送货上门"]) {

        self.lbStyle.text = @"需完善抵运地地址信息";
    }


    if ( [self.btnStyleChoose.titleLabel.text isEqualToString:@"无"]) {

        self.lbStyle.text = @"起运地、抵运地地址信息已确定";
    }

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {





        if ( self.tfWeight.text.length >0 && self.btnStyleChoose && self.tfLargestWeight.text.length >0 && self.tfLong.text.length > 0 && self.tfHeight.text.length > 0 && self.tfWeith.text.length > 0) {
            
            [self.btnboom setBackgroundColor:APP_COLOR_BLUE_BTN];
            
            
        }else {
            
            [self.btnboom setBackgroundColor:APP_COLOR_GRAY_BTN_1];
            
        }

    
    
    
    
    return YES;
}

@end

