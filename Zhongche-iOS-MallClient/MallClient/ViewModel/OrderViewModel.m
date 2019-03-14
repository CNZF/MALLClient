//
//  OrderViewModel.m
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderViewModel.h"

@implementation OrderViewModel


//=====================我要运力======================//

/**
 *  查询订单列表
 *
 *  @param type        类型
 *  @param currentPage 当前页
 *  @param pageSize    每页大小
 *  @param callback    订单数组
 */

- (void)getSaleOfCapacityOrderWithType:(OrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback {

//    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSLog(@"params :%@",params);
    
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getOrderList" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
//        NSString * str = [self convertToJSONData:responseData];调试用，当服务器没有数据的时候，会造成奔溃
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arr = dicData[@"containerType"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    OrderModelForCapacity *model = [OrderModelForCapacity yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                int dada  = [result[@"size"] intValue];
                NSLog(@"resultdada :%d",dada);
                if ([result[@"size"] intValue] < currentPage) {
                    callback(arrModel,YES);
                }
                else
                {
                    callback(arrModel,NO);
                }
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
 *  查询订单详情（我要运力）
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getSaleOfCapacityOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(OrderModelForCapacity *model))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"orderId"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getOrderDetail" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    
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
                 NSLog(@"result %@",dicData);
                OrderModelForCapacity *model = [OrderModelForCapacity yy_modelWithJSON:dicData[@"orderDetial"]];
                model.invoice_0 = [InvoiceModel yy_modelWithJSON:dicData[@"orderDetial"]];
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
 *  取消订单
 *
 *  @param orderId  订单ID
 *  @param callback 取消状态
 */

- (void)cancelSaleOfCapacityOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(NSString *str))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"orderId"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"cancelOrder" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(@"1");
                
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
 *  提交订单(我要运力)
 *
 *  @param info     订单类
 *  @param callback 订单号
 */

- (void)SubmiteSaleOfCapacityOrderWthCapacityInfo:(CapacityEntryModel *)info callback:(void(^)(NSString *orderNo))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setNoNullObject:info.priceInfo.orderTotalMoney forKey:@"totalPrice"];
    [params setNoNullObject:info.transportationModel.ID forKey:@"transportTicketId"];
    [params setNoNullObject:info.priceInfo.ticketTotalPrice forKey:@"transportTicketPrice"];
    NSString *stBoxId = info.box.ID?info.box.ID:@"1";
    [params setNoNullObject:stBoxId forKey:@"containerId"];
//    if (!info.box.ID) {
//        [params setNoNullObject:@"1" forKey:@"containerId"];
//    }
    [params setNoNullObject:info.boxNum forKey:@"containerNumber"];
    [params setNoNullObject:info.businessTypeCode forKey:@"businessTypeCode"];
    [params setNoNullObject:info.deliveryTypeCode forKey:@"deliveryTypeCode"];
    [params setNoNullObject:info.ticketType forKey:@"ticketType"];
    [params setNoNullObject:@"1" forKey:@"sendUserId"];
    [params setNoNullObject:@"2" forKey:@"fetchUserId"];
    NSString *stDate = info.carryGoodsTime;
    NSArray *arrSt = [stDate componentsSeparatedByString:@"-"];

    [params setNoNullObject:arrSt[0] forKey:@"pickupStartTime"];
    [params setNoNullObject:arrSt[1] forKey:@"pickupEndTime"];
    [params setNoNullObject:info.stLatestShipmentsTime forKey:@"estimateEndDepartureTime"];
    [params setNoNullObject:info.stStartTime forKey:@"estimateStartDepartureTime"];
    [params setNoNullObject:info.stStartTime forKey:@"estimateEndDepartureTime"];
    //EstimateEndDepartureTime
    [params setNoNullObject:info.stStartTime forKey:@"estimateDepartureTime"];
    [params setNoNullObject:info.stStartTime forKey:@"expectTime"];
    [params setNoNullObject:info.priceInfo.ticketTotalPrice forKey:@"transportPrice"];
    [params setNoNullObject:info.priceInfo.startAdditionPrice forKey:@"pickupPrice"];
    [params setNoNullObject:info.priceInfo.endAdditionPrice forKey:@"deliveryPrice"];
    if([info.payStyle isEqualToString:@"预付款"]){

        [params setNoNullObject:@"PAY_TYPE_ADVANCE" forKey:@"payTypeCode"];
    }else {

        [params setNoNullObject:@"PAY_TYPE_ALTER" forKey:@"payTypeCode"];
        //PAY_TYPE_ALTER
    }

    [params setNoNullObject:info.totalWeight forKey:@"weight"];
    [params setNoNullObject:info.volume forKey:@"volume"];


    if(info.provide){
        [params setObject:info.provide forKey:@"provide"];
    }else {
        [params setObject:@0 forKey:@"provide"];
    }

    if (info.wrapper) {
        [params setObject:info.wrapper forKey:@"warrper"];
    }else{

        [params setObject:@0 forKey:@"warrper"];
    }

    [params setNoNullObject:info.contactInfo.startID forKey:@"startAddressId"];
    [params setNoNullObject:info.contactInfo.endID forKey:@"endAddressId"];
    [params setNoNullObject:info.priceInfo.insuranceMoney forKey:@"insuredPrice"];
    [params setNoNullObject:@"0" forKey:@"isBuyInsurance"];
    //    [params setObject:info.goodsInfo.code forKey:@"goodsCode"];
    [params setNoNullObject:info.goodsInfo.ID forKey:@"goodsId"];

    //26
    NSDictionary *dicInvoice = [NSDictionary dictionary];
    [params setNoNullObject:dicInvoice forKey:@"orderInvoiceBean"];
    [params setNoNullObject:info.invoice.ID forKey:@"invoiceId"];
    if (info.invoice.ID) {
        
        [params setNoNullObject:@1 forKey:@"isHaveInvoice"];

    }else {

        [params setNoNullObject:@0 forKey:@"isHaveInvoice"];

    }
    [params setNoNullObject:info.remark forKey:@"remark"];

    //========此处脏代码，对不住了兄弟

    //[params setNoNullObject:@"奔驰" forKey:@"vehicleType"];
    [params setNoNullObject:info.biggestWeight forKey:@"unitMaxWeight"];
    [params setNoNullObject:info.longCm forKey:@"unitMaxLength"];
    [params setNoNullObject:info.wideCm forKey:@"unitMaxWidth"];
    [params setNoNullObject:info.highCm forKey:@"unitMaxHigh"];
    [params setNoNullObject:info.boxNum forKey:@"vehicleNum"];
    [params setNoNullObject:info.boxNum forKey:@"getContainerNumber"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"submitCapacityOrder" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];

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
                NSString *stOrder = dicData[@"orderCode"];
                callback(stOrder);


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
 *  查询订单价格
 *
 *  @param info     订单
 *  @param callback 价格对象
 */

- (void) getOrderPriceWithCapacityInfo:(CapacityEntryModel *)info callback:(void(^)(PriceInfo *priceInfo))callback{

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
 
    [params setObject:info.goodsInfo.ID forKey:@"goodsId"];
    [params setObject:info.transportationModel.ID forKey:@"ticketId"];
    [params setObject:info.transportationModel.ticketTotal forKey:@"ticketTotalPrice"];
    [params setObject:info.deliveryTypeCode forKey:@"deliveryTypeCode"];
    [params setObject:@0 forKey:@"isBuyInsurance"];
    [params setObject:@0 forKey:@"supportMoney"];
    [params setObject:info.businessTypeCode forKey:@"bizType"];
    [params setNoNullObject:info.weight forKey:@"weight"];
    [params setNoNullObject:info.volume forKey:@"volume"];
    [params setNoNullObject:info.transportationModel.lineFixPrice forKey:@"lineFixPrice"];
    [params setNoNullObject:info.transportationModel.lineBasePrice forKey:@"lineBasePrice"];
    [params setNoNullObject:info.transportationModel.lineType forKey:@"lineType"];
    [params setNoNullObject:info.boxNum forKey:@"containerNumber"];
    [params setNoNullObject:info.transportationModel.transportType forKey:@"transportType"];

    if (info.weight) {
        [params setNoNullObject:info.weight forKey:@"containerNumber"];
    }
    [params setNoNullObject:info.box.ID forKey:@"containterId"];
    //ticketType
    [params setNoNullObject:info.ticketType forKey:@"ticketType"];

    if (![info.contactInfo.startID isEqualToString:@"-1"]) {

        [params setNoNullObject:info.contactInfo.startID forKey:@"sendUserId"];

    }

    if (![info.contactInfo.endID isEqualToString:@"-1"]) {

        [params setNoNullObject:info.contactInfo.endID forKey:@"fetchUserId"];
    }


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getOrderTotalPrice" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];

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
                NSDictionary *dicOrderTotalPrice = dicData[@"orderTotalPrice"];
                PriceInfo *info = [PriceInfo yy_modelWithDictionary:dicOrderTotalPrice];
                info.additionPrice = [NSString stringWithFormat:@"%.2f",[info.startAdditionPrice floatValue] + [info.endAdditionPrice floatValue]];
                callback(info);

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



//=====================空箱之家======================//

/**
 *  获取空箱之家订单列表
 *
 *  @param type        类型
 *  @param currentPage 当前页
 *  @param pageSize    分页每页尺寸
 *  @param callback    订单数组
 */

- (void)getEmptyContainerOrderWithType:(EmptyContainerOrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    if (type != ALL) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    }
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"]; 
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getContainerOrderList" forKey:@"method"];
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
                NSArray *arr = dicData[@"containerOrderList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    

                    OrderModelForEmptyContainer *model = [OrderModelForEmptyContainer yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                if ([result[@"size"] intValue] > currentPage) {
                    callback(arrModel,NO);
                }
                else
                {
                    callback(arrModel,YES);
                }
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
 *  查询订单详情（空箱之家）
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getEmptyContainerOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(OrderModelForEmptyContainer *model))callback {
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"containerOrderId"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getContainerOrderDetail" forKey:@"method"];
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
                OrderModelForEmptyContainer *model = [OrderModelForEmptyContainer yy_modelWithJSON:dicData[@"containerOrderDetail"]];
                model.arrOrderContainerCode = dicData[@"containerOrderDetail"][@"orderContainerCode"];

                int day = (int)([model.endDate floatValue]/60/24/60/1000 - [model.startDate floatValue]/60/24/60/1000) + 1;
                model.rentdays = [NSString stringWithFormat:@"%i",day];

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
 *  订单操作
 *
 *  @param Id   订单ID
 *  @param type 操作方式
 */

-(void)emptyContainerOrderOperateWithOrderId:(NSString *)Id WithType:(EmptyContainerOrderStatus)type callback:(void(^)(NSString *str))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
//    [params setObject:[NSNumber numberWithInt:type] forKey:@"containerOrderStatus"];
    [params setValue:Id forKey:@"orderId"];
    [self.dicHead setValue:@"cancelOrder" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(status);

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


//=====================空车之爱======================//

/**
 *  获取空车之爱订单列表
 *
 *  @param type        类型 VEHICLE公路  RAILWAY铁路  SHIP轮船
 *  @param currentPage 当前页
 *  @param pageSize    分页每页尺寸
 *  @param callback    订单数组
 */

- (void)getEmptyCarOrderWithType:(EmptyCarOrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    if (type != aLL) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"orderStatus"];
    }
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getVehicleOrderList" forKey:@"method"];
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
                NSArray *arr = dicData[@"vehicleOrderList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    OrderModelForEmptyCar *model = [OrderModelForEmptyCar yy_modelWithJSON:dic];

                    NSString *transportType = model.transportType;
                    if ([transportType isEqualToString:@"ROAD"]) {
                        model.transportTypeEnum = landTransportation;
                        model.transportType = @"公路";
                        if (dic[@"companyName"]) {
                            model.details = dic[@"companyName"];
                        }else {

                            model.details = dic[@"loginName"];
                        }
                    } else if ([transportType isEqualToString:@"RAIL"]) {
                        model.transportTypeEnum = trainsTransportation;
                        model.transportType = @"铁路";
                        model.details = dic[@"regularCode"];

                    }else if ([transportType isEqualToString:@"SEA"]) {
                        model.transportTypeEnum = shipTransportation;
                        model.transportType = @"海运";
                        model.details = dic[@"regularCode"];
                        
                    }
                    [arrModel addObject:model];
                }
                if ([result[@"size"] intValue] > currentPage) {
                    callback(arrModel,NO);
                }
                else
                {
                    callback(arrModel,YES);
                }
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
 *  查询订单详情（空车之爱）
 *
 *  @param type        类型 VEHICLE公路  RAILWAY铁路  SHIP轮船
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getEmptyCarOrderDetailsWithOrderId:(NSString *)orderId WithType:(TransportTypeEnum)type callback:(void(^)(OrderModelForEmptyCar *model))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"orderId"];
    switch (type) {
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

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getEmptyVehicleOrderDetail" forKey:@"method"];
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
                OrderModelForEmptyCar *model = [OrderModelForEmptyCar yy_modelWithJSON:dicData[@"orderDetail"]];
                model.matchCodeList = dicData[@"matchCodeList"];


                //如果有公司名，卖家是公司名
                if (dicData[@"orderDetail"][@"companyName"]) {
                    model.seller = dicData[@"orderDetail"][@"companyName"];
                }

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
 *  订单操作
 *
 *  @param Id   订单ID
 *  @param type 操作方式
  *  @param transportType        类型 ROAD公路  RAIL铁路  SEA轮船
 */

-(void)emptyCarOrderOperateWithOrderId:(NSString *)Id WithType:(EmptyCarOrderStatus)type WithTransportType:(TransportTypeEnum)transportType Withcallback:(void(^)(NSString *str))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSNumber numberWithInt:type] forKey:@"status"];
    switch (transportType) {
        case landTransportation:
            [params setValue:@"ROAD" forKey:@"transportType"];
            
            break;
        case trainsTransportation:
            [params setValue:@"RAIL" forKey:@"transportType"];
            
            break;
        case shipTransportation:
            [params setValue:@"SEA" forKey:@"transportType"];
            break;
    }
    [params setValue:Id forKey:@"orderId"];
    [self.dicHead setValue:@"operateEmptyVehicleOrder" forKey:@"method"];
    [self.dicHead setValue:@"emptyVehicle" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(status);

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


//=====================煤炭=====================//

- (void)getCoalOrderWithType:(CoalOrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    if ([[NSNumber numberWithInt:type]intValue]!=100) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    }

    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getOrderList" forKey:@"method"];
    [self.dicHead setValue:@"goodsOrder" forKey:@"action"];

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
                NSArray *arr = dicData[@"goodsOrderList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    OrderModelForCapacity *model = [OrderModelForCapacity yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                if ([result[@"size"] intValue] > currentPage) {
                    callback(arrModel,NO);
                }
                else
                {
                    callback(arrModel,YES);
                }
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
 *  查询订单详情（我要运力）
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getCoalOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(OrderModelForCapacity *model))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"detailId"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getOrderDetail" forKey:@"method"];
    [self.dicHead setValue:@"goodsOrder" forKey:@"action"];

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
                OrderModelForCapacity *model = [OrderModelForCapacity yy_modelWithJSON:dicData[@"goodsOrderDetail"]];
               
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
 *  取消订单
 *
 *  @param orderId  订单ID
 */

-(void)cancleCoalOrderWithOrderId:(NSString *)orderId Withcallback:(void(^)(NSString *str))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:orderId forKey:@"orderId"];
    [self.dicHead setValue:@"cancleOrder" forKey:@"method"];
    [self.dicHead setValue:@"goodsOrder" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];

            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(status);
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
*  查询发货批次（我要运力）
*
*  @param orderId  订单ID
*  @param callback 订单详情
*/

- (void)getSendOrderDetailsWithOrderId:(NSString *)orderId Type:(NSString *)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSMutableArray *arrayModel, BOOL isLastPage))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"orderId"];
    [params setObject:type forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSLog(@"params %@",params);
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getOrderBatch" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        NSString * str = [self convertToJSONData:responseData];
        NSDictionary * ddd = [self dictionaryWithJsonString:str];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                
                NSString *data = result[@"data"];
                
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSLog(@"result %@",dicData);
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in dicData[@"orderBatchList"]) {
                    SendOrderModel *model = [SendOrderModel yy_modelWithJSON:dic];
                    model.type = type;
                    [arrModel addObject:model];
                }
                if ([result[@"currentPage"] intValue] < currentPage) {
                    callback(arrModel,YES);
                }
                else
                {
                    callback(arrModel,NO);
                }
               
                
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


