//
//  MyFunctionCell.m
//  MallClient
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyFunctionCell.h"
#import "CalculatorViewController.h"
#import "MLNavigationController.h"
#import "UserViewController.h"
#import "InvoiceListViewController.h"
#import "AddressManagerViewController.h"
#import "VerbViewController.h"
#import "MyNeedListViewController.h"

@interface MyFunctionCell ()


@end

@implementation MyFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//未登录装箱计算器
- (IBAction)pressNoLoginCalculator:(id)sender {
    CalculatorViewController * vc = [[CalculatorViewController alloc] initWithNibName:NSStringFromClass([CalculatorViewController class]) bundle:nil];
    UserViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
    
}
//钱包
- (IBAction)pressPurse:(id)sender {
    [[Toast shareToast] makeText:@"功能暂缓开通" aDuration:1];
    
}
//地址
- (IBAction)pressAddress:(id)sender {
    AddressManagerViewController * vc = [AddressManagerViewController new];
    vc.title = @"地址管理";
    vc.isSelect = YES;
    vc.isGoBack = YES;
    UserViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
}
//认证
- (IBAction)pressEvidence:(id)sender {
    VerbViewController * vc = [VerbViewController new];
    UserViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
    
}
//发票
- (IBAction)pressInvoce:(id)sender {
//    #import "InvoiceListViewController.h"
    InvoiceListViewController * vc = [[InvoiceListViewController alloc] initWithNibName:NSStringFromClass([InvoiceListViewController class]) bundle:nil];
    UserViewController * controller = self.target;
    vc.isSelect = YES;
    [controller.navigationController pushViewController:vc animated:YES];
}
//登录装箱计算器
- (IBAction)pressLoginCalculate:(id)sender {
    
    CalculatorViewController * vc = [[CalculatorViewController alloc] initWithNibName:NSStringFromClass([CalculatorViewController class]) bundle:nil];
    UserViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pressXQ:(id)sender {
    
    NSLog(@"点击了需求");
    MyNeedListViewController * vc = [[MyNeedListViewController alloc] init];
    UserViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
    
}


@end
