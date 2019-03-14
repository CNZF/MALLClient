//
//  PaymentPageVC.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/6.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "PaymentPageVC.h"
#import "MLNavigationController.h"

@interface PaymentPageVC ()
@property (nonatomic, strong) UIImageView * igv;
@property (nonatomic, strong) UILabel     * labTitle;
@property (nonatomic, strong) UILabel     * labtext;
@property (nonatomic, strong) UIButton    * goToFirstBtn;
@property (nonatomic, strong) UIButton    * goToOrderBtn;
@end

@implementation PaymentPageVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage getImageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)]];
    ((MLNavigationController *)self.navigationController).canDragBack = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    ((MLNavigationController *)self.navigationController).canDragBack = YES;
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付页面";
    
    self.btnLeft.hidden = YES;
    self.btnRight.hidden = YES;
}

-(void)bindView {
    self.igv.frame = CGRectMake(SCREEN_W / 2 - 91, 45, 182, 67);
    [self.view addSubview:self.igv];
    
    self.labTitle.frame = CGRectMake(0, self.igv.bottom + 36, SCREEN_W, 20);
    [self.view addSubview:self.labTitle];
    self.labtext.frame = CGRectMake(0, self.labTitle.bottom + 20, SCREEN_W, 16);
    [self.view addSubview:self.labtext];
    
    self.goToFirstBtn.frame = CGRectMake(65, self.labtext.bottom + 90, SCREEN_W - 130, 44);
    [self.view addSubview:self.goToFirstBtn];
    self.goToOrderBtn.frame = CGRectMake(65, self.goToFirstBtn.bottom + 20, SCREEN_W - 130, 44);
    [self.view addSubview:self.goToOrderBtn];
}

- (void)bindAction {
    
    WS(ws);
    
    //返回首页
    [[self.goToFirstBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedViewController"
                                                           object:@{
                                                                    @"className":@"KNWantTransportVC"
                                                                    }];
        [ws.navigationController popToRootViewControllerAnimated:YES];

    }];
    
    //返回订单
    [[self.goToOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedViewController"
                                                           object:@{
                                                                    @"className":@"OrderCenterVC"
                                                                    }];
        
        [ws.navigationController popToRootViewControllerAnimated:YES];

    }];
}

/**
 *  getter
 *
 *  @return 懒加载
 */

-(UIImageView *)igv {
    if (!_igv)
    {
        _igv = [UIImageView new];
        _igv.image = [UIImage imageNamed:[@"pay" adS]];
    }
    return _igv;
}

-(UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.text = @"订单支付请前往网上商城";
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.font = [UIFont systemFontOfSize:14.f];
        _labTitle.textColor = APP_COLOR_GRAY_TEXT_1;
    }
    return _labTitle;
}

-(UILabel *)labtext {
    if (!_labtext) {
        _labtext = [UILabel new];
        _labtext.text = @"网上商城网址：www.unitransdata.com";
        _labtext.textAlignment = NSTextAlignmentCenter;
        _labtext.font = [UIFont systemFontOfSize:14.f];
        _labtext.textColor = APP_COLOR_GRAY_TEXT_1;
    }
    return _labtext;
}

-(UIButton *)goToFirstBtn {
    if (!_goToFirstBtn) {
        _goToFirstBtn = [UIButton new];
        [_goToFirstBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [_goToFirstBtn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        _goToFirstBtn.backgroundColor = APP_COLOR_BLUE_BTN;
        _goToFirstBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_goToFirstBtn.layer setMasksToBounds:YES];
        [_goToFirstBtn.layer setCornerRadius:22];//设置矩形四个圆角半径
        
    }
    return _goToFirstBtn;
}

-(UIButton *)goToOrderBtn {
    if (!_goToOrderBtn) {
        _goToOrderBtn = [UIButton new];
        [_goToOrderBtn setTitle:@"前往订单" forState:UIControlStateNormal];
        [_goToOrderBtn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        _goToOrderBtn.backgroundColor = APP_COLOR_WHITE;
        _goToOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_goToOrderBtn.layer setMasksToBounds:YES];
        [_goToOrderBtn.layer setCornerRadius:22];//设置矩形四个圆角半径
        _goToOrderBtn.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _goToOrderBtn.layer.borderWidth = 0.5;
    }
    return _goToOrderBtn;
}

@end