- (void)getPayOrderDetailsWithOrderId:(NSString *)orderId Type:(NSString *)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSMutableArray *arrayModel,BOOL isLastPage))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:orderId forKey:@"orderId"];
    [params setObject:type forKey:@"type"];
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSLog(@"params %@",params);
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getOrderPaymentFlowList" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    
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
                NSLog(@"result %@",dicData);
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in dicData[@"orderPaymentFlowList"]) {
                    OrderPayModel *model = [OrderPayModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                if ([result[@"currentPage"] intValue] < currentPage) {
                    callback(arrModel,YES);
                }
                else
                {
                    callback(arrModel,NO);
                }
                
                
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

- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

-(void)BoxNumberWithBoxId:(NSString *)orderId Withcallback:(void(^)(NSArray * boxModelArray))callback
{
    [SVProgressHUD showWithStatus:LOADING];
//    NSMutableDictionary *params= [NSMutableDictionary dictionary];
//    [params setObject:orderId forKey:@"orderId"];
//
//
//    NSLog(@"params %@",params);
//    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getFixationContainerType" forKey:@"method"];
    [self.dicHead setValue:@"container" forKey:@"action"];
    
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
                NSLog(@"result %@",dicData);
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in dicData[@"containerTypeList"]) {
                    BoxModel *model = [BoxModel yy_modelWithJSON:dic];
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
