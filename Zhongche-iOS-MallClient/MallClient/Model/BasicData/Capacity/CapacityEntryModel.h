//
//  CapacityEntryModel.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/30.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "CityModel.h"
#import "ContainerTypeModel.h"
#import "GoodsInfo.h"
#import "PackagingTypeModel.h"
#import "ContactInfo.h"

#import "TransportationModel.h"
#import "PriceInfo.h"
#import "invoiceModel.h"

@interface CapacityEntryModel : BaseModel<NSCopying>

/*
 *运力票检索条件
 */

@property (nonatomic, strong) NSString            *noGoodsName;//没有搜到货品后

@property (nonatomic, strong) GoodsInfo           *goodsInfo;//货品
@property (nonatomic, copy  ) NSString            *capacityType;//运力类型
@property (nonatomic, strong) NSString            *businessTypeCode;//运力类型code(网络请求)
@property (nonatomic, strong) CityModel           *startPlace;//起运地
@property (nonatomic, strong) CityModel           *endPlace;//抵运地
@property (nonatomic, strong) ContainerTypeModel   *box;//箱型
@property (nonatomic, strong) NSDate              *shipmentsTime;//发货时间
@property (nonatomic, strong) NSString            *stStartTime;
@property (nonatomic, strong) NSDate              *latestShipmentsTime;//最晚发货时间
@property (nonatomic, strong) NSString            *stLatestShipmentsTime;

@property (nonatomic, assign) int transport_minimum;//最低起运箱数

@property (nonatomic, copy  ) NSString            *biggestWeight;//最大单件重量(大件运力)
@property (nonatomic, copy  ) NSString            *longCm;//最大单件尺寸
@property (nonatomic, copy  ) NSString            *wideCm;
@property (nonatomic, copy  ) NSString            *highCm;
@property (nonatomic, strong) PackagingTypeModel  * packagingType;//包装类型
@property (nonatomic, copy  ) NSString            *weight;//重量(批量成件运力)
@property (nonatomic, copy  ) NSString            *volume;//体积

@property (nonatomic, copy  ) NSString            *vehicleBrand;//车辆品牌
@property (nonatomic, copy  ) NSString            *vehicleType;//车辆类型
@property (nonatomic, strong) NSString            *ticketType;

@property (nonatomic, strong) NSDate              *startDate; //请求开始时间
@property (nonatomic, strong) NSDate              *endDate; //请求结束时间
@property (nonatomic, copy) NSString * goodsCode;
/*
 *定制运力
 */
@property (nonatomic, copy  ) NSString            * isPackaging;//是否包装
@property (nonatomic, strong) NSNumber            * wrapper;//是否包装（0 否、1是）
@property (nonatomic, copy  ) NSString            * serviceWay;//服务方式
@property (nonatomic, strong) NSString            * deliveryTypeCode;//服务方式code(网络请求)
@property (nonatomic, copy  ) NSString            * isOwnBox;//是否自备箱
@property (nonatomic, strong) NSNumber            * provide;//是否自备箱（0 否、1是）
@property (nonatomic, copy  ) NSString            * boxNum;//箱子数量
@property (nonatomic, copy  ) NSString            * totalWeight;//总重量
@property (nonatomic, copy  ) NSString            * number;//件数(冷链)
@property (nonatomic, copy  ) NSString            * goodsNum;//货品数量(批量)
@property (nonatomic, copy  ) NSString            * volume_Custom;//体积(散装堆_定制运力)
@property (nonatomic, copy  ) NSString            * carNum;//辆数
@property (nonatomic, copy  ) NSString            * pName;//联系人姓名
@property (nonatomic, copy  ) NSString            * pPhone;//联系人电话


/*
 * 提交订单流程使用
 */
@property (nonatomic, strong) TransportationModel *transportationModel;//运力票Model

@property (nonatomic, strong) InvoiceModel        *invoice;//发票;

@property (nonatomic, strong) ContactInfo         *contactInfo;//联系方式
@property (nonatomic, strong) PriceInfo           *priceInfo;//订单价格
@property (nonatomic, strong) NSString            *carryGoodsTime;//取货时间
@property (nonatomic, strong) NSString            *payStyle; //支付类型
@property (nonatomic, strong) NSString            *remark;
@property (nonatomic, copy) NSString            *price;//首页推荐运力用


/*
 * 推荐运力票 接收字段
 *
 */
@property (nonatomic, copy) NSString *departureTime;
@property (nonatomic, copy) NSString *endName;
@property (nonatomic, copy) NSString *endRegionCode;
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, copy) NSString *startRegionCode;
@property (nonatomic, copy) NSString *lineType;//箱型

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *mileage; //距离

@property (nonatomic, copy) NSString *startEntrepotId;
@property (nonatomic, copy) NSString *endEntrepotId;

@property (nonatomic, copy) NSString *km;

@property (nonatomic, copy) NSString *lineTypeChoose;
@property (nonatomic, copy) NSString * line_fix_price;
@property (nonatomic, copy) NSString * line_base_price;

//推荐散堆装运力票接收字段

@property (nonatomic, copy) NSString * create_user_id;
@property (nonatomic, copy) NSString * endRegionName;
@property (nonatomic, copy) NSString * end_entrepot_id;
@property (nonatomic, copy) NSString * end_region_code;
@property (nonatomic, copy) NSString * expect_time;
@property (nonatomic, copy) NSString * goodName;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * ID;
//@property (nonatomic, copy) NSString * mileage;
//@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * startRegionName;
@property (nonatomic, copy) NSString * start_entrepot_id;
@property (nonatomic, copy) NSString * start_region_code;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * transport_type;
//@property (nonatomic, copy) NSString * weight;
@end
