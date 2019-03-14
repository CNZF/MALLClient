//
//  ContainerCapacityController.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/25.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "ContainerCapacityController.h"
#import "CalendarView.h"
#import "DayIndoModel.h"
#import "EntrySelectCell.h"
#import "EntrySelectCellModel.h"
#import "ZCCityListViewController.h"
#import "ZCBranchesListViewController.h"
#import "SearTransportResultViewController.h"
#import "ContainerViewModel.h"
#import "ContainerTypeModel.h"
#import "GoodsHistorySql.h"
#import "ZSSearchViewController.h"
#import "MLNavigationController.h"
#import "GoToContainerViewController.h"

typedef enum{
    startPlaceBtn,
    endPlaceBtn,
    startTimeBtn,
    endTimeBtn,
}BtnTypeClick;

typedef enum{
    longTFdTag = 101,
    wideTFdTag,
    highTFdTag,
    biggestWeightTag,
    volumeTFdTag,
    weightTFdTag,
    vehicleTypeTFdTag,
    vehicleBrandTFdTag
}BiggestSize;

@interface ContainerCapacityController ()<UITableViewDelegate,UITableViewDataSource,chooseDateDelegate,EntrySelectCellDelegate,ZCCityListViewControllerDelagate,ZSSearchViewControllerDelegate,UITextFieldDelegate,ZCBranchesListViewControllerDelagate>

@property (nonatomic, assign) BtnTypeClick       clickBtn;
@property (nonatomic, strong) UIView             *headerView;//headView
@property (nonatomic, strong) UIButton           *startPlace;
@property (nonatomic, strong) UIButton           *endPlace;
@property (nonatomic, strong) UIButton           *startTime;
@property (nonatomic, strong) UIButton           *endTime;
@property (nonatomic, strong) UIView             *headerBox;//箱型
@property (nonatomic, strong) UILabel            *box;
@property (nonatomic, strong) NSArray            *arrContainerType;//集装箱箱型数组
@property (nonatomic, strong) UIView             *headerGoods;//货品
@property (nonatomic, strong) UILabel            *goods;
@property (nonatomic, strong) NSArray            *goodss;//货品数组
@property (nonatomic, strong) UIView             *biggestWeightView;//最大单件重量
@property (nonatomic, strong) UITextField        *biggestWeight;
@property (nonatomic, strong) UIView             *biggestSizeView;//最大单件尺寸
@property (nonatomic, strong) UILabel            *biggestSize;
@property (nonatomic, strong) UITextField        *longTFd;
@property (nonatomic, strong) UITextField        *wideTFd;
@property (nonatomic, strong) UITextField        *highTFd;
@property (nonatomic, strong) UIView             *packingTypeView;//包装类型
@property (nonatomic, strong) UIButton           *packingType;
@property (nonatomic, strong) UIView             *volume_weight_View;//体积重量
@property (nonatomic, strong) UITextField        *volumeTFd;
@property (nonatomic, strong) UITextField        *weightTFd;
@property (nonatomic, strong) UIView             *vehicleBrandView;//车辆品牌
@property (nonatomic, strong) UITextField        *vehicleBrandTFd;
@property (nonatomic, strong) UIView             *vehicleTypeView;//车辆类型
@property (nonatomic, strong) UITextField        *vehicleTypeTFd;
@property (nonatomic, strong) UIView             *searchView;//搜索
@property (nonatomic, strong) UIButton           *searchBtn;
@property (nonatomic, strong) UITableView        *tbv;//页面
@property (nonatomic, strong) NSMutableArray     *showViews;
@property (nonatomic, strong) CapacityEntryModel *model;//填充model

@property (nonatomic, strong) UIImage *imHead;

@property (nonatomic, strong) UIImageView *ivHead;



@end

@implementation ContainerCapacityController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    if (EQUIPMENTVERSION > 11.0) {
        self.navigationController.navigationBar.translucent = true;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

        self.navigationController.navigationBar.shadowImage = [UIImage new];

    }



    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};

    [self.btnLeft setImage:[UIImage imageNamed:[@"BackWhite" adS]] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [super navigationSet];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};

    self.navigationController.navigationBar.translucent = false;
}


-(void)viewDidLoad {

    [super viewDidLoad];
}

-(void)bindView {
    
//    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
//    [self.view addSubview:self.tbv];


    self.imHead = [UIImage imageNamed:@"jzxHead.jpg"];

    self.ivHead = [[UIImageView alloc]initWithImage:self.imHead];

    self.ivHead.frame = CGRectMake(0, -84, SCREEN_W, 200);
    [self.view addSubview:self.ivHead];

    self.tbv.frame = CGRectMake(0, 20, SCREEN_W, SCREEN_H - 64);
    self.tbv.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.tbv];
}

-(void)bindModel {
    if (_isFromHot) {
        self.clickBtn = startTimeBtn;
        if(self.caModel.shipmentsTime){

            [self chooseDateActionWithDate:self.caModel.shipmentsTime];

        }

        self.clickBtn = startPlaceBtn;
        [self getCityModel:self.caModel.startPlace];
        self.clickBtn = endPlaceBtn;
        [self getCityModel:self.caModel.endPlace];
        return ;
    }
    [self.startPlace setTitle:@"请选择起运地" forState:UIControlStateNormal];
    [self.endPlace setTitle:@"请选择抵运地" forState:UIControlStateNormal];
    [self.startTime setTitle:@"请选择发货时间" forState:UIControlStateNormal];
}

