//
//  InvoiceViewModel.h
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "InvoiceModel.h"

@interface InvoiceViewModel : BaseViewModel

/**
 *  更新发票
 *
 *  @param info 发票对象
 */
- (void)updateInVoiceWithInvoiceInfo:(InvoiceModel* )info callback:(void(^)(NSString *status))callback;

/**
 *  设置默认发票
 *
 *  @param Id 发票ID
 */

- (void)setDefaultInVoiceWithId:(NSString *)Id type:(NSString *)type  callback:(void(^)(NSString *status))callback;

/**
 *  添加发票
 *
 *  @param info     发票对象
 *  @param callback 状态
 */

- (void)addInVoiceWithInvoiceInfo:(InvoiceModel* )info callback:(void(^)(NSString *status))callback;

/**
 *  查询默认发票
 *
 *  @param type     INVOICE_TYPE_VALUE_ADD_TAX
 *  @param callback 发票对象
 */

-(void)getCompanyDefaultInvoiceWithType:(NSString *)type callback:(void(^)(InvoiceModel *info))callback;

/**
 *  发票查询
 *
 *  @param type     0 putongfap 1 增值税发票
 *  @param callback 发票数组
 */

- (void)selectInVoiceWithType:(int)type callback:(void(^)(NSArray *arr))callback;

@end
