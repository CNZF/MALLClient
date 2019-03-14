//
//  OrderCenterVC.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderCenterVC.h"
#import "NinaPagerView.h"
//#import "OrderCenterListVC.h"
#import "MLNavigationController.h"

#define BUTTON_TITLES_IWantToCapacity @[@"全部",@"待确认",@"待付款",@"待发货",@"待收货",@"待退款",@"已完成",@"已取消"]
#define BUTTON_TITLES_HomeOfEmpty @[@"全部",@"待支付",@"待审核",@"待箱主发箱",@"待买家收箱",@"待箱主收箱",@"已完成",@"已取消"]
#define BUTTON_TITLES_EmptyLove @[@"全部",@"待支付",@"待审核",@"待调度",@"待装载",@"已完成",@"已取消"]
#define BUTTON_TITLES_Coal @[@"全部",@"待确定",@"已取消",@"待付款",@"待审核",@"待发货",@"待收货",@"待结算",@"已完成"]

//#define TITELS @[@"我要运力", @"空箱之家", @"空车之爱", @"绿色煤炭"]
#define TITELS @[@"全部",@"待确认",@"待付款",@"待发货",@"待结算",@"已完成",@"已取消"]

@interface OrderCenterVC ()<NinaPagerViewDelegate>

@property (nonatomic, strong) UIButton       * naviBtn;
@property (nonatomic, strong) UIView         * entrysView;

@property (nonatomic, copy  ) NSMutableArray * selectEntrys;
@property (nonatomic, copy  ) NSString       * currentPage;
@end

@implementation OrderCenterVC
{
    NinaPagerView *ninaPagerView;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderCenter" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderPage" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.naviBtn.frame = CGRectMake(SCREEN_W / 2 - 100, 0, 200, 44);
    [self makeButton:self.naviBtn];
//    [self.navigationController.navigationBar addSubview:self.naviBtn];
//    self.navigationController.
    self.title = @"订单中心";
    self.entrysView.frame = CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64);
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:self.entrysView];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if ([GlobalOrderType shareGlobalOrderType].whetherTheAvailable) {
//        [GlobalOrderType shareGlobalOrderType].whetherTheAvailable = NO;
//        [ninaPagerView.pagerView touchAction:ninaPagerView.pagerView.btnArray[[TITELS indexOfObject:[GlobalOrderType shareGlobalOrderType].orderType]]];
//
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.naviBtn removeFromSuperview];
    [self.entrysView removeFromSuperview];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.showNaviLeft) {
         self.btnLeft.hidden = NO;
    }else{
         self.btnLeft.hidden = YES;
    }
    self.btnRight.hidden = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDataNoti:) name:@"refreshOrderCenter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDataNoti:) name:@"refreshOrderPage" object:nil];
}

- (void)bindView {
    NSArray *titleArray = TITELS;
    NSArray *colorArray = [self ninaColorArray];
    NSArray *vcsArray = [self ninaVCsArray];
    
    ninaPagerView = [[NinaPagerView alloc] initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray];
    ninaPagerView.titleScale = 1.15;
    if (self.showNaviLeft) {
       ninaPagerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight);
    }else{
       ninaPagerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight - kTabbarHight);
    }
    [self.view addSubview:ninaPagerView];
    ninaPagerView.pushEnabled = YES;
    ninaPagerView.delegate = self;
}

- (void)bindAction {
    [[self.naviBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self naviBtnClack];
    }];
}

//重置通知
- (void)resetDataNoti:(NSNotification *)noti {

//    if ([noti.name isEqualToString:@"refreshOrderCenter" ]) {
//        [self.selectEntrys replaceObjectAtIndex:[TITELS indexOfObject:noti.object[@"viewTitle"]] withObject:noti.object[@"orderType"]];
//    } else if ([noti.name isEqualToString:@"refreshOrderPage" ]) {
//        [ninaPagerView.pagerView touchAction:ninaPagerView.pagerView.btnArray[[TITELS indexOfObject:noti.object[@"vcTitle"]]]];
//    }
}

//订单中心顶部选择
//- (void)naviBtnClack {
//
//    self.naviBtn.selected = !self.naviBtn.selected;
//    self.entrysView.hidden = !self.naviBtn.selected;
//    if (self.entrysView.hidden == NO)
//    {
//        for (UIButton * button in self.entrysView.subviews)
//        {
//            if ([button isKindOfClass:[UIButton class]]) {
//                [button removeFromSuperview];
//            }
//        }
//        UIButton * btn;
//        NSArray * btnTitles;
//        switch ([self.currentPage intValue]) {
//            case 0:
//                btnTitles = BUTTON_TITLES_IWantToCapacity;
//                break;
//
//            case 1:
//                btnTitles = BUTTON_TITLES_HomeOfEmpty;
//                break;
//
//            case 2:
//                btnTitles = BUTTON_TITLES_EmptyLove;
//                break;
//
//            case 3:
//                btnTitles = BUTTON_TITLES_Coal;
//                break;
//        }
//        CGFloat width = (SCREEN_W - 78) / 3;
//        for(int i= 0;i < btnTitles.count;i++)
//        {
//            btn = [UIButton new];
//            btn.frame = CGRectMake(24 + (i%3)*(width + 15),20 + i / 3 * 48 , width, 33);
//            btn.layer.borderColor = [APP_COLOR_GRAY1 CGColor];
//            btn.layer.borderWidth = 0.5;
//            [btn.layer setMasksToBounds:YES];
//            [btn.layer setCornerRadius:17];//设置矩形四个圆角半径
//            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
//            [btn setTitleColor:APP_COLOR_GRAY_SEARCH_TEXT forState:UIControlStateNormal];
//            [btn setTitleColor:APP_COLOR_ORANGE_BTN_TEXT forState:UIControlStateSelected];
//            btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [_entrysView addSubview:btn];
//        }
//
//        for (UIButton * button in self.entrysView.subviews)
//        {
//            if ([button isKindOfClass:[UIButton class]]) {
//                if ([button.titleLabel.text isEqualToString:self.selectEntrys[[self.currentPage integerValue]]]) {
//                    button.selected = YES;
//                    button.layer.borderColor = [APP_COLOR_ORANGE_BTN_TEXT CGColor];
//
//                }
//                else
//                {
//                    button.layer.borderColor = [APP_COLOR_GRAY1 CGColor];
//                    button.selected = NO;
//                }
//            }
//        }
//    }
//}

