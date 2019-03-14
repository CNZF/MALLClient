//
//  TransportationModel.h
//  MallClient
//
//  Created by lxy on 2016/12/7.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface TransportationModel : BaseModel


/**
 *   {
 "departureTime": 1481040000000,
 "endRegionCode": "310100",
 "expectTime": 1440,
 "id": 12,
 "lineBasePrice": 1000.00,
 "lineFixPrice": 1200.00,
 "lineType": "LINE_TYPE_CONTAINER_20",
 "number": 1000,
 "price20": 1100.00,
 "price40": 1200.00,
 "startRegionCode": "110100",
 "status": 1,
 "surplusNumber": 1000,
 "ticketTotal": 2520,
 "useNumber": 0
 }
 */

@property (nonatomic, strong) NSString *expectTime;//分
@property (nonatomic, strong) NSString *departureTime;//起运时间
@property (nonatomic, strong) NSString *ticketTotal;//总价格
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *type;//运力票类型
@property (nonatomic, strong) NSString *lineBasePrice;//基础价格
@property (nonatomic, strong) NSString *lineFixPrice;//附加价格
@property (nonatomic, strong) NSString *lineType;//线路类型

//轻运力票

@property (nonatomic, strong) NSString *startStation;
@property (nonatomic, strong) NSString *endStation;

@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *endAddress;

@property (nonatomic, strong) NSString *ticketType;




@end
