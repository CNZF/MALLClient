//
//  AllDataSource.h
//  MallClient
//
//  Created by lxy on 2018/6/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoDataView.h"

typedef void(^AllDataBlock)(NSArray * AllDataArray);
typedef void(^AllCurttenPageDataBlock)(NSArray * curttenArray);

@interface AllDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) BOOL isEdite;
@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * deleteArray;
@property (nonatomic, assign) BOOL hasRefresh;//第一次点击后刷新，在此以后上下拉刷新
@property (nonatomic, copy) AllDataBlock allDataBlcok;
@property (nonatomic, copy) AllCurttenPageDataBlock curttenPageDataBlcok;
@property (nonatomic, assign) int curPage;

- (instancetype)initWithTarget:(id)target tableView:(UITableView *)tableView;

- (void)asyncWithMessageAllstatus:(int)status curPage:(int)curPage pageSize:(int)pageSize;

@end