//筛选条件
- (void)btnClick:(UIButton *)btn {
    [_selectEntrys replaceObjectAtIndex:[self.currentPage integerValue] withObject:btn.titleLabel.text];
    self.naviBtn.selected = NO;
    self.entrysView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ConditionsForScreening"
                                                       object:@{
                                                                @"orderType":[btn.titleLabel.text copy],
                                                                @"viewTitle":[TITELS[[self.currentPage intValue]] copy]
                                                                }];
}

//顶部箭头
- (void)makeButton:(UIButton *)btn {
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.frame.size.width * 2, 0.0,0.0)];//文字距离
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width * 2 - btn.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

//顶部筛选视图隐藏
- (BOOL)deallocVCsIfUnnecessary {
    return YES;
}

//订单类型跳转
- (void)ninaCurrentPageIndex:(NSString *)currentPage {
    self.currentPage = currentPage;
}


/**
 *  懒加载
 *
 */

-(NSString *)currentPage {
    if (!_currentPage) {
        _currentPage = @"0";
    }
    return _currentPage;
}

-(UIButton *)naviBtn {
    if (!_naviBtn) {
        _naviBtn = [UIButton new];
        [_naviBtn setTitle:@"订单中心" forState:UIControlStateNormal];
        [_naviBtn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
//        [_naviBtn setImage:[UIImage imageNamed:[@"Back Chevron Copy 5" adS]] forState:UIControlStateNormal];
//        [_naviBtn setImage:[UIImage imageNamed:[@"Clip 4" adS]] forState:UIControlStateSelected];
        _naviBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    }
    return _naviBtn;
}

-(UIView *)entrysView {

    if(!_entrysView) {
        _entrysView = [UIView new];
        _entrysView.hidden = YES;
        
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(naviBtnClack)];
        [_entrysView addGestureRecognizer:tap];
        
        
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        [_entrysView addSubview:view];
        
        
        UIButton * btn;
        NSArray * btnTitles = BUTTON_TITLES_IWantToCapacity;
        CGFloat width = (SCREEN_W - 78) / 3;
        for(int i= 0;i < btnTitles.count;i++)
        {
            btn = [UIButton new];
            btn.frame = CGRectMake(24 + (i%3)*(width + 15),20 + i / 3 * 48 , width, 33);
            btn.layer.borderColor = [APP_COLOR_GRAY1 CGColor];
            btn.layer.borderWidth = 0.5;
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:17];//设置矩形四个圆角半径
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn setTitleColor:APP_COLOR_GRAY_SEARCH_TEXT forState:UIControlStateNormal];
            [btn setTitleColor:APP_COLOR_ORANGE_BTN_TEXT forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_entrysView addSubview:btn];
        }
        
        CGFloat heightMax = 20 + (btnTitles.count - 1) / 3 * 48 + 33 + 20;
        view.frame = CGRectMake(0, 0, SCREEN_W, heightMax);
        
        
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
        effe.frame = CGRectMake(0, heightMax, SCREEN_W, SCREEN_H - heightMax);
        [_entrysView addSubview:effe];
    }
    return _entrysView;
}

- (NSMutableArray *)selectEntrys {
    if (!_selectEntrys) {
        _selectEntrys = [NSMutableArray array];
        [_selectEntrys addObject:BUTTON_TITLES_IWantToCapacity[0]];
        [_selectEntrys addObject:BUTTON_TITLES_HomeOfEmpty[0]];
        [_selectEntrys addObject:BUTTON_TITLES_EmptyLove[0]];
        [_selectEntrys addObject:BUTTON_TITLES_Coal[0]];
    }
    return _selectEntrys;
}

- (NSArray *)ninaColorArray {
    return @[
             APP_COLOR_BLUE_TOP, /**< 选中的标题颜色 Title SelectColor  **/
             APP_COLOR_GRAY_TEXT_1, /**< 未选中的标题颜色  Title UnselectColor **/
             APP_COLOR_BLUE_TOP, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
             APP_COLOR_WHITE, /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
             ];
}
//OrderListCenterVC_ALL,OrderListCenterVC_WaitConfirm,OrderListCenterVC_WaitPay,OrderListCenterVC_WaitPost,OrderListCenterVC_WaitRecpt,OrderListCenterVC_HadFinish,OrderListCenterVC_Cancle
- (NSArray *)ninaVCsArray {
    return @[
             @"OrderListCenterVC_ALL",
             @"OrderListCenterVC_WaitConfirm",
             @"OrderListCenterVC_WaitPay",
             @"OrderListCenterVC_WaitPost",
             @"OrderListCenterVC_WaitRecpt",
             @"OrderListCenterVC_HadFinish",
             @"OrderListCenterVC_Cancle",
             ];
}

@end
