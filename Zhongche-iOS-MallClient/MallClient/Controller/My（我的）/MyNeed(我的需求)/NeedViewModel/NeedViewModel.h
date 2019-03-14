//
//  NeedViewModel.h
//  MallClient
//
//  Created by lxy on 2018/9/11.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"

@interface NeedViewModel : BaseViewModel

/**
 *  查询需求列表
 *
 *  @param retrieveModel  检索条件
 *  @param callback    订单数组
 */

-(void)getEmptyContainerArrWith:(NSString *)userId Page:(int)page limite:(int)limite callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;

@end
