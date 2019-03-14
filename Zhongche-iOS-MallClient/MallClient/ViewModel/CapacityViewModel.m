//
//  CapacityViewModel.m
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CapacityViewModel.h"
#import "TicketsDetailModel.h"

@implementation CapacityViewModel

/**
 *  集装箱运力搜索  todoby沙漠
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)containerSearchWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr,NSString * distance))callback{
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [params setNoNullObject:info.startPlace.code forKey:@"startCode"];
    [params setNoNullObject:info.endPlace.code forKey:@"endCode"];
    NSString *time = [NSString stringWithFormat:@"%ld000", (long)[info.shipmentsTime timeIntervalSince1970]];
    [params setNoNullObject:time forKey:@"departureTime"];
    [params setNoNullObject:info.businessTypeCode forKey:@"bizType"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"queryTickesGroupByExpectTime" forKey:@"method"];
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
                NSArray *arr = dicData[@"mergeTickets"];
                NSString * distance = dicData[@"distance"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    TransportationModel *model = [TransportationModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                callback(arrModel,distance);
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
 *  获取运力票价格日历  todoby沙漠
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)requestPriceCalendaWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr))callback{
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [params setNoNullObject:info.startPlace.code forKey:@"startCode"];
    [params setNoNullObject:info.endPlace.code forKey:@"endCode"];
    NSString *startTime = [NSString stringWithFormat:@"%ld000", (long)[info.startDate timeIntervalSince1970]];
    [params setNoNullObject:startTime forKey:@"departureStartTime"];
    NSString *endTime = [NSString stringWithFormat:@"%ld000", (long)[info.endDate timeIntervalSince1970]];
    [params setNoNullObject:endTime forKey:@"departureEndTime"];

    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"priceCalendar" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    [self.dicHead setValue:@"0.0.0.2" forKey:@"version"];
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
                NSArray *arr = dicData[@"priceList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    CapacityEntryModel *model = [CapacityEntryModel yy_modelWithJSON:dic];
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


/**
 *  需求申报<定制运力>接口  todoby沙漠
 *
 *  @param type   类型
 */
