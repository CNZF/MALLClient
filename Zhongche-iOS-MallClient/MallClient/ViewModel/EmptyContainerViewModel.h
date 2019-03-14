//
//  EmptyContainerViewModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "FilterModel.h"
#import "ContainerModel.h"
#import "StationModel.h"
#import "ContainerOrderInfo.h"

@interface EmptyContainerViewModel : BaseViewModel

/**
 *  查询空箱列表
 *
 *  @param retrieveModel  检索条件
 *  @param callback    订单数组
 */

-(void)getEmptyContainerArrWith:(FilterModel *)retrieveModel callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;

/**
 *  查询箱子详情
 *
 *  @param goodsId  箱子ID
 *  @param callback 箱子对象
 */

- (void)selectEmptyContainerWithID:(NSString *)goodsId callback:(void(^)(ContainerModel *info))callback;

/**
 *  查询网点
 *
 *  @param code     城市code
 *  @param callback 网点数组
 */

-(void)selectStationWithCode:(NSString *)code callback:(void(^)(NSArray *arr))callback;

/**
 *  下单
 *
 *  @param orderInfo 箱子订单对象
 *  @param callback  返回状态
 */
- (void)submitOrderWithOrderInfo:(ContainerOrderInfo *)orderInfo callback:(void(^)(NSString *orderNo))callback;

@end