-(void)bindAction {
    WS(ws);
    [[self.startTime rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        ws.clickBtn = startTimeBtn;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        CalendarView *view = [CalendarView shareCalendarView];
        view.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
        view.backgroundAlpha = 0;
        view.chooseDateInfo = ws;
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(view.left,0, view.width, view.height);
        } completion:^(BOOL finished) {
            
        }];
        
        [window addSubview:view];
    }];

    if(![self isKindOfClass:[ContainerCapacityController_OneBeltOneRoad class]]&&![self isKindOfClass:[ContainerCapacityController_QuickGo class]]) {
        [[self.startPlace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        ZCCityListViewController * vc = [ZCCityListViewController new];
        vc.getCityDelagate = ws;
        vc.fromNaviC = NO;
        ws.clickBtn = startPlaceBtn;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{
            
        }];
    }];
        
        [[self.endPlace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
            
            ZCCityListViewController * vc = [ZCCityListViewController new];
            vc.fromNaviC = NO;
            vc.getCityDelagate = ws;
            ws.clickBtn = endPlaceBtn;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{
                
            }];
        }];
}
    

    [[self.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){



        if([self isKindOfClass:[ContainerCapacityController_OneBeltOneRoad class]]){

            //一带一路网点属性判断
             if (ws.model.startPlace.entrepotType.length > 0&&[ws.model.startPlace.entrepotType isEqualToString:ws.model.endPlace.entrepotType]) {

                 GoToContainerViewController *vc = [GoToContainerViewController new];
                 vc.stPlace = [NSString stringWithFormat:@"%@ - %@",ws.model.startPlace.name,ws.model.endPlace.name];
                 [ws.navigationController pushViewController:vc animated:YES];

             }else{

                 ws.model.capacityType = [ws.title copy];
                 //        NSString *classStr =  [NSString stringWithFormat:@"SearTransportResultViewController_%@",[NSStringFromClass([self class]) componentsSeparatedByString:@"_"][1]];
                 SearTransportResultViewController *vc = (SearTransportResultViewController *)[self getControllerWithBaseName:@"SearTransportResultViewController"];
                 vc.capacityEntry = ws.model;
                 [ws.navigationController pushViewController:vc animated:YES];

             }


        }else{

            ws.model.capacityType = [ws.title copy];
            //        NSString *classStr =  [NSString stringWithFormat:@"SearTransportResultViewController_%@",[NSStringFromClass([self class]) componentsSeparatedByString:@"_"][1]];
            SearTransportResultViewController *vc = (SearTransportResultViewController *)[self getControllerWithBaseName:@"SearTransportResultViewController"];
            vc.capacityEntry = ws.model;
            [ws.navigationController pushViewController:vc animated:YES];


        }
    }];
}

#pragma mark - 属性懒加载
-(CapacityEntryModel *)model {
    if (!_model) {
        _model = [CapacityEntryModel new];
    }
    return _model;
}

- (UIImageView *)ivHead {
    if (!_ivHead) {
        UIImageView *imageView = [[UIImageView alloc]init];

        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _ivHead = imageView;
    }
    return _ivHead;
}


