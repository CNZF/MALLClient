//
//  SearTransportResultViewController.m
//  MallClient
//
//  Created by lxy on 2016/11/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//
#import "SearTransportResultViewController.h"
#import "EntrySelectCell.h"
#import "SearchTransportTableViewCell.h"
#import "CustomCapacityController.h"
#import "TransportationModel.h"
#import "SearchResultView.h"
#import "SubmiteOrderViewController.h"
#import "PerfectOrderViewController.h"
#import "CapacityEntryModel.h"
#import "OrderTransportSuccessViewController.h"
#import "CapacityViewModel.h"
#import "CapacityViewModel.h"
#import "NewTransportTableViewCell.h"
#import "GroupTransportationModel.h"
#import "MLNavigationController.h"
#import "LoginViewController.h"
#import "NoTransportViewController.h"
#import "GoToContainerViewController.h"

@interface SearTransportResultViewController ()<UITableViewDelegate,UITableViewDataSource,CustomCapacityControllerDelegate>

@property (nonatomic, strong) UIView                   *headView;
@property (nonatomic, strong) UIButton                 *btnUpAndDown;
@property (nonatomic, strong) UIImageView              *iv;
@property (nonatomic, strong) UITableView              *tvList;
@property (nonatomic, strong) UIView                   *viFoot;
@property (nonatomic, strong) UIButton                 *btnFoot;
@property (nonatomic, strong) UILabel                  *lbFoot;
@property (nonatomic, strong) UIImageView              *ivFoot;
@property (nonatomic, strong) NSArray                  *arrInfos;
@property (nonatomic, strong) TransportationModel      *currentInfo;
@property (nonatomic, strong) SearchResultView         *viewSear;
@property (nonatomic, strong) UIImageView              *lastBackgroundView;
@property (nonatomic, strong) UIView                   *lastBackgroundBlackView;
@property (nonatomic, strong) UIScrollView             *backScrollVe;
@property (nonatomic, strong) CustomCapacityController *customCapacityVC;
@property (nonatomic, assign) CGFloat                  topHight;
@property (nonatomic, assign) NSInteger                selectNum;
@property (nonatomic, strong) NSString                 *strToast;
@property (nonatomic, strong) UIView                   *viTvHead;

@property (nonatomic, strong) UILabel                  *lbDistance;



@end

@implementation SearTransportResultViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    self.capacityEntry.invoice = nil;
    self.capacityEntry.remark = nil;
    self.capacityEntry.carryGoodsTime = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectNum = -1;
    self.strToast = @"请前往个人中心进行实名认证";
}

- (void)bindView {

    self.view = self.backScrollVe;
    self.title = self.capacityEntry.capacityType;

    [self headViewMake];

    [self.view addSubview:self.headView];

    self.tvList.frame = CGRectMake(0 , 50, SCREEN_W, SCREEN_H - 60 - 50 - 64);
    [self.view addSubview:self.tvList];

    self.viFoot.frame = CGRectMake(0, SCREEN_H - 60 - 64, SCREEN_W, 60);
    [self.view addSubview:self.viFoot];

    [self footViewMake];
}

//这个方法在中重写
-(void)headViewMake{

}

