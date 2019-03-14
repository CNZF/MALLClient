//
//  OrderTransportSuccessViewController.m
//  MallClient
//
//  Created by lxy on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderTransportSuccessViewController.h"

@interface OrderTransportSuccessViewController ()

@property (nonatomic, strong) UILabel     *lbTitle;
@property (nonatomic, strong) UIImageView *ivSuccess;
@property (nonatomic, strong) UILabel     *lbStatuse;
@property (nonatomic, strong) UILabel     *lbOrderNo;
@property (nonatomic, strong) UILabel     *lbOrderNo1;
@property (nonatomic, strong) UIButton    *btnReturnToFirst;
@property (nonatomic, strong) UIButton    *btnGotoOrder;
@property (nonatomic, strong) UILabel     *lbBottom1;
@property (nonatomic, strong) UILabel     *lbBottom2;

@end

@implementation OrderTransportSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.view.backgroundColor = [UIColor whiteColor];

    self.lbTitle.frame = CGRectMake(0, 40, SCREEN_W, 20);
    [self.view addSubview:self.lbTitle];

    self.ivSuccess.frame = CGRectMake(SCREEN_W/2 - 67, self.lbTitle.bottom + 20, 134, 134);
    [self.view addSubview:self.ivSuccess];

    self.lbStatuse.frame = CGRectMake(0, self.ivSuccess.bottom +10, SCREEN_W, 20);
    [self.view addSubview:self.lbStatuse];

    self.lbOrderNo.frame = CGRectMake(0, self.lbStatuse.bottom +20, SCREEN_W, 20);
    [self.view addSubview:self.lbOrderNo];
    self.lbOrderNo1.frame = CGRectMake(0, self.lbOrderNo.bottom +5, SCREEN_W, 20);
    [self.view addSubview:self.lbOrderNo1];


    self.btnReturnToFirst.frame = CGRectMake(SCREEN_W/2 - 125, self.lbOrderNo1.bottom + 30, 250, 44);
    [self.view addSubview:self.btnReturnToFirst];

    self.btnGotoOrder.frame = CGRectMake(SCREEN_W/2 - 125, self.btnReturnToFirst.bottom + 20, 250, 44);
    [self.view addSubview:self.btnGotoOrder];

    self.lbBottom1.frame = CGRectMake(0, SCREEN_H - 80, SCREEN_W, 20);
    [self.view addSubview:self.lbBottom1];

    self.lbBottom2.frame = CGRectMake(0, SCREEN_H - 50, SCREEN_W, 20);
    [self.view addSubview:self.lbBottom2];

}

- (void)bindAction {

    WS(ws);

    //前往订单
    [[self.btnGotoOrder rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {


    }];

    //回到首页
    [[self.btnReturnToFirst rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {


    }];
}

/**
 *  getter
 */

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"定制状态";
        label.textAlignment = NSTextAlignmentCenter;

        _lbTitle = label;
    }
    return _lbTitle;
}

- (UIImageView *)ivSuccess {
    if (!_ivSuccess) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"orderSuccess"];


        _ivSuccess = imageView;
    }
    return _ivSuccess;
}

- (UILabel *)lbStatuse {
    if (!_lbStatuse) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];

        label.text = @"定制成功";
        label.textAlignment = NSTextAlignmentCenter;

        _lbStatuse = label;
    }
    return _lbStatuse;
}

- (UILabel *)lbOrderNo {
    if (!_lbOrderNo) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];

        label.text = @"订单已生成，可前往订单中心查看";
        label.textAlignment = NSTextAlignmentCenter;

        _lbOrderNo = label;
    }
    return _lbOrderNo;
}

- (UILabel *)lbOrderNo1 {
    if (!_lbOrderNo1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];

        label.text = @"我们将在24小时内安排专人与您探讨方案";
        label.textAlignment = NSTextAlignmentCenter;

        _lbOrderNo1 = label;
    }
    return _lbOrderNo1;
}

- (UIButton *)btnReturnToFirst {
    if (!_btnReturnToFirst) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"回到首页" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        button.layer.masksToBounds = YES;
        [button.layer setCornerRadius:22.5];

        _btnReturnToFirst = button;
    }
    return _btnReturnToFirst;
}


- (UIButton *)btnGotoOrder {
    if (!_btnGotoOrder) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"前往订单" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = APP_COLOR_BLUE_BTN.CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:22.5];

        _btnGotoOrder = button;
    }
    return _btnGotoOrder;
}

- (UILabel *)lbBottom1 {
    if (!_lbBottom1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.text = @"订单支付请前往网上商城";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];



        _lbBottom1 = label;
    }
    return _lbBottom1;
}


- (UILabel *)lbBottom2 {
    if (!_lbBottom2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.text = @"网上商城网址：www.unitransdata.com";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        
        
        _lbBottom2 = label;
    }
    return _lbBottom2;
}

@end
