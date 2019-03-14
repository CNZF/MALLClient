//
//  AcountDetail.h
//  MallClient
//
//  Created by lxy on 2017/2/15.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface AcountDetail : BaseModel

@property (nonatomic, strong) NSString *customerNum;//客户号
@property (nonatomic, strong) NSString *accountNoType;//客户号类型\r\n 1. 公司\r\n            2. 司机
@property (nonatomic, strong) NSString *customerAccount;//客户帐号
@property (nonatomic, strong) NSString *accountType;//帐户类型
@property (nonatomic, strong) NSString *bindBlankAccount;//绑定银行帐号
@property (nonatomic, strong) NSString *blankAccountOrganization;//银行帐户开启机构
@property (nonatomic, strong) NSString *blankCardType;//银行账户类型
@property (nonatomic, strong) NSString *creditCardEffective;//信用卡有效日期
@property (nonatomic, strong) NSString *blankTel;//银行预留手机号
@property (nonatomic, strong) NSString *blankCreateDate;//开启日期
@property (nonatomic, strong) NSString *lastTradeDate;//最后交易日期
@property (nonatomic, strong) NSString *lastTradeSeq;//最后交易流水号
@property (nonatomic, strong) NSString *lastDayAmount;//上日余额
@property (nonatomic, strong) NSString *accountAmount;//帐户余额
@property (nonatomic, strong) NSString *appointClearingType;//约定清算类型
@property (nonatomic, strong) NSString *lastClearingDate;//上次清算日期
@property (nonatomic, strong) NSString *appointClearingDate;//约定清算日期
@property (nonatomic, strong) NSString *appointClearingAmount;//约定清算金额
@property (nonatomic, strong) NSString *accountStatus;//帐户状态( 0:正常，-1:销户 )
@property (nonatomic, strong) NSString *bankCustomerName;//银行客户名称（持卡人名称）
@property (nonatomic, strong) NSString *bankShortName;//开户行简称
@property (nonatomic, strong) NSString *cibBankCode;//开户行兴业代码
@property (nonatomic, strong) NSString *pbcBankCode;//开户行人行代码
@property (nonatomic, strong) NSString *pbcBankName;//开户行人行名称





@end
