//
//  MyNeedListViewController.m
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyNeedListViewController.h"
#import "MyNeedCell.h"
#import <MJRefreshNormalHeader.h>
#import <MJRefreshBackNormalFooter.h>
#import "MyNeedDetailController.h"
#import "NeedViewModel.h"
#import "NoDataView.h"
@interface MyNeedListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) MJRefreshHeader  * mj_header;
@property (nonatomic, strong) MJRefreshFooter  * mj_footer;
@property (nonatomic, strong)NSMutableArray   *resultArray;
@property (nonatomic, strong)NoDataView       *noDataView;
@property (nonatomic, assign) int currentPage;
@end

@implementation MyNeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的需求";
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight= UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H- kNavBarHeaderHeight - kiPhoneFooterHeight );
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyNeedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyNeedCell class])];
    [self.view addSubview:self.tableView];
//    self.currentPage = 0;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self getDataWithID];
        NSLog(@"上拉");
        [self.mj_header endRefreshing];
    }];
    self.tableView.mj_header = self.mj_header;
    [self.mj_header beginRefreshing];
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"下拉");
        [self.mj_footer endRefreshing];
        self.currentPage ++;
         [self getDataWithID];
    }];
    self.tableView.mj_footer = self.mj_footer;
    
//    [self getData];
    
}

- (void)getDataWithID
{
    UserInfoModel * info = USER_INFO;
    WS(ws);
    [[NeedViewModel new] getEmptyContainerArrWith:info.iden Page:self.currentPage limite:20 callback:^(NSArray *arr, BOOL isLastPage) {
        
       
        if (ws.currentPage == 1) {
            if (arr.count > 0) {
                [ws.resultArray removeAllObjects];
            }
            NSMutableArray * data = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<arr.count; i++) {
                if (i == 0) {
                    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
                    MyNeedModel * model = arr[0];
                    [tempArray addObject:model];
                    [data addObject:tempArray];
                }else{
                    MyNeedModel * nextModel = arr[i];
                    NSMutableArray * putArray = data.lastObject;
                    MyNeedModel * lastModel = putArray.lastObject;

                    if ([[NSString TimeGetDate:nextModel.create_time] isEqualToString:[NSString TimeGetDate:lastModel.create_time]]) {
                        [putArray addObject:nextModel];
                    }else{
                        NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
                        [tempArray addObject:nextModel];
                        [data addObject:tempArray];
                    }
                }
            }
            ws.resultArray = [[NSMutableArray alloc]initWithArray:data];
        }else{

            if (isLastPage) {
                [[Toast shareToast] makeText:@"没有更多数据了" aDuration:1];
            }else{
//                NSMutableArray * data = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i<arr.count; i++) {
                    MyNeedModel * nextModel = arr[i];
                    NSMutableArray * putArray = self.resultArray.lastObject;
                    MyNeedModel * lastModel = putArray.lastObject;

                    if ([[NSString TimeGetDate:nextModel.create_time] isEqualToString:[NSString TimeGetDate:lastModel.create_time]]) {
                        [putArray addObject:nextModel];
                    }else{
                        NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
                        [tempArray addObject:nextModel];
//                        [data addObject:tempArray];
                         [self.resultArray addObject:tempArray];
                    }
                }


            }
        }
        [ws.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 36)];
    headLabel.backgroundColor = [HelperUtil colorWithHexString:@"f8f8f8"];
    headLabel.textAlignment = NSTextAlignmentCenter;
    NSArray * array = self.resultArray[section];
    MyNeedModel * model = array.lastObject;
    headLabel.text = [NSString TimeGetDate:model.create_time];
    return headLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.resultArray.count) {
        return 36;
    }else{
        return CGFLOAT_MIN;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.resultArray.count) {
        return self.resultArray.count;
    }else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.resultArray.count) {
        return [self.resultArray[section] count];
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resultArray.count) {
        MyNeedCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyNeedCell class]) forIndexPath:indexPath];
        MyNeedModel * model  = self.resultArray[indexPath.section][indexPath.row];
        cell.needModel = model;
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArray.count) {
        MyNeedModel * model  = self.resultArray[indexPath.section][indexPath.row];
        MyNeedDetailController * controller = [[MyNeedDetailController alloc] init];
        controller.needModel  = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.resultArray.count) {
       return [UIView new];
    }else{
        return self.noDataView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.resultArray.count) {
        return CGFLOAT_MIN;
        
    }else{
        return SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight;
    }
}
- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoDataView class]) owner:self options:nil] firstObject];
        _noDataView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight);
        _noDataView.CusLabel.text = @"暂无需求";
        _noDataView.CusImageView.image = [UIImage imageNamed:@"NoNeed"];
    }
    return _noDataView;
}

@end
