//
//  CapacityEntryModel.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/30.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CapacityEntryModel.h"

@implementation CapacityEntryModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"price":@"ticketPrice"};
}
-(void)setDepartureTime:(NSString *)departureTime
{
    _departureTime = [departureTime copy];
    self.shipmentsTime = [NSDate dateWithTimeIntervalSince1970:[_departureTime longLongValue] / 1000];
}

-(void)setStartName:(NSString *)startName
{
    _startName = [startName copy];
    self.startPlace.name = _startName;
}

-(void)setStartRegionCode:(NSString *)startRegionCode
{
    _startRegionCode = [startRegionCode copy];
    self.startPlace.code = _startRegionCode;
}

-(void)setEndName:(NSString *)endName
{
    _endName = [endName copy];
    self.endPlace.name = _endName;
}
- (void)setEndRegionCode:(NSString *)endRegionCode
{
    _endRegionCode = [endRegionCode copy];
    self.endPlace.code = _endRegionCode;
}

-(void)setLineType:(NSString *)lineType
{
    if ([lineType isEqualToString:@"LINE_TYPE_CONTAINER_20"]) {
        _lineType = @"20英尺通用箱";
    }
    else if ([lineType isEqualToString:@"LINE_TYPE_CONTAINER_40"]) {
        _lineType = @"40英尺通用箱";
    }
    else
    {
        _lineType = [lineType copy];
    }
}
- (GoodsInfo *)goodsInfo {
    if (!_goodsInfo) {
        _goodsInfo = [GoodsInfo new];
    }
    return _goodsInfo;
}

- (CityModel *)startPlace {
    if (!_startPlace) {
        _startPlace = [CityModel new];

    }
    return _startPlace;
}

- (CityModel *)endPlace {
    if (!_endPlace) {
        _endPlace = [CityModel new];

    }
    return _endPlace;
}

- (ContainerTypeModel *)box {
    if (!_box) {
        _box = [ContainerTypeModel new];
    }
    return _box;
}

- (PriceInfo *)priceInfo {
    if (!_priceInfo) {
        _priceInfo = [PriceInfo new];

    }
    return _priceInfo;
}

-(void)setShipmentsTime:(NSDate *)shipmentsTime {
    _shipmentsTime = shipmentsTime;

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    self.stStartTime = [outputFormatter stringFromDate:_shipmentsTime];
}

-(void)setLatestShipmentsTime:(NSDate *)latestShipmentsTime{
    _latestShipmentsTime = latestShipmentsTime;
    
    NSDateFormatter *outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    self.stLatestShipmentsTime = [outputFormatter stringFromDate:_latestShipmentsTime];
}

- (void)setCapacityType:(NSString *)capacityType{

    /**
     *  //集装箱
     BUSINESS_TYPE_CONTAINER(1, "BUSINESS_TYPE_CONTAINER"),
     //散堆装
     BUSINESS_TYPE_BULK_STACK(2, "BUSINESS_TYPE_BULK_STACK"),
     //液态
     BUSINESS_TYPE_LIQUID(3,"BUSINESS_TYPE_LIQUID"),
     //液态
     BUSINESS_TYPE_COLD_CHAIN(4,"BUSINESS_TYPE_COLD_CHAIN"),
     //商品车
     BUSINESS_TYPE_VECHICLE(5,"BUSINESS_TYPE_VECHICLE"),
     //大件物品
     BUSINESS_TYPE_LARGE_SIZE(6,"BUSINESS_TYPE_LARGE_SIZE"),
     //三农
     BUSINESS_TYPE_CHEMICAL(7,"BUSINESS_TYPE_CHEMICAL");
     
     BUSINESS_TYPE_ONE_ROAD 一带一路运力
     
     BUSINESS_TYPE_BATCH 批量
     */

    _capacityType = capacityType;

    NSDictionary *dic= @{@"集装箱运力":@"BUSINESS_TYPE_CONTAINER",@"散堆装运力":@"BUSINESS_TYPE_BULK_STACK",@"三农化肥运力":@"BUSINESS_TYPE_CHEMICAL",@"批量成件运力":@"BUSINESS_TYPE_BATCH",@"冷链运力":@"BUSINESS_TYPE_COLD_CHAIN",@"大件运力":@"BUSINESS_TYPE_LARGE_SIZE",@"商品车运力":@"BUSINESS_TYPE_VECHICLE",@"液态运力":@"BUSINESS_TYPE_LIQUID",@"一带一路运力":@"BUSINESS_TYPE_ONE_ROAD"};

    self.businessTypeCode = [dic objectForKey:capacityType];

}

- (void)setServiceWay:(NSString *)serviceWay {

    _serviceWay = serviceWay;
    NSDictionary  *dic = @{@"上门取货":@"DELIVERY_TYPE_DOOR_POINT",@"无":@"DELIVERY_TYPE_POINT_POINT",@"送货上门":@"DELIVERY_TYPE_POINT_DOOR",@"上门取货+送货上门":@"DELIVERY_TYPE_DOOR_DOOR"};

    self.deliveryTypeCode = [dic objectForKey:serviceWay];


}

- (void) setIsPackaging:(NSString *)isPackaging {

    _isPackaging = isPackaging;

    if ([isPackaging isEqualToString:@"是"]) {
        self.wrapper = @1;
    }else {
        self.wrapper = @0;
    }

}


- (void)setIsOwnBox:(NSString *)isOwnBox {

    _isOwnBox = isOwnBox;

    if ([isOwnBox isEqualToString:@"是"]) {

        self.provide = @1;

    }else {
        
        self.provide = @0;
    }
}

@end
