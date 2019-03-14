//
//  OrderModelForEmptyCar.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/5.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderModelForEmptyCar.h"
#import "OrderProgressModel.h"
#import "OrderViewModel.h"
@implementation OrderModelForEmptyCar

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id",
             @"orderID":@[@"orderCode",@"code"],
             @"startPlace":@[@"startAddress",@"start_address"],
             @"endPlace":@[@"endAddress",@"end_address"],
             @"rentTime":@"startDate",
             @"price":@[@"payablePrice",@"price"],
             @"buyNum":@[@"buyNumber",@"payable_number",@"buy_number"],
             @"phone":@[@"phone",@"companyPhone"],
             @"peopelPhone":@[@"conractsPhone",@"contactsPhone"],
             @"endAddress":@"end_address",
             @"peopelName":@[@"contactsName",@"username"],
             @"linePrice":@[@"payablePrice",@"unitPrice"],
             @"create_time":@[@"createTime",@"create_time"],
             @"goodsName":@"goods_name",
             @"capacityBuyDate":@[@"start_date",@"rent_date"],
             @"orderState":@"orderStatus",

             @"peopelName":@[@"username",@"createUser"],
             @"startAddress":@"start_address",
             @"endAddress":@"end_address",
             @"linePrice":@"price",
             @"create_time":@"create_time",
             @"goodsName":@"goods_name",
             @"seller":@"createUser",
             @"carNum":@"plateNo",
             @"shipNum":@"regularCode",
             @"openStorehouse":@"openWhTime",
             @"shipmentClosingDate":@"closeWhTime",
             @"leavePortDate":@"leaveDate",
             @"startingTime":@[@"openWhTime",@"sendDate"],
             @"abortDate":@[@"end_carriage_date",@"deliveryEndDate"],
             @"orderProgress":@"orderProcess",
             @"trainsNum":@"regularCode",
             @"goodsCode":@[@"raiwayCode",@"shipCode",@"vehicleCode"],

             @"imgUrlList":@[@"vehiclePhotoUrl",@"photoUrl"]
             };
}

-(void)setOrderProgress:(NSArray *)orderProgress {
    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary * dict in orderProgress) {
        [arr addObject:[OrderProgressModel yy_modelWithJSON:dict]];

    }

    _orderProgress = arr;
}

-(void)setMatchCodeList:(NSArray *)matchCodeList {
    NSMutableArray * mArray = [NSMutableArray new];
    for (id dic in matchCodeList) {
        if (dic[@"CODE"]) {
            [mArray addObject:dic[@"CODE"]];
        }
    }
    _matchCodeList = [NSArray arrayWithArray:mArray];
}

-(void)setImgUrlList:(id)imgUrlList{
    if ([imgUrlList isKindOfClass:[NSString class]]) {
        NSArray *arrImg = [imgUrlList componentsSeparatedByString:@"☼"];
        self.imgUrl = arrImg[0];
    }
}

-(void)setStatus:(NSString *)status {
    switch ((EmptyCarOrderStatus)[status intValue]) {
        case NeedPayment:
            self.orderState = @"待支付";
            break;
        case WaitCheck:
            self.orderState = @"待审核";
            break;
        case WAIT_DISPATCH:
            self.orderState = @"待调度";
            break;
        case WAIT_LOADING:
            self.orderState = @"待装载";
            break;
        case Accomplish:
            self.orderState = @"已完成";
            break;
        case CallOff:
            self.orderState = @"已取消";
            break;
        default:
            break;
    }
}

-(NSString *)details {
    switch (_transportTypeEnum) {
        case trainsTransportation:
            return [NSString stringWithFormat:@"班列:%@",_details];
            break;
        case shipTransportation:
            return [NSString stringWithFormat:@"班轮:%@",_details];
            break;
        default:
            break;
    }
    return _details;
}

-(NSString *)lineName {
    switch (_transportTypeEnum) {
        case landTransportation:
            return _lineName;
            break;
        default:
            return [NSString stringWithFormat:@"%@ - %@",self.startPlace,self.endPlace];
            break;
            
    }
}
@end
