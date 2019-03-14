//
//  OrderDetailFootView.m
//  MallClient
//
//  Created by lxy on 2018/6/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailFootView.h"
#import "CustomButton.h"
#import "NSString+Money.h"
#import "CapacityOrderDetailVC.h"
#import "PaymentPageVC.h"
#import "OrderViewModel.h"

@interface OrderDetailFootView ()
@property (weak, nonatomic) IBOutlet CustomButton *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnRigntLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnRightLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailRightLine;

@end



@implementation OrderDetailFootView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isShow = NO;
    }
    return self;
}

- (void)layoutSubviews
{
//    self.leftBtn.layer.borderWidth = 1.0;
//    self.leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.rightBtn.layer.cornerRadius = 4.0f;
    self.rightBtn.layer.masksToBounds =YES;
}


- (void)setModel:(OrderModelForCapacity *)model
{
    _model = model;
    [self.priceLabel setAttributedText:[NSString getFormartPrice:[model.price floatValue]]];
    if ([model.ordetType isEqualToString:@"待确认"]) {
        self.rightBtn.hidden = YES;
//        self.leftBtnRigntLine.constant = 20.0f;
        self.detailRightLine.constant = 15.0f;
    }
    if ([model.ordetType isEqualToString:@"待发货"] || [model.ordetType isEqualToString:@"待收货"]) {
//        self.leftBtn.hidden = YES;
        self.detailRightLine.constant = 95.0f;
    }
    if ([model.ordetType isEqualToString:@"已完成"] || [model.ordetType isEqualToString:@"已取消"]) {
//        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.detailRightLine.constant = 15.0f;
    }
    
}

- (void)pressView
{
    self.isShow = !self.isShow;
    if (self.block) {
        self.block(self.isShow);
    }
}

- (IBAction)pressRightBtn:(id)sender {
    CapacityOrderDetailVC * vc = self.targat;
    [vc.navigationController pushViewController:[PaymentPageVC new] animated:YES];
    
}
- (IBAction)pressLeftBtn:(id)sender {
    NSString * title;
    NSString * defaultTitle;
    NSString * cancelTitle;
    NSString * message;
    if ([self.model.ordetType isEqualToString:@"待确认"]) {
        title = @"取消订单";
        defaultTitle = @"否";
        cancelTitle = @"是";
        message  = @"\n是否取消订单？\n";
    }
    if ([self.model.ordetType isEqualToString:@"待付款"]) {
        title = @"取消订单";
        defaultTitle = @"再想想";
        cancelTitle = @"联系客服";
        message  = @"\n取消订单请联系客服\n";
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             if ([self.model.ordetType isEqualToString:@"待确认"]) {
                                                                 [[OrderViewModel new]emptyContainerOrderOperateWithOrderId:self.model.ID WithType:CANCEL callback:^(NSString *str) {
                                                                     
                                                                     if ([str isEqualToString:@"10000"]) {
                                                                         if (self.cancelBlock) {
                                                                             self.cancelBlock(self.model);
                                                                         }
                                                                         
                                                                     }
                                                                     
                                                                 }];
                                                             }else{
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",APP_CUSTOMER_SERVICE]]];
                                                             }
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self.targat presentViewController:alert animated:YES completion:nil];
}
- (IBAction)pressDetailBtn:(id)sender {
    self.isShow = !self.isShow;
    if (self.block) {
        self.block(self.isShow);
    }
}


@end
