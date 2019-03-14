//
//  EmptyWayModel.h
//  MallClient
//
//  Created by lxy on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//


//公路详情对象

#import "BaseModel.h"

@interface EmptyWayModel : BaseModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;//车子名字
@property (nonatomic, strong) NSString *price;//车子价格
@property (nonatomic, assign) BOOL     isSign;//是否认证
@property (nonatomic, strong) NSString *goodsNum;//商品编号
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) NSArray  *arrRouts;//线路数组

@property (nonatomic, strong) NSString *carNum;//车牌号
@property (nonatomic, strong) NSString *carCarryWeight;//载重量
@property (nonatomic, strong) NSString *produceYear;//出厂年份

@property (nonatomic, strong) NSString *capacityMessage;//运力信息
@property (nonatomic, strong) NSString *sellerCompany;//卖家公司
@property (nonatomic, strong) NSString *sellerPhone;//卖家电话

@property (nonatomic, strong) NSArray *imgArr;//轮播图图片url;


@end
