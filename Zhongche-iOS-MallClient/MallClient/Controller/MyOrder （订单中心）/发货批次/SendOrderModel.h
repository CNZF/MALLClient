//
//  SendOrderModel.h
//  MallClient
//
//  Created by lxy on 2018/6/11.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface SendOrderModel : BaseModel

@property (nonatomic, copy)NSString * businessTypeName;
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * container_id;
@property (nonatomic, copy)NSString * business_type_code;
@property (nonatomic, copy)NSString * code;
@property (nonatomic, copy)NSString * container_number;
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * create_time;
@property (nonatomic, copy)NSString * statusName;
@property (nonatomic, copy)NSString * containerName;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * estimate_departure_time;
@property (nonatomic, copy)NSString * reality_weight;//散堆装发货重量
@end
