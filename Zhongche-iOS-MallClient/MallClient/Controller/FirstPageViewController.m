//
//  FirstPageViewController.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/24.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "FirstPageViewController.h"
#import "BuyCapacityController.h"
#import "EmptyContainerVC.h"
#import "LoginViewController.h"
#import "LLBannerView.h"
#import "UserViewModel.h"
#import "HotCapacityCell.h"
#import "ConstructionVC.h"
#import "ContainerCapacityController.h"
#import "ConstructionVC.h"
#import "MLNavigationController.h"
#import "CapacityViewModel.h"
#import "EmptyCarVC.h"
#import "DynamicDetailsViewController.h"

#import "GoToContainerViewController.h"

#import "QuickGoVC.h"

#import "TableViewAnimationKitHeaders.h"



#import "CoalListVC.h"



@interface FirstPageViewController ()<UITableViewDelegate,UITableViewDataSource,LLBannerViewDelegate>

@property (nonatomic, strong) LLBannerView    * bannerVi;
@property (nonatomic, strong) UIView          * capacityVi;
@property (nonatomic, strong) UIButton        * buyCapacityBtn;
@property (nonatomic, strong) UIButton        * containerBtn;
@property (nonatomic, strong) UIButton        * inBulkBtn;
@property (nonatomic, strong) UIButton        * OneBeltOneRoadBtn;
@property (nonatomic, strong) UIButton        * LargeBtn;
@property (nonatomic, strong) UIButton        * LiquidBtn;
@property (nonatomic, strong) UIButton        * ColdBtn;
@property (nonatomic, strong) UIButton        * fertilizerBtn;
@property (nonatomic, strong) UIButton        * ShopCarBtn;
@property (nonatomic, strong) UIButton        * moreBtn;
@property (nonatomic, strong) UIView          * emptyVi;
@property (nonatomic, strong) UIButton        * emptyContainerBtn;
@property (nonatomic, strong) UIButton        * emptyCarBtn;
@property (nonatomic, strong) UIButton        * quickGoBtn;
@property (nonatomic, strong) UIButton        * coalBtn;
@property (nonatomic, strong) UITableViewCell * hotContainerVi;
@property (nonatomic, strong) UIButton        * moreHotBtn;
@property (nonatomic, strong) UITableView     * tbv;
@property (nonatomic, strong) NSMutableArray  * dataArray;
@property (nonatomic, strong) UIImageView *iv1;

@property (nonatomic, strong) NSMutableArray * bannerModelArr;
@property (nonatomic, strong) MJRefreshNormalHeader     * refreshHeader;//MJ刷新

@property (nonatomic, strong) UIImageView *iv01;
@property (nonatomic, strong) UIImageView *iv02;
@property (nonatomic, strong) UIImageView *iv03;
@property (nonatomic, strong) UIImageView *iv04;
@property (nonatomic, strong) UIImageView *iv05;
@property (nonatomic, strong) UIImageView *iv06;
@property (nonatomic, strong) UIImageView *iv07;
@property (nonatomic, strong) UIImageView *iv08;

@property (nonatomic, strong) UILabel *lb1;
@property (nonatomic, strong) UILabel *lb2;
@property (nonatomic, strong) UILabel *lb3;
@property (nonatomic, strong) UILabel *lb4;
@property (nonatomic, strong) UILabel *lb5;
@property (nonatomic, strong) UILabel *lb6;
@property (nonatomic, strong) UILabel *lb7;
@property (nonatomic, strong) UILabel *lb8;

@end

@implementation FirstPageViewController