- (void)requestCustomTransportWithType:(kKNCustomFilterType)type  Model:(CapacityViewModel *)model callback:(void(^)(BOOL))callback{
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setNoNullObject:model.businessTypeCode forKey:@"businessTypeCode"];
    UserInfoModel *us = USER_INFO;
     [params setNoNullObject:model.noGoodName forKey:@"goodsAlias"];
    [params setNoNullObject:us.iden forKey:@"createUserId"];
    [params setNoNullObject:model.contacts forKey:@"contacts"];
    [params setNoNullObject:model.contactsPhone forKey:@"contactsPhone"];
    [params setNoNullObject:model.startRegionCode forKey:@"startRegionCode"];
    [params setNoNullObject:model.endRegionCode forKey:@"endRegionCode"];
    [params setNoNullObject:model.estimateDepartureTime forKey:@"estimateDepartureTime"];
    [params setNoNullObject:model.startContacts forKey:@"startContacts"];
    [params setNoNullObject:model.startPhone forKey:@"startPhone"];
    [params setNoNullObject:model.startAddress forKey:@"startAddress"];
    [params setNoNullObject:model.endContacts forKey:@"endContacts"];
    [params setNoNullObject:model.endPhone forKey:@"endPhone"];
    [params setNoNullObject:model.endAddress forKey:@"endAddress"];
    [params setNoNullObject:model.remark forKey:@"remark"];
    [params setNoNullObject:us.propertyType forKey:@"companyPropertyType"];
    [params setNoNullObject:us.companyStatus forKey:@"companyType"];
    //服务方式判断
    NSString *deliveryTypeCode;
    if (isNullStr(model.startContacts) && isNullStr(model.endContacts)) {
        deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
    }else{
        if (isNullStr(model.startContacts) && !isNullStr(model.endContacts)) {
            deliveryTypeCode = @"DELIVERY_TYPE_POINT_DOOR";
        }else if (!isNullStr(model.startContacts) && isNullStr(model.endContacts)){
            deliveryTypeCode = @"DELIVERY_TYPE_DOOR_POINT";
        }else{
            deliveryTypeCode = @"DELIVERY_TYPE_DOOR_DOOR";
        }
    }
    [params setNoNullObject:deliveryTypeCode forKey:@"deliveryTypeCode"];
    
    switch (type) {
        case kKNCustomFilterTypeCONTAINER:
        {
            [params setNoNullObject:model.goodsCode forKey:@"goodsCode"];
            [params setNoNullObject:@(model.containerId) forKey:@"containerId"];
            [params setNoNullObject:@(model.containerNumber) forKey:@"containerNumber"];

        }
            break;
        case kKNCustomFilterTypeBULK_STACK:
        {
           [params setNoNullObject:model.goodsCode forKey:@"goodsCode"];
           [params setNoNullObject:@(model.weight) forKey:@"weight"];
           [params setNoNullObject:@(model.m3) forKey:@"volume"];
        }
            break;
//        case kKNCustomFilterTypeVECHICLE:
//        {
//            [params setNoNullObject:model.vehicleType forKey:@"vehicleType"];
//            [params setNoNullObject:@(model.vehicleNum) forKey:@"vehicleNum"];
//        }
//            break;
        case kKNCustomFilterTypeLARGE_SIZE:
        {
            [params setNoNullObject:model.goodsCode forKey:@"goodsCode"];
            [params setNoNullObject:@(model.weight) forKey:@"weight"];
            [params setNoNullObject:@(model.wrapperNumber) forKey:@"wrapperNumber"];
            [params setNoNullObject:@(model.unitMaxWeight) forKey:@"unitMaxWeight"];
            [params setNoNullObject:@(model.unitMaxLength) forKey:@"unitMaxLength"];
            [params setNoNullObject:@(model.unitMaxWidth) forKey:@"unitMaxWidth"];
            [params setNoNullObject:@(model.unitMaxHigh) forKey:@"unitMaxHigh"];
        }
            break;
        case kKNCustomFilterTypeOther:
        {
          [params setNoNullObject:model.goodsCode forKey:@"goodsCode"];
        }
            break;
        default:
            break;
    }
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"customOrder" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    [self.dicHead setValue:@"0.0.0.2" forKey:@"version"];
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(YES);
            }else{
               [[Toast shareToast]makeText:message aDuration:2];
            }
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}


/**
 *  获取搜索结果详情  todoby沙漠
 *  @param isSelect 是否是筛选
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)requestTickesByExpectTimeWithInfo:(CapacityEntryModel *)info isSelect:(BOOL)isSelect callback:(void(^)(NSArray *arr))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setNoNullObject:@"BUSINESS_TYPE_CONTAINER" forKey:@"bizType"];
    NSString *time = [NSString stringWithFormat:@"%ld000", (long)[info.shipmentsTime timeIntervalSince1970]];
    [params setNoNullObject:time forKey:@"departureTime"];
    [params setNoNullObject:info.endPlace.code forKey:@"endCode"];
    [params setNoNullObject:info.transportationModel.expectTime forKey:@"expectTime"];
    [params setNoNullObject:info.startPlace.code forKey:@"startCode"];
    if (isSelect) {
        [params setNoNullObject:@(info.box.containerId) forKey:@"containerId"];
    }
    [params setNoNullObject:info.transportationModel.ID forKey:@"ticketId"];
    [params setNoNullObject:info.transportationModel.ticketType forKey:@"ticketType"];
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"queryTickesByExpectTime" forKey:@"method"];
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
                NSArray *arr = dicData[@"ticketsList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    TicketsDetailModel *model = [TicketsDetailModel yy_modelWithJSON:dic];
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


/**
 *  获取集装箱型列表 todoby沙漠
 *
 *  @param callback 返回结果
 */
