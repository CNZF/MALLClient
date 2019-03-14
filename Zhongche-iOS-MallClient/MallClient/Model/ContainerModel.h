//
//  ContainerModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface ContainerModel : BaseModel

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * imgurl;
@property (nonatomic, copy) NSString * certificationState;//认证状态
@property (nonatomic, copy) NSString * containerName;//集装箱类型
@property (nonatomic, copy) NSString * unitPrice;//单价
@property (nonatomic, copy) NSString * unit;//单位
@property (nonatomic, copy) NSString * cityName;//城市
@property (nonatomic, copy) NSString * inventory;//库存
@property (nonatomic, copy) NSString * authenticationStatus;//是否认证
@property (nonatomic, copy) NSString * companyName;//公司名
@property (nonatomic, copy) NSString * companyPhone;//公司电话
@property (nonatomic, copy) NSString * containerStatus;//箱子状态  -1:删除  0:待上架  \r\n1:待租   \r\n2:待售 \r\n3:已下架',
@property (nonatomic, copy) NSString * containerType;//箱子类型
@property (nonatomic, copy) NSString * deposit;//押金
@property (nonatomic, copy) NSString * loadWeight;
@property (nonatomic, copy) NSString * locationCode;
@property (nonatomic, copy) NSString * locationName;
@property (nonatomic, copy) NSString * manufactureDate;
@property (nonatomic, copy) NSString * material;
@property (nonatomic, copy) NSString * photoUrl;///container/1481913853269.jpg☼/container/1481913856865.jpg☼/container/1481913862015.jpg(☼分割)
@property (nonatomic, copy) NSString * rentPrice;//租金
@property (nonatomic, copy) NSString * returnType;
@property (nonatomic, copy) NSString * selfWeight;
@property (nonatomic, copy) NSString * storageNumber;
@property (nonatomic, copy) NSString * structure;
@property (nonatomic, copy) NSString * structureName;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * offsiteReturnBoxPrice;//异地还箱费
@property (nonatomic, copy) NSString * transportPrice;
@property (nonatomic, copy) NSString * address;

@end
