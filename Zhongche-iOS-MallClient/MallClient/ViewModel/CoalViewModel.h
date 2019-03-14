//
//  CalViewModel.h
//  MallClient
//
//  Created by lxy on 2017/10/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "CoalModel.h"

@interface CoalViewModel : BaseViewModel

/**
 *  查询煤
 *
 *  @param dicConditions 筛选条件
 *  @param callback      煤数组
 */

- (void)getCoalListWithConditions:(NSDictionary *)dicConditions callback:(void(^)(NSArray *arr))callback;

/**
 *  获取筛选条件
 */
- (void)getConditionscallback:(void(^)(NSDictionary *dic))callback;

/**
 *  查询煤详情
 *
 *  @param ID       ID
 *  @param callback 煤实体
 */
- (void)getCoalDesWithId:(NSString *)ID callback:(void(^)(CoalModel *model))callback;

/**
 *  提交订单
 */

-(void)saveOrderWithGoodsId:(NSString *)goodsId WithQty:(NSString *)qty WithConractsPhone:(NSString *)conractsPhone WithContactsName:(NSString *)contactsName WithPrice:(NSString *)price WithRemake:(NSString *)remake callback:(void(^)(NSString *orderNo))callback;

@end