- (void)getData{

    CapacityViewModel *vm = [[CapacityViewModel alloc]init];
    WS(ws);
    [vm containerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        if(arr.count == 0) {

            NSMutableArray * array = [[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }
        
    }];
}

- (void) footViewMake {

    self.ivFoot.frame = CGRectMake(SCREEN_W / 2 - 6.5 , 10, 13, 7);
    [self.viFoot addSubview:self.ivFoot];

    self.lbFoot.frame = CGRectMake(0, self.ivFoot.bottom + 5, SCREEN_W, 20);
    [self.viFoot addSubview:self.lbFoot];

    self.btnFoot.frame = CGRectMake(0, 0, SCREEN_W, 60);
    [self.viFoot addSubview:self.btnFoot];
}

- (void) clickAction:(UIButton *)btn {

    if([self.iv.image isEqual:[UIImage imageNamed:@"down"]]) {

        self.iv.image = [UIImage imageNamed:@"up"];
        self.tvList.frame = CGRectMake(0 , self.topHight, SCREEN_W, SCREEN_H - 60 - self.topHight - 64);

    }else{

        self.iv.image = [UIImage imageNamed:@"down"];
        self.tvList.frame = CGRectMake(0 , 50, SCREEN_W, SCREEN_H - 60 - 50 - 64);

    }
}

- (void) onBackAction {
    if (self.backScrollVe.contentOffset.y >= SCREEN_H) {
        [self needGoBackLastView];
    }
    else{
        [super onBackAction];
    }
}

- (void) FootClickAction {

    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {
        WS(ws);

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            self.customCapacityVC.capacityEntry = self.capacityEntry;
            self.customCapacityVC.view.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
            [self.view addSubview:self.customCapacityVC.view];
            [UIView animateWithDuration:0.5 animations:^{
                ws.title = @"定制运力";
                ((UIScrollView *)ws.view).contentOffset = CGPointMake(0,SCREEN_H);
            } completion:^(BOOL finished) {

            }];
        }else {
            [[Toast shareToast]makeText:ws.strToast aDuration:2];
        }
    }

}

- (void) boomAction {

    if (_viewSear.btnYesOrNo && _viewSear.btnStyleChoose && _viewSear.num>0) {
        [_viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = _viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = _viewSear.btnYesOrNo.titleLabel.text;
        self.capacityEntry.boxNum = _viewSear.tfNum.text;


        self.capacityEntry.isOwnBox = _viewSear.btnYesOrNo.titleLabel.text ;
        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",_viewSear.num];
        self.capacityEntry.serviceWay = _viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = [SubmiteOrderViewController new];
            vc.capacityEntry = ws.capacityEntry;

            [ws.navigationController pushViewController:vc animated:YES];
        }];

        [self btnCancle];

    }else {

        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }
}

- (void) btnCancle {
    
    [self.lastBackgroundView removeFromSuperview];
    [self.lastBackgroundBlackView removeFromSuperview];

    self.lastBackgroundView = nil;
    self.lastBackgroundBlackView = nil;
   
    [self.viewSear removeFromSuperview];

    self.viewSear = nil;

}

-(void)pushLogoinVC {
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:vc animated:YES completion:^{

    }];
}




/**
 *
 *  @param tableView delegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Celled";
    SearchTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    TransportationModel *info = [self.arrInfos objectAtIndex:indexPath.row];

    cell.lbMessage.text = [NSString stringWithFormat:@"￥%.2f起",[info.ticketTotal floatValue]];
    //@"￥12000.00起";
    cell.lbMessage.font = [UIFont systemFontOfSize:20];
    cell.lbMessage.textColor = APP_COLOR_RED1;

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:cell.lbMessage.text];

    NSUInteger loc = cell.lbMessage.text.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    cell.lbMessage.attributedText = AttributedStr;

    //    NSString *time = [self stDateToString:info.departureTime];
    //
    //
    //    cell.lbTime.text = time;

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[info.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];
    cell.lbTime.text = stEndTime;
    cell.lbDay.text = [NSString stringWithFormat:@"%i日送达",[info.expectTime intValue]/1440];
    
    return cell;
    
}


/**
 *  getter
 */
- (UIView *)headView {

    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = APP_COLOR_WHITE;

    }
    return _headView;
}

- (UIButton *)btnUpAndDown {
    if (!_btnUpAndDown) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];


        _btnUpAndDown = button;
    }
    return _btnUpAndDown;
}

- (UIImageView *)iv {
    if (!_iv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"down"];


        _iv = imageView;
    }
    return _iv;
}

- (UITableView *)tvList {
    if (!_tvList) {

        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tvList = tableView;
    }
    return _tvList;
}

- (UIView *)viFoot {
    if (!_viFoot) {
        _viFoot = [UIView new];
        _viFoot.backgroundColor = [UIColor whiteColor];
    }
    return _viFoot;
}

