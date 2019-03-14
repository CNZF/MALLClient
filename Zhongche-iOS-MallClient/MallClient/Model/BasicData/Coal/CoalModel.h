//
//  CoalModel.h
//  MallClient
//
//  Created by lxy on 2017/10/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"


@interface CoalModel : BaseModel

/**
 *ash = 10;
 createTime = 1506758376000;
 deliveryAddress = "\U868c\U57e0";
 deliveryContract = 10;
 deliveryRegionCode = 340300;
 deliveryTel = 10;
 goodsId = 4;
 moisture = 10;
 name = "\U52a8\U529b\U7164";
 particleType = "VOLIT_25";
 particleTypeDesc = "20-50\U6beb\U7c73\U4e8c\U4e94\U5757\U7164";
 price = 200;
 priceType = SGP;
 priceTypeDesc = "\U5e93\U63d0\U4ef7";
 productionAddress = "\U5317\U4eac";
 productionContract = 10;
 productionRegionCode = 110100;
 productionTel = 10;
 qnet = 10;
 qty = 10;
 sku = 510010100101;
 spu = 5100101001;
 state = 1;
 sulfur = 10;
 type = DLM;
 volatilize = 10;

 */

@property (nonatomic, strong) NSString *ash;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *deliveryAddress;
@property (nonatomic, strong) NSString *deliveryContract;
@property (nonatomic, strong) NSString *deliveryRegionCode;
@property (nonatomic, strong) NSString *deliveryTel;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *moisture;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *particleType;
@property (nonatomic, strong) NSString *particleTypeDesc;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *priceTypeDesc;
@property (nonatomic, strong) NSString *qnet;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *spu;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *sulfur;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *volatilize;
@property (nonatomic, strong) NSString *productionAddress;
@property (nonatomic, strong) NSString *productionContract;
@property (nonatomic, strong) NSString *productionRegionCode;
@property (nonatomic, strong) NSString *productionTel;

@property (nonatomic, strong) NSString *ID;

@end
