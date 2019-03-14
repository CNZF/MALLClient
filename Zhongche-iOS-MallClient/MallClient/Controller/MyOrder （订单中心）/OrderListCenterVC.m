//
//  OrderListCenterVC.m
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderListCenterVC.h"
#import "OrderListCenterCell.h"
#import "OrderViewModel.h"
#import <UIScrollView+MJRefresh.h>
#import "OrderModelForCapacity.h"
#import "OrderDetailsCapacityVC.h"
#import "NoDataView.h"
#import "CanNotRefreshMore.h"
#import "CapacityOrderDetailVC.h"
#import "AppDelegate.h"

#define PAGE_SIZE_NUM  20
@interface OrderListCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong ) UITableView     * tbv;
@property (nonatomic, strong)MJRefreshHeader  * mj_header;
@property (nonatomic, strong)MJRefreshFooter  * mj_footer;
@property (nonatomic, strong)NSMutableArray   *resultArray;
@property (nonatomic, strong)NoDataView       *noDataView;
@property (nonatomic, assign)int              currentPage;
@property (nonatomic, strong) CanNotRefreshMore         * refresheEndFooter;
@end

@implementation OrderListCenterVC

-(instancetype)init {
    if (self = [super init]) {
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.ShowOrderLeft) {
        self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight -44);
    }else{
        self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight -44- kTabbarHight);
    }
    [self.view addSubview:self.tbv];
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadDataWithOrderType:@""];
    }];
    self.tbv.mj_header = self.mj_header;
    [self.mj_header beginRefreshing];
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self loadDataWithOrderType:@""];
    }];
    self.tbv.mj_footer = self.mj_footer;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//OrderListCenterVC_ALL,OrderListCenterVC_WaitConfirm,OrderListCenterVC_WaitPay,OrderListCenterVC_WaitPost,OrderListCenterVC_WaitRecpt,OrderListCenterVC_HadFinish,OrderListCenterVC_Cancle

#pragma mark - Tabview Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderListCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListCenterCell class]) forIndexPath:indexPath];
    OrderModelForCapacity * model = self.resultArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 235;
}

-(void)loadDataWithOrderType:(NSString *)orderType
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CapacityOrderDetailVC * vc  =[CapacityOrderDetailVC new];
    OrderModelForCapacity *model = self.resultArray[indexPath.row];
    vc.model  = model;
    [vc setCancelBlcok:^(OrderModelForCapacity *model) {
        [self.resultArray removeObject:model];
        [self.tbv reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.resultArray.count<1 && self.resultArray!=nil) {
         return self.noDataView;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.resultArray.count<1 && self.resultArray!=nil) {
        return SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight -44;
    }else{
        return CGFLOAT_MIN;
    }
}

-(UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderListCenterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderListCenterCell class])];
        _tbv = tableView;
    }
    return _tbv;
}

- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoDataView class]) owner:self options:nil] firstObject];
        _noDataView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight);
    }
    return _noDataView;
}
-(CanNotRefreshMore *)refresheEndFooter {
    if (!_refresheEndFooter){
        WS(ws);
        _refresheEndFooter = [CanNotRefreshMore footerWithRefreshingBlock:^{
            [ws.tbv.mj_footer endRefreshing];
        }];
        [_refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        [_refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        [_refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
    }
    return _refresheEndFooter;
}
@end

//全部
@implementation OrderListCenterVC_ALL

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = allOrder;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
        //        if (isLastPage) {
        //            ws.tbv.mj_footer = ws.refresheEndFooter;
        //            if (arr.count == 0) {
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        //            }
        //            else
        //            {
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
        //            }
        //        }
        //        else
        //        {
        //            ws.tbv.mj_footer = ws.mj_footer;
        //        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}

@end
//待确认
@implementation OrderListCenterVC_WaitConfirm

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = needConfirm;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
        //        if (isLastPage) {
        //            ws.tbv.mj_footer = ws.refresheEndFooter;
        //            if (arr.count == 0) {
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        //            }
        //            else
        //            {
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
        //            }
        //        }
        //        else
        //        {
        //            ws.tbv.mj_footer = ws.mj_footer;
        //        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}
@end
//待待付款
@implementation OrderListCenterVC_WaitPay

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = needPayment;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
        //        if (isLastPage) {
        //            ws.tbv.mj_footer = ws.refresheEndFooter;
        //            if (arr.count == 0) {
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        //            }
        //            else
        //            {
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
        //            }
        //        }
        //        else
        //        {
        //            ws.tbv.mj_footer = ws.mj_footer;
        //        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}

@end
//待待发货
@implementation OrderListCenterVC_WaitPost

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = needDelivery;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
        //        if (isLastPage) {
        //            ws.tbv.mj_footer = ws.refresheEndFooter;
        //            if (arr.count == 0) {
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        //            }
        //            else
        //            {
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
        //            }
        //        }
        //        else
        //        {
        //            ws.tbv.mj_footer = ws.mj_footer;
        //        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}

@end
//待待收货
@implementation OrderListCenterVC_WaitRecpt

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = needpayed;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
        //        if (isLastPage) {
        //            ws.tbv.mj_footer = ws.refresheEndFooter;
        //            if (arr.count == 0) {
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        //            }
        //            else
        //            {
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
        //            }
        //        }
        //        else
        //        {
        //            ws.tbv.mj_footer = ws.mj_footer;
        //        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}

@end
//已完成
@implementation OrderListCenterVC_HadFinish

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = accomplish;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
        //        if (isLastPage) {
        //            ws.tbv.mj_footer = ws.refresheEndFooter;
        //            if (arr.count == 0) {
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        //            }
        //            else
        //            {
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
        //                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
        //            }
        //        }
        //        else
        //        {
        //            ws.tbv.mj_footer = ws.mj_footer;
        //        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}

@end
//已取消 
@implementation OrderListCenterVC_Cancle

-(void)loadDataWithOrderType:(NSString *)orderType
{
    OrderStatus status = callOff;
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage WithPageSize:2 callback:^(NSArray *arr, BOOL isLastPage){
        
//        if (isLastPage) {
//            ws.tbv.mj_footer = ws.refresheEndFooter;
//            if (arr.count == 0) {
//                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
//                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
//                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
//            }
//            else
//            {
//                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
//                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
//                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
//            }
//        }
//        else
//        {
//            ws.tbv.mj_footer = ws.mj_footer;
//        }
        
        if (self.currentPage == 1) {
            self.resultArray = [[NSMutableArray alloc]initWithArray:arr];
        }else{
            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
                [ws.resultArray addObjectsFromArray:arr];
            }
        }
        [ws.tbv reloadData];
        [ws.mj_header endRefreshing];
        [ws.mj_footer endRefreshing];
    }];
    
}

@end