- (UIImageView *)ivFoot {
    if (!_ivFoot) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"up"];


        _ivFoot = imageView;
    }
    return _ivFoot;
}

- (UILabel *)lbFoot {
    if (!_lbFoot) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有合适运力？ 开始定制";

        _lbFoot = label;
    }
    return _lbFoot;
}

- (UIButton *)btnFoot {
    if (!_btnFoot) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(FootClickAction) forControlEvents:UIControlEventTouchUpInside];

        _btnFoot = button;
    }
    return _btnFoot;
}

-(UIScrollView *)backScrollVe {
    if (!_backScrollVe) {
        UIScrollView * view = [UIScrollView new];
        view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        view.contentSize = CGSizeMake(SCREEN_W, 2 * SCREEN_H);
        view.backgroundColor = APP_COLOR_WHITE;
        view.scrollEnabled = NO;
        _backScrollVe = view;
    }
    return _backScrollVe;
}

-(CustomCapacityController *)customCapacityVC {
    if (!_customCapacityVC) {
        _customCapacityVC =(CustomCapacityController *)[self getControllerWithBaseName:@"CustomCapacityController"];
        
        _customCapacityVC.vcDelgate = self;
    }
    return _customCapacityVC;
}

- (UIView *)viTvHead {

    if (!_viTvHead) {
        _viTvHead = [UIView new];

        self.lbDistance = [UILabel new];

        CLLocation *orig=[[CLLocation alloc] initWithLatitude:[self.capacityEntry.startPlace.centerLat floatValue]  longitude:[self.capacityEntry.startPlace.centerLng floatValue]];
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:[self.capacityEntry.endPlace.centerLat floatValue] longitude:[self.capacityEntry.endPlace.centerLng floatValue] ];
        CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
        self.lbDistance.text = [NSString stringWithFormat:@"参考里程：约%.0f公里",kilometers];
        if (self.capacityEntry.km) {

            self.lbDistance.text = [NSString stringWithFormat:@"参考里程：约%@公里",self.capacityEntry.km];
            
        }

        if (self.capacityEntry.mileage) {
            self.lbDistance.text = [NSString stringWithFormat:@"参考里程：约%@公里",self.capacityEntry.mileage];

        }
        self.lbDistance.textColor = APP_COLOR_GRAY_TEXT_1;
        self.lbDistance.font = [UIFont systemFontOfSize:12];
        self.lbDistance.frame = CGRectMake(15, 10, SCREEN_W - 15, 20);
        [_viTvHead addSubview:self.lbDistance];

    }
    return _viTvHead;
}

- (UILabel *)lbDistance {
    if (!_lbDistance) {
        UILabel* label = [[UILabel alloc]init];


        _lbDistance = label;
    }
    return _lbDistance;
}



#pragma mark - 推窗交互代码部分
// get the current view screen shot
- (UIImage *)capture {
    // 判断是否为retina屏, 即retina屏绘图时有放大因子
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.window.bounds.size);
    }
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 页面交互代码部分
-(void)needPushNextView {
    [self.navigationController pushViewController:[OrderTransportSuccessViewController new] animated:YES];
}

-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title =@"集装箱运力";
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];

}
@end



#pragma mark - 集装箱运力
@implementation SearTransportResultViewController_Container : SearTransportResultViewController

- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];
            
        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{



    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name],self.capacityEntry.box.name, self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;
    
}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];


        
    }else {
        
        
        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现
- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView new];
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;

    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}
@end

#pragma mark - 散堆装运力
@implementation SearTransportResultViewController_InBulk : SearTransportResultViewController

- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name], self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( (self.viewSear.btnStyleChoose && self.viewSear.tfWeight.text.length >0)||(self.viewSear.btnStyleChoose && self.viewSear.tfBulk.text.length >0)) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        if (self.viewSear.tfWeight.text) {
            self.capacityEntry.weight = self.viewSear.tfWeight.text;
        }
        if (self.viewSear.tfBulk.text) {
            self.capacityEntry.volume = self.viewSear.tfBulk.text;

        }


        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/吨",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/吨 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现
- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView1 new];
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}
@end

#pragma mark - 三农化肥运力
@implementation SearTransportResultViewController_Fertilizer : SearTransportResultViewController

- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name], self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {

        self.capacityEntry.weight = self.viewSear.tfWeight.text;
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;

        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现
- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView2 new];
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}
@end


#pragma mark - 一带一路运力
@implementation SearTransportResultViewController_OneBeltOneRoad : SearTransportResultViewController


- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{

//            if (ws.capacityEntry.startPlace.entrepotType&&[ws.capacityEntry.startPlace.entrepotType isEqualToString:ws.capacityEntry.endPlace.entrepotType]) {
//
//                GoToContainerViewController *vc = [GoToContainerViewController new];
//                vc.lbPlace.text = [NSString stringWithFormat:@"%@ - %@",ws.capacityEntry.startPlace.name,ws.capacityEntry.endPlace.name];
//                [ws.navigationController pushViewController:vc animated:YES];
//
//            }else{

                ws.arrInfos = arr;
                [ws.tvList reloadData];
//
//            }

        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name],self.capacityEntry.box.name, self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现

- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView new];
    self.viewSear.lb1.text = @"一带一路运力";

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分

-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end

#pragma mark - 冷链运力
@implementation SearTransportResultViewController_ColdChain : SearTransportResultViewController
- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name],self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现

- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView new];
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}

@end

#pragma mark - 大件运力
@implementation SearTransportResultViewController_Big : SearTransportResultViewController

- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

//        arr  = @[];
//        ws.arrInfos = arr;
//        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name], self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = self.viewSear.tfNum.text;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.weight = self.viewSear.tfWeight.text;
        self.capacityEntry.longCm = self.viewSear.tfLong.text;
        self.capacityEntry.wideCm = self.viewSear.tfWeith.text;
        self.capacityEntry.highCm = self.viewSear.tfHeight.text;
        self.capacityEntry.biggestWeight = self.viewSear.tfLargestWeight.text;


        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现
- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView4 new];
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}
@end


#pragma mark - 商品车运力
@implementation SearTransportResultViewController_ForCar : SearTransportResultViewController

- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name], self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现
- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView new];
    self.viewSear.lb5.text = @"用车数量";
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}
@end

#pragma mark - 液态运力
@implementation SearTransportResultViewController_Liquid : SearTransportResultViewController

- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{
            ws.arrInfos = arr;
            [ws.tvList reloadData];
        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name], self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        self.capacityEntry.weight = self.viewSear.tfWeight.text;
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    cell.startStation.text = tModel.startStation;
    cell.startAddress.text = tModel.startAddress;
    cell.endStation.text = tModel.endStation;
    cell.endAddress.text = tModel.endAddress;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现
- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView2 new];
    self.viewSear.lb1.text = self.capacityEntry.capacityType;

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];


    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分
-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}
@end

#pragma mark - 快速配送运力
@implementation SearTransportResultViewController_QuickGo : SearTransportResultViewController


- (void)getData {

    CapacityViewModel *vm = [CapacityViewModel new];
    WS(ws);
    [vm lightcontainerCapacitySearchWithInfo:self.capacityEntry callback:^(NSArray *arr) {

        ws.arrInfos = arr;
        [ws.tvList reloadData];


        if(arr.count == 0) {

            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
            //删除最后一个，也就是自己
            [array removeObjectAtIndex:array.count-1];
            NoTransportViewController *vc= (NoTransportViewController *)[self getControllerWithBaseName:@"NoTransportViewController"];
            //添加要跳转的controller
            [array addObject:vc];
            vc.capacityEntry = ws.capacityEntry;
            [ws.navigationController pushViewController:vc animated:YES];
            [ws.navigationController setViewControllers:array animated:YES];
            MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
            [nv removePanGestureRecognizer];

        }else{

            //            if (ws.capacityEntry.startPlace.entrepotType&&[ws.capacityEntry.startPlace.entrepotType isEqualToString:ws.capacityEntry.endPlace.entrepotType]) {
            //
            //                GoToContainerViewController *vc = [GoToContainerViewController new];
            //                vc.lbPlace.text = [NSString stringWithFormat:@"%@ - %@",ws.capacityEntry.startPlace.name,ws.capacityEntry.endPlace.name];
            //                [ws.navigationController pushViewController:vc animated:YES];
            //
            //            }else{

            ws.arrInfos = arr;
            [ws.tvList reloadData];
            //
            //            }

        }

    }];


}

