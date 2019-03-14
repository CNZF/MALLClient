//
//  EmptyCarVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/28.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarVC.h"
#import "SelectCapacityVC.h"
#import "EmptyCarCell.h"
#import "EmptyCarDetailVC.h"
#import "EmptyShipDetailVC.h"
#import "EmptyTrainDetailVC.h"
#import "CanNotRefreshMore.h"

const int pageSize = 20;
@interface EmptyCarVC ()<UITableViewDelegate,UITableViewDataSource,SelectCapacityVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbv;

@property (nonatomic, strong) NSMutableArray            * array;
@property (nonatomic, strong) UIView                    * headerLine;
@property (nonatomic, strong) MJRefreshNormalHeader     * refreshHeader;//MJ刷新
@property (nonatomic, strong) MJRefreshBackNormalFooter * refreshFooter;
@property (nonatomic, strong) CanNotRefreshMore         * refresheEndFooter;
@property (nonatomic, strong) UIImageView               * ivNoTransport;//200 108
@property (nonatomic, strong) UILabel                   * lb1;

@end

@implementation EmptyCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"空车之爱";
    [self.tbv registerClass:[EmptyCarCell class] forCellReuseIdentifier:NSStringFromClass([EmptyCarCell class])];
    self.tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(self.isRecommendedVC) {
        self.btnRight.hidden = NO;
        [self.btnRight setTitle:@"查找更多" forState:UIControlStateNormal];
        [self.btnRight setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        self.btnRight.frame = CGRectMake(0, 0, 70, 44);
    }
    self.tbv.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
}

-(void)bindView {
    
    self.ivNoTransport.frame = CGRectMake(SCREEN_W/2 - 100, 120, 200, 108);
    self.ivNoTransport.hidden = YES;
    [self.tbv addSubview:self.ivNoTransport];
    
    self.lb1.frame = CGRectMake(0, self.ivNoTransport.bottom + 60 , SCREEN_W, 20);
    self.lb1.hidden = YES;
    [self.tbv addSubview:self.lb1];
}

-(void)bindModel {
    
    if(self.isRecommendedVC) {
        [self loadData];
    }
    else {
        self.filterModel.currentPage = 0;
        [self loadingDataForFilterModel];
    }
}

-(void)bindAction {
    self.tbv.mj_header = self.refreshHeader;

}

-(void)onRightAction {
    
    SelectCapacityVC * vc = [SelectCapacityVC new];
    vc.model = self.filterModel;
    //vc.vcDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//加载数据
-(void)loadData {
    WS(ws);
    [[EmptyCarViewModel new]getRecommendListCallBack:^(NSArray *arr) {
        if (arr) {
            [ws.array removeAllObjects];
            [ws.array addObjectsFromArray:arr];
            [ws.tbv reloadData];
            if (ws.array.count >0) {
                ws.ivNoTransport.hidden = YES;
                ws.lb1.hidden = YES;
            }else{
                ws.ivNoTransport.hidden = NO;
                ws.lb1.hidden = NO;
            }
        }
        [ws.tbv.mj_header endRefreshing];
    }];
}

//懒加载

-(NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

-(UIView *)headerLine {
    if (!_headerLine) {
        UIView * vi = [UIView new];
        _headerLine = vi;
    }
    return _headerLine;
}

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抱歉，没有找到符合您需求的结果";
        
        _lb1 = label;
    }
    return _lb1;
}

- (UIImageView *)ivNoTransport {
    if (!_ivNoTransport) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"NoTransport"];
        
        _ivNoTransport = imageView;
    }
    return _ivNoTransport;
}

-(EmptyCarFilterModel *)filterModel {
    if (!_filterModel) {
        EmptyCarFilterModel * model = [EmptyCarFilterModel new];
        model.pagesize = pageSize;
        model.currentPage = 0;
        model.startTime = [NSDate date];
        _filterModel = model;
    }
    return _filterModel;
}

-(MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        WS(ws);
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.filterModel.currentPage = 0;
            [self bindModel];
        }];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}

-(MJRefreshBackNormalFooter *)refreshFooter {
    if (!_refreshFooter){
        WS(ws);
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.filterModel.currentPage ++;
            [self loadingDataForFilterModel];
        }];
    }
    return _refreshFooter;
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

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EmptyCarCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyCarCell class]) forIndexPath:indexPath];
    [cell loadUIWithmodel:self.array[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerLine;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    EmptyCarModel * model = self.array[indexPath.row];
    
    BaseViewController *vc;
    switch (model.transportTypeEnum) {
            
        case landTransportation:
            
            vc = [EmptyCarDetailVC new];
            ((EmptyCarDetailVC *)vc).current = model;
            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        case trainsTransportation:

            vc = [EmptyTrainDetailVC new];
            ((EmptyTrainDetailVC *)vc).current = model;
            [self.navigationController pushViewController:vc animated:YES];
            break;

        case shipTransportation:

            vc = [EmptyShipDetailVC new];
            ((EmptyShipDetailVC *)vc).current = model;
            [self.navigationController pushViewController:vc animated:YES];
            break;
    }

}

//根据筛选条件刷新
-(void)chooseCompleteNeedLoadingData {
    self.filterModel.currentPage = 0;
    self.tbv.mj_header = self.refreshHeader;
    [self loadingDataForFilterModel];
}

//加载数据
-(void)loadingDataForFilterModel{
    WS(ws);
    [[EmptyCarViewModel new]getEmptyVehicleListWithFilterModel:self.filterModel callBack:^(NSArray *arr, BOOL isLastPage){
        if (!arr) {
            if (ws.filterModel.currentPage == 0) {
                [ws.tbv.mj_header endRefreshing];
            }
            else
            {
                ws.filterModel.currentPage --;
                [ws.tbv.mj_footer endRefreshing];
            }
            return ;
        }
        if (ws.filterModel.currentPage == 0) {
            [ws.array removeAllObjects];
            [ws.tbv.mj_header endRefreshing];
        }
        else
        {
            [ws.tbv.mj_footer endRefreshing];
        }
        
        if (isLastPage) {
            ws.tbv.mj_footer = ws.refresheEndFooter;
            if (arr.count == 0) {
                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateIdle];
                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStatePulling];
                [ws.refresheEndFooter setTitle:@"" forState:MJRefreshStateRefreshing];
            }
            else
            {
                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateIdle];
                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStatePulling];
                [ws.refresheEndFooter setTitle:@"已显示全部" forState:MJRefreshStateRefreshing];
            }
        }
        else
        {
            ws.tbv.mj_footer = ws.refreshFooter;
        }
        [ws.array addObjectsFromArray:arr];
        
        if (ws.array.count >0) {
            ws.ivNoTransport.hidden = YES;
            ws.lb1.hidden = YES;
        }else{
            ws.ivNoTransport.hidden = NO;
            ws.lb1.hidden = NO;
        }
        [ws.tbv reloadData];
    }];
}

@end
