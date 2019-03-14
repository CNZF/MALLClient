//
//  OrderCenterListVC.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderCenterListVC.h"
#import "OrderCenterTabCell.h"
#import "UIView+UIScreenDisplaying.h"
#import "OrderViewModel.h"
#import "CanNotRefreshMore.h"
#import "OrderDetailsCapacityVC.h"
#import "OrderDetailsContainerVC.h"
#import "OrderDetailsCarVC.h"
#import "MLNavigationController.h"
#import "LoginViewController.h"
#import "CoalOrderCell.h"
#import "OrderDetailsCoal.h"


#define PAGE_SIZE_NUM 20

@interface OrderCenterListVC ()<UITableViewDelegate,UITableViewDataSource,OrderCenterTabCellDelegate>
@property (nonatomic,strong ) UITableView               * tbv;
@property (nonatomic,strong ) NSMutableArray            * dataArr;
@property (nonatomic,strong ) NSMutableArray            * allDataArr;
@property (nonatomic, copy  ) NSString                  * viewTitle;
@property (nonatomic, strong) NSMutableArray            * placedAtTheTopCells;
@property (nonatomic, copy  ) NSString                  * orderType;//列表展示订单状态

@property (nonatomic, assign) int                       currentPage;
@property (nonatomic, strong) MJRefreshNormalHeader     * refreshHeader;//MJ刷新
@property (nonatomic, strong) MJRefreshBackNormalFooter * refreshFooter;
@property (nonatomic, strong) CanNotRefreshMore         * refresheEndFooter;

@property (nonatomic, strong) UIImageView               * nullIgv;
@property (nonatomic, strong) UILabel                   * nullLab;
@end

@implementation OrderCenterListVC


-(void)dealloc {
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConditionsForScreening" object:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderCenter" object:nil];
}

-(instancetype)init {
   if (self = [super init]) {
      self.currentPage = 0;
      self.orderType = @"全部";
   }
   return self;
}

-(void)loadDataWithOrderType:(NSString *)orderType {
   [self.allDataArr removeAllObjects];
   self.tbv.contentOffset = CGPointZero;
   [self.tbv reloadData];
}

//条件
-(void)conditionsForScreening {
   [self.dataArr removeAllObjects];

   if (!self.orderType || [self.orderType isEqualToString:@"全部"]) {
      [self.dataArr addObjectsFromArray:self.allDataArr];
   }
   else
   {
      for (OrderModelForCapacity * model in self.allDataArr)
      {
         if ([self.orderType isEqualToString:model.ordetType])
         {
            [self.dataArr addObject:model];
         }
      }
   }
}

//数据置顶
-(void)placedAtTheTop {
   OrderModelForCapacity * model;
   //置顶
   for (NSString * placedAtTheTopId in self.placedAtTheTopCells)
   {
      for (int i = 0;i < self.dataArr.count;i++) {
         model = self.dataArr[i];
         if ([model.orderID isEqualToString:placedAtTheTopId]){
            [self.dataArr removeObject:model];
            [self.dataArr insertObject:model atIndex:0];
         }
      }
   }
}

//根据筛选刷新
-(void)loadDataNoti:(NSNotification *)noti {
   if ([self.viewTitle isEqualToString:noti.object[@"viewTitle"]]) {
      
      if ([noti.object[@"orderType"] isEqualToString:self.orderType])
         return;
      self.currentPage = 0;
      self.orderType = noti.object[@"orderType"];
      [self loadDataWithOrderType:noti.object[@"orderType"]];
   }
}

//根据筛选刷新
-(void)resetDataNoti:(NSNotification *)noti {
   if ([self.viewTitle isEqualToString:noti.object[@"viewTitle"]]) {
      
      self.currentPage = 0;
      self.orderType = noti.object[@"orderType"];
      [self loadDataWithOrderType:noti.object[@"orderType"]];
   }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   //监听更新
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataNoti:) name:@"ConditionsForScreening" object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDataNoti:) name:@"refreshOrderCenter" object:nil];
   self.currentPage = 0;
   
   [self loadDataWithOrderType:self.orderType];

}

