//
//  OrderModel.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"orderID":@[@"CODE",@"code"],
             @"price":@"totalPrice",
             @"startPlace":@"startRegionName",
             @"endPlace":@"endRegionName",
             @"goodsNum":@"containerNumber",
             @"ordetType":@"statusDesc",
             @"goodsName":@[@"goodsName",@"gooodsName"],
             @"capacityType":@"businessTypeCodeDesc",
             @"ID":@"id",
             
             @"startpName":@"startContacts",
             @"startpPhone":@"startPhone",
             @"startaddress":@"startAddress",
             @"endpName":@"endContacts",
             @"endpPhone":@"endPhone",
             @"endaddress":@"endAddress",
             
             @"startTime":@"estimateDepartureTime",
             @"endTime":@"estimateFinishTime",
             
             @"serviceType":@"deliveryTypeCode",
             @"autonomousBoxNum":@"provide",
             @"boxNum":@"containerNumber",
             
             @"insurancePrice":@"insuredPrice",
             @"pointToPointPrice":@"additionPrice",
             @"doorToDoorPrice":@"transportPrice",
             @"allPrice":@"totalPrice",
             @"placeTheOrderTime":@"submitTime",
             @"note":@"remark",
             @"orderProgress":@"orderProcess"
             };
}

-(NSString *)note
{
    if (!_note) {
        _note = @"怕摔，轻拿轻放，易碎";
    }
    return _note;
}
-(void)setServiceType:(NSString *)serviceType
{
    if ([serviceType isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]) {
        _serviceType = @"送货上门";
    }
    else if ([serviceType isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        _serviceType = @"无";

    }
    else if ([serviceType isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]) {
        _serviceType = @"上门取货";

    }
    else if ([serviceType isEqualToString:@"DELIVERY_TYPE_DOOR_DOOR"]) {
        _serviceType = @"上门取货、送货上门";

    }
}
-(void)setOrderProgress:(NSArray *)orderProgress
{
    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary * dict in orderProgress) {
        [arr addObject:[OrderProgressModel yy_modelWithJSON:dict]];
        
    }
    _orderProgress = arr;
}

-(void)setPaymentFlow:(NSArray *)paymentFlow
{
    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary * dict in paymentFlow) {
        [arr addObject:[PaymentFlowModel yy_modelWithJSON:dict]];
    }
    _paymentFlow = arr;
}
-(NSString *)payTypeCode
{
    if ([_payTypeCode isEqualToString:@"PAY_TYPE_ADVANCE"]) {
        _payTypeCode = @"预付款";
    }
    else if ([_payTypeCode isEqualToString:@"PAY_TYPE_ALTER"]) {
        _payTypeCode = @"后付款";
    }
    return _payTypeCode;
}

//ordetType;//订单类型
//capacityType;//运力类型
-(NSString *)startEntrepotNameStr {
    return [NSString stringWithFormat:@"%@  %@",self.startEntrepotName,self.startEntrepotAddress];
}
-(NSString *)endEntrepotNameStr {
    return [NSString stringWithFormat:@"%@  %@",self.endEntrepotName,self.endEntrepotAddress];

}
@end
