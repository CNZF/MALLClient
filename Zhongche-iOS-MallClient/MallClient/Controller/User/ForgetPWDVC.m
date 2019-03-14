//
//  ForgetPWDVC.m
//  MallClient
//
//  Created by lxy on 2017/2/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "ForgetPWDVC.h"

@interface ForgetPWDVC ()

@property (nonatomic, strong) UIButton *btnContactService;

@end

@implementation ForgetPWDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"忘记密码";
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"forgetPWD"];
    iv.frame = CGRectMake(SCREEN_W/2 - 266/2, 100, 266, 105);
    [self.view addSubview:iv];

    UILabel *lb1 = [self labelWithText:@"目前平台仅支持拨打客服电话" WithFont:[UIFont systemFontOfSize:18] WithTextAlignment:NSTextAlignmentCenter WithTextColor:[UIColor blackColor]];
    lb1.frame = CGRectMake(0, iv.bottom + 40, SCREEN_W, 20);
    [self.view addSubview:lb1];

    UILabel *lb2 = [self labelWithText:@"进行密码重置" WithFont:[UIFont systemFontOfSize:18] WithTextAlignment:NSTextAlignmentCenter WithTextColor:[UIColor blackColor]];
    lb2.frame = CGRectMake(0, lb1.bottom, SCREEN_W, 20);
    [self.view addSubview:lb2];

    UILabel *lb3 = [self labelWithText:@"客服电话 400-900-6667" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_BTN_1];
    lb3.frame = CGRectMake(0, lb2.bottom + 30, SCREEN_W, 15);
    [self.view addSubview:lb3];
    self.btnContactService.frame = CGRectMake(20, lb3.bottom + 20, SCREEN_W - 40, 40);
    [self.view addSubview:self.btnContactService];

}

//电话按钮点击事件
- (void)phoneAction {

    [self callAction];
}

/**
 *  getter
 */

- (UIButton *)btnContactService {
    if (!_btnContactService) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"联系客服" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_ORANGE_BTN_TEXT];
        [button addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
        [button.layer setMasksToBounds:YES];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnContactService = button;
    }
    return _btnContactService;
}


@end