-(void)bindView {
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 44 -44);
    [self.view addSubview:self.tbv];
   
   self.nullIgv.frame = CGRectMake((SCREEN_W - 160) / 2, 150, 160, 115);
   self.nullIgv.hidden = YES;
   [self.tbv addSubview:self.nullIgv];
   
   self.nullLab.frame = CGRectMake(0, self.nullIgv.bottom + 50, SCREEN_W, 30);
   self.nullLab.hidden = YES;
   [self.tbv addSubview:self.nullLab];
}

-(void)bindModel {
   self.currentPage = 0;
//   [self loadDataWithOrderType:self.orderType];
}



/**
 *  懒加载
 *
 */

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
    
}

-(void)bindAction {
   self.tbv.mj_header = self.refreshHeader;
}

-(MJRefreshNormalHeader *)refreshHeader {
   if (!_refreshHeader) {
      WS(ws);
      _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         ws.currentPage = 0;
         [self loadDataWithOrderType:ws.orderType];
      }];
      _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
   }
   return _refreshHeader;
}

-(MJRefreshBackNormalFooter *)refreshFooter {
   if (!_refreshFooter){
      WS(ws);
      _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         ws.currentPage ++;
         [self loadDataWithOrderType:ws.orderType];
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

-(NSMutableArray *)allDataArr {
   if (!_allDataArr) {
      _allDataArr = [NSMutableArray array];
   }
   return _allDataArr;
}

- (NSMutableArray *)placedAtTheTopCells {
   if (!_placedAtTheTopCells) {
      _placedAtTheTopCells = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])]];
   }
   return _placedAtTheTopCells;
}

-(UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[OrderCenterTabCell class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell class])];
        _tbv = tableView;
    }
    return _tbv;
}

-(UIImageView *)nullIgv{
   if (!_nullIgv) {
      UIImageView * igv = [UIImageView new];
      igv.image = [UIImage imageNamed:[@"NullIgv" adS]];
      _nullIgv = igv;
   }
   return _nullIgv;
}

-(UILabel *)nullLab {
   if (!_nullLab) {
      UILabel * lab = [UILabel new];
      lab.font = [UIFont systemFontOfSize:18.f];
      lab.textColor = APP_COLOR_BLACK_TEXT;
      lab.textAlignment = NSTextAlignmentCenter;
      lab.text = @"暂无订单";
      _nullLab = lab;
   }
   return _nullLab;
}

#pragma mark - Tabview Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   OrderCenterTabCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell class]) forIndexPath:indexPath];
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   [cell loadUIWithmodel:self.dataArr[indexPath.row]];
   cell.cellDelegate = self;
   cell.cellIndexPath = indexPath;
   cell.beenPlacedAtTheTop = [self.placedAtTheTopCells indexOfObject:[self.dataArr[indexPath.row] orderID]] != NSNotFound;

   return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 210;
}

//取消置顶
-(void)getTheTopCancelButtonClickWithCellIndexPath:(NSIndexPath *)cellIndexPath {
   OrderModelForCapacity* model = self.dataArr[cellIndexPath.row];
   [self.placedAtTheTopCells removeObject:model.orderID];
   [[NSUserDefaults standardUserDefaults] setObject:self.placedAtTheTopCells forKey:NSStringFromClass([self class])];
   [self conditionsForScreening];
   [self placedAtTheTop];
   self.tbv.contentOffset = CGPointZero;
   [self.tbv reloadData];
}