- (void)requestcontainerListCallback:(void(^)(NSArray *arr))callback{
    [SVProgressHUD showWithStatus:LOADING];
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
                NSArray *arr = dicData[@"containerTypeList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    ContainerTypeModel *model = [ContainerTypeModel yy_modelWithJSON:dic];
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

/**
 *  根据条件动态查询订单价格  todoby沙漠
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)requestOrderPriceDataWithInfo:(CapacityEntryModel *)info AndContainerModel:(ContainerModel *)containerModel  callback:(void(^)(PriceInfo *priceInfo))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [params setObject:@"BUSINESS_TYPE_CONTAINER" forKey:@"bizType"];
    [params setObject:@0 forKey:@"isBuyInsurance"];
    [params setObject:@0 forKey:@"lineBasePrice"];
    [params setObject:@0 forKey:@"lineFixPrice"];
    [params setObject:@0 forKey:@"supportMoney"];
    [params setNoNullObject:info.boxNum forKey:@"containerNumber"];
    [params setNoNullObject:info.box.ID forKey:@"containterId"];
    [params setNoNullObject:info.deliveryTypeCode forKey:@"deliveryTypeCode"];
    [params setNoNullObject:info.contactInfo.startID forKey:@"sendUserId"];
    [params setNoNullObject:info.contactInfo.endID forKey:@"fetchUserId"];
    [params setNoNullObject:info.transportationModel.ticketType forKey:@"ticketType"];
    [params setNoNullObject:info.transportationModel.ID forKey:@"ticketId"];
    [params setNoNullObject:@(containerModel.oneTicketTotal) forKey:@"ticketTotalPrice"];
    
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

/**
 *  下单确认接口 todoby 沙漠
 *
 *  @param info     订单类
 *  @param callback 订单号
 */

- (void)makeSureOrderOfCapacityWithCapacityInfo:(CapacityEntryModel *)info TicketsDetailModel:(TicketsDetailModel*)model  callback:(void(^)(NSString *orderNo))callback {
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [params setNoNullObject:@"BUSINESS_TYPE_CONTAINER" forKey:@"businessTypeCode"];
    NSString *stDate = info.carryGoodsTime;
    NSArray *arrSt = [stDate componentsSeparatedByString:@"-"];
    [params setNoNullObject:arrSt[0] forKey:@"pickupStartTime"];
    [params setNoNullObject:arrSt[1] forKey:@"pickupEndTime"];
    [params setNoNullObject:info.priceInfo.endAdditionPrice forKey:@"deliveryPrice"];
    [params setNoNullObject:info.ticketType forKey:@"ticketType"];
    [params setNoNullObject:info.box.ID forKey:@"containerId"];
    [params setNoNullObject:model.ID forKey:@"transportTicketId"];
    [params setNoNullObject:info.priceInfo.ticketTotalPrice forKey:@"transportPrice"];
    [params setNoNullObject:@"2" forKey:@"fetchUserId"];
    [params setNoNullObject:@"1" forKey:@"sendUserId"];
    [params setNoNullObject:@"0" forKey:@"isBuyInsurance"];
    [params setNoNullObject:info.priceInfo.ticketTotalPrice forKey:@"transportTicketPrice"];
    [params setNoNullObject:info.contactInfo.startID forKey:@"startAddressId"];
    [params setNoNullObject:info.contactInfo.startContacts forKey:@"startContacts"];
    [params setNoNullObject:info.contactInfo.startContactsPhone forKey:@"startPhone"];
    [params setNoNullObject:info.contactInfo.endID forKey:@"endAddressId"];
    [params setNoNullObject:info.contactInfo.endContacts forKey:@"endContacts"];
    [params setNoNullObject:info.contactInfo.endContactsPhone forKey:@"endPhone"];
    [params setNoNullObject:info.priceInfo.orderTotalMoney forKey:@"totalPrice"];
    [params setNoNullObject:info.goodsInfo.ID forKey:@"goodsId"];
    [params setNoNullObject:info.noGoodsName forKey:@"goodsAlias"];
//    [params setNoNullObject:info.transportationModel.ID forKey:@"transportTicketId"];
    [params setNoNullObject:info.stStartTime forKey:@"estimateStartDepartureTime"];
    [params setNoNullObject:info.deliveryTypeCode forKey:@"deliveryTypeCode"];
    [params setNoNullObject:info.stStartTime forKey:@"estimateDepartureTime"];
    [params setNoNullObject:info.boxNum forKey:@"containerNumber"];
    [params setNoNullObject:info.priceInfo.startAdditionPrice forKey:@"pickupPrice"];
    NSDictionary *dicInvoice = [NSDictionary dictionary];
    [params setNoNullObject:dicInvoice forKey:@"orderInvoiceBean"];
    [params setNoNullObject:info.remark forKey:@"remark"];
    if([info.payStyle isEqualToString:@"预付款"]){
        [params setNoNullObject:@"PAY_TYPE_ADVANCE" forKey:@"payTypeCode"];
    }else {
        [params setNoNullObject:@"PAY_TYPE_ALTER" forKey:@"payTypeCode"];
    }
    [params setNoNullObject:info.invoice.ID forKey:@"invoiceId"];
    if (info.invoice.ID) {
        [params setNoNullObject:@1 forKey:@"isHaveInvoice"];
    }else {
        [params setNoNullObject:@0 forKey:@"isHaveInvoice"];
    }
    
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
 *  运力票搜索
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */

- (void)containerCapacitySearchWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr))callback {


    //========搜索类型=======
    //    //集装箱
    //    BUSINESS_TYPE_CONTAINER(1, "BUSINESS_TYPE_CONTAINER"),
    //    //散堆装
    //    BUSINESS_TYPE_BULK_STACK(2, "BUSINESS_TYPE_BULK_STACK"),
    //    //液态
    //    BUSINESS_TYPE_LIQUID(3,"BUSINESS_TYPE_LIQUID"),
    //    //液态
    //    BUSINESS_TYPE_COLD_CHAIN(4,"BUSINESS_TYPE_COLD_CHAIN"),
    //    //商品车
    //    BUSINESS_TYPE_VECHICLE(5,"BUSINESS_TYPE_VECHICLE"),
    //    //大件物品
    //    BUSINESS_TYPE_LARGE_SIZE(6,"BUSINESS_TYPE_LARGE_SIZE"),
    //    //三农
    //    BUSINESS_TYPE_CHEMICAL(7,"BUSINESS_TYPE_CHEMICAL");



    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setNoNullObject:info.startPlace.code forKey:@"startCode"];
    [params setNoNullObject:info.endPlace.code forKey:@"endCode"];

    NSString *time = [NSString stringWithFormat:@"%ld000", (long)[info.shipmentsTime timeIntervalSince1970]];
    [params setNoNullObject:time forKey:@"departureTime"];
    [params setNoNullObject:info.goodsInfo.ID forKey:@"goodsId"];
    [params setNoNullObject:info.box.ID forKey:@"containerId"];
    [params setNoNullObject:info.businessTypeCode forKey:@"bizType"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"searchTransportCapacityTickets" forKey:@"method"];
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
                NSArray *arr = dicData[@"capacityTickets"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    TransportationModel *model = [TransportationModel yy_modelWithJSON:dic];
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

    /**
     *  {
     header =     {
     device = "iphone 5s(Global),8.3";
     encrpy = 0;
     platform = IOS;
     version = "0.0.0.1";
     zip = 0;
     };
     response =     {
     message = "\U6267\U884c\U6210\U529f";
     result =         {
     currentPage = 0;
     data = "{\"goods\":[{\"batchExpressGoods\":0,\"code\":\"2040006\",\"createTime\":1471949939000,\"createUserId\":1,\"goodsCategoryId\":268,\"id\":3102,\"ltlPriceCode\":24,\"name\":\"\U725b\U5976\",\"phoneticCode\":\"NN\",\"status\":1,\"tlPriceCode\":6}]}";
     pageCount = 0;
     };
     status = 10000;
     };
     token = "";
     }
     */


}


/**
 *  轻运力票搜索
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */

- (void)lightcontainerCapacitySearchWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr))callback {





    //========搜索类型=======
    //    //集装箱
    //    BUSINESS_TYPE_CONTAINER(1, "BUSINESS_TYPE_CONTAINER"),
    //    //散堆装
    //    BUSINESS_TYPE_BULK_STACK(2, "BUSINESS_TYPE_BULK_STACK"),
    //    //液态
    //    BUSINESS_TYPE_LIQUID(3,"BUSINESS_TYPE_LIQUID"),
    //    //液态
    //    BUSINESS_TYPE_COLD_CHAIN(4,"BUSINESS_TYPE_COLD_CHAIN"),
    //    //商品车
    //    BUSINESS_TYPE_VECHICLE(5,"BUSINESS_TYPE_VECHICLE"),
    //    //大件物品
    //    BUSINESS_TYPE_LARGE_SIZE(6,"BUSINESS_TYPE_LARGE_SIZE"),
    //    //三农
    //    BUSINESS_TYPE_CHEMICAL(7,"BUSINESS_TYPE_CHEMICAL");



    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setNoNullObject:info.startPlace.code forKey:@"startCode"];
    [params setNoNullObject:info.endPlace.code forKey:@"endCode"];

    NSString *time = [NSString stringWithFormat:@"%ld000", (long)[info.shipmentsTime timeIntervalSince1970]];
    [params setNoNullObject:time forKey:@"departureTime"];
    [params setNoNullObject:info.goodsInfo.ID forKey:@"goodsId"];
    [params setNoNullObject:info.box.ID forKey:@"containerId"];
    [params setNoNullObject:@"1" forKey:@"containerId"];
    [params setNoNullObject:info.businessTypeCode forKey:@"bizType"];

    [params setNoNullObject:info.startEntrepotId forKey:@"startEntrepotId"];
    [params setNoNullObject:info.endEntrepotId forKey:@"endEntrepotId"];
    //[params setNoNullObject:@"BUSINESS_TYPE_CONTAINER" forKey:@"bizType"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"searchTransportCapacityTickets" forKey:@"method"];
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
                NSArray *arr = dicData[@"capacityTickets"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    GroupTransportationModel *model = [GroupTransportationModel yy_modelWithJSON:dic];
                    NSString *stPrice = dic[@"ticketTotal"];
                    float price = [stPrice floatValue];
                    if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {

                        model.ticketTotal = [NSString stringWithFormat:@"%.2f",price];

                    }

                    if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_LIQUID"]) {

                        model.ticketTotal = [NSString stringWithFormat:@"%.2f",price/20];

                    }

                    if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_COLD_CHAIN"]) {

                        model.ticketTotal = [NSString stringWithFormat:@"%.2f",price*6];
                    }

                    if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_VECHICLE"]) {

                        model.ticketTotal = [NSString stringWithFormat:@"%.2f",price*0.7];
                    }

                    if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_CHEMICAL"]) {
                        
                        model.ticketTotal = [NSString stringWithFormat:@"%.2f",price/25];
                    }

                    NSMutableArray *arrLightcontainerCapacity = [NSMutableArray array];
                    NSArray *arrTicketList = dic[@"ticketList"];
                    for (NSDictionary *dicTicket in arrTicketList) {

                        //NSString *st = [self dictionaryToJson:dicTicket];

                        TransportationModel *model = [TransportationModel new];
                        model.ticketType = dicTicket[@"ticketType"];
                        model.ticketTotal = dicTicket[@"ticketTotal"];
                        model.expectTime = dicTicket[@"expectTime"];
                        model.ID = dicTicket[@"id"];
                        model.startStation = dicTicket[@"startEntrepotName"];
                        model.endStation = dicTicket[@"endEntrepotName"];
                        model.startAddress = dicTicket[@"startEntrepotAddress"];
                        model.endAddress = dicTicket[@"endEntrepotAddress"];
                        model.transportType = dicTicket[@"transportType"];
                        model.startRegionName = dicTicket[@"startRegionName"];
                        model.endRegionName = dicTicket[@"endRegionName"];


                        //价格逻辑处理
                        NSString *stPrice = dicTicket[@"ticketTotal"];
                        float price = [stPrice floatValue];

                        //========搜索类型=======
                        //    //集装箱
                        //    BUSINESS_TYPE_CONTAINER(1, "BUSINESS_TYPE_CONTAINER"),
                        //    //散堆装
                        //    BUSINESS_TYPE_BULK_STACK(2, "BUSINESS_TYPE_BULK_STACK"),/25显示价格
                        //    //液态
                        //    BUSINESS_TYPE_LIQUID(3,"BUSINESS_TYPE_LIQUID"),/20显示价格
                        //    //冷链
                        //    BUSINESS_TYPE_COLD_CHAIN(4,"BUSINESS_TYPE_COLD_CHAIN"),*6显示价格
                        //    //商品车
                        //    BUSINESS_TYPE_VECHICLE(5,"BUSINESS_TYPE_VECHICLE"),*0.7显示价格
                        //    //大件物品
                        //    BUSINESS_TYPE_LARGE_SIZE(6,"BUSINESS_TYPE_LARGE_SIZE"),
                        //    //三农
                        //    BUSINESS_TYPE_CHEMICAL(7,"BUSINESS_TYPE_CHEMICAL");/25显示价格
                        if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {

                            model.ticketTotal = [NSString stringWithFormat:@"%.2f",price/25];

                        }

                        if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_LIQUID"]) {

                            model.ticketTotal = [NSString stringWithFormat:@"%.2f",price/20];

                        }

                        if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_COLD_CHAIN"]) {

                            model.ticketTotal = [NSString stringWithFormat:@"%.2f",price*6];
                        }

                        if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_VECHICLE"]) {

