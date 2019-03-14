//
//  OrderPayModel.h
//  MallClient
//
//  Created by lxy on 2018/6/11.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface OrderPayModel : BaseModel

@property (nonatomic, copy)NSString * remark;
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * price;
@property (nonatomic, copy)NSString * statusName;
@property (nonatomic, copy)NSString * tradeOrderNo;
@property (nonatomic, copy)NSString * pay_voucher_url;
@property (nonatomic, copy)NSString * trade_order_type;

@end
