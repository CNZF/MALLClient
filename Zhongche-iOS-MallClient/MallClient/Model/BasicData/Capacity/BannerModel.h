//
//  BannerModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/5/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel : BaseModel

@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * needForward;//是否跳转
@property (nonatomic, copy)NSString * forwardType;//跳转类型（native跳转，web跳转）
@property (nonatomic, copy)NSString * forwardPath;//跳转路径
@property (nonatomic, copy)NSString * order;
@property (nonatomic, copy)NSString * title;//标题
@property (nonatomic, copy)NSString * typeCode;//图片类型（banner、闪屏广告图等）
@property (nonatomic, copy)NSString * url;//图片地址（url）

@end