//                            model.ticketTotal = [NSString stringWithFormat:@"%.2f",price*0.7];
                            model.ticketTotal = [NSString stringWithFormat:@"%.2f",price];
                        }

                        if ([info.businessTypeCode isEqualToString:@"BUSINESS_TYPE_CHEMICAL"]) {

                            model.ticketTotal = [NSString stringWithFormat:@"%.2f",price/25];
                        }


                        [arrLightcontainerCapacity addObject:model];

                    }
                    model.arrTransportationModel = arrLightcontainerCapacity;
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


/**
 *  首页轮播
 *
 *  @param callback 结果
 */

- (void)getBannerCallback:(void(^)(NSArray *arr))callback {
    
    
//    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getActivity" forKey:@"method"];
    [self.dicHead setValue:@"activity" forKey:@"action"];
    
    
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
                NSArray *arr = dicData[@"activityList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    BannerModel *model = [BannerModel yy_modelWithJSON:dic];
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

/**
 *  推荐运力票
 *
 *  @param callback 结果
 */

- (void)getRecommendTicketsCallback:(void(^)(NSArray *arr))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getRecommendTickets" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];

    [self.dicHead setValue:@"0.0.0.3" forKey:@"version"];
    
    
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
                NSArray *arr = dicData[@"lines"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    CapacityEntryModel *model = [CapacityEntryModel yy_modelWithJSON:dic];
                    model.startPlace.centerLat = dic[@"startCenterLat"];
                    model.startPlace.centerLng = dic[@"startCenterLng"];
                    model.endPlace.centerLat = dic[@"endCenterLat"];
                    model.endPlace.centerLng = dic[@"endCenterLng"];
                    model.km = dic[@"km"];
                    [arrModel addObject:model];
                }
                callback(arrModel);
                
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
    
    /**
     *  {
     header =     {
     device = "iphone 5s(Global),8.3";
     encrpy = 0;
     platform = IOS;
     version = "0.0.0.1";
     zip = 0;
     };
     response =     {
     message = "\U6267\U884c\U6210\U529f";
     result =         {
     currentPage = 0;
     data = "{\"goods\":[{\"batchExpressGoods\":0,\"code\":\"2040006\",\"createTime\":1471949939000,\"createUserId\":1,\"goodsCategoryId\":268,\"id\":3102,\"ltlPriceCode\":24,\"name\":\"\U725b\U5976\",\"phoneticCode\":\"NN\",\"status\":1,\"tlPriceCode\":6}]}";
     pageCount = 0;
     };
     status = 10000;
     };
     token = "";
     }
     */
    
    
}
/**
 *  推荐散堆装运力票
 *
 *  @param callback 结果
 */

- (void)getRecommendStacksCallback:(void(^)(NSArray *arr))callback {
    
    
//    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:@"1" forKey:@"currentPage"];
    [params setValue:@"100" forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getBulkStackPath" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
   
    [self.dicHead setValue:@"0.0.0.2" forKey:@"version"];
    
    
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
                NSArray *arr = dicData[@"bulkStackPahtList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    CapacityEntryModel *model = [CapacityEntryModel yy_modelWithJSON:dic];
//                    model.startPlace.centerLat = dic[@"startCenterLat"];
//                    model.startPlace.centerLng = dic[@"startCenterLng"];
//                    model.endPlace.centerLat = dic[@"endCenterLat"];
//                    model.endPlace.centerLng = dic[@"endCenterLng"];
//                    model.km = dic[@"km"];
                    [arrModel addObject:model];
                }
                callback(arrModel);
                
            }else {
                
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        
//        [SVProgressHUD dismiss];
        
        
    }error:^(NSError *error) {
        
        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
//        [SVProgressHUD dismiss];
    }];
    
    /**
     *  {
     header =     {
     device = "iphone 5s(Global),8.3";
     encrpy = 0;
     platform = IOS;
     version = "0.0.0.1";
     zip = 0;
     };
     response =     {
     message = "\U6267\U884c\U6210\U529f";
     result =         {
     currentPage = 0;
     data = "{\"goods\":[{\"batchExpressGoods\":0,\"code\":\"2040006\",\"createTime\":1471949939000,\"createUserId\":1,\"goodsCategoryId\":268,\"id\":3102,\"ltlPriceCode\":24,\"name\":\"\U725b\U5976\",\"phoneticCode\":\"NN\",\"status\":1,\"tlPriceCode\":6}]}";
     pageCount = 0;
     };
     status = 10000;
     };
     token = "";
     }
     */
    
    
}

