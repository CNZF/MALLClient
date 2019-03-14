//
//  CitySql.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "CitySqlModel.h"

@interface CitySql : NSObject

+(CitySql *)shareCitySql;
//查询全部省份
- (NSMutableArray *)selectAllProvincesData;
//查询下一级别城市
- (NSMutableArray *)selectTheNextCityDataWithCity:(CitySqlModel *)city;

@end
