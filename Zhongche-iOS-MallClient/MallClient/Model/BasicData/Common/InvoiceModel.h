//
//  InvoiceModel.h
//  MallClient
//
//  Created by lxy on 2016/12/21.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface InvoiceModel : BaseModel


/**
 *    companyId = 848;
 contactsAddress = "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U4e94\U9053\U53e3";
 contactsName = "\U5927\U5e08";
 contactsTel = 17875336527;
 content = "\U8fd0\U8f93\U8d39";
 id = 26;
 isDefault = 0;
 title = "\U4e2d\U8f66\U516c\U53f8";
 type = "INVOICE_TYPE_COMMON_TAX";
 */

@property (nonatomic, copy  ) NSString *companyId;//公司id
@property (nonatomic, copy  ) NSString *contactsAddress;//发票地址
@property (nonatomic, copy  ) NSString *contactsName;//发票人
@property (nonatomic, copy  ) NSString *contactsTel;//发票人联系方式
@property (nonatomic, copy  ) NSString *content;//项目
@property (nonatomic, copy  ) NSString *isDefault;//是否默认
@property (nonatomic, copy  ) NSString *ID;//发票id
@property (nonatomic, copy  ) NSString *title;//发票抬头
@property (nonatomic, copy  ) NSString *type;//发票类型   普通发票 : INVOICE_TYPE_COMMON_TAX  增值发票 : INVOICE_TYPE_VALUE_ADD_TAX
@property (nonatomic, copy  ) NSString *typeStr;//发票类型

@property (nonatomic, copy  ) NSString *idCode;//纳税人识别码
@property (nonatomic, copy  ) NSString *regAddress;//注册地址
@property (nonatomic, copy  ) NSString *regTel;//注册电话
@property (nonatomic, copy  ) NSString *regBlank;//注册银行
@property (nonatomic, copy  ) NSString *regBlankAccount;//注册银行账户
@property (nonatomic, assign) int      isShowAll;

@property (nonatomic, copy)NSString * companyInvoiceId;//发票ID可用于判断发票是否存在




@end