/**
 *  定制运力
 *
 *  @param info     运力定制模型
 *
 */

- (void)makeCapacityWthCapacityInfo:(CapacityEntryModel *)info callback:(void(^)(BOOL success))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setNoNullObject:info.box.ID forKey:@"containerTypeId"];
    [params setNoNullObject:info.boxNum forKey:@"containerNumber"];
    [params setNoNullObject:info.number forKey:@"containerNumber"];
    [params setNoNullObject:info.startPlace.code forKey:@"startRegionCode"];
    [params setNoNullObject:info.endPlace.code forKey:@"endRegionCode"];

    NSString *timeSp = [NSString stringWithFormat:@"%ld000", (long)[info.shipmentsTime timeIntervalSince1970]];
    [params setNoNullObject:timeSp forKey:@"sendStartDate"];
    [params setNoNullObject:info.deliveryTypeCode forKey:@"deliveryTypeCode"];
    [params setNoNullObject:info.pName forKey:@"contracts"];
    [params setNoNullObject:info.pPhone forKey:@"contractTel"];

    [params setNoNullObject:info.goodsInfo.ID forKey:@"goodsTypeId"];

    [params setNoNullObject:info.provide forKey:@"provide"];
    [params setNoNullObject:info.wrapper forKey:@"wrapper"];
    [params setNoNullObject:info.businessTypeCode forKey:@"businessTypeCode"];

    [params setNoNullObject:info.totalWeight forKey:@"weight"];
    [params setNoNullObject:info.volume_Custom forKey:@"volume"];

    [params setNoNullObject:info.carNum forKey:@"vehicleNum"];
    [params setNoNullObject:info.longCm forKey:@"unitMaxLength"];
    [params setNoNullObject:info.wideCm forKey:@"unitMaxWidth"];
    [params setNoNullObject:info.highCm forKey:@"unitMaxHigh"];
    [params setNoNullObject:info.biggestWeight forKey:@"unitMaxWeight"];
    [params setNoNullObject:@"奔驰" forKey:@"vehicleType"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"customizeCapacity" forKey:@"method"];
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

                callback(YES);

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
 *  查询运力票起终点
 *
 *  @param ID       运力票ID
 *  @param callback 地点信息对象
 */

