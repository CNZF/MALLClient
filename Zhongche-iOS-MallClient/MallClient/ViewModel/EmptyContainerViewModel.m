//
//  EmptyContainerViewModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyContainerViewModel.h"

@implementation EmptyContainerViewModel


/**
 *  查询空箱列表
 *
 *  @param retrieveModel  检索条件
 *  @param callback    订单数组
 */

-(void)getEmptyContainerArrWith:(FilterModel *)retrieveModel callback:(void(^)(NSArray *arr,BOOL isLastPage))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setNoNullObject:[NSNumber numberWithInt:retrieveModel.currentPage] forKey:@"currentPage"];
    [params setNoNullObject:[NSNumber numberWithInt:retrieveModel.pageSize] forKey:@"pageSize"];
    if([retrieveModel.saleType isEqualToString:@"租"]) {
        [params setNoNullObject:@"CONTAINER_RENTSALE_TYPE_RENT" forKey:@"saleType"];

    } else if([retrieveModel.saleType isEqualToString:@"售"]){
        [params setNoNullObject:@"CONTAINER_RENTSALE_TYPE_SALE" forKey:@"saleType"];
    }
    [params setNoNullObject:[NSNumber numberWithInt:retrieveModel.useNumberSort] forKey:@"useNumberSort"];
    [params setNoNullObject:[NSNumber numberWithInt:retrieveModel.isAuthenticated] forKey:@"isAuthenticated"];
    if (retrieveModel.city.code.length >= 3) {
        [params setNoNullObject:[retrieveModel.city.code substringWithRange:NSMakeRange(0,3)] forKey:@"location"];
    }
    [params setNoNullObject:retrieveModel.container.ID forKey:@"containerTypeId"];
//        NEW_CONTAINER( "新造箱",1), INTACT_CONTAINER( "完好在用箱",2), SLIGHTLY_INCLUDED_CONTAINER( "轻微瑕疵在用箱",3), DAMAGE_CONTAINER("破损在用箱",4)
    if (retrieveModel.containerCondition < new0) {
        [params setNoNullObject:[NSNumber numberWithInt:retrieveModel.containerCondition + 1] forKey:@"containerStatus"];
    }
    
    NSDateFormatter * formatter;
    formatter = [ NSDateFormatter new];
    
    //起始时间为当天第一秒
    if (retrieveModel.startTime) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * startTime = [NSString stringWithFormat:@"%@ 00:00:00",[formatter stringFromDate:retrieveModel.startTime]];
        [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
        double date = [[formatter dateFromString:startTime] timeIntervalSince1970] * 1000.f;
        [params setNoNullObject:[NSString stringWithFormat:@"%.0f",date] forKey:@"startDate"];

    }
    //终止时间为当天最后一秒
    if (retrieveModel.endTime) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * startTime = [NSString stringWithFormat:@"%@ 23:59:59",[formatter stringFromDate:retrieveModel.endTime]];
        [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
        double date = [[formatter dateFromString:startTime] timeIntervalSince1970] * 1000.f;
        [params setNoNullObject:[NSString stringWithFormat:@"%.0f",date] forKey:@"endDate"];
    }
    
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getEmptyContainerList" forKey:@"method"];
    [self.dicHead setValue:@"emptyContainer" forKey:@"action"];
    
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
                NSArray *arr = dicData[@"emptyContainerList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    ContainerModel *model = [ContainerModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                callback(arrModel,YES);
//                if ([dicData[@"containerType"][@"size"] intValue] >retrieveModel.currentPage) {
//                    callback(arrModel,NO);
//                }
//                else
//                {
//                    callback(arrModel,YES);
//                }
            }else {
                callback(nil,NO);
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        else
        {
            callback(nil,NO);
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        callback(nil,NO);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];

}


/**
 *  查询箱子详情
 *
 *  @param goodsId  箱子ID
 *  @param callback 箱子对象
 */