-(UIView *)headerView {
    if (!_headerView)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 154)];
        view.backgroundColor = [UIColor clearColor];

        UIView *viHead = [UIView new];
        viHead.frame = CGRectMake(7, 15, SCREEN_W - 14, 140);
        viHead.backgroundColor = [UIColor whiteColor];
        [view addSubview:viHead];
        
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 2, 17)];
        lab1.text = @"起运地";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W / 2 + 20, 25, (SCREEN_W - 80)/ 2, 17)];
        lab2.text = @"抵运地";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UIImageView * igv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[@"The arrow" adS]]];
        igv.frame = CGRectMake(SCREEN_W / 2 - 13, 48, 25, 25);
        [view addSubview:igv];
        
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 2, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W / 2 + 20 , 78, (SCREEN_W - 80) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        
        self.startPlace.frame = CGRectMake(20, 50, SCREEN_W / 2 - 40, 20);
        [self makeButton:self.startPlace];
        [view addSubview:self.startPlace];
        
        self.endPlace.frame = CGRectMake(SCREEN_W / 2 + 20, 50, SCREEN_W / 2 - 40, 20);
        [self makeButton:self.endPlace];
        [view addSubview:self.endPlace];
        //单独处理三农化肥运力
        if ([self isKindOfClass:[ContainerCapacityController_Fertilizer class]]) {
//            UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, (SCREEN_W - 80)/ 2, 17)];
//            lab3.text = @"发货开始";
//            lab3.font = [UIFont systemFontOfSize:12.0f];
//            lab3.textAlignment = NSTextAlignmentLeft;
//            lab3.textColor = APP_COLOR_GRAY2;
//            [view addSubview:lab3];
//            
//            
//            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20, lab3.bottom + 37, (SCREEN_W - 80) / 2, 0.5)];
//            line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
//            [view addSubview:line3];
//            
//            UIImageView * igv1 = [[UIImageView alloc]initWithFrame:CGRectMake(line3.right - 7, 130, 7, 13)];
//            igv1.image = [UIImage imageNamed:[@"Back Chevron Copy 4" adS]];
//            [view addSubview:igv1];
//            
//            UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W / 2 + 20, lab3.top, (SCREEN_W - 80)/ 2, 17)];
//            lab4.text = @"发货截止";
//            lab4.font = [UIFont systemFontOfSize:12.0f];
//            lab4.textAlignment = NSTextAlignmentLeft;
//            lab4.textColor = APP_COLOR_GRAY2;
//            [view addSubview:lab4];
//            
//            
//            UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W / 2 + 20, lab3.bottom + 37, (SCREEN_W - 80) / 2, 1)];
//            line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
//            [view addSubview:line4];
//            
//            UIImageView * igv2 = [[UIImageView alloc]initWithFrame:CGRectMake(line4.right - 7, 130, 7, 13)];
//            igv2.image = [UIImage imageNamed:[@"Back Chevron Copy 4" adS]];
//            [view addSubview:igv2];
//            
//            
//            self.startTime.frame = CGRectMake(20, 125, SCREEN_W / 2 - 40, 20);
//            [self makeButton:self.startTime];
//            [view addSubview:self.startTime];
//            
//            self.endTime.frame = CGRectMake(SCREEN_W  / 2 + 20, 125, SCREEN_W / 2 - 40, 20);
//            [self makeButton:self.endTime];
//            [view addSubview:self.endTime];
            UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, SCREEN_W - 40, 17)];
            lab3.text = @"发货日期";
            lab3.font = [UIFont systemFontOfSize:12.0f];
            lab3.textAlignment = NSTextAlignmentLeft;
            lab3.textColor = APP_COLOR_GRAY2;
            [view addSubview:lab3];

            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20, lab3.bottom + 37, SCREEN_W - 40, 0.5)];
            line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            [view addSubview:line3];

            UIImageView * igv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W - 27, 130, 7, 13)];
            igv.image = [UIImage imageNamed:[@"Back Chevron Copy 4" adS]];
            [view addSubview:igv];

            self.startTime.frame = CGRectMake(20, 125, SCREEN_W - 40, 20);
            [self makeButton:self.startTime];
            [view addSubview:self.startTime];

        }
        else
        {
            UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, SCREEN_W - 40, 17)];
            lab3.text = @"发货日期";
            lab3.font = [UIFont systemFontOfSize:12.0f];
            lab3.textAlignment = NSTextAlignmentLeft;
            lab3.textColor = APP_COLOR_GRAY2;
            [view addSubview:lab3];
            
            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20, lab3.bottom + 37, SCREEN_W - 40, 0.5)];
            line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            [view addSubview:line3];
            
            UIImageView * igv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W - 27, 130, 7, 13)];
            igv.image = [UIImage imageNamed:[@"Back Chevron Copy 4" adS]];
            [view addSubview:igv];
            
            self.startTime.frame = CGRectMake(20, 125, SCREEN_W - 40, 20);
            [self makeButton:self.startTime];
            [view addSubview:self.startTime];
        }
        
        _headerView = view;
    }
    return _headerView;
}

-(UIButton *)startPlace {
    if (!_startPlace) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _startPlace = btn;
    }
    return _startPlace;
}

-(UIButton *)endPlace {
    if (!_endPlace) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _endPlace = btn;
    }
    return _endPlace;
}

-(UIButton *)startTime {
    if (!_startTime) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _startTime = btn;
    }
    return _startTime;
}

-(UIButton *)endTime {
    if (!_endTime) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _endTime = btn;
    }
    return _endTime;
}

-(UIView *)headerBox {
    if (!_headerBox)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
        view.backgroundColor = APP_COLOR_WHITE;

        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, (SCREEN_W - 60)/ 2, 17)];
        lab1.text = @"箱型";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        self.box.frame = CGRectMake(SCREEN_W - 140, 20, 120, 16);
        [view addSubview:self.box];

        _headerBox = view;
    }
    return _headerBox;
}

-(UILabel *)box {
    if (!_box)
    {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentRight;
        _box = label;
    }
    return _box;
}

-(UIView *)headerGoods {
    if (!_headerGoods)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
        view.backgroundColor = APP_COLOR_WHITE;

        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, (SCREEN_W - 60)/ 2, 17)];
        if ([self isKindOfClass:[ContainerCapacityController_Fertilizer class] ]) {
            lab1.text = @"项目名称";
        }
        else if ([self isKindOfClass:[ContainerCapacityController_ForCar class] ]) {
            lab1.text = @"品牌/车型";
        }
        else
        {
            lab1.text = @"货品名称";
        }



        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        self.goods.frame = CGRectMake(SCREEN_W - 140, 20, 120, 16);
        [view addSubview:self.goods];
        
        _headerGoods = view;
    }
    return _headerGoods;
}

