//
//  EmptyOrderModel.h
//  MallClient
//
//  Created by lxy on 2017/3/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "EmptyCarModel.h"
#import "GoodsInfo.h"

@interface EmptyOrderModel : BaseModel

@property (nonatomic, strong) EmptyCarModel *emptyCarInfo;//海陆空商品对象

//陆运
@property (nonatomic, strong) NSDate    *time;//陆运：运输时间

@property (nonatomic, strong) GoodsInfo *goodsInfo;//货品对象

@property (nonatomic, strong) NSString  *contactName;
@property (nonatomic, strong) NSString  *contactPhone;
@property (nonatomic, strong) NSString  *startAddress;
@property (nonatomic, strong) NSString  *endAddress;
@property (nonatomic, assign) int num;



@end