- (void)dealloc {
    [self.bannerVi.timer invalidate];
    self.bannerVi = nil;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bindView {
    
    self.tbv.frame = CGRectMake(0, -20, SCREEN_W, SCREEN_H - 24);
    [self.view addSubview:self.tbv];

    //隐藏更多按钮
    self.moreHotBtn.hidden = YES;


//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"沙盒=====%@", paths[0]);


    
}

- (void)bindModel {

    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 1; i ++) {
        [arr addObject:[UIImage imageNamed:@"B3.jpg"]];
        [arr addObject:[UIImage imageNamed:@"b1.jpg"]];
        [arr addObject:[UIImage imageNamed:@"B2.jpg"]];
        [arr addObject:[UIImage imageNamed:@"B4.jpg"]];

    }
    self.bannerVi.images = arr;
    
    [self.dataArray addObject:[NSArray new]];
    [self.dataArray addObject:[NSArray new]];
    [self.dataArray addObject:[NSArray new]];
    [self.dataArray addObject:[NSMutableArray arrayWithObjects:[NSNull new],nil]];

    [self loadingData];
}

- (void)loadingData{

    WS(ws);
    [[CapacityViewModel new]getBannerCallback:^(NSArray *arr) {
        if(arr.count > 0) {
            [self.bannerModelArr removeAllObjects];
            [self.bannerModelArr addObjectsFromArray:arr];
            NSMutableArray * urlArr = [NSMutableArray new];
            for (BannerModel * model in self.bannerModelArr) {
                [urlArr addObject:model.url];
            }
            self.bannerVi.images = urlArr;
        }

    }];
    
    [[CapacityViewModel new]getRecommendTicketsCallback:^(NSArray *arr) {
        if(arr){
            NSMutableArray * marr = [NSMutableArray arrayWithArray:arr];
            [marr insertObject:[NSNull new] atIndex:0];
            [ws.dataArray replaceObjectAtIndex:3 withObject:marr];
            [ws.tbv reloadData];
        }

        [ws.tbv.mj_header endRefreshing];
    }];
}

- (void)bindAction {

     WS(ws);
    [[self.buyCapacityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
       [ws.navigationController pushViewController:[BuyCapacityController new] animated:YES];
    }];

    [[self.containerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_Container new] animated:YES];
    }];
    
    [[self.inBulkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_InBulk new] animated:YES];
    }];
    
    [[self.fertilizerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_Fertilizer new] animated:YES];
    }];

    [[self.LargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_Big new] animated:YES];
    }];

    [[self.ShopCarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_ForCar new] animated:YES];
    }];

    [[self.ColdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_ColdChain new] animated:YES];
    }];
    
    [[self.OneBeltOneRoadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
            [ws.navigationController pushViewController:[ContainerCapacityController_OneBeltOneRoad new] animated:YES];
    }];
    
    [[self.LiquidBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        [ws.navigationController pushViewController:[ContainerCapacityController_Liquid new] animated:YES];
    }];
    
    [[self.moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        [ws.navigationController pushViewController:[BuyCapacityController new] animated:YES];
    }];
    

    [[self.emptyContainerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        [ws.navigationController pushViewController:[EmptyContainerVC new] animated:YES];
    }];
    
    [[self.emptyCarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        EmptyCarVC * vc = [EmptyCarVC new];
        vc.isRecommendedVC = YES;
        [ws.navigationController pushViewController:vc animated:YES];
    }];

    [[self.quickGoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
       [ws.navigationController pushViewController:[ContainerCapacityController_QuickGo new] animated:YES];


        //QuickGoVC.h
    }];

   

    //煤
    [[self.coalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        [ws.navigationController pushViewController:[CoalListVC new] animated:YES];
    }];

    [[self.moreHotBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){

        [ws.navigationController pushViewController:[ContainerCapacityController_Container new] animated:YES];
    }];
    
    self.tbv.mj_header = self.refreshHeader;

}

/**
 *  懒加载
 *
 */

-(LLBannerView *)bannerVi {
    if (!_bannerVi) {
        _bannerVi = [LLBannerView new];
        _bannerVi.frame = CGRectMake(0, 0, SCREEN_W, 185 * SCREEN_W_COEFFICIENT);
        _bannerVi.bannerViewDelegate=self;
    }
    return _bannerVi;
}

