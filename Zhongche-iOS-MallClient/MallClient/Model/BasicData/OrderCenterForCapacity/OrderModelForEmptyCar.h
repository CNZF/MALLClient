//
//  OrderModelForEmptyCar.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/5.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "EmptyCarModel.h"

/**
 *  brand = "\U4e1c\U98ce";
 buyNumber = "";
 companyName = "\U9e3f\U8f69\U96c6\U56e2";
 createTime = 1482992430000;
 endAddress = "\U6d4e\U5357";
 goodsName = "\U963f\U65af\U987f";
 id = 1;
 loginName = hxjt;
 orderCode = TSO2016122914203000000;
 orderStatus = "\U5df2\U53d6\U6d88";
 payablePrice = 12000;
 phone = 15678902345;
 photoUrl = "/emptyvehicle/1481915054188.jpg\U263c/emptyvehicle/1481915057347.jpg\U263c/emptyvehicle/1481915060110.jpg";
 regularCode = "";
 startAddress = "\U5317\U4eac";
 startDate = 1482940800000;
 transportType = VEHICLE;
 username = as;
 vehicleType = "\U8f7d\U8d27\U8f66";
 */

@interface OrderModelForEmptyCar : BaseModel
@property (nonatomic, copy)NSString *ID;//拉取运单详情使用  id
@property (nonatomic, copy)NSString *orderID;//订单号  orderCode
@property (nonatomic, copy)NSString *orderState;//订单状态  orderStatus
@property (nonatomic, copy)NSString *status;//订单状态

@property (nonatomic, copy)NSString *startParentAddress;
@property (nonatomic, copy)NSString *endParentAddress;
@property (nonatomic, copy)NSString *startPlace;//起运地  startAddress
@property (nonatomic, copy)NSString *endPlace;//,抵运地   endAddress
@property (nonatomic, copy)NSString *lineName;
@property (nonatomic, copy)NSString *transportType;//类运输型(公路/海运/铁路)transportType
@property (nonatomic, assign)TransportTypeEnum transportTypeEnum;
@property (nonatomic, copy)NSString *rentTime;//租用时间  startDate

@property (nonatomic, copy)NSString *details;//详情(公路:公司 铁路:班列:*** 海运:班轮:***) goodsName
@property (nonatomic, copy)NSString *phone;//联系电话  phone
@property (nonatomic, copy)NSString *price;//价格  payablePrice
@property (nonatomic, copy)NSString *buyNum;//购买数量 buyNumber
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, assign)id imgUrlList;


@property (nonatomic, copy)NSString * peopelName;//姓名  username  createUser
@property (nonatomic, copy)NSString * peopelPhone;//电话  contactsPhone
@property (nonatomic, copy)NSString * startAddress;//起运地 start_address
@property (nonatomic, copy)NSString * endAddress;//抵运地  end_address
@property (nonatomic, copy)NSString * goodsCode;//商品编号
@property (nonatomic, copy)NSString * linePrice;//线路价格  price
@property (nonatomic, copy)NSString * create_time;//下单时间  create_time
@property (nonatomic, copy)NSString * goodsName;//货品名字  goods_name
@property (nonatomic, copy)NSString * capacityBuyDate;//运力购买日期  create_time
@property (nonatomic, copy)NSString * seller;//卖家 //createUser
@property (nonatomic, copy)NSString * carNum;//车牌号 //plateNo
@property (nonatomic, copy)NSString * shipNum;//班轮号
@property (nonatomic, copy)NSString * openStorehouse;//开仓时间  open_wh_time
@property (nonatomic, copy)NSString * shipmentClosingDate;//截载时间   close_wh_time
@property (nonatomic, copy)NSString * leavePortDate;//离港时间 leave_date
@property (nonatomic, copy)NSString * trainsNum;//班列号
@property (nonatomic, copy)NSString * startingTime;//发车时间 send_date
@property (nonatomic, copy)NSString * abortDate;//接货截止日期 end_carriage_date

@property (nonatomic, strong)NSArray * orderProgress;


//弹框显示字段
@property (nonatomic, strong) NSString *driverName;//司机姓名
@property (nonatomic, strong) NSString *driverPhone;//司机电话

@property (nonatomic, strong) NSArray * matchCodeList;//仓号,车号

@end
