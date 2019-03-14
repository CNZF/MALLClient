//
//  PaymentBillVC.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/15.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "PaymentFlowModel.h"

@interface PaymentBillVC : BaseViewController

@property (nonatomic, strong)NSArray<PaymentFlowModel *> * paymentFlowModelArray;
@end
