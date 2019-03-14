//
//  EmptyCarViewModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "EmptyCarFilterModel.h"
#import "EmptyCarModel.h"
#import "CarOrShipTypeModel.h"
#import "EmptyOrderModel.h"

@interface EmptyCarViewModel : BaseViewModel

/**
 *  推荐空车列表
 *
 *  @param callback  数组
 */
-(void)getRecommendListCallBack:(void(^)(NSArray *arr))callback;

/**
 *  查询空车列表
 *
 *  @param model  检索条件
 *  @param callback  数组
 */
-(void)getEmptyVehicleListWithFilterModel:(EmptyCarFilterModel *)model callBack:(void(^)(NSArray *arr,BOOL isLastPage))callback;

/**
 *  查询空车详情
 *
 *  @param model   查询空车
 *  @param callback 空车详情
 */
-(void)getVehicleDetail:(EmptyCarModel *)model callBack:(void(^)(EmptyCarModel * emptyCarModel))callback;

/**
 *  空车下单
 *
 *  @param model   下单数据
 *  @param callback 下单状态
 */
-(void)submitVehicleOrder:(EmptyOrderModel *)model callBack:(void(^)(NSString *orderCode))callback;

/**
 *  查询车类型列表
 *
 *  @param method   查询火车或车辆
                   "getVehicleTypeList";获取公路车辆类型列表
                   "getTrainTypeList";获取铁路班列列表
 *  @param callback  数组
 */
-(void)getEmptyCarListMethod:(NSString *)method callBack:(void(^)(NSArray *arr))callback;

@end
