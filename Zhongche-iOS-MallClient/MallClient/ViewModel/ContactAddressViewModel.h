//
//  ContactAddressViewModel.h
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "AddressSearch.h"
#import "AddressInfo.h"

@interface ContactAddressViewModel : BaseViewModel

/**
 *  添加地址
 *
 *  @param name    联系人姓名
 *  @param phone   手机号
 *  @param address 地址
 *  @param code    城市code
 *  @param type    1、起始地 2、抵运地
 */

- (void)addAddressWithName:(NSString *)name WithPhone:(NSString *)phone WithAddress:(AMapPOI *)address WithCityCode:(NSString *)code WithType:(NSString *)type callback:(void(^)(NSString *status))callback;

/**
 *  修改地址
 *
 *  @param name    联系人姓名
 *  @param phone   手机号
 *  @param address 地址
 *  @param code    城市code
 *  @param ID      联系方式ID
 */

- (void)updateAddressWithName:(NSString *)name WithPhone:(NSString *)phone WithAddress:(AMapPOI *)address WithCityCode:(NSString *)code WithId:(NSString *)ID callback:(void(^)(NSString *status))callback;


/**
 *  搜索地址
 */

- (void)selectAddressWithType:(NSString *)type callback:(void(^)(NSArray *arr))callback;
/**
 *  删除地址
 */

- (void)delegateAddressWithType:(NSString *)type IdArray:(NSArray *)idArray callback:(void(^)(BOOL ret))callback;
@end
