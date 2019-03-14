//
//  PriceInfo.h
//  MallClient
//
//  Created by lxy on 2016/12/20.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface PriceInfo : BaseModel

//additionPrice\":0,\"insuranceMoney\":0,\"orderTotalMoney\":5205,\"ticketTotalPrice\":5205

@property (nonatomic, strong) NSString *additionPrice;// 门到门附加费
@property (nonatomic, strong) NSString *insuranceMoney;// 保价金额
@property (nonatomic, strong) NSString *orderTotalMoney;// 总价
@property (nonatomic, strong) NSString *ticketTotalPrice;//运力票价格
@property (nonatomic, strong) NSString *startAdditionPrice;//上门取货费
@property (nonatomic, strong) NSString *endAdditionPrice;//送货上门费

@end
