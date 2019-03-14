//
//  GoodsHistorySql.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/7.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "GoodsHistorySql.h"

//定义一个静态变量用于接收实例对象，初始化为nil
static GoodsHistorySql * goodsHistorySqlite = nil;
@interface GoodsHistorySql ()

@property (nonatomic,retain)FMDatabase * database;

@end

@implementation GoodsHistorySql


+(GoodsHistorySql *)shareGoodsHistorySqlite{
    @synchronized(self){//线程保护，增加同步锁
        if (goodsHistorySqlite ==nil ) {
            goodsHistorySqlite = [[self alloc] init];
        }
    }
    return goodsHistorySqlite;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createSqliteAndTable];
    }
    return self;
}


//创建数据库和表
- (void)createSqliteAndTable
{
    //数据库路径
    NSString * sqlitePath = [NSString stringWithFormat:@"%@/GoodsHistorySql.db",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    _database = [[FMDatabase alloc]initWithPath:sqlitePath];
    if (_database.open == NO)
    {
        NSLog(@"创建数据库失败");
        return ;
    }
    NSString * createTablestr = @"CREATE TABLE IF NOT EXISTS OrderInformation(use_number int,last_use_time varchar(20),ID varchar(20),name varchar(20))";
    if ([_database executeUpdate:createTablestr] == NO)
    {
        NSLog(@"创建表失败");
    }
    else
    {
        NSLog(@"创建表成功");
    }
}
//添加数据
- (void)increaseOneGoodsData:(GoodsInfo *)data
{
    NSString * insertSql = @"INSERT INTO OrderInformation(use_number,last_use_time,ID,name) values(?,?,?,?)";
    if([self selectGoodsData:data])
    {
        data = [self selectGoodsData:data];
        [self deleteOneGoodsData:data];
    }
    else
    {
        data.use_number = 0;
    }
    data.use_number ++;
    BOOL isSuc           = [_database executeUpdate:insertSql,[NSString stringWithFormat:@"%d",data.use_number],[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],data.ID,data.name];
    if (isSuc == NO)
    {
        NSLog(@"增加失败");
    }
    else
    {
        NSLog(@"增加成功");
    }
}
//删除数据
- (void)deleteOneGoodsData:(GoodsInfo *)data
{
    NSString * deleteSql = @"DELETE FROM OrderInformation WHERE ID = ?";
    BOOL isSuc = [_database executeUpdate:deleteSql,data.ID];
    if (isSuc == NO)
    {
        NSLog(@"删除失败");
    }
    else
    {
        NSLog(@"删除成功");
    }
}

//查找全部数据(按开始时间排序)
- (NSMutableArray *)selectAllGoodsData
{
    NSString * selectSql = @"SELECT * FROM OrderInformation ORDER BY last_use_time DESC";
    FMResultSet * set = [_database executeQuery:selectSql];
    NSMutableArray * OrderDataArray = [NSMutableArray array];
    GoodsInfo * orderData;
    
    while ([set next])
    {
        orderData                         = [[GoodsInfo alloc]init];
        orderData.use_number = [set intForColumn:@"use_number"];
        orderData.last_use_time    = [set stringForColumn:@"last_use_time"];
        
        orderData.ID    = [set stringForColumn:@"ID"];
        orderData.name    = [set stringForColumn:@"name"];
        
        [OrderDataArray addObject:orderData];
        orderData = nil;
    }
    return OrderDataArray;
}
//查找数据某一数据是否存在 不存在 返回nil
-(id)selectGoodsData:(GoodsInfo *)data
{
    NSString * selectSql = @"SELECT * FROM OrderInformation WHERE ID = ?";
    FMResultSet * set = [_database executeQuery:selectSql,data.ID];
    GoodsInfo * orderData = nil;
    while ([set next])
    {
        orderData                         = [[GoodsInfo alloc]init];
        orderData.use_number = [set intForColumn:@"use_number"];
        orderData.last_use_time    = [set stringForColumn:@"last_use_time"];
        
        orderData.ID    = [set stringForColumn:@"ID"];
        orderData.name    = [set stringForColumn:@"name"];
    }
    return orderData;
}
@end

