//
//  SubmitCoalVC.m
//  MallClient
//
//  Created by lxy on 2017/10/13.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "SubmitCoalVC.h"
#import "CoalViewModel.h"
#import "SubmitOrderSuccessViewController.h"

@interface SubmitCoalVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfNum;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfRemark;

@end

@implementation SubmitCoalVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"填写订单";

}


- (IBAction)submitAction:(id)sender {

    CoalViewModel *vm = [CoalViewModel new];

    if (self.tfNum.text&&self.tfName.text&&self.tfPhone.text&&self.tfRemark.text) {
        WS(ws);
        [vm saveOrderWithGoodsId:self.model.goodsId WithQty:self.tfNum.text WithConractsPhone:self.tfPhone.text WithContactsName:self.tfName.text WithPrice:self.model.price WithRemake:self.tfRemark.text callback:^(NSString *orderNo) {

            SubmitOrderSuccessViewController *vc = [SubmitOrderSuccessViewController new];
            vc.stOrderNo = orderNo;
            vc.type = coal;
            [ws.navigationController pushViewController:vc animated:YES];

        }];
    }else{

        [[Toast shareToast]makeText:@"信息未完整" aDuration:1];
    }
}



@end
