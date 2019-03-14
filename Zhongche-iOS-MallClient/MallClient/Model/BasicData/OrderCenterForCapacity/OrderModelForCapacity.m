//
//  OrderModel.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderModelForCapacity.h"

@implementation OrderModelForCapacity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderID":@[@"CODE",@"code"],
             @"price":@"totalPrice",
             @"startPlace":@"startRegionName",
             @"endPlace":@"endRegionName",
             @"goodsNum":@"containerNumber",
             @"ordetType":@[@"statusDesc",@"statusName"],
             @"goodsName":@[@"goodsName",@"gooodsName"],
             @"capacityType":@"businessTypeCodeDesc",
             @"ID":@"id",
             
             @"startpName":@"startContacts",
             @"startpPhone":@"startPhone",
             @"startaddress":@"startAddress",
             @"endpName":@"endContacts",
             @"endpPhone":@"endPhone",
             @"endaddress":@"endAddress",  
             
//             @"startTime":@"estimateDepartureTime",
//             @"endTime":@"estimateFinishTime",
             
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

-(NSString *)note {
    if (!_note) {
        _note = @"无";
    }
    return _note;
}

-(void)setServiceType:(NSString *)serviceType {
    if ([serviceType isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]) {
        _serviceType = @"上门取货";
    }
    else if ([serviceType isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        _serviceType = @"无";

    }
    else if ([serviceType isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]) {
        _serviceType = @"送货上门";

    }
    else if ([serviceType isEqualToString:@"DELIVERY_TYPE_DOOR_DOOR"]) {
        _serviceType = @"上门取货、送货上门";

    }
}

-(void)setStatus:(NSString *)status {

    /**
     *   coalCancle = -1,//已取消
     coalCertaining = 0,//待确定
     coalPaying = 1,//待付款
     coalConfirming = 2,//待审核
     coalSenting =3,//待审核
     coalReceiving = 4,//待收货
     coalEvaluating  =5,//待结算
     coalFish = 6,//已完成
     coalAll = 100//全部
     */
    
    switch ([status intValue]) {
        case -1:
            _status = @"已取消";
            break;

        case 0:
            _status = @"待确定";
            break;

        case 1:
            _status = @"待付款";
            break;

        case 2:
            _status = @"待审核";
            break;

        case 3:
            _status = @"待发货";
            break;

        case 4:
            _status = @"待收货";
            break;

        case 5:
            _status = @"待结算";
            break;

        case 6:
            _status = @"已完成";
            break;

        default:
            break;
    }
}

-(void)setOrderProgress:(NSArray *)orderProgress {
    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary * dict in orderProgress) {
        [arr addObject:[OrderProgressModel yy_modelWithJSON:dict]];
        
    }
    //数组排序
//    [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
//       return [((OrderProgressModel *)obj1).time longLongValue] >= [((OrderProgressModel *)obj2).time longLongValue];
//    }];
    
    _orderProgress = arr;
}

-(void)setPaymentFlow:(NSArray *)paymentFlow {
    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary * dict in paymentFlow) {
        [arr addObject:[PaymentFlowModel yy_modelWithJSON:dict]];
    }
    _paymentFlow = arr;
}

-(NSString *)payTypeCode {
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