-(UILabel *)goods {

    if (!_goods)
    {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentRight;
        _goods = label;
    }
    return _goods;
}

-(UIView *)biggestWeightView {
    if (!_biggestWeightView)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, SCREEN_W - 40, 17)];
        lab1.text = @"最大单件重量";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(20, lab1.bottom + 37, SCREEN_W - 40, 0.5)];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(line.right - 12, 54, 12, 16)];
        lab2.text = @"吨";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentRight;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
    
        self.biggestWeight.frame = CGRectMake(20, 54, SCREEN_W - 40, 20);
        [view addSubview:self.biggestWeight];
        
        _biggestWeightView = view;
    }
    return _biggestWeightView;
}

-(UITextField *)biggestWeight {
    if (!_biggestWeight) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.placeholder = @"单件";
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = biggestWeightTag;
        _biggestWeight = tfd;
    }
    return _biggestWeight;
}

-(UIView *)biggestSizeView {
    if (!_biggestSizeView)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, SCREEN_W - 40, 17)];
        if([self isKindOfClass:[ContainerCapacityController_Big class]])
        {
            lab.text = @"最大单件尺寸（长*宽*高）";
        }
        else if([self isKindOfClass:[ContainerCapacityController_Batch class]])
        {
            lab.text = @"最大单件尺寸（长-宽-高）";
        }
        
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab];
        
        UIView * line1;
        UILabel * lab1;
        for (int i = 0; i < 3; i ++) {
            line1 = [[UIView alloc]initWithFrame:CGRectMake(20 + (SCREEN_W - 20) / 3 * i, lab.bottom + 37, (SCREEN_W - 80) / 3, 0.5)];
            line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            [view addSubview:line1];
            
            lab1 = [[UILabel alloc]initWithFrame:CGRectMake(line1.right - 20, 54, 20, 16)];
            lab1.text = @"cm";
            lab1.font = [UIFont systemFontOfSize:12.0f];
            lab1.textAlignment = NSTextAlignmentRight;
            lab1.textColor = APP_COLOR_GRAY2;
            [view addSubview:lab1];
        }
        
        self.biggestSize.frame = CGRectMake(SCREEN_W - 140, 20, 120, 16);
        [view addSubview:self.biggestSize];
        
        self.longTFd.frame = CGRectMake(20, 50, (SCREEN_W - 80) / 3 - 20, 20);
        [view addSubview:self.longTFd];
        
        self.wideTFd.frame = CGRectMake(self.longTFd.right + 40, 50, (SCREEN_W - 80) / 3 - 20, 20);
        [view addSubview:self.wideTFd];
        
        self.highTFd.frame = CGRectMake(self.wideTFd.right + 40, 50, (SCREEN_W - 80) / 3 - 20, 20);
        [view addSubview:self.highTFd];
        
        _biggestWeightView = view;
    }
    return _biggestWeightView;
}

-(UILabel *)biggestSize {
    if (!_biggestSize)
    {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentRight;
        _biggestSize = label;
    }
    return _biggestSize;
}

-(UITextField *)longTFd {
    if (!_longTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.placeholder = @"长";
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = longTFdTag;
        _longTFd = tfd;
    }
    return _longTFd;
}

-(UITextField *)wideTFd {
    if (!_wideTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.placeholder = @"宽";
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = wideTFdTag;
        _wideTFd = tfd;
    }
    return _wideTFd;
}

-(UITextField *)highTFd {
    if (!_highTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.placeholder = @"高";
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = highTFdTag;
        _highTFd = tfd;
    }
    return _highTFd;
}

-(UIView *)packingTypeView {
    if (!_packingTypeView)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, SCREEN_W - 40, 17)];
        lab1.text = @"包装类型";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(20, lab1.bottom + 37, SCREEN_W - 40, 0.5)];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line];
        
        UIImageView * igv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W - 27, 54, 7, 13)];
        igv.image = [UIImage imageNamed:[@"Back Chevron Copy 4" adS]];
        [view addSubview:igv];
        
        
        self.packingType.frame = CGRectMake(20, 52, SCREEN_W - 40, 20);
        [self makeButton:self.packingType];
        [view addSubview:self.packingType];
        
        _biggestWeightView = view;
    }
    return _biggestWeightView;
}

-(UIButton *)packingType {
    if (!_packingType) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        [btn setTitle:@"包装类型" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _packingType = btn;
    }
    return _packingType;
}

-(UIView *)volume_weight_View {

    if (!_volume_weight_View)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 2, 17)];
        lab1.text = @"单件重量";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W / 2 + 20, 25, (SCREEN_W - 80)/ 2, 17)];
        lab2.text = @"单件体积";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 2, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W / 2 + 20, 78, (SCREEN_W - 80) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        UILabel * lab1_1 = [[UILabel alloc]initWithFrame:CGRectMake(line1.right - 14, 54, 14, 16)];
        lab1_1.text = @"kg";
        lab1_1.font = [UIFont systemFontOfSize:12.0f];
        lab1_1.textAlignment = NSTextAlignmentRight;
        lab1_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1_1];
        
        UILabel * lab1_2 = [[UILabel alloc]initWithFrame:CGRectMake(line2.right - 16, 54, 16, 16)];
        lab1_2.text = @"m³";
        lab1_2.font = [UIFont systemFontOfSize:12.0f];
        lab1_2.textAlignment = NSTextAlignmentRight;
        lab1_2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1_2];
        
        
        self.weightTFd.frame = CGRectMake(20, 50, (SCREEN_W - 80) / 2, 20);
        [view addSubview:self.weightTFd];
        
        self.volumeTFd.frame = CGRectMake(SCREEN_W / 2 + 20, 50,(SCREEN_W - 80) / 2, 20);
        [view addSubview:self.volumeTFd];
        
        _volume_weight_View = view;
    }
    return _volume_weight_View;
}

