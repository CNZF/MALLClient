//
//  EmptyCarLineModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface EmptyCarLineModel : BaseModel

@property (nonatomic, copy) NSString * ID;//线路id
@property (nonatomic, copy) NSString * startParentAddress;//起始城市名
@property (nonatomic, copy) NSString * endParentAddress;
@property (nonatomic, copy) NSString * startCity;
@property (nonatomic, copy) NSString * endCity;
@property (nonatomic, copy , readonly) NSString * lineStr;
@property (nonatomic, copy) NSString * price;

@end
