//
//  AddressSearch.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AddressSearch : NSObject
+(AddressSearch *__nonnull)shareAddressSearch;

/**
 *  地理位置检索
 *
 *  @param keyword  检索关键字（不可空）
 *  @param city     在city内检索，传空位全国检索
 *  @param callback 回调，传回地址列表
 */
-(void)searchKeyword:(NSString *__nonnull)keyword withCity:(NSString *__nullable)city withCallback:(void (^__nullable)(NSArray<AMapPOI*>*__nullable pois,NSString *__nullable keyword))callback;
@end
