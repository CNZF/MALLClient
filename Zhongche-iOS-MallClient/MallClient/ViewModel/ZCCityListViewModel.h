//
//  ZCCityListViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "CapacityEntryModel.h"

@interface ZCCityListViewModel : BaseViewModel

/**
 *  拉取城市列表
 *
 *  callback
 */
-(void)getCityListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback;


/**
 *  拉取网点城市列表
 *
 *  callback
 */
-(void)getCityAndBranchesListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback;

/**
 *  拉取网点、城市列表
 *
 */
-(void)getQuickCityAndBranchesListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback;
@end
