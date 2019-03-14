//
//  KNWantTransportVC.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNWantTransportVC.h"
#import "HotCapacityCell.h"
#import "CapacityViewModel.h"
#import "BannerModel.h"
#import "KNWantTransportHeaderView.h"
#import "MLNavigationController.h"
#import "KNWantTransportSectionHeader.h"
#import "ZCCityListViewController.h"
#import "CalendarView.h"
#import "DayIndoModel.h"
#import "KNTransportResultListVC.h"
#import "DynamicDetailsViewController.h"
#import "CapacityEntryModel.h"
#import "StackCell.h"
#import "SDZViewCompleteVc.h"
#import "LoginViewController.h"
#import "NSString+Money.h"
#import "containerCell.h"

#define headHight 45
@interface KNWantTransportVC ()<UITableViewDelegate,UITableViewDataSource,chooseDateDelegate,SDCycleScrollViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * mainScrollerView;
@property (nonatomic, strong) UIScrollView * headScrollerView;
@property (nonatomic, strong) UIScrollView * tableScrollerView;
@property (nonatomic, strong) KNWantTransportHeaderView *headerView;

@property (nonatomic, strong) UITableView *KNTableView;
@property (nonatomic, strong) UITableView *KNSDZTableView;
@property (nonatomic, strong) NSMutableArray *bannerListArray;

@property (nonatomic, strong) NSMutableArray *resultArray;
//页面填充model
@property (nonatomic, copy) CapacityEntryModel *fillModel;

@property (nonatomic, assign) int fxIndex;

@property (nonatomic, strong) UIImageView * fxImageView;

@property (nonatomic, strong)UISwipeGestureRecognizer * recognizer;
@property (nonatomic, strong)NSMutableArray * tacktArray;
@end

@implementation KNWantTransportVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ADviewDismiss) name:@"ADVIEWMISS" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self bindImage];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;
   
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)ADviewDismiss
{
     [self loadingData];
}

- (void)bindImage
{
    self.fxIndex = 1;
   
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstAddFxImageView"]) {
        [Defaults setObject:@YES forKey:@"isFirstAddFxImageView"];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [app.window addSubview:self.fxImageView];
        [app.window insertSubview:self.fxImageView atIndex:1];
    }
}

- (void)onImage
{
    self.fxIndex = self.fxIndex+1;
    if (self.fxIndex == 7) {
        [self.fxImageView removeFromSuperview];
        self.fxImageView = nil;
    }else
    {
        self.fxImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fc%d",self.fxIndex]];
    }
}

- (void)bindView{
     self.lineState = JZXXL;
    [self.mainScrollerView addSubview:self.headerView];
    [self.mainScrollerView addSubview:self.headScrollerView];
    [self.mainScrollerView addSubview:self.tableScrollerView];
    [self.tableScrollerView addSubview:self.KNTableView];
    [self.tableScrollerView addSubview:self.KNSDZTableView];
    [self.view addSubview:self.mainScrollerView];
   
//    [self.view addSubview:self.headerView];
    

//    self.KNTableView.tableHeaderView = self.headerView;
}
- (void)bindModel {
   
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 1; i ++) {
        [arr addObject:[UIImage imageNamed:@"B3.jpg"]];
        [arr addObject:[UIImage imageNamed:@"b1.jpg"]];
        [arr addObject:[UIImage imageNamed:@"B2.jpg"]];
        [arr addObject:[UIImage imageNamed:@"B4.jpg"]];
    }
    self.headerView.cycleScrollView.localizationImageNamesGroup = arr;
//    [self loadingData];
}

