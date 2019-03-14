//
//  GoodsHistorySql.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/7.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "GoodsInfo.h"

@interface GoodsHistorySql : NSObject
+(GoodsHistorySql *)shareGoodsHistorySqlite;
/**
 *  添加记录
 */
- (void)increaseOneGoodsData:(GoodsInfo *)data;
/**
 *  删除data数据字段
 */
- (void)deleteOneGoodsData:(GoodsInfo *)data;
/**
 *  查找表 结果按时间排序
 *
 *  @return OrderModel列表数组
 */
- (NSMutableArray *)selectAllGoodsData;
//查找数据某一数据是否存在 不存在 返回nil
-(id)selectGoodsData:(GoodsInfo *)data;
@end