-(UIView *)capacityVi {
    if (!_capacityVi) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;

        
        self.containerBtn.frame = CGRectMake(0, 10, SCREEN_W / 4, 60);
        self.iv01.frame = CGRectMake(0, 10, SCREEN_W / 4, 60);
        [self makeButton:self.containerBtn];
        [view addSubview:self.iv01];
        [view addSubview:self.containerBtn];

        self.lb1.frame = CGRectMake(0, 65, SCREEN_W / 4, 20);
        [view addSubview:self.lb1];
        
        self.inBulkBtn.frame = CGRectMake(SCREEN_W / 4   ,10, SCREEN_W / 4, 60);
        self.iv02.frame = CGRectMake(SCREEN_W / 4   ,10, SCREEN_W / 4, 60);
        [self makeButton:self.inBulkBtn];
        [view addSubview:self.inBulkBtn];
        [view addSubview:self.iv02];
        self.lb2.frame = CGRectMake(SCREEN_W / 4, 65, SCREEN_W / 4, 20);
        [view addSubview:self.lb2];

        self.OneBeltOneRoadBtn.frame = CGRectMake(SCREEN_W / 4 * 2, 10, SCREEN_W / 4, 60);
        self.iv03.frame = CGRectMake(SCREEN_W / 4 * 2, 10, SCREEN_W / 4, 60);
        [self makeButton:self.OneBeltOneRoadBtn];
        [view addSubview:self.OneBeltOneRoadBtn];
        [view addSubview:self.iv03];
        self.lb3.frame = CGRectMake(SCREEN_W / 4 *2, 65, SCREEN_W / 4, 20);
        [view addSubview:self.lb3];

        self.LargeBtn.frame = CGRectMake(SCREEN_W / 4 * 3 , 10, SCREEN_W / 4, 60);
        self.iv04.frame = CGRectMake(SCREEN_W / 4 * 3 , 10, SCREEN_W / 4, 60);
        [self makeButton:self.LargeBtn];
        [view addSubview:self.LargeBtn];
        [view addSubview:self.iv04];
        self.lb4.frame = CGRectMake(SCREEN_W / 4 *3, 65, SCREEN_W / 4, 20);
        [view addSubview:self.lb4];

        self.ColdBtn.frame = CGRectMake(0, 100, SCREEN_W / 4, 60);
        self.iv05.frame = CGRectMake(0, 100, SCREEN_W / 4, 60);
        [self makeButton:self.ColdBtn];
        [view addSubview:self.ColdBtn];
        [view addSubview:self.iv05];
        self.lb5.frame = CGRectMake(0, 155, SCREEN_W / 4, 20);
        [view addSubview:self.lb5];

        self.LiquidBtn.frame = CGRectMake(SCREEN_W / 4, 100, SCREEN_W / 4, 60);
        self.iv06.frame = CGRectMake(SCREEN_W / 4, 100, SCREEN_W / 4, 60);
        [self makeButton:self.LiquidBtn];
        [view addSubview:self.LiquidBtn];
        [view addSubview:self.iv06];
        self.lb6.frame = CGRectMake(SCREEN_W / 4, 155, SCREEN_W / 4, 20);
        [view addSubview:self.lb6];

        self.ShopCarBtn.frame = CGRectMake(SCREEN_W / 4 * 2 + 5, 100, SCREEN_W / 4, 60);
        self.iv07.frame = CGRectMake(SCREEN_W / 4 * 2 , 100, SCREEN_W / 4, 60);
        [self makeButton:self.ShopCarBtn];
        [view addSubview:self.ShopCarBtn];
        [view addSubview:self.iv07];
        self.lb7.frame = CGRectMake(SCREEN_W / 4 *2, 155, SCREEN_W / 4, 20);
        [view addSubview:self.lb7];

        self.fertilizerBtn.frame = CGRectMake(SCREEN_W / 4 * 3 + 5, 100, SCREEN_W / 4, 60);
        self.iv08.frame = CGRectMake(SCREEN_W / 4 * 3 , 100, SCREEN_W / 4, 60);
        [self makeButton:self.fertilizerBtn];
        [view addSubview:self.fertilizerBtn];
        [view addSubview:self.iv08];
        self.lb8.frame = CGRectMake(SCREEN_W / 4 *3, 155, SCREEN_W / 4, 20);
        [view addSubview:self.lb8];

        

        

        _capacityVi = view;
    }
    return _capacityVi;
}

