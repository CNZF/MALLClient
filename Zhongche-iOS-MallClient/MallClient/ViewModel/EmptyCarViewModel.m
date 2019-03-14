//
//  EmptyCarViewModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarViewModel.h"
#import "UserInfoModel.h"

@implementation EmptyCarViewModel

/**
 *  推荐空车列表
 *
 *  @param callback  数组
 */

-(void)getRecommendListCallBack:(void(^)(NSArray *arr))callback{
    [SVProgressHUD showWithStatus:LOADING];
    [self.dicHead setValue:@"getRecommendList" forKey:@"method"];
    [self.dicHead setValue:@"emptyVehicle" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSDictionary *dict = dicData[@"emptyVehicleList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                EmptyCarModel *model;
                @try {
                    for (NSDictionary * dic in dict[@"vehicle"]) {
                        model = [EmptyCarModel yy_modelWithJSON:dic];
                        model.transportTypeEnum = landTransportation;
                        [arrModel addObject:model];
                    }
                    for (NSDictionary * dic in dict[@"railway"]) {
                        model = [EmptyCarModel yy_modelWithJSON:dic];
                        model.transportTypeEnum = trainsTransportation;
                        [arrModel addObject:model];
                    }
                    for (NSDictionary * dic in dict[@"ship"]) {
                        model = [EmptyCarModel yy_modelWithJSON:dic];
                        model.transportTypeEnum = shipTransportation;
                        [arrModel addObject:model];
                    }
                } @catch (NSException *exception) {

                } @finally {

                    callback(arrModel);

                }
            }else {
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

/**
 *  查询空车列表
 *
 *  @param model  检索条件
 *  @param callback  数组
 */
-(void)getEmptyVehicleListWithFilterModel:(EmptyCarFilterModel *)model callBack:(void(^)(NSArray *arr,BOOL isLastPage))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithBool:model.isCertification] forKey:@"authenticate"];
    [params setObject:[NSString stringWithFormat:@"%.0f",[model.startTime timeIntervalSince1970] * 1000.f] forKey:@"deliverDate"];

    [params setObject:[NSNumber numberWithInt:model.currentPage + 1] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:model.pagesize] forKey:@"pageSize"];
   
    //code取前4位
    if (model.startCity.code.length >= 4) {
        [params setObject:[model.startCity.code substringWithRange:NSMakeRange(0, 4)] forKey:@"startRegionCode"];

    }
    if (model.endCity.code.length >= 4) {
        [params setObject:[model.endCity.code substringWithRange:NSMakeRange(0, 4)] forKey:@"endRegionCode"];
    }
    switch (model.transportType) {
        case landTransportation:
            [params setObject:@"ROAD" forKey:@"transportType"];
            break;
        case trainsTransportation:
            [params setObject:@"RAIL" forKey:@"transportType"];
            break;
        case shipTransportation:
            [params setObject:@"SEA" forKey:@"transportType"];
            break;
    }
    [params setNoNullObject:model.carOrShipType.code forKey:@"vehicleTypeCode"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getEmptyVehicleList" forKey:@"method"];
    [self.dicHead setValue:@"emptyVehicle" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arr = dicData[@"emptyVehicleList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    EmptyCarModel *model = [EmptyCarModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                
                if ([result[@"currentPage"] intValue] < [result[@"size"] intValue]) {
                    callback(arrModel,NO);

                }else {
                    callback(arrModel,YES);

                }

            }else {
                callback(nil,NO);

                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        callback(nil,NO);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}


/**
 *  查询空车详情
 *
 *  @param model   查询空车
 *  @param callback 空车详情
 */
-(void)getVehicleDetail:(EmptyCarModel *)model callBack:(void(^)(EmptyCarModel * emptyCarModel))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setNoNullObject:model.ID forKey:@"id"];
    switch (model.transportTypeEnum) {
        case landTransportation:
            [params setObject:@"ROAD" forKey:@"type"];
            break;
        case trainsTransportation:
            [params setObject:@"RAIL" forKey:@"type"];
            break;
        case shipTransportation:
            [params setObject:@"SEA" forKey:@"type"];
            break;
    }
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getVehicleDetail" forKey:@"method"];
    [self.dicHead setValue:@"emptyVehicle" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    TransportTypeEnum transportType = model.transportTypeEnum;
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                EmptyCarModel *model;
                NSString *urls;
                NSMutableArray *arrImgs = [NSMutableArray array];
                switch (transportType) {
                    case landTransportation:
                        model = [EmptyCarModel yy_modelWithJSON:dicData[@"emptyContainerDetail"][@"vehicle"]];
                        model.arrRouts = dicData[@"emptyContainerDetail"][@"line"];
                        urls = dicData[@"emptyContainerDetail"][@"vehicle"][@"photoUrl"];
                        for (NSString *url in [urls componentsSeparatedByString:@"☼"]) {

                            [arrImgs addObject:[NSString stringWithFormat:@"%@%@",BASEIMGURL,url]];
                        }
                        model.imgArr = arrImgs;
                        break;
                    case trainsTransportation:
                        model = [EmptyCarModel yy_modelWithJSON:dicData[@"emptyContainerDetail"]];
                         urls = dicData[@"emptyContainerDetail"][@"railway_photo_url"];
                        for (NSString *url in [urls componentsSeparatedByString:@"☼"]) {

                            [arrImgs addObject:[NSString stringWithFormat:@"%@%@",BASEIMGURL,url]];
                        }
                        model.imgArr = arrImgs;
                        break;
                    case shipTransportation:
                        model = [EmptyCarModel yy_modelWithJSON:dicData[@"emptyContainerDetail"]];
                        urls = dicData[@"emptyContainerDetail"][@"ship_photo_url"];
                        for (NSString *url in [urls componentsSeparatedByString:@"☼"]) {

                            [arrImgs addObject:[NSString stringWithFormat:@"%@%@",BASEIMGURL,url]];
                        }
                        model.imgArr = arrImgs;
                        break;
                }
                model.transportTypeEnum = transportType;
                callback(model);
                
            }else {
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];

}



