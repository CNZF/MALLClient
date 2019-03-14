//
//  ReadDataSource.h
//  MallClient
//
//  Created by lxy on 2018/6/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReadDataBlock)(NSArray * ReadDataArray);
typedef void(^AllCurttenPageDataBlock)(NSArray * curttenArray);

@interface ReadDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) BOOL isEdite;
@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * deleteArray;
@property (nonatomic, assign) BOOL hasRefresh;
@property (nonatomic, copy) ReadDataBlock readDataBlock;
@property (nonatomic, copy) AllCurttenPageDataBlock curttenPageDataBlcok;
@property (nonatomic, assign) int curPage;

- (instancetype)initWithTarget:(id)target tableView:(UITableView *)tableView;
- (void)asyncWithMessageAllstatus:(int)status curPage:(int)curPage pageSize:(int)pageSize;

@end