-(UIButton *)buyCapacityBtn {
    if (!_buyCapacityBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"Group 27 Copy" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"我要运力" forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTitleColor:APP_COLOR_BLUE_BTN_ forState:UIControlStateNormal];
        _buyCapacityBtn = btn;
    }
    return _buyCapacityBtn;
}

-(UIButton *)containerBtn {
    if (!_containerBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"jzx" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"  集装箱   " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"集装箱   " forState:UIControlStateNormal];
//        }
//        if (SCREEN_W > 400) {
//            [btn setTitle:@"集装箱 " forState:UIControlStateNormal];
//        }
//        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        _containerBtn = btn;
    }
    return _containerBtn;
}

-(UIButton *)inBulkBtn {
    if (!_inBulkBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"sdz" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"  散堆装   " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"散堆装   " forState:UIControlStateNormal];
//        }
//        if (SCREEN_W > 400) {
//            [btn setTitle:@"散堆装 " forState:UIControlStateNormal];
//        }

        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        _inBulkBtn = btn;
    }
    return _inBulkBtn;
}

-(UIButton *)OneBeltOneRoadBtn {
    if (!_OneBeltOneRoadBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"ydyl" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"一带一路  " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"  一带一路  " forState:UIControlStateNormal];
//        }
//        if (SCREEN_W > 400) {
//            [btn setTitle:@"一带一路" forState:UIControlStateNormal];
//        }
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        _OneBeltOneRoadBtn = btn;
    }
    return _OneBeltOneRoadBtn;
}

-(UIButton *)fertilizerBtn {
    if (!_fertilizerBtn) {
        UIButton * btn = [UIButton new];
        //[btn setImage:[[UIImage imageNamed:[@"sn" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"三农化肥  " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"  三农化肥  " forState:UIControlStateNormal];
//        }
//        if (SCREEN_W > 400) {
//            [btn setTitle:@"三农化肥" forState:UIControlStateNormal];
//        }
//        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        _fertilizerBtn = btn;
    }
    return _fertilizerBtn;
}

-(UIButton *)LiquidBtn {
    if (!_LiquidBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"yt" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"   液态   " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"  液态   " forState:UIControlStateNormal];
//        }
//        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        _LiquidBtn = btn;
    }
    return _LiquidBtn;
}

- (UIButton *)ColdBtn {
    if (!_ColdBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"ll" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"   冷链   " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"  冷链   " forState:UIControlStateNormal];
//        }
//        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];

        _ColdBtn = btn;
    }
    return _ColdBtn;
}

- (UIButton *)ShopCarBtn {
    if (!_ShopCarBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"spc" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"  商品车   " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"商品车   " forState:UIControlStateNormal];
//        }
//        if (SCREEN_W > 400) {
//            [btn setTitle:@"商品车 " forState:UIControlStateNormal];
//        }
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];

        _ShopCarBtn = btn;
    }
    return _ShopCarBtn;
}


- (UIButton *)LargeBtn {
    if (!_LargeBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"dj" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"   大件   " forState:UIControlStateNormal];
//        if (SCREEN_W > 320) {
//            [btn setTitle:@"  大件   " forState:UIControlStateNormal];
//        }
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];

        _LargeBtn = btn;
    }
    return _LargeBtn;
}


-(UIButton *)moreBtn {
    if (!_moreBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"  ●  ●  ●  " forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:8.f];
        [btn setTitleColor:APP_COLOR_GRAY1 forState:UIControlStateNormal];
        _moreBtn = btn;
    }
    return _moreBtn;
}