//加载图片
- (void)loadingData{
    
    WS(ws);
    [[CapacityViewModel new]getBannerCallback:^(NSArray *arr) {
        if(arr.count > 0) {
            [self.bannerListArray removeAllObjects];
            [self.bannerListArray addObjectsFromArray:arr];
            NSMutableArray * urlArr = [NSMutableArray new];
            for (BannerModel * model in self.bannerListArray) {
                [urlArr addObject:model.url];
            }
            self.headerView.cycleScrollView.imageURLStringsGroup = urlArr;
        }

    }];

    [[CapacityViewModel new]getRecommendStacksCallback:^(NSArray *arr) {
        if(arr){
            [self.tacktArray removeAllObjects];
            ws.tacktArray  = [NSMutableArray arrayWithArray:arr];
            ws.KNSDZTableView.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, ws.tacktArray.count * 65);
//            ws.tableScrollerView.frame = CGRectMake(0, self.headScrollerView.bottom, SCREEN_W, ws.tacktArray.count * 65);
//            ws.mainScrollerView.contentSize = CGSizeMake(SCREEN_W, self.headScrollerView.bottom + 65 * ws.tacktArray.count);
            [self.KNSDZTableView reloadData];
            
            [[CapacityViewModel new]getRecommendTicketsCallback:^(NSArray *arr) {
                if(arr){
                    [self.dataArray removeAllObjects];
                    [ws.dataArray addObjectsFromArray:arr];
                    ws.KNTableView.frame = CGRectMake(0, 0, SCREEN_W, ws.dataArray.count * 65);
                    ws.tableScrollerView.frame = CGRectMake(0, self.headScrollerView.bottom, SCREEN_W, ws.dataArray.count * 65);
                    ws.mainScrollerView.contentSize = CGSizeMake(SCREEN_W, self.headScrollerView.bottom + 65 * ws.dataArray.count);
                    [self.KNTableView reloadData];
                    
                }
            }];
            
        }
    }];
   
    


}