//置顶
-(void)getTheTopButtonClickWithCellIndexPath:(NSIndexPath *)cellIndexPath {
   if (self.placedAtTheTopCells.count >= 3) {
      [[Toast shareToast]makeText:@"最对置顶三项" aDuration:1];
   }
   else
   {
      OrderModelForCapacity* model = self.dataArr[cellIndexPath.row];
      [self.placedAtTheTopCells addObject:[model.orderID copy]];
      [[NSUserDefaults standardUserDefaults] setObject:self.placedAtTheTopCells forKey:NSStringFromClass([self class])];
      [self placedAtTheTop];
      self.tbv.contentOffset = CGPointZero;
      [self.tbv reloadData];
   }
}

-(void)getCellClick:(NSIndexPath *)cellIndexPath {

}

@end

@implementation OrderCenterListVC_IWantToCapacity

-(void)bindModel {
   self.viewTitle = @"我要运力";
   [super bindModel];
}

-(void)loadDataWithOrderType:(NSString *)orderType {
   OrderStatus status = allOrder;
   if ([orderType isEqualToString:@"全部"]) {
      status = allOrder;
   }
   else if ([orderType isEqualToString:@"待付款"]) {
      status = needPayment;
   }
   else if ([orderType isEqualToString:@"待发货"]) {
      status = needDelivery;
   }
   else if ([orderType isEqualToString:@"待收货"]) {
      status = needTakeDelivery;
   }
   else if ([orderType isEqualToString:@"已完成"]) {
      status = accomplish;
   }
   else if ([orderType isEqualToString:@"已取消"]) {
      status = callOff;
   }
   else if ([orderType isEqualToString:@"待确认"]) {
      status = needConfirm;
   }
   else if ([orderType isEqualToString:@"待退款"]) {
      status = needRefund;
   }
   
   WS(ws);
   [[OrderViewModel new] getSaleOfCapacityOrderWithType:status WithCurrentPage:self.currentPage + 1 WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
      if (!arr) {
         if (ws.currentPage == 0) {
            [ws.tbv.mj_header endRefreshing];
         }
         else
         {
            ws.currentPage --;
            [ws.tbv.mj_footer endRefreshing];
         }
         return ;
      }
      [ws.dataArr removeAllObjects];
      if (ws.currentPage == 0) {
         [ws.allDataArr removeAllObjects];
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
      
      for (OrderModelForCapacity * model in arr) {
         [ws.allDataArr addObject:model];
      }
      [ws.dataArr addObjectsFromArray:ws.allDataArr];
      [self placedAtTheTop];
      
      if (ws.dataArr.count >0) {
         ws.nullLab.hidden = YES;
         ws.nullIgv.hidden = YES;
      }else{
         ws.nullIgv.hidden = NO;
         ws.nullLab.hidden = NO;
      }
      [ws.tbv reloadData];
   }];
}

-(void)getCellClick:(NSIndexPath *)cellIndexPath {
   OrderModelForCapacity * model = self.dataArr[cellIndexPath.row];
   OrderDetailsCapacityVC *vc = [OrderDetailsCapacityVC new];
   vc.model = model;
   [self.navigationController pushViewController:vc animated:YES];
}

@end

@implementation OrderCenterListVC_HomeOfEmpty

-(void)bindModel {
   self.viewTitle = @"空箱之家";
}