-(UIView *)emptyVi {
    if (!_emptyVi) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;

        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        line.frame = CGRectMake(0, 0, SCREEN_W , 1);
        [view addSubview:line];
        
//
//        UIView * line1 = [UIView new];
//        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
//        line1.frame = CGRectMake( SCREEN_W / 2, 15,0.5 , 110);
//        [view addSubview:line1];

        UIImageView *iv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ksps"]];
        iv1.contentMode = UIViewContentModeCenter;
        iv1.frame = CGRectMake(0, 0, SCREEN_W/4, 70);
        [view addSubview:iv1];
        UILabel *lb11 = [UILabel new];
        lb11.frame = CGRectMake(0, iv1.bottom - 5, SCREEN_W/4, 20);
        lb11.textAlignment = NSTextAlignmentCenter;
        lb11.text = @"快速配送";
        lb11.font = [UIFont systemFontOfSize:14];
        [view addSubview:lb11];
//        UILabel *lb12 = [UILabel new];
//        lb12.frame = CGRectMake(0, lb11.bottom, SCREEN_W/3, 40 );
//        lb12.numberOfLines = 0;
//        lb12.textAlignment = NSTextAlignmentCenter;
//        lb12.text = @"工业产品的快递、\n快送、快配";
//        lb12.font = [UIFont systemFontOfSize:11];
//        lb12.textColor = APP_COLOR_GRAY999;
//        [view addSubview:lb12];

        UIImageView *iv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kxzj"]];
        iv2.contentMode = UIViewContentModeCenter;
        iv2.frame = CGRectMake(SCREEN_W/4, 0, SCREEN_W/4, 70);
        [view addSubview:iv2];
        UILabel *lb21 = [UILabel new];
        lb21.frame = CGRectMake(SCREEN_W/4, iv1.bottom - 5, SCREEN_W/4, 20);
        lb21.textAlignment = NSTextAlignmentCenter;
        lb21.text = @"空箱之家";
        lb21.font = [UIFont systemFontOfSize:14];
        [view addSubview:lb21];
//        UILabel *lb22 = [UILabel new];
//        lb22.frame = CGRectMake(SCREEN_W/3, lb11.bottom, SCREEN_W/3, 20);
//        lb22.textAlignment = NSTextAlignmentCenter;
//        lb22.text = @"箱子的天地";
//        lb22.font = [UIFont systemFontOfSize:11];
//        lb22.textColor = APP_COLOR_GRAY999;
//        [view addSubview:lb22];

        UIImageView *iv3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kcza"]];
        iv3.contentMode = UIViewContentModeCenter;
        iv3.frame = CGRectMake(SCREEN_W/4 *2, 0, SCREEN_W/4, 70);
        [view addSubview:iv3];
        UILabel *lb31 = [UILabel new];
        lb31.frame = CGRectMake(SCREEN_W/4 *2, iv1.bottom - 5, SCREEN_W/4, 20);
        lb31.textAlignment = NSTextAlignmentCenter;
        lb31.text = @"空车之爱";
        lb31.font = [UIFont systemFontOfSize:14];
        [view addSubview:lb31];
//        UILabel *lb32 = [UILabel new];
//        lb32.frame = CGRectMake(SCREEN_W/3 *2, lb11.bottom, SCREEN_W/3, 20);
//        lb32.textAlignment = NSTextAlignmentCenter;
//        lb32.text = @"让司机有爱";
//        lb32.font = [UIFont systemFontOfSize:11];
//        lb32.textColor = APP_COLOR_GRAY999;
//        [view addSubview:lb32];

        UIImageView *iv4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coal"]];
        iv4.contentMode = UIViewContentModeCenter;
        iv4.frame = CGRectMake(SCREEN_W/4 *3, 0, SCREEN_W/4, 70);
        [view addSubview:iv4];
        UILabel *lb41 = [UILabel new];
        lb41.frame = CGRectMake(SCREEN_W/4 *3, iv1.bottom - 5, SCREEN_W/4, 20);
        lb41.textAlignment = NSTextAlignmentCenter;
        lb41.text = @"绿色煤炭";
        lb41.font = [UIFont systemFontOfSize:14];
        [view addSubview:lb41];

        self.quickGoBtn.frame = CGRectMake(0, 0, SCREEN_W / 4, 110);
        [view addSubview:self.quickGoBtn];

        self.emptyContainerBtn.frame = CGRectMake(SCREEN_W/4, 0, SCREEN_W / 4, 110);
        [view addSubview:self.emptyContainerBtn];

        self.emptyCarBtn.frame = CGRectMake(SCREEN_W/4 *2, 0, SCREEN_W / 4, 110);
        [view addSubview:self.emptyCarBtn];

        self.coalBtn.frame = CGRectMake(SCREEN_W/4 *3, 0, SCREEN_W / 4, 110);
        [view addSubview:self.coalBtn];


        _emptyVi = view;
    }
    return _emptyVi;
}

