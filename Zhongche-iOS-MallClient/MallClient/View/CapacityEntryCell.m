//
//  CapacityEntryCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/30.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CapacityEntryCell.h"

@interface CapacityEntryCell()

@property (nonatomic, strong) UILabel * goodsType;
@property (nonatomic, strong) UILabel * goodsType_text;
@property (nonatomic, strong) UILabel * goodsName;
@property (nonatomic, strong) UILabel * goodsName_text;
@property (nonatomic, strong) UILabel * startPlace;
@property (nonatomic, strong) UILabel * startPlace_text;
@property (nonatomic, strong) UILabel * endPlace;
@property (nonatomic, strong) UILabel * endPlace_text;
@property (nonatomic, strong) UILabel * box;
@property (nonatomic, strong) UILabel * box_text;
@property (nonatomic, strong) UILabel * shipmentsTime;
@property (nonatomic, strong) UILabel * shipmentsTime_text;
@property (nonatomic, strong) UILabel * biggestWeight;
@property (nonatomic, strong) UILabel * biggestWeight_text;
@property (nonatomic, strong) UILabel * biggestSize;
@property (nonatomic, strong) UILabel * biggestSize_text;
@property (nonatomic, strong) UILabel * packagingType;
@property (nonatomic, strong) UILabel * packagingType_text;
@property (nonatomic, strong) UILabel * weight;
@property (nonatomic, strong) UILabel * weight_text;
@property (nonatomic, strong) UILabel * volume;
@property (nonatomic, strong) UILabel * volume_text;
@property (nonatomic, strong) UILabel * vehicleBrand;
@property (nonatomic, strong) UILabel * vehicleBrand_text;
@property (nonatomic, strong) UILabel * vehicleType;
@property (nonatomic, strong) UILabel * vehicleType_text;

@end

@implementation CapacityEntryCell
-(void)loadUIWithmodel:(CapacityEntryModel*)model
{
    self.goodsType_text.text = model.capacityType;
    self.goodsName_text.text = model.goodsInfo.name;
    self.startPlace_text.text = model.startPlace.name;
    self.endPlace_text.text = model.endPlace.name;
    self.box_text.text = model.box.name;
    self.shipmentsTime_text.text = model.stStartTime;
    
    self.biggestWeight_text.text = [NSString stringWithFormat:@"%@吨",model.biggestWeight];
    self.biggestSize_text.text = [NSString stringWithFormat:@"%@*%@*%@(长宽高)cm",model.longCm,model.wideCm,model.highCm];
    self.packagingType_text.text = model.packagingType.name;
    self.weight_text.text = [NSString stringWithFormat:@"%@千克",model.weight];
    self.volume_text.text = [NSString stringWithFormat:@"%@m³",model.volume];
    self.vehicleBrand_text.text = model.vehicleBrand;
    self.vehicleType_text.text = model.vehicleType;
}
-(void)bindView
{
    self.goodsType.frame = CGRectMake(20, 15, 80, 20);
    [self addSubview:self.goodsType];
    self.goodsType_text.frame = CGRectMake(150, self.goodsType.top, SCREEN_W - 160, 20);
    [self addSubview:self.goodsType_text];
    
}
-(UILabel *)goodsType
{
    if (!_goodsType) {
        UILabel * lab = [UILabel new];
        lab.text = @"货品类型";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _goodsType = lab;
    }
    return _goodsType;
}
-(UILabel *)goodsType_text
{
    if (!_goodsType_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _goodsType_text = lab;
    }
    return _goodsType_text;
}-(UILabel *)goodsName
{
    if (!_goodsName) {
        UILabel * lab = [UILabel new];
        lab.text = @"货品名称";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _goodsName = lab;
    }
    return _goodsName;
}
-(UILabel *)goodsName_text
{
    if (!_goodsName_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _goodsName_text = lab;
    }
    return _goodsName_text;
}
-(UILabel *)startPlace
{
    if (!_startPlace) {
        UILabel * lab = [UILabel new];
        lab.text = @"起运地";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _startPlace = lab;
    }
    return _startPlace;
}
-(UILabel *)startPlace_text
{
    if (!_startPlace_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _startPlace_text = lab;
    }
    return _startPlace_text;
}
-(UILabel *)endPlace
{
    if (!_endPlace) {
        UILabel * lab = [UILabel new];
        lab.text = @"抵运地";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _endPlace = lab;
    }
    return _endPlace;
}
-(UILabel *)endPlace_text
{
    if (!_endPlace_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _endPlace_text = lab;
    }
    return _endPlace_text;
}
-(UILabel *)box
{
    if (!_box) {
        UILabel * lab = [UILabel new];
        lab.text = @"箱型";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _box = lab;
    }
    return _box;
}
-(UILabel *)box_text
{
    if (!_box_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _box_text = lab;
    }
    return _box_text;
}
-(UILabel *)shipmentsTime
{
    if (!_shipmentsTime) {
        UILabel * lab = [UILabel new];
        if ([self isKindOfClass:[CapacityEntryCell_Fertilizer class]]) {
            lab.text = @"开始日期";

        }
        else
        {
            lab.text = @"发货日期";
        }
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _shipmentsTime = lab;
    }
    return _shipmentsTime;
}
-(UILabel *)shipmentsTime_text
{
    if (!_shipmentsTime_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _shipmentsTime_text = lab;
    }
    return _shipmentsTime_text;
}
-(UILabel *)biggestWeight
{
    if (!_biggestWeight) {
        UILabel * lab = [UILabel new];
        lab.text = @"最大单件重量";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _biggestWeight = lab;
    }
    return _biggestWeight;
}
-(UILabel *)biggestWeight_text
{
    if (!_biggestWeight_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _biggestWeight_text = lab;
    }
    return _biggestWeight_text;
}
-(UILabel *)biggestSize
{
    if (!_biggestSize) {
        UILabel * lab = [UILabel new];
        lab.text = @"最大单件尺寸";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _biggestSize = lab;
    }
    return _biggestSize;
}
-(UILabel *)biggestSize_text
{
    if (!_biggestSize_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _biggestSize_text = lab;
    }
    return _biggestSize_text;
}
-(UILabel *)packagingType
{
    if (!_packagingType) {
        UILabel * lab = [UILabel new];
        lab.text = @"包装类型";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _packagingType = lab;
    }
    return _packagingType;
}
-(UILabel *)packagingType_text
{
    if (!_packagingType_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _packagingType_text = lab;
    }
    return _packagingType_text;
}
-(UILabel *)weight
{
    if (!_weight) {
        UILabel * lab = [UILabel new];
        lab.text = @"单件重量";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _weight = lab;
    }
    return _weight;
}
-(UILabel *)weight_text
{
    if (!_weight_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _weight_text = lab;
    }
    return _weight_text;
}
-(UILabel *)volume
{
    if (!_volume) {
        UILabel * lab = [UILabel new];
        lab.text = @"单件体积";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _volume = lab;
    }
    return _volume;
}
-(UILabel *)volume_text
{
    if (!_volume_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _volume_text = lab;
    }
    return _volume_text;
}
-(UILabel *)vehicleBrand
{
    if (!_vehicleBrand) {
        UILabel * lab = [UILabel new];
        lab.text = @"车辆品牌";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _vehicleBrand = lab;
    }
    return _vehicleBrand;
}
-(UILabel *)vehicleBrand_text
{
    if (!_vehicleBrand_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _vehicleBrand_text = lab;
    }
    return _vehicleBrand_text;
}
-(UILabel *)vehicleType
{
    if (!_vehicleType) {
        UILabel * lab = [UILabel new];
        lab.text = @"车辆型号";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        
        _vehicleType = lab;
    }
    return _vehicleType;
}
-(UILabel *)vehicleType_text
{
    if (!_vehicleType_text) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        
        _vehicleType_text = lab;
    }
    return _vehicleType_text;
}
@end

