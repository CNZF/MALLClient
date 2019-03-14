//
//  OrderModelForEmptyContainer.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/5.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

typedef enum{
    rentContainer,
    buyContainer
}TransactionTypeEnum;

@interface OrderModelForEmptyContainer : BaseModel

@property (nonatomic, copy  ) NSString            *ID;//拉取运单详情使用
@property (nonatomic, copy  ) NSString            *orderID;//订单号
@property (nonatomic, copy  ) NSString            *orderState;//订单状态statusName
@property (nonatomic, copy  ) NSString            *containerType;//集装箱类型
@property (nonatomic, copy  ) NSString            *orderType;//订单类型(购买或租赁)
@property (nonatomic, assign) TransactionTypeEnum orderTypeEnum;//订单类型
@property (nonatomic, copy  ) NSString            *startTime;//租赁起始时间
@property (nonatomic, copy  ) NSString            *endTime;
@property (nonatomic, copy  ) NSString            *companyName;//公司名
@property (nonatomic, copy  ) NSString            *phone;//联系电话（卖家）
@property (nonatomic, copy  ) NSString            *containerNum;//集装箱数量
@property (nonatomic, copy  ) NSString            *price;//价格(总金额)
@property (nonatomic, copy  ) NSString            *imgUrl;
@property (nonatomic, assign) id imgUrlList;
@property (nonatomic, copy  ) NSString            *createTime;//下单时间
@property (nonatomic, strong) NSArray             * orderProgress;//订单进展

@property (nonatomic, copy  ) NSString            *peopelName;//买家人姓名 buyerContactsName
@property (nonatomic, strong) NSString            *buyerContactsPhone;//买家phone
@property (nonatomic, copy  ) NSString            *buyersAddress;//收箱地  receiveAddress
@property (nonatomic, copy  ) NSString            *sellerAddress;//还箱地 givebackAddress
@property (nonatomic, copy  ) NSString            *containerPrice;//箱子金额  payable
@property (nonatomic, copy  ) NSString            *rentPrice;//租金  rentPrice
@property (nonatomic, strong  ) NSString            *rentdays;//租期(几天)
@property (nonatomic, copy  ) NSString            *mortgage;//押金  depositPrice
@property (nonatomic, copy  ) NSString            *giveBackPrice;//异地还箱 offsiteReturnBoxPrice
@property (nonatomic, assign) int                 containerState;//箱况 containerState NEW_CONTAINER(1, "新造箱"), INTACT_CONTAINER(2, "完好在用箱"), SLIGHTLY_INCLUDED_CONTAINER(3, "轻微瑕疵在用箱"), DAMAGE_CONTAINER(4, "破损在用箱");
@property (nonatomic, copy  ) NSString            *containerCondition;//箱况
@property (nonatomic, copy  ) NSString            *goodsCode;//商品编号 containerOrderCode
@property (nonatomic, strong) NSString            *startDate;
@property (nonatomic, strong) NSString            *endDate;

@property (nonatomic, strong) NSArray            *arrOrderContainerCode;


/**
 *  containerOrderDetail =     {
 buyerContactsName = "\U674e\U96ea\U9633";
 buyerContactsPhone = "177-1048-3021";
 containerOrderCode = CO2017040110232800000;
 containerOrderId = 25;
 containerState = 1;
 containerType = "20\U82f1\U5c3a\U901a\U7528\U96c6\U88c5\U7bb1";
 createTime = 1491013408000;
 depositPrice = 500;
 endDate = 1491128536000;
 givebackAddress = "\U5317\U4eac\U5e02\U5317\U4eac\U5e02";
 goodsCode = CRS2017032717363600002;
 number = 1;
 offsiteReturnBoxPrice = 50;
 orderProcess =         (
 );
 payable = 550;
 photoUrl = "/container/1490607390301.png";
 rentPrice = 1000;
 saleTypeCode = "CONTAINER_RENTSALE_TYPE_RENT";
 sellerName = "\U60c5\U4eba\U8282\U6d4b\U8bd5";
 sellerPhone = 18810325947;
 startDate = 1491042136000;
 status = 7;
 */
@end
