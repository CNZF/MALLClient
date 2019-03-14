//
//  ContainerViewModel.h
//  MallClient
//
//  Created by lxy on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "ContainerTypeModel.h"
#import "CapacityEntryModel.h"
#import "GoodsInfo.h"
#import "TransportationModel.h"
#import "AddressInfo.h"
#import "CapacityEntryModel.h"
#import "ContactInfo.h"
#import "InvoiceModel.h"
#import "PriceInfo.h"
#import "AddressSearch.h"

@interface ContainerViewModel : BaseViewModel

/**
 *  获取箱型
 *
 *  @param callback 箱型数组
 */

- (void)getContainerTypecallback:(void(^)(NSArray *arr))callback;

/**
 *  货品联想搜索
 *
 *  @param keyWords 关键字
 *  @param callback 搜索结果
 */

- (void)getGoodsWithKeyWords:(NSString *)keyWords callback:(void(^)(NSArray *arr,NSString *keywords))callback ;


@end
