//
//  EmptyCarFilterModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "CityModel.h"
#import "EmptyCarModel.h"
#import "CarOrShipTypeModel.h"

@interface EmptyCarFilterModel : BaseModel

@property (nonatomic, strong)CityModel * startCity;
@property (nonatomic, strong)CityModel * endCity;
@property (nonatomic, assign)TransportTypeEnum transportType;
@property (nonatomic, strong)CarOrShipTypeModel * carOrShipType;

@property (nonatomic, strong)NSDate * startTime;

@property (nonatomic, assign)BOOL isCertification;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int pagesize;
@end