- (void)headViewMake{

    EntrySelectView *ev= [EntrySelectView new];
    CGFloat hight  = [ev loadViewWithEntrys:@[[NSString stringWithFormat:@"起运地：%@",self.capacityEntry.startPlace.name],[NSString stringWithFormat:@"抵运地：%@",self.capacityEntry.endPlace.name],[NSString stringWithFormat:@"货品：%@",self.capacityEntry.goodsInfo.name],self.capacityEntry.box.name, self.capacityEntry.stStartTime] WithWidth:SCREEN_W - 100];

    self.topHight = hight;
    ev.frame = CGRectMake(70, 10, SCREEN_W - 100, hight);
    [self.headView addSubview:ev];

    UILabel *lb = [UILabel new];
    lb.text = @"搜索条件";
    lb.font = [UIFont systemFontOfSize:12];
    lb.frame = CGRectMake(10, 20, 60 , 10);
    [self.headView addSubview:lb];

    self.iv.frame = CGRectMake(ev.right , 25, 13, 7);
    [self.headView addSubview:self.iv];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 60 , 0, 60, 60);
    [self.headView addSubview:self.btnUpAndDown];
    self.headView.frame  =CGRectMake(0, 0, SCREEN_W, hight + 10);

    self.viTvHead.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.tvList.tableHeaderView = self.viTvHead;

}