- (void)selectEmptyContainerWithID:(NSString *)goodsId callback:(void(^)(ContainerModel *info))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:goodsId forKey:@"id"];
    [self.dicHead setValue:@"getContainerDetail" forKey:@"method"];
    [self.dicHead setValue:@"emptyContainer" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate = [self dictionaryWithJsonString:stInfo];
                NSDictionary *dicInfo = dicDate[@"emptyContainerDetail"];
                ContainerModel *model = [ContainerModel yy_modelWithJSON:dicInfo];
                callback(model);

            }else{

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
 *  查询网点
 *
 *  @param code     城市code
 *  @param callback 网点数组
 */

-(void)selectStationWithCode:(NSString *)code callback:(void(^)(NSArray *arr))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:code forKey:@"regionCode"];
    [self.dicHead setValue:@"getEntrepotList" forKey:@"method"];
    [self.dicHead setValue:@"entrepot" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:stInfo];
                NSArray *arr = dicDate[@"entrepotList"];

                 NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {

                    StationModel *model = [StationModel yy_modelWithJSON:dic];

                    [arrModel addObject:model];

                    
                }

                callback(arrModel);


            }else{

                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

//        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}



/**
 *  下单
 *
 *  @param orderInfo 箱子订单对象
 *  @param callback  返回状态
 */

- (void)submitOrderWithOrderInfo:(ContainerOrderInfo *)orderInfo callback:(void(^)(NSString *orderNo))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:orderInfo.containerModel.ID forKey:@"id"];
    [params setValue:[NSString stringWithFormat:@"%.2f",orderInfo.totalPrice] forKey:@"payable"];
//    [params setValue:orderInfo.containerModel.transportPrice forKey:@"transportPrice"];
//    if(!orderInfo.containerModel.transportPrice||[orderInfo.containerModel.transportPrice isEqualToString:@""]){
        [params setValue:@"0" forKey:@"transportPrice"];

//    }
    [params setValue:orderInfo.containerModel.deposit forKey:@"deposit"];
    if(!orderInfo.containerModel.deposit||[orderInfo.containerModel.deposit isEqualToString:@""]){
        [params setValue:@"0" forKey:@"deposit"];

    }

    [params setValue:orderInfo.name forKey:@"contactsName"];
    [params setValue:orderInfo.phone forKey:@"contactsPhone"];
    [params setValue:[NSString stringWithFormat:@"%@ %@",orderInfo.endFullName,orderInfo.endStation.name] forKey:@"givebackAddress"];
    [params setValue:[NSString stringWithFormat:@"%i",orderInfo.num] forKey:@"useNumber"];
    [params setValue:@"0" forKey:@"rentPrice"];
    [params setValue:@"0" forKey:@"salePrice"];
    if (![orderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {


        [params setValue:[NSString stringWithFormat:@"%@000",orderInfo.strStartDate] forKey:@"startDate"];
        [params setValue:[NSString stringWithFormat:@"%@000",orderInfo.strEndDate] forKey:@"endDate"];

        [params setValue:orderInfo.containerModel.unitPrice forKey:@"rentPrice"];
        if(!orderInfo.containerModel.unitPrice||[orderInfo.containerModel.unitPrice isEqualToString:@""]){
            [params setValue:@"0" forKey:@"rentPrice"];
            
        }
    }else{

        [params setValue:orderInfo.containerModel.unitPrice forKey:@"salePrice"];
        if(!orderInfo.containerModel.unitPrice||[orderInfo.containerModel.unitPrice isEqualToString:@""]){
            [params setValue:@"0" forKey:@"salePrice"];

        }
    }

    [params setValue:orderInfo.containerModel.offsiteReturnBoxPrice forKey:@"unReturnContainerCost"];
    [params setValue:orderInfo.type forKey:@"saleTypeCode"];
    [params setValue:[NSString stringWithFormat:@"%i",orderInfo.day]forKey:@"useDay"];
    [params setValue:[NSString stringWithFormat:@"%@ %@",orderInfo.startFullName,orderInfo.startStation.name] forKey:@"receiveAddress"];


    [self.dicHead setValue:@"submitContainerOrder" forKey:@"method"];
    [self.dicHead setValue:@"emptyContainer" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:stInfo];

                callback(dicDate[@"orderCode"]);

            }else{

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

@end