-(UIButton *)emptyContainerBtn {
    if (!_emptyContainerBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"Group 25 Copy" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"    空空空空" forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
//
//
//        UILabel * lab = [UILabel new];
//        lab.numberOfLines = 0;
//        lab.frame = CGRectMake(86* SCREEN_W_COEFFICIENT, 0, SCREEN_W / 2 - 86* SCREEN_W_COEFFICIENT, 110);
//        NSMutableAttributedString * allTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"空箱之家\n\n租赁、购买"]];
//        [allTitle addAttribute:NSForegroundColorAttributeName value:APP_COLOR_ORANGE_ range:NSMakeRange(0,4)];
//        [allTitle addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT_1 range:NSMakeRange(4,allTitle.length - 4)];
//        [allTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0,4)];
//        [allTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(4,allTitle.length - 4)];
//        lab.attributedText = allTitle;
//        [btn addSubview:lab];

        _emptyContainerBtn = btn;
    }
    return _emptyContainerBtn;
}

-(UIButton *)emptyCarBtn {
    if (!_emptyCarBtn) {
        UIButton * btn = [UIButton new];
//        [btn setImage:[[UIImage imageNamed:[@"Group 26 Copy" adS]] modifyTheImg] forState:UIControlStateNormal];
//        [btn setTitle:@"    空空空空" forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
//        
//        
//        UILabel * lab = [UILabel new];
//        lab.numberOfLines = 0;
//        lab.frame = CGRectMake(86* SCREEN_W_COEFFICIENT, 0, SCREEN_W / 2 - 86* SCREEN_W_COEFFICIENT, 110);
//        NSMutableAttributedString * allTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"空车之爱\n\n公、铁、海"]];
//        [allTitle addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(0,4)];
//        [allTitle addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT_1 range:NSMakeRange(4,allTitle.length - 4)];
//        [allTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0,4)];
//        [allTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(4,allTitle.length - 4)];
//        lab.attributedText = allTitle;
//        [btn addSubview:lab];

        _emptyCarBtn = btn;
    }
    return _emptyCarBtn;
}

- (UIButton *)quickGoBtn {
    if (!_quickGoBtn) {
        UIButton *button = [[UIButton alloc]init];


        _quickGoBtn = button;
    }
    return _quickGoBtn;
}


- (UIButton *)coalBtn {
    if (!_coalBtn) {
        UIButton *button = [[UIButton alloc]init];

        _coalBtn = button;
    }
    return _coalBtn;
}


