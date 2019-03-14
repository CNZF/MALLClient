//
//  SubmitOrderSuccessViewController.m
//  MallClient
//
//  Created by lxy on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SubmitOrderSuccessViewController.h"
#import "OrderCenterListVC.h"
#import "MLNavigationController.h"

@interface SubmitOrderSuccessViewController ()

@property (nonatomic, strong) UILabel     *lbTitle;
@property (nonatomic, strong) UIImageView *ivSuccess;
@property (nonatomic, strong) UILabel     *lbStatuse;
@property (nonatomic, strong) UILabel     *lbOrderNo;
@property (nonatomic, strong) UIButton    *btnReturnToFirst;
@property (nonatomic, strong) UIButton    *btnGotoOrder;
@property (nonatomic, strong) UILabel     *lbBottom1;
@property (nonatomic, strong) UILabel     *lbBottom2;

@end


@implementation SubmitOrderSuccessViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = NO;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;
}

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


    self.btnReturnToFirst.frame = CGRectMake(SCREEN_W/2 - 125, self.lbOrderNo.bottom + 30, 250, 44);
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

        [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedViewController"
                                                           object:@{
                                                                    @"className":@"OrderCenterVC"
                                                                    }];
        switch (ws.type) {
            case capacity:
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderPage"
                                                                   object:@{
                                                                            @"vcTitle":@"我要运力"
                                                                            }];
                [GlobalOrderType shareGlobalOrderType].orderType  = @"我要运力";
                break;
            case emptyContainer:
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderPage"
                                                                   object:@{
                                                                            @"vcTitle":@"空箱之家"
                                                                            }];
                [GlobalOrderType shareGlobalOrderType].orderType = @"空箱之家";

                break;
            case emptyCar:
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderPage"
                                                                   object:@{
                                                                            @"vcTitle":@"空车之爱"
                                                                            }];
                [GlobalOrderType shareGlobalOrderType].orderType = @"空车之爱";
                break;
            case coal:
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderPage"
                                                                   object:@{
                                                                            @"vcTitle":@"绿色煤炭"
                                                                            }];
                [GlobalOrderType shareGlobalOrderType].orderType = @"绿色煤炭";
                break;
        }
        
        [ws.navigationController popToRootViewControllerAnimated:YES];

    }];

    //回到首页
    [[self.btnReturnToFirst rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedViewController"
                                                           object:@{
                                                                    @"className":@"KNWantTransportVC"
                                                                    }];

        [ws.navigationController popToRootViewControllerAnimated:YES];


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
        //label.text = @"提交成功";
        label.textAlignment = NSTextAlignmentCenter;

        _lbTitle = label;
    }
    return _lbTitle;
}

- (UIImageView *)ivSuccess {
    if (!_ivSuccess) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"orderSUCCESS"];


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

        label.text = @"提交成功";
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
        label.font = [UIFont systemFontOfSize:16.0f];

        label.text = [NSString stringWithFormat:@"订单号 %@",self.stOrderNo];
        label.textAlignment = NSTextAlignmentCenter;

        _lbOrderNo = label;
    }
    return _lbOrderNo;
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
        button.layer.borderWidth = 0.5;
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
//        label.text = @"工作人员稍后将与您联系";
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
        label.text = [NSString stringWithFormat:@"客服电话：%@",APP_CUSTOMER_SERVICE];//
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];

        _lbBottom2 = label;
    }
    return _lbBottom2;
}

@end