- (void)bindAction{
    WS(weakSelf)
    [[self.headerView.startButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ZCCityListViewController * vc = [[ZCCityListViewController alloc] init];
        vc.fromNaviC = NO;
        vc.completeBlock = ^(CityModel *model) {
            [weakSelf.headerView.startButton setTitle:model.name forState:UIControlStateNormal];
            [weakSelf.headerView.startButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
             weakSelf.fillModel.startPlace = model;
        };
        [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
    }];
    
    [[self.headerView.arriveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ZCCityListViewController * vc = [[ZCCityListViewController alloc] init];
        vc.fromNaviC = NO;
        vc.completeBlock = ^(CityModel *model) {
            [weakSelf.headerView.arriveButton setTitle:model.name forState:UIControlStateNormal];
            [weakSelf.headerView.arriveButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
             weakSelf.fillModel.endPlace = model;
        };
        [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
    }];
    
    [[self.headerView.changeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (!weakSelf.fillModel.startPlace.name || !weakSelf.fillModel.endPlace.name) {
            [[Toast shareToast] makeText:@"请先选择地址" aDuration:1];
            return ;
        }
        
        CityModel * tempModel = [CityModel new];
        tempModel = weakSelf.fillModel.startPlace;
        weakSelf.fillModel.startPlace = weakSelf.fillModel.endPlace;
        weakSelf.fillModel.endPlace = tempModel;
        
        [weakSelf.headerView.startButton setTitle:weakSelf.fillModel.startPlace.name forState:UIControlStateNormal];
        [weakSelf.headerView.startButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        
        [weakSelf.headerView.arriveButton setTitle:weakSelf.fillModel.endPlace.name forState:UIControlStateNormal];
        [weakSelf.headerView.arriveButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        
    }];
    
    [[self.headerView.timeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        CalendarView *view = [[CalendarView alloc]init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isFourDays" object:@"YES"];
        view.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
        view.backgroundAlpha = 0;
        view.chooseDateInfo = weakSelf;
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(view.left,0, view.width, view.height);
        } completion:^(BOOL finished) {
        }];
        [window addSubview:view];
    }];
    
    [[self.headerView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (isNullStr(weakSelf.fillModel.endPlace.name) || isNullStr(weakSelf.fillModel.startPlace.name) || !weakSelf.fillModel.shipmentsTime) {
            [[Toast shareToast]makeText:@"请将信息填写完整" aDuration:2];
            return;
        }
        switch (self.lineState) {
            case 0:
            {
                //首页默认集装箱搜索
                weakSelf.fillModel.businessTypeCode = @"BUSINESS_TYPE_CONTAINER";
                KNTransportResultListVC *resultVC = [[KNTransportResultListVC alloc] init];
                resultVC.requestModel = [weakSelf.fillModel copy];
                [weakSelf.navigationController pushViewController:resultVC animated:YES];
                break;
            }
                
            case 1:
            {
                
                if (!USER_INFO) {
                    [self pushLogoinVC];
                    return;
                }
                
                SDZViewCompleteVc *resultVC = [[SDZViewCompleteVc alloc] init];
                
                resultVC.reRequestModel.startRegionName = self.fillModel.startPlace.name;
                resultVC.reRequestModel.endRegionName = self.fillModel.endPlace.name;
                resultVC.reRequestModel.startRegionCode = self.fillModel.startPlace.code;
                resultVC.reRequestModel.endRegionCode = self.fillModel.endPlace.code;
                
//                resultVC.reRequestModel.startRegionName = self.fillModel.startPlace.name;
//                resultVC.reRequestModel.endRegionName = self.fillModel.endPlace.name;
//                resultVC.reRequestModel.estimateDepartureTime = self.fillModel.stStartTime;
                [self.navigationController pushViewController:resultVC animated:YES];
            }
                
                break;
            default:
                break;
        }
       
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _KNTableView) {
        return self.dataArray.count;
    }else{
        return self.tacktArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _KNTableView) {
//        HotCapacityCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCapacityCell class]) forIndexPath:indexPath];
//        cell.lbDistance.hidden = YES;
//        cell.lbDay.hidden = YES;
//        [cell loadUIWithmodel:self.dataArray[indexPath.row]];
//
//        return cell;
        containerCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([containerCell class]) forIndexPath:indexPath];
        [cell loadUIWithmodel:self.dataArray[indexPath.row]];
        return cell;
    }else{
        StackCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StackCell class]) forIndexPath:indexPath];
        [cell loadUIWithmodel:self.tacktArray[indexPath.row]];
        return cell;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    KNWantTransportSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([KNWantTransportSectionHeader class])];
//    [header setHeadBlock:^(NSString *title) {
//        if ([title isEqualToString:@"O"]) {
//            self.lineState  = JZXXL;
//        }else{
//            self.lineState  = SDZXL;
//        }
//        [self.KNTableView reloadData];
//    }];
//    return header;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 65.0f;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 85.5;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.lineState) {
        case 0:
        {
            self.fillModel.businessTypeCode = @"BUSINESS_TYPE_CONTAINER";
            KNTransportResultListVC *resultVC = [[KNTransportResultListVC alloc] init];
            CapacityEntryModel *model = self.dataArray[indexPath.row];
//            model.shipmentsTime = [NSDate date];
            
            
//            self.fillModel.startPlace = model.startPlace;
//            self.fillModel.endPlace = model.endPlace;
//            self.fillModel.shipmentsTime = model.shipmentsTime;
//            [self.headerView.startButton setTitle:self.fillModel.startPlace.name forState:UIControlStateNormal];
//            [self.headerView.startButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
//            [self.headerView.arriveButton setTitle:self.fillModel.endPlace.name forState:UIControlStateNormal];
//            [self.headerView.arriveButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
//            [self.headerView.timeButton setTitle:self.fillModel.stStartTime forState:UIControlStateNormal];
//            [self.headerView.timeButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            
            NSInteger dis = 4; //前后的天数
            
            NSDate*nowDate = [NSDate date];
            NSDate* theDate;
            
            if(dis!=0)
            {
                NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
                
                theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis ];
                //or
//                theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
            }
            else
            {
                theDate = nowDate;
            }
            model.shipmentsTime = theDate;
            model.startPlace.code = model.start_region_code;
            model.endPlace.code = model.end_region_code;
            resultVC.requestModel = [model copy];
            [self.navigationController pushViewController:resultVC animated:YES];
            break;
        }
            
        case 1:
        {
            if (!USER_INFO) {
                [self pushLogoinVC];
                return;
            }
            
            CapacityEntryModel *model = self.tacktArray[indexPath.row];
            model.shipmentsTime = [NSDate date];
//            self.fillModel.startPlace = model.startPlace;
//            self.fillModel.endPlace = model.endPlace;
//            self.fillModel.shipmentsTime = model.shipmentsTime;
//            [self.headerView.startButton setTitle:self.fillModel.startPlace.name forState:UIControlStateNormal];
//            [self.headerView.startButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
//            [self.headerView.arriveButton setTitle:self.fillModel.endPlace.name forState:UIControlStateNormal];
//            [self.headerView.arriveButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
//            [self.headerView.timeButton setTitle:self.fillModel.stStartTime forState:UIControlStateNormal];
//            [self.headerView.timeButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            SDZViewCompleteVc *resultVC = [[SDZViewCompleteVc alloc] init];
            resultVC.reRequestModel.startRegionName = model.startRegionName;
            resultVC.reRequestModel.endRegionName = model.endRegionName;
            resultVC.reRequestModel.startRegionCode = model.start_region_code;
            resultVC.reRequestModel.endRegionCode = model.end_region_code;
//            resultVC.reRequestModel.estimateDepartureTime = ;]
            
            resultVC.goods.name = model.goodName;
            resultVC.reRequestModel.goodsCode = model.goodsCode;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
            
            break;
        default:
            break;
    }
    
    
}

- (void)OnJzxClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        _tableScrollerView.contentOffset = CGPointMake(0, 0);
    }];