-(UITableViewCell *)hotContainerVi {
    if (!_hotContainerVi) {
        UITableViewCell * cell = [UITableViewCell new];
        cell.backgroundColor = APP_COLOR_WHITE;
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        line.frame = CGRectMake(0, 0, SCREEN_W , 15);
        [cell addSubview:line];
        
        UIImageView * img = [UIImageView new];
        img.frame = CGRectMake(14, 31, 13, 16);
        img.image = [UIImage imageNamed:[@"iconfont-hot copy" adS]];
        [cell addSubview:img];
        
        UILabel * lab = [UILabel new];
        lab.text = @"热门线路";
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.frame = CGRectMake(34, 30, SCREEN_W - 120, 18);
        [cell addSubview:lab];
        
        self.moreHotBtn.frame = CGRectMake(SCREEN_W - 15 - 40, 34, 40, 12);
        [self makeButton_:self.moreHotBtn];
        [cell addSubview:self.moreHotBtn];
        
        UIView * line1 = [UIView new];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line1.frame = CGRectMake(0, 59,SCREEN_W, 0.5);
        [cell addSubview:line1];
        
        _hotContainerVi = cell;
    }
    return _hotContainerVi;
}

-(UIButton *)moreHotBtn {
    if(!_moreHotBtn)
    {
        UIButton * btn = [UIButton new];
        [btn setImage:[[UIImage imageNamed:[@"Back Chevron Copy 2" adS]] modifyTheImg] forState:UIControlStateNormal];
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        _moreHotBtn = btn;
    }
    return _moreHotBtn;
}

-(NSMutableArray *)bannerModelArr {
    if (!_bannerModelArr) {
        _bannerModelArr = [NSMutableArray new];
    }
    return _bannerModelArr;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[HotCapacityCell class] forCellReuseIdentifier:NSStringFromClass([HotCapacityCell class])];
        _tbv = tableView;
    }
    return _tbv;
}

-(MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self loadingData];
        }];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}

#pragma mark - Tabview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.section][indexPath.row] isKindOfClass:[NSNull class]]) {
        self.hotContainerVi.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.hotContainerVi;
    }
    HotCapacityCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCapacityCell class]) forIndexPath:indexPath];
    cell.lbDistance.hidden = YES;
    cell.lbDay.hidden = YES;
    [cell loadUIWithmodel:self.dataArray[indexPath.section][indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.bannerVi.frame = CGRectMake(0, 0, SCREEN_W, 185 * SCREEN_W_COEFFICIENT);
        return self.bannerVi;
    }
    else if (section == 1) {
        self.capacityVi.frame = CGRectMake(0, 0, SCREEN_W, 200);
        return self.capacityVi;
    }
    else if (section == 2) {
        self.emptyVi.frame = CGRectMake(0, 0, SCREEN_W, 125);
        return self.emptyVi;
    }
    else if (section == 3) {
        self.hotContainerVi.frame = CGRectMake(0, 0, SCREEN_W, 60);
        return self.hotContainerVi;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.dataArray[indexPath.section][indexPath.row] isKindOfClass:[NSNull class]])
    {
        return 60;
    }
    return 77;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 0) {
        height = 185 * SCREEN_W_COEFFICIENT;
    }
    else if(section == 1) {
        
        height = 185;
    }
    else if(section == 2) {
        
        height = 125;
    }
    else if(section == 3) {
        
        height = 0;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataArray.count - 1) {

        if (indexPath.row == 0) {
            return;

        }

        CapacityEntryModel * caModel = self.dataArray[indexPath.section][indexPath.row];

        ContainerCapacityController * vc ;

        //    //集装箱
        //    BUSINESS_TYPE_CONTAINER(1, "BUSINESS_TYPE_CONTAINER"),
        //    //散堆装
        //    BUSINESS_TYPE_BULK_STACK(2, "BUSINESS_TYPE_BULK_STACK"),
        //    //液态
        //    BUSINESS_TYPE_LIQUID(3,"BUSINESS_TYPE_LIQUID"),
        //    //液态
        //    BUSINESS_TYPE_COLD_CHAIN(4,"BUSINESS_TYPE_COLD_CHAIN"),
        //    //商品车
        //    BUSINESS_TYPE_VECHICLE(5,"BUSINESS_TYPE_VECHICLE"),
        //    //大件物品
        //    BUSINESS_TYPE_LARGE_SIZE(6,"BUSINESS_TYPE_LARGE_SIZE"),
        //    //三农
        //    BUSINESS_TYPE_CHEMICAL(7,"BUSINESS_TYPE_CHEMICAL");

        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_CONTAINER"]) {

            vc = [ContainerCapacityController_Container new];

        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {

            vc = [ContainerCapacityController_InBulk new];
            
        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_LIQUID"]) {

            vc = [ContainerCapacityController_Liquid new];


        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_COLD_CHAIN"]) {

            vc = [ContainerCapacityController_ColdChain new];


        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_VECHICLE"]) {

            vc = [ContainerCapacityController_ForCar new];


        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_ONE_ROAD"]) {

            vc = [ContainerCapacityController_OneBeltOneRoad new];


        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_LARGE_SIZE"]) {

            vc = [ContainerCapacityController_Big new];


        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_CHEMICAL"]) {

            vc = [ContainerCapacityController_Batch new];


        }
        if ([caModel.lineTypeChoose isEqualToString:@"BUSINESS_TYPE_MULTI_TRANSPORT"]) {

            vc = [ContainerCapacityController_QuickGo new];


        }


        vc.isFromHot = YES;
        vc.caModel = caModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)bannerViewCurrentPageIs:(NSInteger) num{
    
    if (num > self.bannerModelArr.count) {
        return ;
    }
    BannerModel *model=self.bannerModelArr[num - 1];
    if([model.needForward boolValue]){
        if([model.forwardType isEqualToString:@"web"]){
            DynamicDetailsViewController *vc=[DynamicDetailsViewController new];
            vc.urlStr=model.forwardPath;
            vc.title=model.title;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
}

-(void)makeButton:(UIButton *)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height  + 20,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

//空车、空箱按钮适配
-(void)makeButton_:(UIButton *)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.frame.size.width * 2, 0.0,0.0)];//文字距离
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width * 2 - btn.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}


