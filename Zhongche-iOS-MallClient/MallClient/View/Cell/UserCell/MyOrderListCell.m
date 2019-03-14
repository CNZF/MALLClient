//
//  MyOrderListCell.m
//  MallClient
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyOrderListCell.h"
#import "UserViewController.h"
#import "OrderCenterVC.h"
#import "AdverbOrderController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MLNavigationController.h"

@interface MyOrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *waitComfirmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitConfirmLabelWidth;


@property (weak, nonatomic) IBOutlet UILabel *WaitPayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitPayLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *waitSendLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitSendLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *waitReviceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitReviceLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelLabelWidth;


@end

@implementation MyOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    if (USER_INFO) {
//        self.WaitPayLabel.hidden = NO;
//        self.waitSendLabel.hidden = NO;
//        self.waitReviceLabel.hidden = NO;
//        self.finishLabel.hidden = NO;
//        self.cancelLabel.hidden = NO;
//    }else{
//        self.WaitPayLabel.hidden = YES;
//        self.waitSendLabel.hidden = YES;
//        self.waitReviceLabel.hidden = YES;
//        self.finishLabel.hidden = YES;
//        self.cancelLabel.hidden = YES;
//    }
//}

- (void) setChildView{
    self.waitComfirmLabel.hidden = YES;
    self.WaitPayLabel.hidden = YES;
    self.waitSendLabel.hidden = YES;
    self.waitReviceLabel.hidden = YES;
    self.finishLabel.hidden = YES;
    self.cancelLabel.hidden = YES;

}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    if (!USER_INFO) {
        [self setChildView];
        return;
    }
    //待确认
    if ([orderDic[@"orderStatus"][@"toBeConfirmed"] intValue] == 0) {
        self.waitComfirmLabel.hidden = YES;
    }else{
        self.waitComfirmLabel.hidden = NO;
        NSNumber  * num = orderDic[@"orderStatus"][@"toBeConfirmed"];
        int number = [num intValue];
        if (number >= 100) {
            self.waitComfirmLabel.text = @"99+";
            self.waitConfirmLabelWidth.constant = 25;
        }else{
            self.waitConfirmLabelWidth.constant = 20;
             self.waitComfirmLabel.text = [orderDic[@"orderStatus"][@"toBeConfirmed"] stringValue];
        }
       
    }
    
    //待付款
    if ([orderDic[@"orderStatus"][@"forThePayment"] intValue] == 0) {
        self.WaitPayLabel.hidden = YES;
    }else{
        self.WaitPayLabel.hidden = NO;
        NSNumber  * num = orderDic[@"orderStatus"][@"forThePayment"];
        int number = [num intValue];
        if (number >= 100) {
            self.WaitPayLabel.text = @"99+";
            self.waitPayLabelWidth.constant = 25;
        }else{
            self.waitPayLabelWidth.constant = 20;
            self.WaitPayLabel.text = [orderDic[@"orderStatus"][@"forThePayment"] stringValue];
        }
        
    }
    
    //待发货
    if ([orderDic[@"orderStatus"][@"toSendTheGoods"] intValue] == 0) {
       self.waitSendLabel.hidden = YES;
    }else{
        self.waitSendLabel.hidden = NO;
        
        
        NSNumber  * num = orderDic[@"orderStatus"][@"toSendTheGoods"];
        int number = [num intValue];
        if (number >= 100) {
            self.waitSendLabel.text = @"99+";
            self.waitSendLabelWidth.constant = 25.0f;
        }else{
            self.waitSendLabelWidth.constant = 20.0f;
            self.waitSendLabel.text = [orderDic[@"orderStatus"][@"toSendTheGoods"] stringValue];
        }
    }
    
    //待结算
    if ([orderDic[@"orderStatus"][@"forTheGoods"] intValue] == 0) {
        self.waitReviceLabel.hidden = YES;
    }else{
        self.waitReviceLabel.hidden = NO;
        
        NSNumber  * num = orderDic[@"orderStatus"][@"forTheGoods"];
        int number = [num intValue];
        if (number >= 100) {
            self.finishLabel.text = @"99+";
            self.waitReviceLabelWidth.constant = 25.0f;
        }else{
            self.waitReviceLabelWidth.constant = 20.0f;
            self.waitReviceLabel.text = [orderDic[@"orderStatus"][@"forTheGoods"] stringValue];
        }
    }
    
    //完成
    if ([orderDic[@"orderStatus"][@"completed"] intValue] == 0) {
       self.finishLabel.hidden = YES;
    }else{
        self.finishLabel.hidden = NO;
        
        NSNumber  * num = orderDic[@"orderStatus"][@"completed"];
        int number = [num intValue];
        if (number >= 100) {
            self.finishLabelWidth.constant = 25.0f;
            self.finishLabel.text = @"99+";
        }else{
            self.finishLabelWidth.constant = 20.0f;
            self.finishLabel.text = [orderDic[@"orderStatus"][@"completed"] stringValue];
        }
    }
    //取消
    if ([orderDic[@"orderStatus"][@"cancel"] intValue] == 0) {
        self.cancelLabel.hidden = YES;
    }else{
        self.cancelLabel.hidden = NO;
        
        NSNumber  * num = orderDic[@"orderStatus"][@"cancel"];
        int number = [num intValue];
        if (number >= 100) {
            self.cancelLabel.text = @"99+";
            self.cancelLabelWidth.constant = 25.0f;
        }else{
            self.cancelLabelWidth.constant = 20.0f;
            self.cancelLabel.text = [orderDic[@"orderStatus"][@"cancel"] stringValue];
        }
    }

}

//查看更多订单
- (IBAction)pressMoreBtn:(id)sender {
    if (!USER_INFO) {
        [self pushLogoinVC];
        return;
    }
    OrderCenterVC * vc = [[OrderCenterVC alloc]init];
    UserViewController * controller = self.target;
    vc.showNaviLeft = YES;
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.ShowOrderLeft = YES;
    [controller.navigationController pushViewController:vc animated:YES];
}
- (IBAction)oressWaitConfirmBtn:(id)sender {
    
    [self goToAdvcWithType:@"needConfirm"];
}
//待付款
- (IBAction)pressWaitBtn:(id)sender {
    [self goToAdvcWithType:@"needPayment"];
}
//待发货
- (IBAction)pressWaitSendBtn:(id)sender {
    [self goToAdvcWithType:@"needDelivery"];
}
//待收货
- (IBAction)pressWaitReciveBtn:(id)sender {
    [self goToAdvcWithType:@"needpayed"];
}
//已完成
- (IBAction)pressFinishBtn:(id)sender {
    [self goToAdvcWithType:@"accomplish"];
}
//已取消
- (IBAction)pressCancelBtn:(id)sender {
    [self goToAdvcWithType:@"callOff"];
}

//进详情
- (void)goToAdvcWithType:(NSString *)type
{
    if (!USER_INFO) {
        [self pushLogoinVC];
        return;
    }
    AdverbOrderController * vc = [[AdverbOrderController alloc]init];
    vc.orderType = type;
    UserViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
}

//登录跳转
-(void)pushLogoinVC {
    
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.target presentViewController:vc animated:YES completion:^{
        
    }];
}
@end