- (void) boomAction {


    if ( self.viewSear.btnStyleChoose && self.viewSear.num>0) {
        [self.viewSear removeFromSuperview];
        self.capacityEntry.transportationModel = self.currentInfo;
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;
        self.capacityEntry.isOwnBox = @"否";
        self.capacityEntry.boxNum = self.viewSear.tfNum.text;

        self.capacityEntry.boxNum = [NSString stringWithFormat:@"%i",self.viewSear.num];
        self.capacityEntry.serviceWay = self.viewSear.btnStyleChoose.titleLabel.text;

        CapacityViewModel *vm = [CapacityViewModel new];
        WS(ws);
        [vm getCapacityAddressWthCapacityId:self.currentInfo.ID callback:^(ContactInfo *contactInfo) {


            ws.capacityEntry.contactInfo = contactInfo;

            SubmiteOrderViewController *vc = (SubmiteOrderViewController *)[self getControllerWithBaseName:@"SubmiteOrderViewController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.capacityEntry.ticketType = ws.currentInfo.ticketType;

            [ws.navigationController pushViewController:vc animated:YES];

        }];
        [self btnCancle];



    }else {


        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectNum == section) {

        GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

        NSArray *arr = model.arrTransportationModel;

        return arr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:indexPath.section];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *tModel = [arr objectAtIndex:indexPath.row];
    NSString *st = [NSString stringWithFormat:@"%.2f元/箱",[tModel.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 0.5;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];

    UILabel *lbStart = [UILabel new];
    lbStart.frame = CGRectMake(40, 20, 100, 32);
    lbStart.font = [UIFont systemFontOfSize:14];
    lbStart.text = tModel.startRegionName;
    [cell addSubview:lbStart];

    UILabel *lbEnd = [UILabel new];
    lbEnd.frame = CGRectMake(40, 83, 100, 35);
    lbEnd.font = [UIFont systemFontOfSize:14];
    lbEnd.text = tModel.endRegionName;
    [cell addSubview:lbEnd];


    cell.startStation.hidden = YES;
    cell.startAddress.hidden = YES;
    cell.endStation.hidden = YES;
    cell.endAddress.hidden = YES;
    cell.btnChoose.tag = indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *stPrice;
    NSString *stDay;
    if ([tModel.ticketTotal floatValue] > [model.ticketTotal floatValue]) {

        stPrice = [NSString stringWithFormat:@"+￥%.2f",[tModel.ticketTotal floatValue]-[model.ticketTotal floatValue]];

    }else{
        stPrice = @"";
    }

    if ([tModel.expectTime floatValue] > [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"+%i天",(int)[tModel.expectTime floatValue]/60/24-(int)[model.expectTime floatValue]/60/24];
    }else if ([tModel.expectTime floatValue] < [model.expectTime floatValue]) {

        stDay = [NSString stringWithFormat:@"-%i天",(int)[model.expectTime floatValue]/60/24-(int)[tModel.expectTime floatValue]/60/24];
    }else {
        stDay = @"";
    }
    cell.lbDetail.text = [NSString stringWithFormat:@"%@ %@",stDay,stPrice];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 147;

}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 ;
}

//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GroupTransportationModel *model = [self.arrInfos objectAtIndex:section];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 86)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 0.5;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 2, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = [NSString stringWithFormat:@"%.2f元/箱 起",[model.ticketTotal floatValue]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY_TEXT_1
                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downAction1"]];
    if (section == self.selectNum) {

        ivUpDanDown.image = [UIImage imageNamed:@"upAction1"];

    }
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    //[header addSubview:viFoot];
    //
    //
    //    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    UIView *viLine = [UIView new];
    viLine.frame = CGRectMake(0, 0, SCREEN_W, 2);
    viLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [header addSubview:viLine];


    long long time = [model.departureTime longLongValue] + [model.expectTime longLongValue]*60*1000;

    lbTime.text = [NSString stringWithFormat:@"预计抵达 %@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
    lbDay.text = [NSString stringWithFormat:@"%i",(int)[model.expectTime longLongValue]/24/60];

    ivDingzhi.hidden = YES;

    if ([model.lineType isEqualToString:@"LINE_TYPE_CUSTOM_LINE"]) {

        //定制运力
        ivDingzhi.hidden = NO;
    }


    return header;
}

#pragma mark 展开收缩section中cell 手势监听

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{

    if (self.selectNum == recognizer.view.tag) {

        self.selectNum = -1;

    }else{

        self.selectNum = recognizer.view.tag;

    }
    [self.tvList reloadData];
}

- (void)chooseAction:(UIButton *)btn {


    if (!USER_INFO) {
        [self pushLogoinVC];
        return ;
    }else {

        UserInfoModel *us = USER_INFO;
        if ([us.authStatus isEqualToString:@"2"]) {

            [self searchViewShow:btn];
        }else {
            [[Toast shareToast]makeText:self.strToast aDuration:2];
        }
    }
}

#pragma mark -弹框出现

- (void)searchViewShow:(UIButton *)btn{

    self.lastBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundView.image = [self capture];
    self.lastBackgroundBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.lastBackgroundBlackView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.superview addSubview:self.lastBackgroundBlackView];
    [self.navigationController.view.superview addSubview:self.lastBackgroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.viewSear = [SearchResultView new];
    self.viewSear.lb1.text = @"快速配送运力";

    self.viewSear.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    self.viewSear.backgroundAlpha = 0;

    [window addSubview:self.viewSear];

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.viewSear.frame = CGRectMake(ws.viewSear.left, 0, ws.viewSear.width, ws.viewSear.height);
        ws.viewSear.backgroundAlpha = 0.7;
        ws.lastBackgroundView.transform = CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL finished) {
    }];

    [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

    [self.viewSear.btnCancle addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];
    
    
    GroupTransportationModel *model = [self.arrInfos objectAtIndex:self.selectNum];
    NSArray *arr = model.arrTransportationModel;
    TransportationModel *info = [arr objectAtIndex:btn.tag];
    self.currentInfo = info;
    self.viewSear.info = info;
    
    [self.viewSear.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 页面交互代码部分

-(void)needGoBackLastView {
    UIScrollView * view = (UIScrollView *)self.view;
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.title = ws.capacityEntry.capacityType;
        view.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end