- (UIImageView *)iv01 {
    if (!_iv01) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"jzx"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv01 = imageView;
    }
    return _iv01;
}

- (UIImageView *)iv02 {
    if (!_iv02) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"sdz"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv02 = imageView;
    }
    return _iv02;
}

- (UIImageView *)iv03{
    if (!_iv03) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"ydyl"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv03 = imageView;
    }
    return _iv03;
}

- (UIImageView *)iv04 {
    if (!_iv04) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"dj"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        _iv04 = imageView;
    }
    return _iv04;
}

- (UIImageView *)iv05 {
    if (!_iv05) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"ll"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv05 = imageView;
    }
    return _iv05;
}

- (UIImageView *)iv06 {
    if (!_iv06) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"yt"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv06 = imageView;
    }
    return _iv06;
}

- (UIImageView *)iv07 {
    if (!_iv07) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"spc"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        _iv07 = imageView;
    }
    return _iv07;
}

- (UIImageView *)iv08 {
    if (!_iv08) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"sn"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv08 = imageView;
    }
    return _iv08;
}

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"集装箱";



        _lb1 = label;
    }
    return _lb1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"散堆装";

        _lb2 = label;
    }
    return _lb2;
}

- (UILabel *)lb3 {
    if (!_lb3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"一带一路";

        _lb3 = label;
    }
    return _lb3;
}

- (UILabel *)lb4 {
    if (!_lb4) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"大件";

        _lb4 = label;
    }
    return _lb4;
}

- (UILabel *)lb5 {
    if (!_lb5) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"冷链";


        _lb5 = label;
    }
    return _lb5;
}

- (UILabel *)lb6 {
    if (!_lb6) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"液态";

        _lb6 = label;
    }
    return _lb6;
}

- (UILabel *)lb7 {
    if (!_lb7) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"商品车";

        _lb7 = label;
    }
    return _lb7;
}


- (UILabel *)lb8 {
    if (!_lb8) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"三农化肥";

        _lb8 = label;
    }
    return _lb8;
}


@end
