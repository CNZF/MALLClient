//
//  paymentFlowModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface PaymentFlowModel : BaseModel
@property (nonatomic, strong)NSString * updateTime;//时间
@property (nonatomic, strong)NSString * tradeOrderNo;//流水号
@property (nonatomic, strong)NSString * price;//数额
@property (nonatomic, strong)NSString * status;//状态
@property (nonatomic, strong)NSString * statusStr;//状态
@end
