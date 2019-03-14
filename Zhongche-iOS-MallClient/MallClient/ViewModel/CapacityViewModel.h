//
//  CapacityViewModel.h
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "GroupTransportationModel.h"
#import "BannerModel.h"
#import "ContainerModel.h"
#import "TicketsDetailModel.h"

@interface CapacityViewModel : BaseViewModel

/*
 * 需求申报<定制运力>接口 参数
 */
@property (nonatomic, assign) NSInteger containerId; // 箱型id
@property (nonatomic, assign) NSInteger containerNumber; // 箱数
@property (nonatomic, copy) NSString *businessTypeCode; // 运力类型 默认集装箱类型
@property (nonatomic, copy) NSString *contacts; // 联系人
@property (nonatomic, copy) NSString *contactsPhone; // 联系电话
@property (nonatomic, copy) NSString *startRegionName; // 起点name
@property (nonatomic, copy) NSString *startRegionCode; // 起点code
@property (nonatomic, copy) NSString *startContacts; // 起点联系人
@property (nonatomic, copy) NSString *startPhone; // 起点联系人电话
@property (nonatomic, copy) NSString *startAddress; // 起点详细地址
@property (nonatomic, copy) NSString *endRegionName; // 终点name
@property (nonatomic, copy) NSString *endRegionCode; // 终点code
@property (nonatomic, copy) NSString *endContacts; // 终点联系人
@property (nonatomic, copy) NSString *endPhone; // 终点联系人电话
@property (nonatomic, copy) NSString *endAddress; // 终点详细地址
@property (nonatomic, copy) NSString *estimateDepartureTime; // 预计发货时间

@property (nonatomic, copy) NSString *estimateDepartureTime_cus; // 预计发货时间
@property (nonatomic, copy) NSString *goodsCode; // 商品code
@property (nonatomic, assign) double weight; // 重量
@property (nonatomic, assign) double m3; // 总体积
@property (nonatomic, assign) NSInteger vehicleNum; // 台数
@property (nonatomic, copy) NSString *vehicleType; // 车辆类型
@property (nonatomic, assign) NSInteger wrapperNumber; // 包装件数量（单位：个）
@property (nonatomic, assign) double unitMaxWeight; // 最大单件重量
@property (nonatomic, assign) double unitMaxLength; // 最大单件长
@property (nonatomic, assign) double unitMaxWidth; // 最大单件宽
@property (nonatomic, assign) double unitMaxHigh; // 最大单件高
@property (nonatomic, copy) NSString *remark; // 备注
@property (nonatomic, copy) NSString *noGoodName; // 无搜索货品
@property (nonatomic, assign) BOOL isNoGoodSelect; // 无搜索货品
@property (nonatomic, copy) NSString *deliveryTypeCode; // 送货类型
@property (nonatomic, copy) NSString *serviceWay; // 送货方式、

@property (nonatomic, copy)NSString * shouPerson;
@property (nonatomic, copy)NSString * shouTel;
@property (nonatomic, copy)NSString * faPerson;
@property (nonatomic, copy)NSString * faTel;

/**
 *  集装箱运力搜索  todoby沙漠
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)containerSearchWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr,NSString * distance))callback;


/**
 *  获取运力票价格日历  todoby沙漠
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)requestPriceCalendaWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr))callback;

/**
 *  需求申报<定制运力>接口  todoby沙漠
 *
 *  @param type        类型
 *  @param callback    返回结果
 */
- (void)requestCustomTransportWithType:(kKNCustomFilterType)type  Model:(CapacityViewModel *)model callback:(void(^)(BOOL))callback;

/**
 *  获取搜索结果详情  todoby沙漠
 *  @param isSelect 是否是筛选
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)requestTickesByExpectTimeWithInfo:(CapacityEntryModel *)info isSelect:(BOOL)isSelect callback:(void(^)(NSArray *arr))callback;
/**
 *  获取集装箱型列表 todoby沙漠
 *
 *  @param callback 返回结果
 */
- (void)requestcontainerListCallback:(void(^)(NSArray *arr))callback;

/**
 *  根据条件动态查询订单价格  todoby沙漠
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */
- (void)requestOrderPriceDataWithInfo:(CapacityEntryModel *)info AndContainerModel:(ContainerModel *)containerModel  callback:(void(^)(PriceInfo *priceInfo))callback;

/**
 *  下单确认接口 todoby 沙漠
 *
 *  @param info     订单类参数
 *  @param callback 订单号
 */

- (void)makeSureOrderOfCapacityWithCapacityInfo:(CapacityEntryModel *)info TicketsDetailModel:(TicketsDetailModel*)model callback:(void(^)(NSString *orderNo))callback;


/**
 *  运力票搜索
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */

- (void)containerCapacitySearchWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr))callback;


/**
 *  轻运力票搜索
 *
 *  @param info     搜索条件
 *  @param callback 搜索结果
 */

- (void)lightcontainerCapacitySearchWithInfo:(CapacityEntryModel *)info callback:(void(^)(NSArray *arr))callback;


/**
 *  首页轮播
 *
 *  @param callback 结果
 */

- (void)getBannerCallback:(void(^)(NSArray *arr))callback;
/**
 *  推荐运力票
 *
 *  @param callback 结果
 */

- (void)getRecommendTicketsCallback:(void(^)(NSArray *arr))callback;

/**
 *  推荐运力票
 *
 *  @param callback 结果
 */
- (void)getRecommendStacksCallback:(void(^)(NSArray *arr))callback;

/**
 *  定制运力
 *
 *  @param info     运力定制模型
 *  @param callback 状态
 */

- (void)makeCapacityWthCapacityInfo:(CapacityEntryModel *)info callback:(void(^)(BOOL success))callback;

/**
 *  查询运力票起终点
 *
 *  @param ID       运力票ID
 *  @param callback 地点信息对象
 */

- (void)getCapacityAddressWthCapacityId:(NSString *)ID callback:(void(^)(ContactInfo *contactInfo))callback;

/**
 *  搜索快速配送路线
 *
 *  @param startCity 起运城市
 *  @param endCity   抵运城市
 */

-(void)selectQuickCapacityWithStartCity:(CityModel *)startCity WithEndCity:(CityModel *)endCity callback:(void(^)(NSArray *arr))callback;

@end