//    _tableScrollerView.contentOffset.x = SCREEN_W;
    
}
- (void)OnSdzClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        _tableScrollerView.contentOffset = CGPointMake(SCREEN_W, 0);
    }];
    
//    _tableScrollerView.contentOffset.x = SCREEN_W;
}
#pragma mark --Scroller
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIButton * jzxBtn = [self.view viewWithTag:12001];
    UIButton * sdzBtn = [self.view viewWithTag:12002];
    if (scrollView == _tableScrollerView) {
        if (scrollView.contentOffset.x == SCREEN_W) {
            self.lineState = SDZXL;
            self.headerView.titleLabel.text = @"散堆装运力";
            [jzxBtn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
            [sdzBtn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
             [UIView animateWithDuration:0.3 animations:^{
                 self.tableScrollerView.frame = CGRectMake(0, self.headScrollerView.bottom, SCREEN_W,self.tacktArray.count * 65+5);
                 self.mainScrollerView.contentSize = CGSizeMake(SCREEN_W, self.headScrollerView.bottom + 65 * self.tacktArray.count+5);
             }];
            
        }else if(scrollView.contentOffset.x == 0){
            self.lineState = JZXXL;
            self.headerView.titleLabel.text = @"集装箱运力";
            [sdzBtn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
            [jzxBtn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.tableScrollerView.frame = CGRectMake(0, self.headScrollerView.bottom, SCREEN_W, self.dataArray.count * 65);
                self.mainScrollerView.contentSize = CGSizeMake(SCREEN_W, self.headScrollerView.bottom + 65 * self.dataArray.count);
            }];
            
            
        }
    }
}

#pragma mark -- chooseDateDelegate
- (void)chooseDateActionWithDate:(NSDate *)date {
    DayIndoModel *dateInfo = [[DayIndoModel alloc] init];
    [dateInfo modelWithDate:date];
    NSString *buttonTitle = [NSString stringWithFormat:@"%i年%i月%i日",dateInfo.year,dateInfo.month,dateInfo.day];
    [self.headerView.timeButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.headerView.timeButton setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
    self.fillModel.shipmentsTime = date;
}

#pragma mark -- SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerListArray.count > 0) {
        BannerModel *model=self.bannerListArray[index];
        if([model.needForward boolValue]){
            if([model.forwardType isEqualToString:@"web"]){
                DynamicDetailsViewController *vc=[DynamicDetailsViewController new];
                vc.urlStr=model.forwardPath;
                vc.title=model.title;
                [self.navigationController pushViewController:vc animated:NO];
            }
        }
    }
}

//登录跳转
-(void)pushLogoinVC {
    
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark -- Getter && Setter
- (KNWantTransportHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[KNWantTransportHeaderView alloc] init];
        _headerView.cycleScrollView.delegate = self;
        _headerView.frame = CGRectMake(0, 0, SCREEN_W, 455);
        
    }
    return _headerView;
}

- (UIImageView *)fxImageView
{
    if (!_fxImageView) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fc1"]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImage)];
        [imageView addGestureRecognizer:tap];
        _fxImageView  = imageView;
    }
    return _fxImageView;
}

