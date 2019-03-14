//
//  AllDataSource.m
//  MallClient
//
//  Created by lxy on 2018/6/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AllDataSource.h"
#import "HasOrderCell.h"
#import <UIScrollView+MJRefresh.h>
#import "MessageViewModel.h"
#import "MessageModel.h"

@implementation AllDataSource

- (instancetype)initWithTarget:(id)target tableView:(UITableView *)tableView{
    if (self = [super init]) {
        self.target = target;
        self.tableView  = tableView;
        self.curPage = 1;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HasOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HasOrderCell class])];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 0;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return [UITableViewCell new];
    }else{
        HasOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HasOrderCell class]) forIndexPath:indexPath];
        cell.isEdite = self.isEdite;
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }
}


- (void)asyncWithMessageAllstatus:(int)status curPage:(int)curPage pageSize:(int)pageSize
{

    WS(weakSelf);
    [[MessageViewModel new] getUserMessageListWithType:status WithCurrentPage:curPage WithPageSize:pageSize callback:^(NSArray *arr, BOOL isLastPage) {

        if (curPage == 1) {
            weakSelf.dataArray = [[NSMutableArray alloc]initWithArray:arr];
        }else
        {
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1.0f];

            }else{
                [weakSelf.dataArray addObjectsFromArray:arr];
                if (arr.count>0 && self.isAllSelect) {
                    for (MessageModel *model in arr) {
                        model.isSelect = YES;
                    }
                    if (weakSelf.curttenPageDataBlcok) {
                        weakSelf.curttenPageDataBlcok(arr);
                    }
                }
            }
        }
        [weakSelf.tableView reloadData];
        if (weakSelf.allDataBlcok) {
            weakSelf.allDataBlcok(self.dataArray);
        }
       

    }];
}

@end
