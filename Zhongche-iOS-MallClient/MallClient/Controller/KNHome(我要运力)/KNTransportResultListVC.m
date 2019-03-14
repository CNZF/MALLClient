//
//  KNTransportResultListVC.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTransportResultListVC.h"
#import "KNTransportResultListTopView.h"
#import "KNResultListTableViewCell.h"
#import "KNTransportResultDetailVC.h"
#import "KNTransportSelectDateVC.h"
#import "KNCustomTransportVC.h"
#import "CapacityEntryModel.h"
#import "CapacityViewModel.h"
#import "VerbViewController.h"
#import "NoTransDataView.h"
#import "MallViewController.h"

@interface KNTransportResultListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) KNTransportResultListTopView *topView;

@property (nonatomic, strong) UITableView *KNTableView;

@property (nonatomic, strong) NoTransDataView * noDataView;

@property (nonatomic, strong) UIButton *customButton;

@end

@implementation KNTransportResultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ - %@",self.requestModel.startPlace.name,self.requestModel.endPlace.name];
    self.customButton.hidden = YES;
    self.noDataView.hidden = YES;
}
- (void)bindView{
    [self.view addSubview:self.topView];
}

- (void)getData{
    
//    if (self.requestModel.km) {
//        self.requestModel.km = self.requestModel.km;
//    }else{
//        CLLocation *orig=[[CLLocation alloc] initWithLatitude:[self.requestModel.startPlace.centerLat floatValue]  longitude:[self.requestModel.startPlace.centerLng floatValue]];
//        CLLocation* dist=[[CLLocation alloc] initWithLatitude:[self.requestModel.endPlace.centerLat floatValue] longitude:[self.requestModel.endPlace.centerLng floatValue] ];
//        CLLocationDistance kilometers = [orig distanceFromLocation:dist]/1000;
//        if (self.requestModel.startPlace.centerLat) {
//            self.requestModel.km = [NSString stringWithFormat:@"%.0f",kilometers];
//        }
//    }
//    self.topView.distanceLabel.text = [NSString stringWithFormat:@"预计里程：约%@公里",self.requestModel.km];

    CapacityViewModel *viewModel = [[CapacityViewModel alloc] init];
    WS(weakSelf);
    
    
    
    [viewModel containerSearchWithInfo:self.requestModel callback:^(NSArray *arr,NSString * distance) {
        
        NSString * distant = [NSString stringWithFormat:@"%i",[distance intValue]];
        if ([self.requestModel.startPlace.name isEqualToString:self.requestModel.endPlace.name]) {
            self.requestModel.km = @"同城";
            self.topView.distanceLabel.text = [NSString stringWithFormat:@"预计里程：%@",self.requestModel.km];
        }else{
             self.requestModel.km = distant;
            self.topView.distanceLabel.text = [NSString stringWithFormat:@"预计里程：约%@公里",distant];
        }
        
       
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:arr];
        [self.view addSubview:self.KNTableView];
        [self.view addSubview:self.customButton];
        if (weakSelf.dataArray.count == 0) {
            self.customButton.hidden = YES;
            self.KNTableView.bounces = NO;
            self.noDataView.hidden = NO;
            self.KNTableView.frame = CGRectMake(0, _topView.bottom, SCREEN_W, SCREEN_H-_topView.bottom-kNavBarHeaderHeight- kiPhoneFooterHeight);
            self.customButton.frame = CGRectZero;
            self.noDataView.frame = CGRectMake(0, self.topView.bottom, SCREEN_W, SCREEN_H-self.topView.bottom- kNavBarHeaderHeight-kiPhoneFooterHeight);
        }else
        {
            self.KNTableView.bounces = YES;
            self.customButton.hidden = NO;
            self.KNTableView.frame = CGRectMake(0, _topView.bottom, SCREEN_W, SCREEN_H-_topView.bottom-80-kNavBarHeaderHeight- kiPhoneFooterHeight);
            self.customButton.frame = CGRectMake(15, SCREEN_H-kiPhoneFooterHeight-65- kNavBarHeaderHeight, SCREEN_W-30, 50);
            self.noDataView.frame = CGRectMake(0, self.topView.bottom, SCREEN_W, SCREEN_H-self.topView.bottom- kNavBarHeaderHeight-kiPhoneFooterHeight-80);
        }
        [weakSelf.KNTableView reloadData];
    }];
}

#pragma mark --- 计算两日期相差多少天
- (NSInteger)getChaDays:(NSString *)selectStr curDay:(NSString *)curday{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:selectStr];
    NSDate *endDate = [dateFormatter dateFromString:curday];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传:
     * NSCalendarUnitDay : 天
     * NSCalendarUnitYear : 年
     * NSCalendarUnitMonth : 月
     * NSCalendarUnitHour : 时
     * NSCalendarUnitMinute : 分
     * NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    NSLog(@"%li",(long)delta.day);
    return (long)delta.day;
}