#pragma mark - 集装箱运力
@implementation CapacityEntryCell_Container : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.box,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.box_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];

        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}
@end
#pragma mark - 散堆装运力
@implementation CapacityEntryCell_InBulk : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 三农化肥运力
@implementation CapacityEntryCell_Fertilizer : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 批量成件运力
@implementation CapacityEntryCell_Batch : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.weight,self.volume,self.biggestSize,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.weight_text,self.volume_text,self.biggestSize_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 冷链运力
@implementation CapacityEntryCell_ColdChain : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.packagingType,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.packagingType_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 大件运力
@implementation CapacityEntryCell_Big : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.biggestWeight,self.biggestSize,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.biggestWeight_text,self.biggestSize_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 商品车运力
@implementation CapacityEntryCell_ForCar : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.vehicleBrand,self.vehicleType,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.vehicleBrand_text,self.vehicleType_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 液态运力
@implementation CapacityEntryCell_Liquid : CapacityEntryCell
-(void)bindView
{
    [super bindView];
    NSArray * array1 = @[self.goodsName,self.startPlace,self.endPlace,self.shipmentsTime];
    NSArray * array2 = @[self.goodsName_text,self.startPlace_text,self.endPlace_text,self.shipmentsTime_text];
    UIView * view;
    float _y = self.goodsType.bottom + 10;
    for (int i = 0; i < MIN(array1.count, array2.count);i++) {
        
        view = array1[i];
        view.frame = CGRectMake(20, _y, 80, 20);
        [self addSubview:view];
        
        
        view = array2[i];
        view.frame = CGRectMake(150, _y, SCREEN_W - 160, 20);
        [self addSubview:view];
        
        
        _y = view.bottom + 10;
    }
    _y = self.goodsType.bottom + 10;
}

@end

#pragma mark - 一带一路运力
@implementation CapacityEntryCell_OneBeltOneRoad : CapacityEntryCell
@end
