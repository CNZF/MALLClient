//
//  OrderCenterViewModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/19.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "OrderModel.h"

typedef enum
{
    callOff = 0,//已取消
    needPayment,//待付款
    auditNotPass,//审核未通过
    needDelivery,//待发货
    needTakeDelivery,//待收货
    accomplish,//已完成
    allOrder,//全部
}OrderStatus;
@interface OrderCenterViewModel : BaseViewModel

- (void)getOrderWithType:(OrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr))callback;

@end
