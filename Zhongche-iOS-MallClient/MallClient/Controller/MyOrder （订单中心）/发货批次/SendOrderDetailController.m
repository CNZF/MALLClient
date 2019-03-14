//
//  SendOrderDetailController.m
//  MallClient
//
//  Created by lxy on 2018/6/10.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "SendOrderDetailController.h"
#import <UIScrollView+MJRefresh.h>
#import "SendOrderCell.h"
#import "OrderViewModel.h"
#import "OrderModelForCapacity.h"
#import "SendNoDataView.h"

#define PAGE_SIZE_NUM  20
#define NotiDetailModel @"kNotiDetailModel"

@interface SendOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) OrderModelForCapacity * model;
@property (nonatomic, strong) NSMutableArray * resultArray;
@property (nonatomic, strong)MJRefreshHeader  * mj_header;
@property (nonatomic, strong)MJRefreshFooter  * mj_footer;
@property (nonatomic, assign)int              currentPage;
@property (nonatomic, strong)SendNoDataView  * noDataView;
@end
//SendOrderDetailController_ALL SendOrderDetailController_WaitSend  SendOrderDetailController_OnLoad  SendOrderDetailController_HadSend
@implementation SendOrderDetailController
@dynamic dataArray;

-(instancetype)init {
    if (self = [super init]) {
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
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

- (void)asyncDetailDate
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendOrderCell class]) forIndexPath:indexPath];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////
//    SendOrderModel * model;
//    if (self.resultArray.count) {
//       model = self.resultArray[indexPath.row];
//    }
//
//    if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {
//        return 96.0f;
//    }else{
//        return UITableViewAutomaticDimension;
//    }
//}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_W, SCREEN_H - kNavBarHeaderHeight - 40) style:UITableViewStylePlain];
        _tableView.backgroundColor = APP_COLOR_WHITEBG;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 150.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SendOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SendOrderCell class])];
    }
    return _tableView;
}

- (SendNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SendNoDataView class]) owner:self options:nil] firstObject];
        _noDataView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight  -40);
    }
    return _noDataView;
}




@end

//全部
@implementation SendOrderDetailController_ALL

- (void)asyncDetailDate
{
    WS(ws);

    [[OrderViewModel new] getSendOrderDetailsWithOrderId:self.model.ID Type:@"" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
        
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

//待发货
@implementation SendOrderDetailController_WaitSend


- (void)asyncDetailDate
{
    WS(ws);
    
    [[OrderViewModel new] getSendOrderDetailsWithOrderId:self.model.ID Type:@"3" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
        
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


@implementation SendOrderDetailController_OnLoad

//在途
- (void)asyncDetailDate
{
    WS(ws);
    
    [[OrderViewModel new] getSendOrderDetailsWithOrderId:self.model.ID Type:@"4" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
        
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

//已交付

@implementation SendOrderDetailController_HadSend

- (void)asyncDetailDate
{
    WS(ws);
    
    [[OrderViewModel new] getSendOrderDetailsWithOrderId:self.model.ID Type:@"5" WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSMutableArray *arrayModel, BOOL isLastPage) {
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