/**
 *  空车下单
 *
 *  @param model   下单数据
 *  @param callback 下单状态
 */
-(void)submitVehicleOrder:(EmptyOrderModel *)model callBack:(void(^)(NSString *orderCode))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    //公共


    UserInfoModel *us = USER_INFO;
    [params setNoNullObject:us.iden forKey:@"userId"];
    [params setNoNullObject:model.goodsInfo.name forKey:@"goodsName"];//货品名称
    [params setNoNullObject:model.startAddress forKey:@"startAddress"];//起运地
    [params setNoNullObject:model.endAddress forKey:@"endAddress"];//抵运地
    [params setNoNullObject:[NSString stringWithFormat:@"%.0f",[model.time timeIntervalSince1970] * 1000.f] forKey:@"startDate"];//起运日期
    [params setNoNullObject:model.contactName forKey:@"name"];//姓名
    [params setNoNullObject:model.contactPhone forKey:@"phone"];//手机号
    


    float price;
    switch (model.emptyCarInfo.transportTypeEnum) {
        case landTransportation:
            [self.dicHead setValue:@"submitVehicleOrder" forKey:@"method"];
            [params setObject:@"ROAD" forKey:@"type"];
            [params setNoNullObject:model.emptyCarInfo.vehicleId forKey:@"vehicleId"];//汽车ID
            [params setNoNullObject:model.emptyCarInfo.currentLine.ID forKey:@"lineId"];//线路ID
            [params setNoNullObject:model.emptyCarInfo.currentLine.price forKey:@"payablePrice"];//订单金额
            break;
        case trainsTransportation:
            [self.dicHead setValue:@"submitRailwayOrder" forKey:@"method"];
            [params setObject:@"RAIL" forKey:@"type"];
            [params setNoNullObject:[NSString stringWithFormat:@"%i",model.num] forKey:@"number"];//购买TEU数量
            [params setNoNullObject:model.emptyCarInfo.railwayId forKey:@"railwayId"];//火车ID
            price = [model.emptyCarInfo.price longLongValue] * model.num;
            [params setNoNullObject:[NSString stringWithFormat:@"%.2f",price] forKey:@"payablePrice"];//订单金额

            [params setNoNullObject:model.emptyCarInfo.trainStartStation forKey:@"startAddress"];//火车ID

            [params setNoNullObject:model.emptyCarInfo.trainEndStation  forKey:@"endAddress"];//火车ID
            break;
        case shipTransportation:
            [self.dicHead setValue:@"submitShipOrder" forKey:@"method"];
            [params setObject:@"SEA" forKey:@"type"];
            [params setNoNullObject:[NSString stringWithFormat:@"%i",model.num] forKey:@"number"];//购买TEU数量
            [params setNoNullObject:model.emptyCarInfo.shipId forKey:@"shipId"];//轮船ID
            price = [model.emptyCarInfo.price longLongValue] * model.num;
            [params setNoNullObject:[NSString stringWithFormat:@"%.2f",price] forKey:@"payablePrice"];//订单金额

            [params setNoNullObject:model.emptyCarInfo.shipStartStation forKey:@"startAddress"];//火车ID

            [params setNoNullObject:model.emptyCarInfo.shipEndStation  forKey:@"endAddress"];//火车ID
            break;
    }


    [self.dicRequest setObject:params forKey:@"params"];
    

    [self.dicHead setValue:@"emptyVehicle" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                callback(dicData[@"orderCode"]);
                
            }else {
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
}

/**
 *  查询车类型列表
 *
 *  @param method   查询火车或车辆
 *  @param callback  数组
 */
-(void)getEmptyCarListMethod:(NSString *)method callBack:(void(^)(NSArray *arr))callback{
    
    [SVProgressHUD showWithStatus:LOADING];
    [self.dicHead setNoNullObject:method forKey:@"method"];
    [self.dicHead setValue:@"emptyVehicle" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arr = dicData[@"vehicleTypeList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                [arrModel addObject:[CarOrShipTypeModel
                                     yy_modelWithJSON:@{@"vehicleTypeName":@"全部"}]];
                for (NSDictionary *dic in arr) {
                    CarOrShipTypeModel *model = [CarOrShipTypeModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                callback(arrModel);
            }else {
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];

}

@end