- (void)getCapacityAddressWthCapacityId:(NSString *)ID callback:(void(^)(ContactInfo *contactInfo))callback {


//    [SVProgressHUD showWithStatus:LOADING];
//    NSMutableDictionary *params= [NSMutableDictionary dictionary];
//
//    [params setNoNullObject:ID forKey:@"ticketId"];
//
//
//    [self.dicRequest setObject:params forKey:@"params"];
//
//    [self.dicHead setValue:@"getPreciseEntrepot" forKey:@"method"];
//    [self.dicHead setValue:@"address" forKey:@"action"];
//
//
//    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
//    NSString *st = [self dictionaryToJson:dic];
//    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
//        id responseData = [self getResponseData:tuple];
//        if (responseData) {
//            NSDictionary *response = responseData[@"response"];
//            NSString *status = response[@"status"];
//            NSString *message = response[@"message"];
//            if ([status isEqualToString:REQUESTSUCCESS]) {
//
//                NSDictionary *result = response[@"result"];
//                NSString *data = result[@"data"];
//                NSDictionary *dicData = [self dictionaryWithJsonString:data];
//                NSDictionary *dicPreciseEntrepot = dicData[@"preciseEntrepot"];
//                NSDictionary *dicEndEntrepot = dicPreciseEntrepot[@"endEntrepot"];
//                NSDictionary *dicStartEntrepot = dicPreciseEntrepot[@"startEntrepot"];
                ContactInfo *info = [ContactInfo new];
//                info.startID = @"1";
//                info.endID = @"1";

//                info.startAddress =dicStartEntrepot[@"address"];
//                info.startContacts =dicStartEntrepot[@"contacts"];
//                info.startContactsPhone =dicStartEntrepot[@"contactsPhone"];
//                info.startID = dicStartEntrepot[@"id"];
//
//
//                info.endAddress =dicEndEntrepot[@"address"];
//                info.endContacts =dicEndEntrepot[@"contacts"];
//                info.endContactsPhone =dicEndEntrepot[@"contactsPhone"];
//                info.endID = dicEndEntrepot[@"id"];
                callback(info);
//
//                
//            }else {
//                
//                [[Toast shareToast]makeText:message aDuration:1];
//            }
//            
//        }
//        

        
//        [SVProgressHUD dismiss];
//        
//    }error:^(NSError *error) {
//        
//        [[Toast shareToast]makeText:BUSY aDuration:1];
//        [SVProgressHUD dismiss];
//    }];

}


/**
 *  搜索快速配送路线
 *
 *  @param startCity 起运城市
 *  @param endCity   抵运城市
 */

-(void)selectQuickCapacityWithStartCity:(CityModel *)startCity WithEndCity:(CityModel *)endCity callback:(void(^)(NSArray *arr))callback{

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    if (startCity) {
        [params setValue:startCity.code forKey:@"startRegionCode"];
    }

    if (endCity) {
        [params setValue:startCity.code forKey:@"endRegionCode"];
    }

    [self.dicHead setValue:@"getTransportDispatchLineList" forKey:@"method"];
    [self.dicHead setValue:@"region" forKey:@"action"];
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

                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arr = dicData[@"TransportDispatchLineList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    CapacityEntryModel *model = [CapacityEntryModel yy_modelWithJSON:dic];
                    model.startPlace.code = dic[@"startRegionCode"];
                    model.endPlace.code = dic[@"endRegionCode"];
                    model.startName = dic[@"startRegionName"];
                    model.endName = dic[@"endRegionName"];


                    [arrModel addObject:model];
                }
                callback(arrModel);

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

@end
