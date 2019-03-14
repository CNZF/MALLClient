//
//  EmptyCarModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarModel.h"
/**
 *  {
 companyAuth = 1;
 companyName = "\U9e3f\U8f69\U96c6\U56e2";
 companyPhone = 13342289878;
 companyQuaAuth = 1;
 endCarriageDate = 1491580800000;
 endStation = "\U95f5\U884c";
 endStationRegionCode = 310100;
 id = 19;
 number = 10;
 price = 1000;
 railwayPhotoUrl = "/emptyvehicle/1491029698316.jpg\U263c/emptyvehicle/1491029701096.jpg\U263c/emptyvehicle/1491029704097.jpg";
 regularCode = K1001;
 regularType = "TRAIN_TYPE_EXPRESS";
 regularTypeName = "\U7279\U5feb";
 startCarriageDate = 1491062400000;
 startStation = "\U9ec4\U6751";
 startStationRegionCode = 110100;
 transportType = RAILWAY;
 }
 */

@implementation EmptyCarModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id",
             @"name":@[@"regularCode",@"name"],
             @"details":@[@"shipCode",@"regularCode",@"companyName",@"createUser",@"loginName",@"name"],
             @"goodsNum":@[@"code",@"CODE"],
             @"city":@"locationName",
             @"carNum":@"plateno",
             @"carCarryWeight":@"totalWeight",
             @"produceYear":@[@"factory_date",@"factoryDate"],
             @"capacityMessage":@"remark",
             @"sellerCompany":@[@"companyName",@"loginName",@"name"],
             @"phone":@[@"phone",@"userPhone",@"companyPhone"],
             @"startAddress":@[@"startAddress",@"startStation"],
             @"endAddress":@[@"endAddress",@"endStation"],
             @"trainsType":@"regularTypeName",
             @"trainStartStation":@"startStation",
             @"trainEndStation":@"endStation",
             @"trainStartTime":@"send_date",
             @"trainEndTime":@"end_carriage_date",
             @"railwayId":@"id",//railway_regular_id
             @"leftNum":@"number",
             @"shipNum":@"shipCode",
             @"shipStartStation":@"loadHabor",
             @"shipEndStation":@"unloadHabor",
             @"shipStartTime":@"open_wh_time",
             @"shipEndTime":@"close_wh_time",
             @"shipLeaveTime":@"leave_date",
             @"shipId":@"id",//ship_regular_id
            };
}

-(void)setArrRouts:(NSArray *)arrRouts {
    NSMutableArray * array = [NSMutableArray new];
    if (arrRouts.count != 0) {
        for (NSDictionary * dic in arrRouts) {
            [array addObject:[EmptyCarLineModel yy_modelWithJSON:dic]];
        }
    }
    _arrRouts = [NSArray arrayWithArray:array];
}

-(NSString *)certification {
    
    _certification = nil;
    
    if ([self.companyAuth intValue] == 2) {
        _certification = @"实名认证";
    }
    if ([self.companyQuaAuth intValue] == 2 && [self.companyAuth intValue] == 2) {
        _certification = @"资质认证";
    }
    return _certification;
}

-(NSString *)priceUnit {
    if (self.transportTypeEnum == landTransportation) {
        _priceUnit = @"起";
    } else {
        _priceUnit = @"/TEU";

    }
    
    return _priceUnit;
}

-(NSString *)name {
    switch (self.transportTypeEnum) {
        case landTransportation:
            if (!self.type) {
                _name = nil;
            } else {
                if (!self.brand) {
                    _name = self.type;
                }
                else {
                    _name = [NSString stringWithFormat:@"%@(%@)",self.type,self.brand];
                }
            }
            return _name;
            break;
            
        case trainsTransportation:
            return [NSString stringWithFormat:@"班列:%@",_name];
            break;
            
        case shipTransportation:
            return [NSString stringWithFormat:@"班轮:%@",_name];
            break;
    }
    return nil;
}

-(NSString *)details {
    if (self.transportTypeEnum == shipTransportation) {
        return [NSString stringWithFormat:@"航次 :%@",_details];
    }

    if (self.transportTypeEnum == trainsTransportation) {
        return [NSString stringWithFormat:@"班列 :%@",_details];
    }
    return _details;
}
-(void)setTransportType:(NSString *)transportType{

    _transportType = [transportType copy];

    if ([transportType isEqualToString:@"ROAD"]) {
        _transportTypeEnum = landTransportation;
    } else if ([transportType isEqualToString:@"RAIL"]) {
        _transportTypeEnum = trainsTransportation;

    }else if ([transportType isEqualToString:@"SEA"]) {
        _transportTypeEnum = shipTransportation;
        
    }
}

-(void)setUpGroundDate:(NSString *)upGroundDate {
    double time = [[NSDate date] timeIntervalSince1970] - [upGroundDate doubleValue] / 1000;
    double i = 0;
    if (time >= 365.f * 24 * 3600) {
        self.timeStr = @"1年前";
    }else if(time >= 30.f * 24 * 3600) {
        i = time / (30 * 24 * 3600);
        self.timeStr = [NSString stringWithFormat:@"%ld个月前",(long)i];
    }else if(time >= 7 * 24 * 3600) {
        i = time / (7 * 24 * 3600);
        self.timeStr = [NSString stringWithFormat:@"%ld周前",(long)i];
    }else if(time >= 24 * 3600) {
        i = time / (24 * 3600);
        self.timeStr = [NSString stringWithFormat:@"%ld天前",(long)i];
    }else {
        self.timeStr = @"当天";
    }
}

-(NSString *)startAddress {
    if (!_startAddress) {
        return @"";
    }
    return _startAddress;
}

-(NSString *)startParentAddress {
    if (!_startParentAddress) {
        return @"";
    }
    return _startParentAddress;
}

-(NSString *)endAddress {
    if (!_endAddress) {
        return @"";
    }
    return _endAddress;
}

-(NSString *)endParentAddress {
    if (!_endParentAddress) {
        return @"";
    }
    return _endParentAddress;
}
@end