-(void)loadDataWithOrderType:(NSString *)orderType {
   EmptyContainerOrderStatus status = ALL;
   if ([orderType isEqualToString:@"全部"]) {
      status = ALL;
   }
   else if ([orderType isEqualToString:@"待支付"]) {
      status = WAIT_PAY;
   }
   else if ([orderType isEqualToString:@"待审核"]) {
      status = WAIT_AUDIT;
   }
   else if ([orderType isEqualToString:@"待箱主发箱"]) {
      status = WAIT_TRANSPORT_CAPACITY_MATCH;
   }
   else if ([orderType isEqualToString:@"待买家收箱"]) {
      status = WAIT_SIGN;
   }
   else if ([orderType isEqualToString:@"待箱主收箱"]) {
      status = WAIT_ACCEPT_BOX;
   }
   else if ([orderType isEqualToString:@"已完成"]) {
      status = COMPLETED;
   }
   else if ([orderType isEqualToString:@"已取消"]) {
      status = CANCEL;
   }

   WS(ws);
   [[OrderViewModel new] getEmptyContainerOrderWithType:status WithCurrentPage:self.currentPage + 1 WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
      if (!arr) {
         if (ws.currentPage == 0) {
            [ws.tbv.mj_header endRefreshing];
         }
         else
         {
            ws.currentPage --;
            [ws.tbv.mj_footer endRefreshing];
         }
         return ;
      }
      [ws.dataArr removeAllObjects];
      if (ws.currentPage == 0) {
         [ws.allDataArr removeAllObjects];
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
      
      for (OrderModelForEmptyContainer * model in arr) {
         [ws.allDataArr addObject:model];
      }
      [ws.dataArr addObjectsFromArray:ws.allDataArr];
      [self placedAtTheTop];
      
      if (ws.dataArr.count >0) {
         ws.nullLab.hidden = YES;
         ws.nullIgv.hidden = YES;
      }else{
         ws.nullIgv.hidden = NO;
         ws.nullLab.hidden = NO;
      }
      [ws.tbv reloadData];
   }];
}

-(void)getCellClick:(NSIndexPath *)cellIndexPath {
   OrderDetailsContainerVC *vc = [OrderDetailsContainerVC new];
   vc.model = self.dataArr[cellIndexPath.row];
   [self.navigationController pushViewController:vc animated:YES];
}


@end

@implementation OrderCenterListVC_EmptyLove

-(void)bindModel {
   self.viewTitle = @"空车之爱";
//   [super bindModel];
}

-(void)loadDataWithOrderType:(NSString *)orderType {
   EmptyCarOrderStatus status = aLL;
   if ([orderType isEqualToString:@"全部"]) {
      status = aLL;
   }
   else if ([orderType isEqualToString:@"待支付"]) {
      status = NeedPayment;
   }
   else if ([orderType isEqualToString:@"待审核"]) {
      status = WaitCheck;
   }
   else if ([orderType isEqualToString:@"待调度"]) {
      status = WAIT_DISPATCH;
   }
   else if ([orderType isEqualToString:@"待装载"]) {
      status = WAIT_LOADING;
   }
   else if ([orderType isEqualToString:@"已完成"]) {
      status = Accomplish;
   }
   else if ([orderType isEqualToString:@"已取消"]) {
      status = CallOff;
   }
   
   WS(ws);
   [[OrderViewModel new] getEmptyCarOrderWithType:status WithCurrentPage:self.currentPage + 1 WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
      if (!arr) {
         if (ws.currentPage == 0) {
            [ws.tbv.mj_header endRefreshing];
         }
         else
         {
            ws.currentPage --;
            [ws.tbv.mj_footer endRefreshing];
         }
         return ;
      }
      [ws.dataArr removeAllObjects];
      if (ws.currentPage == 0) {
         [ws.allDataArr removeAllObjects];
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
      for (OrderModelForEmptyCar * model in arr) {
         [ws.allDataArr addObject:model];
      }
      [ws.dataArr addObjectsFromArray:ws.allDataArr];
      [self placedAtTheTop];
      
      if (ws.dataArr.count >0) {
         ws.nullLab.hidden = YES;
         ws.nullIgv.hidden = YES;
      }else{
         ws.nullIgv.hidden = NO;
         ws.nullLab.hidden = NO;
      }
      [ws.tbv reloadData];
   }];
}

-(void)getCellClick:(NSIndexPath *)cellIndexPath {
   OrderDetailsCarVC *vc = [OrderDetailsCarVC new];
   vc.model = self.dataArr[cellIndexPath.row];
   [self.navigationController pushViewController:vc animated:YES];
}


@end

@implementation OrderCenterListVC_Coal

