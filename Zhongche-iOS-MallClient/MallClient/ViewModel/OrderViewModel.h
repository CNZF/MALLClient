//
//  OrderViewModel.h
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "OrderModelForCapacity.h"
#import "OrderModelForEmptyCar.h"
#import "OrderModelForEmptyContainer.h"
#import "SendOrderModel.h"
#import "OrderPayModel.h"
#import "BoxModel.h"

typedef enum
{
    callOff = 0,//已取消
    needPayment = 1,//待付款
    needDelivery = 3,//待发货
    needTakeDelivery = 4,//待收货
    accomplish = 5,//已完成
    allOrder = 6,//全部
    needConfirm = 7,//待确认
    needRefund = 8,//待退款
    needpayed = 9//待结算
}OrderStatus;

typedef enum
{
    DELETE = -1,//删除
    SOLD = 0,//已售完
    WAIT_PAY = 1,//待支付
    WAIT_AUDIT = 2,//待审核
    WAIT_TRANSPORT_CAPACITY_MATCH = 3,//待匹配运力
    WAIT_SIGN = 4,//代签收
    COMPLETED = 5,//已完成
    WAIT_REFUND_MONEY = 6,//待退款
    CANCEL = 7,//取消
    WAIT_ACCEPT_BOX = 8,//待收箱
    ALL = 100
}EmptyContainerOrderStatus;

typedef enum
{

    NeedPayment = 1,//待支付
    WaitCheck = 2,//待审核
    WAIT_DISPATCH = 3,//待调度
    WAIT_LOADING = 4,//待装载
    Accomplish = 5,//已完成
    CallOff = 7,//取消
    aLL = 100
}EmptyCarOrderStatus;

typedef enum
{


    //#define BUTTON_TITLES_Coal @[@"全部",@"待确定",@"已取消",@"待付款",@"待审核",@"待审核待审核",@"待收货",@"待结算",@"已完成"]
    coalCancle = -1,//已取消
    coalCertaining = 0,//待确定
    coalPaying = 1,//待付款
    coalConfirming = 2,//待审核
    coalSenting =3,//待审核
    coalReceiving = 4,//待收货
    coalEvaluating  =5,//待结算
    coalFish = 6,//已完成
    coalAll = 100//全部

}CoalOrderStatus;


@interface OrderViewModel : BaseViewModel



//=====================我要运力======================//

/**
 *  查询订单列表
 *
 *  @param type        类型
 *  @param currentPage 当前页
 *  @param pageSize    每页大小
 *  @param callback    订单数组
 */

- (void)getSaleOfCapacityOrderWithType:(OrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;
/**
 *  查询订单详情
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getSaleOfCapacityOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(OrderModelForCapacity *model))callback;

/**
 *  取消订单
 *
 *  @param orderId  订单ID
 *  @param callback 取消状态
 */

- (void)cancelSaleOfCapacityOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(NSString *str))callback;

/**
 *  提交订单
 *
 *  @param info     订单类
 *  @param callback 订单号
 */

- (void)SubmiteSaleOfCapacityOrderWthCapacityInfo:(CapacityEntryModel *)info callback:(void(^)(NSString *orderNo))callback;

/**
 *  查询订单价格
 *
 *  @param info     订单
 *  @param callback 价格对象
 */
- (void) getOrderPriceWithCapacityInfo:(CapacityEntryModel *)info callback:(void(^)(PriceInfo *priceInfo))callback;



//=====================空箱之家======================//

/**
 *  获取空箱之家订单列表
 *
 *  @param type        类型
 *  @param currentPage 当前页
 *  @param pageSize    分页每页尺寸
 *  @param callback    订单数组
 */

- (void)getEmptyContainerOrderWithType:(EmptyContainerOrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;

/**
 *  查询订单详情
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getEmptyContainerOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(OrderModelForEmptyContainer *model))callback;

/**
 *  订单操作
 *
 *  @param Id   订单ID
 *  @param type 操作方式
 */

-(void)emptyContainerOrderOperateWithOrderId:(NSString *)Id WithType:(EmptyContainerOrderStatus)type callback:(void(^)(NSString *str))callback;

//=====================空车之爱======================//

/**
 *  获取空箱之家订单列表
 *
 *  @param type        类型
 *  @param currentPage 当前页
 *  @param pageSize    分页每页尺寸
 *  @param callback    订单数组
 */

- (void)getEmptyCarOrderWithType:(EmptyCarOrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;

/**
 *  查询订单详情（空车之爱）
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getEmptyCarOrderDetailsWithOrderId:(NSString *)orderId WithType:(TransportTypeEnum)type callback:(void(^)(OrderModelForEmptyCar *model))callback;
/**
 *  订单操作
 *
 *  @param Id   订单ID
 *  @param type 操作方式
 *  @param transportType        类型 VEHICLE公路  RAILWAY铁路  SHIP轮船
 */

-(void)emptyCarOrderOperateWithOrderId:(NSString *)Id WithType:(EmptyCarOrderStatus)type WithTransportType:(TransportTypeEnum)transportType Withcallback:(void(^)(NSString *str))callback;

//=====================煤炭=====================//

- (void)getCoalOrderWithType:(CoalOrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;

/**
 *  查询订单详情（我要运力）
 *
 *  @param orderId  订单ID
 *  @param callback 订单详情
 */

- (void)getCoalOrderDetailsWithOrderId:(NSString *)orderId callback:(void(^)(OrderModelForCapacity *model))callback;

/**
 *  取消订单
 *
 *  @param orderId  订单ID
 */

-(void)cancleCoalOrderWithOrderId:(NSString *)orderId Withcallback:(void(^)(NSString *str))callback;


//查询发货批次列表
- (void)getSendOrderDetailsWithOrderId:(NSString *)orderId Type:(NSString *)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSMutableArray *arrayModel,BOOL isLastPage))callback;

//查询支付明细列表
- (void)getPayOrderDetailsWithOrderId:(NSString *)orderId Type:(NSString *)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSMutableArray *arrayModel,BOOL isLastPage))callback;
//装箱计算器
-(void)BoxNumberWithBoxId:(NSString *)orderId Withcallback:(void(^)(NSArray * boxModelArray))callback;
@end
