//
//  ContainerOrderInfo.h
//  MallClient
//
//  Created by lxy on 2017/3/24.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "ContainerModel.h"
#import "StationModel.h"

@interface ContainerOrderInfo : BaseModel

@property (nonatomic, strong) ContainerModel *containerModel;//箱子对象
@property (nonatomic, strong) NSString       *sentType;//配送方式
@property (nonatomic, assign) int            num;//数量
@property (nonatomic, strong) NSString       *startDate;
@property (nonatomic, strong) NSString       *endDate;
@property (nonatomic, strong) NSString       *strStartDate;//时间戳
@property (nonatomic, strong) NSString       *strEndDate;//时间戳

@property (nonatomic, assign) int            day;

@property (nonatomic, strong) NSString       *name;
@property (nonatomic, strong) NSString       *phone;
@property (nonatomic, strong) NSString       *startFullName;
@property (nonatomic, strong) NSString       *endFullName;
@property (nonatomic, strong) StationModel   *startStation;
@property (nonatomic, strong) StationModel   *endStation;
@property (nonatomic, assign) float          totalPrice;

/**
 *    租售   CONTAINER_RENTSALE_TYPE_RENT
 销售   CONTAINER_RENTSALE_TYPE_SALE
 */
@property (nonatomic, strong) NSString *type;


@end
