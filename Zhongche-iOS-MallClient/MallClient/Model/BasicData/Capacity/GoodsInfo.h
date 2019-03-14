//
//  GoodsInfo.h
//  MallClient
//
//  Created by lxy on 2016/12/6.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsInfo : BaseModel

/**
 {
 "batchExpressGoods": 0,
 "code": "2040006",
 "createTime": 1471949939000,
 "createUserId": 1,
 "goodsCategoryId": 268,
 "id": 3102,
 "ltlPriceCode": 24,
 "name": "\U725b\U5976",
 "phoneticCode": "NN",
 "status": 1,
 "tlPriceCode": 6
 }
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSString *code;


//货品数据库使用字段
@property (nonatomic,assign)int use_number;
@property (nonatomic,copy) NSString * last_use_time;

@end
