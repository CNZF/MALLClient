//
//  OrderPayDetailContentController.m
//  MallClient
//
//  Created by lxy on 2018/6/10.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderPayDetailContentController.h"
#import "OrderPayDetailCell.h"
#import <UIScrollView+MJRefresh.h>
#import "OrderModelForCapacity.h"
#import "OrderViewModel.h"
#import "SendNoDataView.h"

#define PAGE_SIZE_NUM  20

@interface OrderPayDetailContentController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)OrderModelForCapacity * model;
@property (nonatomic, assign)int              currentPage;
@property (nonatomic, strong) NSMutableArray * resultArray;
@property (nonatomic, strong)MJRefreshHeader  * mj_header;
@property (nonatomic, strong)MJRefreshFooter  * mj_footer;
@property (nonatomic, strong)SendNoDataView  * noDataView;
@end



@implementation OrderPayDetailContentController

-(instancetype)init {
    if (self = [super init]) {
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.model = app.model;
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self asyncDetailDate];
    }];
    self.tableView.mj_header = self.mj_header;
    [self.mj_header beginRefreshing];
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self asyncDetailDate];
    }];
    self.tableView.mj_footer = self.mj_footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)asyncDetailDate
{
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPayDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderPayDetailCell class]) forIndexPath:indexPath];
    cell.model = self.resultArray[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.resultArray.count<1 && self.resultArray!=nil) {
        return self.noDataView;
    }else{
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.resultArray.count<1 && self.resultArray!=nil) {
        return SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight -44;
    }else{
        return 1;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_W, SCREEN_H - kNavBarHeaderHeight - 40) style:UITableViewStylePlain];
        _tableView.backgroundColor = APP_COLOR_WHITEBG;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 170.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderPayDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderPayDetailCell class])];
    }
    return _tableView;
}
- (SendNoDataView * )noDataView
{
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SendNoDataView class]) owner:self options:nil] firstObject];
        _noDataView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight  -40);
        _noDataView.noLabel.text = @"暂无支付明细";
    }
    return _noDataView;
}

@end

@implementation OrderPayDetailContentController_ALL

- (void)asyncDetailDate
{
    WS(ws);
    
    [[OrderViewModel new] getPayOrderDetailsWithOrderId:self.model.ID Type:@"" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
        
        if (ws.currentPage == 1) {
            ws.resultArray = [[NSMutableArray alloc]initWithArray:arrayModel];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1.0f];
            }else{
                [ws.resultArray addObjectsFromArray:arrayModel];
            }
        }
        [ws.tableView reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
}

@end

//线上支付
@implementation OrderPayDetailContentController_OnLine

- (void)asyncDetailDate
{
    WS(ws);
    
    [[OrderViewModel new] getPayOrderDetailsWithOrderId:self.model.ID Type:@"1" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
        
        if (ws.currentPage == 1) {
            ws.resultArray = [[NSMutableArray alloc]initWithArray:arrayModel];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1.0f];
            }else{
                [ws.resultArray addObjectsFromArray:arrayModel];
            }
        }
        [ws.tableView reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
}

@end

//线下支付
@implementation OrderPayDetailContentController_Nomal

- (void)asyncDetailDate
{
    WS(ws);
    
    [[OrderViewModel new] getPayOrderDetailsWithOrderId:self.model.ID Type:@"2" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
        
        if (ws.currentPage == 1) {
            ws.resultArray = [[NSMutableArray alloc]initWithArray:arrayModel];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1.0f];
            }else{
                [ws.resultArray addObjectsFromArray:arrayModel];
            }
        }
        [ws.tableView reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
}


@end



