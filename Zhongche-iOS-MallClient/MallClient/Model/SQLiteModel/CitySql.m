//
//  CitySql.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "CitySql.h"

//定义一个静态变量用于接收实例对象，初始化为nil
static CitySql * citySql = nil;
@interface CitySql ()

@property (nonatomic,retain)FMDatabase * database;

@end
@implementation CitySql

+(CitySql *)shareCitySql{
    @synchronized(self){//线程保护，增加同步锁
        if (citySql ==nil ) {
            citySql = [[self alloc] init];
        }
    }
    return citySql;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        [self createSqliteAndTable];
    }
    return self;
}

//创建数据库和表
- (void)createSqliteAndTable {
    //数据库路径
    NSString * sqlitePath = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"db"];
    
    _database = [[FMDatabase alloc]initWithPath:sqlitePath];
    if (_database.open == NO)
    {
        NSLog(@"创建数据库失败");
        return ;
    }
//    NSString * createTablestr = @"CREATE TABLE IF NOT EXISTS t_region(id int,code varchar(50),name varchar(40),level int,parent_code varchar(50),full_name varchar(100),geo_area varchar(100),center_lat varchar(),center_lng varchar())";
//    if ([_database executeUpdate:createTablestr] == NO)
//    {
//        NSLog(@"创建表失败");
//    }
//    else
//    {
//        NSLog(@"创建表成功");
//    }
}

//查找省份数据(按code排序)
- (NSMutableArray *)selectAllProvincesData {
    NSString * selectSql = @"SELECT * FROM t_region WHERE level = ? ORDER BY code ";
    FMResultSet * set = [_database executeQuery:selectSql,@"1"];
    NSMutableArray * provincesArray = [NSMutableArray array];
    CitySqlModel * cityData;
    
    while ([set next])
    {
        cityData             = [[CitySqlModel alloc]init];
        cityData.ID          = [set intForColumn:@"id"];
        cityData.level       = [set intForColumn:@"level"];
        cityData.code        = [set stringForColumn:@"code"];
        cityData.name        = [set stringForColumn:@"name"];
        cityData.parent_code = [set stringForColumn:@"parent_code"];
        cityData.full_name   = [set stringForColumn:@"full_name"];
        cityData.geo_area    = [set stringForColumn:@"geo_area"];
        cityData.center_lat  = [set stringForColumn:@"center_lat"];
        cityData.center_lng  = [set stringForColumn:@"center_lng"];

        [provincesArray addObject:cityData];
        cityData = nil;
    }
    return provincesArray;
}

- (NSMutableArray *)selectTheNextCityDataWithCity:(CitySqlModel *)city {
    NSString * selectSql = @"SELECT * FROM t_region WHERE parent_code = ? ORDER BY code ";
    FMResultSet * set = [_database executeQuery:selectSql,city.code];
    NSMutableArray * cityArray = [NSMutableArray array];
    CitySqlModel * cityData;
    
    while ([set next])
    {
        cityData = [[CitySqlModel alloc]init];
        cityData.ID = [set intForColumn:@"id"];
        cityData.level = [set intForColumn:@"level"];
        cityData.code    = [set stringForColumn:@"code"];
        cityData.name    = [set stringForColumn:@"name"];
        cityData.parent_code    = [set stringForColumn:@"parent_code"];
        cityData.full_name    = [set stringForColumn:@"full_name"];
        cityData.geo_area    = [set stringForColumn:@"geo_area"];
        cityData.center_lat    = [set stringForColumn:@"center_lat"];
        cityData.center_lng    = [set stringForColumn:@"center_lng"];
        
        [cityArray addObject:cityData];
        cityData = nil;
    }
    return cityArray;
}

@end
