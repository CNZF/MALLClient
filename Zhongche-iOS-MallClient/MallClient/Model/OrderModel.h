//
//  OrderModel.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderProgressModel.h"
#import "InvoiceModel.h"
#import "PaymentFlowModel.h"

@interface OrderModel : BaseTableViewCell

@property (nonatomic, copy)NSString *ID;//拉取运单详情使用
@property (nonatomic, copy)NSString *orderID;//订单号
@property (nonatomic, copy)NSString *ordetType;//订单类型
@property (nonatomic, copy)NSString *capacityType;//运力类型
@property (nonatomic, copy)NSString *startPlace;//起运地
@property (nonatomic, copy)NSString *endPlace;//抵运地
@property (nonatomic, copy)NSString *goodsName;//货品名称
@property (nonatomic, copy)NSString *goodsNum;//货品数量
@property (nonatomic, copy)NSString *price;//价格
@property (nonatomic, copy)NSString *weight;//重量
@property (nonatomic, copy)NSString *volume;//体积

@property (nonatomic, copy)NSString *imgUrl;

@property (nonatomic, copy)NSString * startpName;//起始地联系人姓名
@property (nonatomic, copy)NSString * startpPhone;//起始地联系人电话
@property (nonatomic, copy)NSString * startaddress;//起始地址 详细
@property (nonatomic, copy)NSString * endpName;//抵运联系人姓名
@property (nonatomic, copy)NSString * endpPhone;//抵运联系人电话
@property (nonatomic, copy)NSString * endaddress;//抵运地址

@property (nonatomic, copy)NSString * startTime;//发货时间
@property (nonatomic, copy)NSString * endTime;//预计抵达时间

@property (nonatomic, copy)NSString * serviceType;//服务方式
@property (nonatomic, copy)NSString * autonomousBoxNum;//自备箱数量provide
@property (nonatomic, copy)NSString * boxNum;//箱子数量----->货品数量
@property (nonatomic, copy)NSString * note;//备注信息
@property (nonatomic, copy)NSString * doorToDoorPrice;//运费
@property (nonatomic, copy)NSString * pointToPointPrice;//点到点运费
@property (nonatomic, copy)NSString * insurancePrice;//保险费
@property (nonatomic, copy)NSString * allPrice;//费用合计------>价格
@property (nonatomic, copy)NSString * payTypeCode;
@property (nonatomic, copy)NSString * placeTheOrderTime;//下单时间

@property (nonatomic, strong)InvoiceModel * invoice_0;//用于判断发票有无


@property (nonatomic, strong)NSArray * orderProgress;//订单进展
@property (nonatomic, strong)NSArray * paymentFlow;//支付流水
//付费信息
@property (nonatomic, copy)NSString * paidPrice;//已付
@property (nonatomic, copy)NSString * unconfirmedPrice;//待付


//网点信息
@property (nonatomic, copy)NSString * endEntrepotAddress;
@property (nonatomic, copy)NSString * endEntrepotName;
@property (nonatomic, copy)NSString * startEntrepotAddress;
@property (nonatomic, copy)NSString * startEntrepotName;

@property (nonatomic, copy)NSString * endEntrepotNameStr;
@property (nonatomic, copy)NSString * startEntrepotNameStr;

//上门取货and送货上门
@property (nonatomic, copy)NSString * pickupPrice;//上门取货费
@property (nonatomic, copy)NSString * deliveryPrice;//送货上门费
@end
