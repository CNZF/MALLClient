//
//  EmptyCarModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "EmptyCarLineModel.h"
#import "EmptyCarLineModel.h"

typedef enum {
    landTransportation,
    trainsTransportation,
    shipTransportation
}TransportTypeEnum;
@interface EmptyCarModel : BaseModel

@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * transportType;//运输类型
@property (nonatomic, assign)TransportTypeEnum transportTypeEnum;
@property (nonatomic, copy)NSString * startAddress;//运输路线
@property (nonatomic, copy)NSString * startParentAddress;
@property (nonatomic, copy)NSString * endAddress;
@property (nonatomic, copy)NSString * endParentAddress;
@property (nonatomic, copy)NSString * shopVehicleLineId;//默认线路ID

@property (nonatomic, copy)NSString * certification;//认证情况
@property (nonatomic, copy)NSString * companyQuaAuth;//资质认证
@property (nonatomic, copy)NSString * companyAuth;//实名认证

@property (nonatomic, copy)NSString * details;//运输详情
@property (nonatomic, copy)NSString * upGroundDate;//发布时间
@property (nonatomic, copy)NSString * timeStr;
@property (nonatomic, copy)NSString * trainsType;//铁运方式
@property (nonatomic, copy)NSString * priceUnit;//价格单位
@property (nonatomic, copy)NSString * phone;//联系电话



//公用
@property (nonatomic, copy)NSString * price;//价格
@property (nonatomic, strong) NSArray  *imgArr;//轮播图图片url;
@property (nonatomic, copy) NSString *goodsNum;//商品编号

@property (nonatomic, copy) NSString *sellerCompany;//卖家公司
@property (nonatomic, strong) NSString *leftNum;//剩余数量

//车
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSString * brand;
@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSArray  *arrRouts;//线路数组

@property (nonatomic, copy) NSString *carNum;//车牌号
@property (nonatomic, copy) NSString *carCarryWeight;//载重量
@property (nonatomic, copy) NSString *produceYear;//出厂年份

@property (nonatomic, copy) NSString *capacityMessage;//运力信息
@property (nonatomic, copy) NSString *vehicleId;//车辆ID(下单使用)

@property (nonatomic, strong) EmptyCarLineModel *currentLine;



//船

@property (nonatomic, strong) NSString *shipNum;//航次
@property (nonatomic, strong) NSString *shipStartStation;//船装货港
@property (nonatomic, strong) NSString *shipEndStation;//船卸货港
@property (nonatomic, strong) NSString *shipStartTime;//开仓时间
@property (nonatomic, strong) NSString *shipEndTime;//截载时间
@property (nonatomic, strong) NSString *shipLeaveTime;//离港时间
@property (nonatomic, strong) NSString *shipId;//轮船ID(下单使用)




//铁路
@property (nonatomic, strong) NSString *trainStartStation;//始发站
@property (nonatomic, strong) NSString *trainEndStation;//终点站
@property (nonatomic, strong) NSString *trainStartTime;//发车时间
@property (nonatomic, strong) NSString *trainEndTime;//接货截止日期
@property (nonatomic, copy) NSString *railwayId;//火车ID(下单使用)

@end