-(void)viewWillAppear:(BOOL)animated {

   [super viewWillAppear:animated];

   [self loadDataWithOrderType:@"全部"];
}

-(void)bindModel {
   self.viewTitle = @"绿色煤炭";
   [super bindModel];
}


//#define BUTTON_TITLES_Coal @[@"全部",@"待确定",@"已取消",@"待付款",@"待审核",@"待发货",@"待收货",@"待结算",@"已完成"]
-(void)loadDataWithOrderType:(NSString *)orderType {
   CoalOrderStatus status = coalAll;
   if ([orderType isEqualToString:@"全部"]) {
      status = coalAll;
   }
   else if ([orderType isEqualToString:@"待确定"]) {
      status = coalCertaining;
   }
   else if ([orderType isEqualToString:@"已取消"]) {
      status = coalCancle;
   }
   else if ([orderType isEqualToString:@"待付款"]) {
      status = coalPaying;
   }
   else if ([orderType isEqualToString:@"待审核"]) {
      status = coalConfirming;
   }
   else if ([orderType isEqualToString:@"待发货"]) {
      status = coalSenting;
   }
   else if ([orderType isEqualToString:@"待收货"]) {
      status = coalReceiving;
   }
   else if ([orderType isEqualToString:@"待结算"]) {
      status = coalEvaluating;
   }
   else if ([orderType isEqualToString:@"已完成"]) {
      status = coalFish;
   }

   WS(ws);
   [[OrderViewModel new] getCoalOrderWithType:status WithCurrentPage:self.currentPage + 1 WithPageSize:PAGE_SIZE_NUM callback:^(NSArray *arr, BOOL isLastPage){
      if (!arr) {
         if (ws.currentPage == 0) {
            [ws.tbv.mj_header endRefreshing];
         }
         else
         {
            ws.currentPage --;
            [ws.tbv.mj_footer endRefreshing];
         }
         return ;
      }
      [ws.dataArr removeAllObjects];
      if (ws.currentPage == 0) {
         [ws.allDataArr removeAllObjects];
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

      for (OrderModelForCapacity * model in arr) {
         [ws.allDataArr addObject:model];
      }
      [ws.dataArr addObjectsFromArray:ws.allDataArr];
      [self placedAtTheTop];

      if (ws.dataArr.count >0) {
         ws.nullLab.hidden = YES;
         ws.nullIgv.hidden = YES;
      }else{
         ws.nullIgv.hidden = NO;
         ws.nullLab.hidden = NO;
      }
      [ws.tbv reloadData];
   }];
}

#pragma mark - Tabview Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   static NSString *CellIdentifier = @"Celled";
   CoalOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CoalOrderCell" owner:self options:nil];
   cell = [array objectAtIndex:0];
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

   OrderModelForCapacity *model = self.dataArr[indexPath.row];
   cell.lbNo.text = [NSString stringWithFormat:@"订单号：%@",model.orderCode];
   cell.lbDate.text = [self stDateToString1:model.createTime];
   cell.lbName.text = model.produceName;
   cell.lbPNum.text = model.produceCode;
   cell.lbPriceNum.text = model.price;
   cell.lbAddress.text = model.deliveryAddress;
   cell.lbPrice.text = model.priceType;
   cell.lbStatus.text = model.status;



   return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

   return 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


   OrderDetailsCoal *vc = [OrderDetailsCoal new];
   OrderModelForCapacity *model = self.dataArr[indexPath.row];
   vc.detailId = model.detailId;
   [self.navigationController pushViewController:vc animated:YES];
}

-(void)getCellClick:(NSIndexPath *)cellIndexPath {
   OrderModelForCapacity * model = self.dataArr[cellIndexPath.row];
   OrderDetailsCapacityVC *vc = [OrderDetailsCapacityVC new];
   vc.model = model;
   [self.navigationController pushViewController:vc animated:YES];
}

@end