- (void)bindAction{
    WS(weakSelf)
    [[self.topView.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        KNTransportSelectDateVC *dateVC = [[KNTransportSelectDateVC alloc] init];
        dateVC.requestModel = weakSelf.requestModel;
        dateVC.selectDateBlock = ^(NSDate *date) {
            
            NSDateFormatter *outputFormatter = [ NSDateFormatter new];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSInteger days = [self getChaDays:[outputFormatter stringFromDate:[NSDate date]] curDay:[outputFormatter stringFromDate:date]];
            if (days<4) {
                [[Toast shareToast] makeText:@"请选择4天以后的日期" aDuration:1.0];
                return ;
            }
            weakSelf.topView.requestModel.shipmentsTime = date;
            weakSelf.requestModel.shipmentsTime = date;
            [weakSelf.topView requestData];
            [weakSelf getData];
        };
        [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:dateVC]  animated:YES completion:nil];
    }];
    
    [[self.customButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf checkout_logInSuccessBlock:^{
            if (!USER_INFO) {
                [weakSelf pushLogoinVC];
                return;
            }else{
                 [weakSelf goToLogin];
            }
        }];

    }];
    
    self.topView.selectModel = ^(NSDate *date) {
        
        
        weakSelf.requestModel.shipmentsTime = date;
        [weakSelf getData];
    };
}
     

- (void)goToLogin {
     UserInfoModel * info = USER_INFO;
//     if ([info.companyType isEqualToString:@"4"] || [info.companyType isEqualToString:@"1"] || [info.companyType isEqualToString:@"3"] ) {
         KNCustomTransportVC *customVC = [[KNCustomTransportVC alloc] init];
         customVC.isNotTabBarSubVC = YES;
         customVC.requestModel = self.requestModel;
         [self.navigationController pushViewController:customVC animated:YES];
//            AppDelegate * app = (AppDelegate *)[UIApplication shared Application].delegate;
//            MallViewController * controller = [[MallViewController alloc] init];
//            controller.selectedIndex = 1;
//            app.window.rootViewController = controller;
    
    
    
//     }else{
//         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"\n您的账号尚未完成认证，请认证后继续后续操作\n" preferredStyle:UIAlertControllerStyleAlert];
//
//         //可以给alertview中添加一个输入框
//         //                   [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//         //                       textField.placeholder = @"alert中的文本";
//         //                   }];
//
//         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//             NSLog(@"点击了按钮1，进入按钮1的事件");
//             //textFields是一个数组，获取所输入的字符串
//             //                       NSLog(@"%@",alert.textFields.lastObject.text);
//         }];
//         UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//             //                       NSLog(@"点击了取消");
//             //去认证
//             VerbViewController * vc = [VerbViewController new];
//             [self.navigationController pushViewController:vc animated:YES];
//
//         }];
//
//         [alert addAction:action1];
//         [alert addAction:action2];
//
//         [self presentViewController:alert animated:YES completion:nil];
//
//     }
}
     
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0;
    }else{
        return 1;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNResultListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KNResultListTableViewCell class]) forIndexPath:indexPath];
    cell.cellModel = self.dataArray[indexPath.section];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.dataArray.count == 0) {
        return self.noDataView;
    }else{
        UITableViewHeaderFooterView *sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        sectionFooter.contentView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        return sectionFooter;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  SCREEN_H-self.topView.bottom- kNavBarHeaderHeight-kiPhoneFooterHeight;
    }else{
        return 10;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KNTransportResultDetailVC *detailVC = [[KNTransportResultDetailVC alloc] init];
    detailVC.requestModel = [self.requestModel copy];
    detailVC.transportModel = self.dataArray[indexPath.section];
    detailVC.titleStr = self.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- Getter
- (KNTransportResultListTopView *)topView{
    if (!_topView) {
        _topView = [[KNTransportResultListTopView alloc] initWithRequestModel:self.requestModel];
        _topView.frame = CGRectMake(0, 0, SCREEN_W, 105);
    }
    return _topView;
}

-(UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc]init];
        _KNTableView.frame = CGRectMake(0, _topView.bottom, SCREEN_W, SCREEN_H-_topView.bottom-80-kNavBarHeaderHeight- kiPhoneFooterHeight);
        _KNTableView.rowHeight = 85;
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNResultListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([KNResultListTableViewCell class])];
        [_KNTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
       
    }
    return _KNTableView;
}

- (UIButton *)customButton{
    if (!_customButton) {
        _customButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_H-kiPhoneFooterHeight-65- kNavBarHeaderHeight, SCREEN_W-30, 50)];
        [_customButton setBackgroundColor:[HelperUtil colorWithHexString:@"3BA0F3"]];
        [_customButton setTitle:@"定制需求" forState:UIControlStateNormal];
        _customButton.layer.cornerRadius = 4.0f;
        _customButton.layer.masksToBounds = YES;
        _customButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _customButton;
}

- (NoTransDataView *)noDataView
{
    WS(weakSelf);
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoTransDataView class]) owner:self options:nil] firstObject];
        _noDataView.frame = CGRectMake(0, self.topView.bottom, SCREEN_W, SCREEN_H-self.topView.bottom- kNavBarHeaderHeight-kiPhoneFooterHeight);
        [_noDataView setBlock:^(NSInteger index) {
            if (index == 0) {
                if (!USER_INFO) {
                    [weakSelf pushLogoinVC];
                    return;
                }else{
                    [weakSelf goToLogin];
                }
            }else{
                [weakSelf callAction];
            }
        }];
    }
    return _noDataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