-(UITextField *)weightTFd{
    if (!_weightTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.placeholder = @"重量";
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = wideTFdTag;
        _weightTFd = tfd;
    }
    return _weightTFd;
}

-(UITextField *)volumeTFd{
    if (!_volumeTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.placeholder = @"体积";
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = volumeTFdTag;
        _volumeTFd = tfd;
    }
    return _volumeTFd;
}

-(UIView *)vehicleBrandView {
    if (!_vehicleBrandView)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, SCREEN_W - 40, 17)];
        lab1.text = @"车辆品牌";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(20, lab1.bottom + 37, SCREEN_W - 40, 0.5)];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line];
        
        self.vehicleBrandTFd.frame = CGRectMake(20, 54, SCREEN_W - 40, 20);
        [view addSubview:self.vehicleBrandTFd];
        
        _vehicleBrandView = view;
    }
    return _vehicleBrandView;
}

-(UITextField *)vehicleBrandTFd{
    if (!_vehicleBrandTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.placeholder = @"奔驰、大众、奥迪、雪铁龙…";
        tfd.delegate = self;
        tfd.tag = vehicleBrandTFdTag;

        _vehicleBrandTFd = tfd;
    }
    return _vehicleBrandTFd;
}

-(UIView *)vehicleTypeView {
    if (!_vehicleTypeView)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, SCREEN_W - 40, 17)];
        lab1.text = @"车辆类型";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(20, lab1.bottom + 37, SCREEN_W - 40, 0.5)];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line];
        
        self.vehicleTypeTFd.frame = CGRectMake(20, 54, SCREEN_W - 40, 20);
        [view addSubview:self.vehicleTypeTFd];
        
        _vehicleTypeView = view;
    }
    return _vehicleTypeView;
}

-(UITextField *)vehicleTypeTFd {
    if (!_vehicleTypeTFd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        tfd.placeholder = @"高尔夫、切诺基、瑞虎、秦…";
        tfd.delegate = self;
        tfd.tag = vehicleTypeTFdTag;
        _vehicleTypeTFd = tfd;
    }
    return _vehicleTypeTFd;
}

-(UIView *)searchView {
    if (!_searchView) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 123)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        self.searchBtn.frame = CGRectMake(20, 50, SCREEN_W - 40, 44);
        [view addSubview:self.searchBtn];
        
        _searchView = view;
    }
    return _searchView;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_GRAY_BTN_1 andSize:CGSizeMake(SCREEN_W - 40, 44)] createRadius:5] forState:UIControlStateDisabled];
        [button setBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_BLUE_BTN andSize:CGSizeMake(SCREEN_W - 40, 44)] createRadius:5] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_GRAY_BTN_1];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        button.enabled = NO;
        _searchBtn = button;
    }
    return _searchBtn;
}

-(NSMutableArray *)showViews{
    if (!_showViews) {
        _showViews = [NSMutableArray array];
    }
    return _showViews;
}


- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[EntrySelectCell class] forCellReuseIdentifier:NSStringFromClass([EntrySelectCell class])];
        _tbv = tableView;
    }
    return _tbv;
}

#pragma mark - Tabview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntrySelectCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EntrySelectCell class]) forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.dataArray[indexPath.section]];
    cell.cellDelegate = self;
    cell.indexPath = indexPath;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.showViews[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showViews.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.dataArray[section] isKindOfClass:[EntrySelectCellModel class]]) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    double height = 0;
    if ([self.dataArray[indexPath.section] isKindOfClass:[EntrySelectCellModel class]]) {
        if (((EntrySelectCellModel *)(self.dataArray[indexPath.section])).cellCloseOrOpen) {
            height = ((EntrySelectCellModel *)(self.dataArray[indexPath.section])).cellHeightOpen;
        }
        else
        {
            height = ((EntrySelectCellModel *)(self.dataArray[indexPath.section])).cellHeightClose;
        }
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    UIView * view = self.showViews[section];
    return view.height;
}

- (void)makeButton:(UIButton *)btn {
    if ([btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width > btn.width) {
        return ;
    }
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,-(btn.width -  [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width), 0.0,0.0)];
}

#pragma mark - 键入值回调