- (NSMutableArray *)bannerListArray{
    if (!_bannerListArray) {
        _bannerListArray = [NSMutableArray array];
    }
    return _bannerListArray;
}
- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
        [_resultArray addObject:@""];
        [_resultArray addObject:@""];
        [_resultArray addObject:@""];
    }
    return _resultArray;
}
- (CapacityEntryModel *)fillModel{
    if (!_fillModel) {
        _fillModel = [[CapacityEntryModel alloc] init];
    }
    return _fillModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)mainScrollerView
{
    if (!_mainScrollerView) {
        _mainScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H- kTabbarHight- kiPhoneFooterHeight)];
        _mainScrollerView.contentSize = CGSizeMake(SCREEN_W, 2000);
    }
    return _mainScrollerView;
}

- (UIScrollView *)headScrollerView
{
    if (!_headScrollerView) {
        _headScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.headerView.bottom, SCREEN_W,headHight)];
        _headScrollerView.contentSize = CGSizeMake(SCREEN_W, 44);
        _headScrollerView.showsHorizontalScrollIndicator = NO;
        UIButton * jzxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jzxBtn.frame = CGRectMake(15, 0, 75, 44);
        jzxBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        jzxBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [jzxBtn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        [jzxBtn setTitle:@"集装箱线路" forState:UIControlStateNormal];
        [jzxBtn addTarget:self action:@selector(OnJzxClicked) forControlEvents:UIControlEventTouchUpInside];
        jzxBtn.tag = 12001;
        [_headScrollerView addSubview:jzxBtn];
        
        UIButton * sdzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sdzBtn.frame = CGRectMake(SCREEN_W/3+15, 0, 75, 44);
        sdzBtn.tag = 12002;
        [sdzBtn setTitle:@"散堆装线路" forState:UIControlStateNormal];
        sdzBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sdzBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [sdzBtn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [sdzBtn addTarget:self action:@selector(OnSdzClicked) forControlEvents:UIControlEventTouchUpInside];
        [_headScrollerView addSubview:sdzBtn];
        
        UIView * buttomView = [[UIView alloc] initWithFrame:CGRectMake(15,headHight-1, SCREEN_W-30, 1)];
        buttomView.backgroundColor = [HelperUtil colorWithHexString:@"f8f8f8"];
        [_headScrollerView addSubview:buttomView];
    
    }
    return _headScrollerView;
}
- (UIScrollView *)tableScrollerView
{
    if (!_tableScrollerView) {
        _tableScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.headScrollerView.bottom, SCREEN_W,SCREEN_H-self.headScrollerView.bottom - kTabbarHight - kiPhoneFooterHeight)];
        _tableScrollerView.contentSize = CGSizeMake(SCREEN_W*2, 200);
        _tableScrollerView.pagingEnabled = YES;
        _tableScrollerView.delegate = self;
        _tableScrollerView.bounces =NO;
    }
    return _tableScrollerView;
}
- (UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc]initWithFrame:self.tableScrollerView.frame];

        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
        {
            _KNTableView.cellLayoutMarginsFollowReadableWidth = NO;// 9.0以上才有这个属性，针对ipad。
        }
        _KNTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNTableView.scrollEnabled = NO;
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerClass:[HotCapacityCell class] forCellReuseIdentifier:NSStringFromClass([HotCapacityCell class])];
        [_KNTableView registerClass:[KNWantTransportSectionHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([KNWantTransportSectionHeader class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([StackCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([StackCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([containerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([containerCell class])];
    }
    return _KNTableView;
}
- (UITableView *)KNSDZTableView {
    if (!_KNSDZTableView) {
        _KNSDZTableView = [[UITableView alloc]initWithFrame:CGRectZero];

        _KNSDZTableView.delegate = self;
        _KNSDZTableView.dataSource = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
        {
            _KNSDZTableView.cellLayoutMarginsFollowReadableWidth = NO;// 9.0以上才有这个属性，针对ipad。
        }
        _KNSDZTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNSDZTableView.scrollEnabled = NO;
        _KNSDZTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNSDZTableView registerClass:[HotCapacityCell class] forCellReuseIdentifier:NSStringFromClass([HotCapacityCell class])];
        [_KNSDZTableView registerClass:[KNWantTransportSectionHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([KNWantTransportSectionHeader class])];
        [_KNSDZTableView registerNib:[UINib nibWithNibName:NSStringFromClass([StackCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([StackCell class])];
        
    }
    return _KNSDZTableView;
}
@end