- (void)chooseDateActionWithDate:(NSDate *)date {
    DayIndoModel *dateInfo = [DayIndoModel new];
    [dateInfo modelWithDate:date];
    switch (self.clickBtn) {
        case startTimeBtn:
            self.model.shipmentsTime = date;
            [self.startTime setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            [self.startTime setTitle:[NSString stringWithFormat:@"%i年%i月%i日",dateInfo.year,dateInfo.month,dateInfo.day] forState:UIControlStateNormal];
            [self makeButton:self.startTime];
            break;
        case endTimeBtn:
            self.model.latestShipmentsTime = date;
            [self.endTime setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            [self.endTime setTitle:[NSString stringWithFormat:@"%i年%i月%i日",dateInfo.year,dateInfo.month,dateInfo.day] forState:UIControlStateNormal];
            [self makeButton:self.endTime];
            break;
        default:
            break;
    }
    [self refreshSearchBtn];
}

-(void)tabviewNeedReloadDataForIndexPath:(NSIndexPath *)indexPath {
    [self.tbv reloadData];

//    [self.tbv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    [self refreshSearchBtn];
}

-(void)getCityModel:(CityModel *)cityModel {

    if (self.clickBtn == startPlaceBtn) {
        [self.startPlace setTitle:cityModel.name forState:UIControlStateNormal];
        [self.startPlace setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.model.startPlace = cityModel;
        [self makeButton:self.startPlace];
    }
    else if (self.clickBtn == endPlaceBtn)
    {
        [self.endPlace setTitle:cityModel.name forState:UIControlStateNormal];
        [self.endPlace setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.model.endPlace = cityModel;
        [self makeButton:self.endPlace];

    }

    [self refreshSearchBtn];
}

-(void)plusSignHiddenCellClick {
    ZSSearchViewController * vc = [ZSSearchViewController new];
    vc.vcDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getGood:(GoodsInfo *)goods {
    self.model.goodsInfo = goods;
    
    [[GoodsHistorySql shareGoodsHistorySqlite] increaseOneGoodsData:goods];
    self.goods.text = goods.name;
    self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;
    
    EntrySelectCellModel * model2;
    if ([self isKindOfClass:[ContainerCapacityController_Container class]] || [self isKindOfClass:[ContainerCapacityController_OneBeltOneRoad class]]) {
        model2 =  self.dataArray[2];
    }
    else
    {
        model2 =  self.dataArray[1];

    }
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    [model2.entrys removeAllObjects];
    for (GoodsInfo * goods in self.goodss)
    {
        [model2.entrys addObject:goods.name];
    }
    [[EntrySelectCell new]loadUIWithmodel:model2];
    model2.selectStr = goods.name;
    [self.tbv reloadData];
    [self refreshSearchBtn];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case longTFdTag:
            self.model.longCm = textField.text;
            self.biggestSize.text = [NSString stringWithFormat:@"%dx%dx%d",[self.model.longCm intValue],[self.model.wideCm intValue],[self.model.highCm intValue]];
            break;
        case wideTFdTag:
            self.model.wideCm = textField.text;
            self.biggestSize.text = [NSString stringWithFormat:@"%dx%dx%d",[self.model.longCm intValue],[self.model.wideCm intValue],[self.model.highCm intValue]];
            break;
        case highTFdTag:
            self.model.highCm = textField.text;
            self.biggestSize.text = [NSString stringWithFormat:@"%dx%dx%d",[self.model.longCm intValue],[self.model.wideCm intValue],[self.model.highCm intValue]];
            break;
        case volumeTFdTag:
            self.model.volume = textField.text;
            break;
        case weightTFdTag:
            self.model.weight = textField.text;
            break;
        case vehicleTypeTFdTag:
            self.model.vehicleType = textField.text;

            break;
        case vehicleBrandTFdTag:
            self.model.vehicleBrand = textField.text;
            break;
        case biggestWeightTag:
            self.model.biggestWeight = textField.text;

            break;
        default:
            break;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {
    
}

-(void)getBranchesModel:(CityModel *)cityModel {
    
}
@end

#pragma mark - 集装箱运力

@implementation ContainerCapacityController_Container


-(void)viewDidLoad {

    [super viewDidLoad];

    self.title = @"集装箱运力";
    self.imHead = [UIImage imageNamed:@"jzxHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)getData {
    ContainerViewModel *vm = [ContainerViewModel new];
    WS(ws);
    [vm getContainerTypecallback:^(NSArray *arr) {
        
        ws.arrContainerType = arr;
        EntrySelectCellModel * model = ws.dataArray[1];
        [model.entrys removeAllObjects];
        for (ContainerTypeModel * mod in arr)
        {
            if(mod.name){
                
                [model.entrys addObject:mod.name];
                
            }
            
        }
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

-(void)bindModel {

    [super bindModel];
    self.model.km = self.caModel.km;
    self.box.text = @"未选择";
    self.goods.text = @"未选择";
    [self.startTime setTitle:@"请选择发货时间" forState:UIControlStateNormal];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model1 = [EntrySelectCellModel new];
    model1.cellHeightClose = 55;
    model1.cellCloseOrOpen = NO;
    [self.dataArray addObject:model1];
    
    EntrySelectCellModel * model2 = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model2.entrys addObject:goods.name];
    }
    model2.cellHeightClose = 55;
    model2.cellCloseOrOpen = NO;
    model2.plusSignHidden = NO;
    [self.dataArray addObject:model2];
    [self.dataArray addObject:[NSObject new]];
    
    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerBox];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.box.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        if (self.arrContainerType) {
            self.model.box = [self.arrContainerType objectAtIndex:row];
        }
        
        self.box.text = str;
    }
    else if (indexPath.section == 2)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        
        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {
    
    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.box.name && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

-(void)onBackAction {
    if (self.isReturnToFirst) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

#pragma mark - 散堆装运力
@implementation ContainerCapacityController_InBulk

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"散堆装运力";

    self.imHead = [UIImage imageNamed:@"sdzHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindModel {
    [super bindModel];
    self.goods.text = @"未选择";

    [self.startTime setTitle:@"请选择发货时间" forState:UIControlStateNormal];
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];
    
    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        
        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {
    
    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

@end

#pragma mark - 三农化肥运力 
@implementation ContainerCapacityController_Fertilizer

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三农化肥运力";

    self.imHead = [UIImage imageNamed:@"snHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.endTime rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        ws.clickBtn = endTimeBtn;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        CalendarView *view = [CalendarView shareCalendarView];
        view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        view.chooseDateInfo = ws;
        [window addSubview:view];
    }];
}

-(void)bindModel {
    [super bindModel];
    [self.endTime setTitle:@"请选择发货截止时间" forState:UIControlStateNormal];
    self.goods.text = @"未选择";
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];
    
    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        
        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {
    
    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime  && self.model.goodsInfo) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

@end

#pragma mark - 批量成件运力
@implementation ContainerCapacityController_Batch

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"批量成件运力";

    self.imHead = [UIImage imageNamed:@"snHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindModel {
    [super bindModel];
    self.goods.text = @"未选择";
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    [self.dataArray addObject:[NSObject new]];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];
    
    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.volume_weight_View];
    [self.showViews addObject:self.biggestSizeView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        
        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {
    
    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime&& self.model.volume&& self.model.weight && self.model.longCm &&self.model.wideCm &&self.model.highCm && self.model.goodsInfo) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

@end

#pragma mark - 冷链运力
@implementation ContainerCapacityController_ColdChain

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"冷链运力";

    self.imHead = [UIImage imageNamed:@"llHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindModel {
    [super bindModel];
    self.goods.text = @"未选择";

    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];

    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];

    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;

        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {

    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

@end

#pragma mark - 大件运力
@implementation ContainerCapacityController_Big

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大件运力";

    self.imHead = [UIImage imageNamed:@"djHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindModel {
    [super bindModel];
    self.goods.text = @"未选择";

    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];

    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];

    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;

        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {

    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}
@end

#pragma mark - 商品车运力
@implementation ContainerCapacityController_ForCar

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品车运力";

    self.imHead = [UIImage imageNamed:@"spcHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindModel {
    [super bindModel];
    self.goods.text = @"未选择";

    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];

    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];

    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;

        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {

    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

@end

#pragma mark - 液态运力
@implementation ContainerCapacityController_Liquid

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"液态运力";

    self.imHead = [UIImage imageNamed:@"ytHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindModel {
    [super bindModel];
    self.goods.text = @"未选择";

    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];

    EntrySelectCellModel * model = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model.entrys addObject:goods.name];
    }
    model.cellHeightClose = 55;
    model.cellCloseOrOpen = NO;
    model.plusSignHidden = NO;
    [self.dataArray addObject:model];
    [self.dataArray addObject:[NSObject new]];

    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;

        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {

    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

@end

#pragma mark - 一带一路运力
@implementation ContainerCapacityController_OneBeltOneRoad

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"一带一路运力";

    self.imHead = [UIImage imageNamed:@"ydylHead.jpg"];
    self.ivHead.image = self.imHead;
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.startPlace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        ZCBranchesListViewController * vc = [ZCBranchesListViewController new];
        vc.getCityDelagate = ws;
        ws.clickBtn = startPlaceBtn;
        vc.title = @"起运地";
        [ws presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{
            
        }];
    }];
    
    [[self.endPlace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        ZCBranchesListViewController * vc = [ZCBranchesListViewController new];
        vc.getCityDelagate = ws;
        vc.title = @"抵运地";
        ws.clickBtn = endPlaceBtn;
        [ws presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{
            
        }];
    }];

}

-(void)getData {
    ContainerViewModel *vm = [ContainerViewModel new];
    WS(ws);
    [vm getContainerTypecallback:^(NSArray *arr) {
        
        ws.arrContainerType = arr;
        EntrySelectCellModel * model = ws.dataArray[1];
        [model.entrys removeAllObjects];
        for (ContainerTypeModel * mod in arr)
        {
            if(mod.name){
                
                [model.entrys addObject:mod.name];
                
            }
            
        }
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

-(void)bindModel {
    
    [super bindModel];
    self.box.text = @"未选择";
    self.goods.text = @"未选择";
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model1 = [EntrySelectCellModel new];
    model1.cellHeightClose = 55;
    model1.cellCloseOrOpen = NO;
    [self.dataArray addObject:model1];
    
    EntrySelectCellModel * model2 = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model2.entrys addObject:goods.name];
    }
    model2.cellHeightClose = 55;
    model2.cellCloseOrOpen = NO;
    model2.plusSignHidden = NO;
    [self.dataArray addObject:model2];
    [self.dataArray addObject:[NSObject new]];
    
    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerBox];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1)
    {
        self.box.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        if (self.arrContainerType) {
            self.model.box = [self.arrContainerType objectAtIndex:row];
        }
        
        self.box.text = str;
    }
    else if (indexPath.section == 2)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        
        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {
    
    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

- (void)getBranchesModel:(CityModel *)cityModel {
    if (self.clickBtn == startPlaceBtn) {
        [self.startPlace setTitle:cityModel.name forState:UIControlStateNormal];
        [self.startPlace setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.model.startPlace = cityModel;
        [self makeButton:self.startPlace];
    }
    else if (self.clickBtn == endPlaceBtn)
    {
        [self.endPlace setTitle:cityModel.name forState:UIControlStateNormal];
        [self.endPlace setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.model.endPlace = cityModel;
        [self makeButton:self.endPlace];
        
    }
    
    [self refreshSearchBtn];
}

@end

#pragma mark - 快速配送运力
@implementation ContainerCapacityController_QuickGo

-(void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"快速配送运力";

    self.imHead = [UIImage imageNamed:@"快速配送"];
    self.ivHead.image = self.imHead;
}

-(void)getData {
    ContainerViewModel *vm = [ContainerViewModel new];
    WS(ws);
    [vm getContainerTypecallback:^(NSArray *arr) {

        ws.arrContainerType = arr;
        EntrySelectCellModel * model = ws.dataArray[1];
        [model.entrys removeAllObjects];
        for (ContainerTypeModel * mod in arr)
        {
            if(mod.name){

                [model.entrys addObject:mod.name];

            }

        }
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

    }];
}

-(void)bindModel {

    [super bindModel];

    self.model.startEntrepotId = self.caModel.startEntrepotId;
    self.model.endEntrepotId = self.caModel.endEntrepotId;
    self.model.mileage = self.caModel.mileage;

    self.box.text = @"未选择";
    self.goods.text = @"未选择";

    [self.startTime setTitle:@"请选择发货时间" forState:UIControlStateNormal];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];

    EntrySelectCellModel * model1 = [EntrySelectCellModel new];
    model1.cellHeightClose = 55;
    model1.cellCloseOrOpen = NO;
    [self.dataArray addObject:model1];

    EntrySelectCellModel * model2 = [EntrySelectCellModel new];
    self.goodss = [[GoodsHistorySql shareGoodsHistorySqlite] selectAllGoodsData];
    for (GoodsInfo * goods in self.goodss)
    {
        [model2.entrys addObject:goods.name];
    }
    model2.cellHeightClose = 55;
    model2.cellCloseOrOpen = NO;
    model2.plusSignHidden = NO;
    [self.dataArray addObject:model2];
    [self.dataArray addObject:[NSObject new]];

    [self.showViews addObject:self.headerView];
    [self.showViews addObject:self.headerBox];
    [self.showViews addObject:self.headerGoods];
    [self.showViews addObject:self.searchView];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1)
    {
        self.box.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        if (self.arrContainerType) {
            self.model.box = [self.arrContainerType objectAtIndex:row];
        }

        self.box.text = str;
    }
    else if (indexPath.section == 2)
    {
        self.goods.textColor = APP_COLOR_ORANGE_BTN_TEXT;

        self.model.goodsInfo = self.goodss[row];
        self.goods.text = str;
    }
    [self refreshSearchBtn];
}

-(void)refreshSearchBtn {

    if (self.model.startPlace.name && self.model.endPlace.name && self.model.shipmentsTime && self.model.box.name && self.model.goodsInfo.name) {
        self.searchBtn.enabled = YES;
    }
    else
    {
        self.searchBtn.enabled = NO;
    }
}

-(void)onBackAction {
    if (self.isReturnToFirst) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.startPlace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        ZCBranchesListViewController * vc = [ZCBranchesListViewController new];
        vc.getCityDelagate = ws;
        ws.clickBtn = startPlaceBtn;
        vc.title = @"起运地";
        vc.type = 1;
        [ws presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{

        }];
    }];

    [[self.endPlace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        ZCBranchesListViewController * vc = [ZCBranchesListViewController new];
        vc.getCityDelagate = ws;
        vc.title = @"抵运地";
        vc.type = 1;
        ws.clickBtn = endPlaceBtn;
        [ws presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{

        }];
    }];

}


- (void)getBranchesModel:(CityModel *)cityModel {
    if (self.clickBtn == startPlaceBtn) {
        [self.startPlace setTitle:cityModel.name forState:UIControlStateNormal];
        [self.startPlace setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.model.startPlace = cityModel;
        [self makeButton:self.startPlace];
    }
    else if (self.clickBtn == endPlaceBtn)
    {
        [self.endPlace setTitle:cityModel.name forState:UIControlStateNormal];
        [self.endPlace setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.model.endPlace = cityModel;
        [self makeButton:self.endPlace];

    }

    [self refreshSearchBtn];
}

@end
