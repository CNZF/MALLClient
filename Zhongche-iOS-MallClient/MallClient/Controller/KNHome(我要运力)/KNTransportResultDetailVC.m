//
//  KNTransportResultDetailVC.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTransportResultDetailVC.h"
#import "KNResultDetailHeaderView.h"
#import "KNResultDetailSectionHeader.h"
#import "KNResultDetailTbleViewCell.h"
#import "KNCustomTransportVC.h"
#import "KNResultFilterPopView.h"
#import "KNOrderCompleteVC.h"
#import "CapacityViewModel.h"
#import "TicketsDetailModel.h"
#import "ContainerModel.h"
#import "EntrepotModel.h"
#import "TransportationModel.h"
#import "TransportResultDetailHeadView.h"
#import "TransportResultHeadCell.h"
#import "NSString+Money.h"
#import "VerbViewController.h"

@interface KNTransportResultDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) KNResultDetailHeaderView *headerView;
@property (nonatomic, strong) TransportResultDetailHeadView * headView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic, strong) UIView * scrollBottomView;
@property (nonatomic, strong) UITableView *KNTableView;

@property (nonatomic, strong) UIButton *customButton;

@property (nonatomic, strong) KNResultFilterPopView *menuView;
@property (nonatomic, assign) BOOL isSelect;

@end

@implementation KNTransportResultDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.isSelect = NO;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:[UIImage imageNamed:@"KN_resultMenu_icon"] forState:UIControlStateNormal];
}

- (void)bindView{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.KNTableView];
//    [self.view addSubview:self.customButton];
}

- (void)getData{
    CapacityViewModel *viewModel = [[CapacityViewModel alloc] init];
    WS(weakSelf);
    self.requestModel.transportationModel.ID = self.transportModel.ID;
    self.requestModel.transportationModel.expectTime = self.transportModel.expectTime;
    self.requestModel.transportationModel.ticketType = self.transportModel.ticketType;
    [viewModel requestTickesByExpectTimeWithInfo:self.requestModel isSelect:self.isSelect callback:^(NSArray *arr) {
        [weakSelf.customButton removeFromSuperview];
        if (arr.count<1) {
            self.KNTableView.hidden = YES;
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 88, SCREEN_W, 65)];
//            view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
            view.tag = 10001;
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0,45, SCREEN_W, 20)];
            [btn setAttributedTitle:[NSString getFormartBtnTitle:@"没找到合适的?定制需求"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(onDingZhiXuQiuBtn) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [view addSubview:btn];
            [self.view addSubview:view];
        }else{
            self.KNTableView.hidden = NO;
            UIView * view = [self.view viewWithTag:10001];
            if (view) {
                [view removeFromSuperview];
            }
        }
        
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:arr];
        [weakSelf.KNTableView reloadData];
        [weakSelf.KNTableView setScrollsToTop:YES];
        
        CGFloat hhh = self.KNTableView.contentSize.height;
        NSLog(@"%f",hhh);
    }];
}

//监听tableView的滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    
    double  qqq= ceil(bottomOffset);
    double www = ceil(height);
    NSLog(@"bottomOffset %f",qqq);
    NSLog(@"height %f",www);
    if (ceil(bottomOffset)  <= ceil(height) +1)
    {
        CGFloat AllHeight = 0;
        
        if (self.dataArray.count>0) {
            for (TicketsDetailModel * model in self.dataArray) {
                AllHeight = model.simpleTransportList.count * 110 +88 +AllHeight +self.dataArray.count * 15;
            }
        }
            NSLog(@"AllHeight %f",AllHeight);
//            NSLog(@"SCREEN_H %f",SCREEN_H);
//            NSLog(@"_headerView.bottom %f",_headerView.bottom);
            NSLog(@"kNavBarHeaderHeight %d",SCREEN_H-88-kNavBarHeaderHeight);
        
        if (AllHeight > SCREEN_H-88-kNavBarHeaderHeight) {
            __block CGFloat Y =0;
            self.customButton.frame = CGRectMake(0, SCREEN_H - kNavBarHeaderHeight- kiPhoneFooterHeight -50, SCREEN_W,0);
            [self.view addSubview:self.customButton];
            [self.view bringSubviewToFront:self.customButton];
            
            [UIView animateWithDuration:1.0 animations:^{
                
                Y = 50;
            } completion:^(BOOL finished) {
                self.customButton.frame = CGRectMake(0, SCREEN_H - kNavBarHeaderHeight- kiPhoneFooterHeight - 50, SCREEN_W,Y);
                
            }];
        }
         NSLog(@"底部");
    }
    else
    {
        self.customButton.frame = CGRectMake(0, SCREEN_H - kNavBarHeaderHeight, SCREEN_W,0);
        NSLog(@"非底部");
    }

}

#pragma mark -- Action
- (void)bindAction{
    WS(weakSelf)

    self.menuView.selectBlock = ^(ContainerTypeModel *model) {
        weakSelf.isSelect = true;
        weakSelf.requestModel.box.containerId = [model.ID intValue];
        [weakSelf getData];
    };
}
- (void)onRightAction{
    [self.menuView show];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TicketsDetailModel *detailModel = self.dataArray[section];
    if (_isSelect || detailModel.flagContainer) {
        return 2;
    }
    return detailModel.simpleTransportList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TransportResultHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TransportResultHeadCell class]) forIndexPath:indexPath];
        TicketsDetailModel *model = self.dataArray[indexPath.section];
        cell.model = model;
        return cell;
    }
    KNResultDetailTbleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KNResultDetailTbleViewCell class]) forIndexPath:indexPath];
    TicketsDetailModel *model = self.dataArray[indexPath.section];
    if (!model.transportMinimum) {
        model.transportMinimum = 1;
    }
    WS(weakSelf)
    cell.actionBlock = ^{
        [weakSelf checkout_logInSuccessBlock:^{
            
            if (!USER_INFO) {
                [self pushLogoinVC];
            }else{
                UserInfoModel * info = USER_INFO;
//                if ([info.companyType isEqualToString:@"4"] || [info.companyType isEqualToString:@"1"] || [info.companyType isEqualToString:@"3"] ) {
                    KNOrderCompleteVC *submitOder = [[KNOrderCompleteVC alloc] init];
                
                    submitOder.detailModel = model;
                if (model.simpleTransportList) {
                    submitOder.containerModel = model.simpleTransportList[indexPath.row-1];
                }else{
                    ContainerModel * coModel = [ContainerModel new];
                    coModel.oneTicketTotal = model.oneTicketTotal;
                    submitOder.containerModel = coModel;
                }
                
                
                    submitOder.transportModel = weakSelf.transportModel;
                    if (_isSelect || model.flagContainer) {
                        weakSelf.requestModel.box.name = model.containerName;
                        weakSelf.requestModel.box.ID = model.containerId;
                        weakSelf.requestModel.boxNum = [NSString stringWithFormat:@"%i",model.transportMinimum];
                        weakSelf.requestModel.transport_minimum = model.transportMinimum;
                    }else{
                        ContainerModel *detailModel = model.simpleTransportList[indexPath.row-1];
                        weakSelf.requestModel.box.name = detailModel.containerName;
                        weakSelf.requestModel.box.ID = detailModel.containerId;
                        weakSelf.requestModel.boxNum = [NSString stringWithFormat:@"%i",model.transportMinimum];
                        weakSelf.requestModel.transport_minimum = model.transportMinimum;
                    }
                
                    submitOder.requestModel = weakSelf.requestModel ;
                    [weakSelf.navigationController pushViewController:submitOder animated:YES];
//                }else{
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"\n您的账号尚未完成认证，请认证后继续后续操作\n" preferredStyle:UIAlertControllerStyleAlert];
//
//                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSLog(@"点击了按钮1，进入按钮1的事件");
//
//                    }];
//                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        //去认证
//                        VerbViewController * vc = [VerbViewController new];
//                        [self.navigationController pushViewController:vc animated:YES];
//
//                    }];
//
//                    [alert addAction:action1];
//                    [alert addAction:action2];
//
//                    [self presentViewController:alert animated:YES completion:nil];
//
//                }
            }
        
            
        }];
    };
    if (self.isSelect || model.flagContainer) {
        cell.titleNameLabel.text = [NSString stringWithFormat:@" %@%@",model.containerName,@" "] ;
        if (model.transportMinimum) {
            cell.numberLabel.text = [NSString stringWithFormat:@"%i", model.transportMinimum];
        }else{
            cell.numberLabel.text = [NSString stringWithFormat:@"%i",1];
        }
        NSString *str = [NSString stringWithFormat:@"%.2f",model.oneTicketTotal];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSUInteger loc = str.length;
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:11.0]
                              range:NSMakeRange(loc - 2, 2)];
        cell.priceLabel.attributedText = AttributedStr;
        return cell;
    }
    else {
        ContainerModel *detailModel = model.simpleTransportList[indexPath.row-1];
        cell.titleNameLabel.text = [NSString stringWithFormat:@" %@%@ ",detailModel.containerName,@" "];
        if (model.transportMinimum) {
            cell.numberLabel.text = [NSString stringWithFormat:@"%i", model.transportMinimum];
        }else{
            cell.numberLabel.text = [NSString stringWithFormat:@"%i",1];
        }
        NSString *str = [NSString stringWithFormat:@"￥%.2f",detailModel.oneTicketTotal];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSUInteger loc = str.length;
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:11.0]
                              range:NSMakeRange(loc - 2, 2)];
        cell.priceLabel.attributedText = AttributedStr;
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSelect) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, CGFLOAT_MIN)];
        return headerView;
    }
    else {
//        KNResultDetailSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"KNResultDetailSectionHeader"];
//        TicketsDetailModel *model = self.dataArray[section];
//        sectionHeader.distanceLabel.text = [NSString stringWithFormat:@"%@   至   %@",model.startName,model.endName];
//        sectionHeader.descLabel.text = [NSString stringWithFormat:@"%@   至   %@",model.startEntrepotName.name,model.endEntrepotName.name];
//        return sectionHeader;
        
//        TicketsDetailModel *model = self.dataArray[section];
//
//        self.headView.model  = model;
//        return self.headView;
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.isSelect) {
//        return CGFLOAT_MIN;
//    }
//    return 15.0f;
    return 15.0f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat AllHeight =0;
    
    if (self.dataArray.count>0) {
        for (TicketsDetailModel * model in self.dataArray) {
            AllHeight = model.simpleTransportList.count * 110 +88 +AllHeight +self.dataArray.count * 15;
        }
    }
     if (section  == self.dataArray.count-1) {
         
         if (AllHeight> SCREEN_H-_headerView.bottom- kNavBarHeaderHeight) {
             return 50.0f;
         }else{
             return 56.0f;
         }
         
     }else
     {
         return CGFLOAT_MIN;
     }
}
//
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat AllHeight = 0;
    
    if (self.dataArray.count>0) {
        for (TicketsDetailModel * model in self.dataArray) {
            AllHeight = model.simpleTransportList.count * 110 +88 +AllHeight +self.dataArray.count * 15;
        }
    }
    
//    NSLog(@"AllHeight %f",AllHeight);
//    NSLog(@"SCREEN_H %f",SCREEN_H);
//    NSLog(@"_headerView.bottom %f",_headerView.bottom);
//    NSLog(@"kNavBarHeaderHeight %d",kNavBarHeaderHeight);
    if (section  == self.dataArray.count-1) {
        if (AllHeight> SCREEN_H-_headerView.bottom-kNavBarHeaderHeight) {
//            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
//            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, SCREEN_W, 50)];
//            btn.backgroundColor = APP_COLOR_Btn;
//            [btn addTarget:self action:@selector(onDingZhiXuQiuBtn) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitle:@"定制需求" forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont systemFontOfSize:16];
//            [view addSubview:btn];
//            view.backgroundColor = [UIColor whiteColor];
//
            return [UIView new];
        }else{
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 56)];
            view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0,36, SCREEN_W, 20)];
            [btn setAttributedTitle:[NSString getFormartBtnTitle:@"没找到合适的?定制需求"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(onDingZhiXuQiuBtn) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [view addSubview:btn];
            return view;
        }
    }else{
        return [UIView new];
    }
}

- (void)setTransportModel:(TransportationModel *)transportModel {
    _transportModel = transportModel;
    
    NSInteger days = [transportModel.expectTime intValue]/1440;
    
    if (days % 1 > 0 || days == 0) {
       days  = days/1+1;
    }
    self.headerView.dayNumLabel.text = [NSString stringWithFormat:@"%li",(long)days];

    if ([self.requestModel.startPlace.name isEqualToString:self.requestModel.endPlace.name]) {
        self.headerView.distanceLabel.text = [NSString stringWithFormat:@"%@",self.requestModel.km];
    }else{
        self.headerView.distanceLabel.text = [NSString stringWithFormat:@"约%@公里",self.requestModel.km];
    }
    
//    long long time = [transportModel.departureTime longLongValue] + [transportModel.expectTime longLongValue]*60*1000+24*60*60*1000;
    long long time = [transportModel.departureTime longLongValue] + [transportModel.expectTime longLongValue]*60*1000;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *startTimeStr =  [dateFormatter stringFromDate:self.requestModel.shipmentsTime];
    NSString *endTimeStr = [dateFormatter stringFromDate:endDate];
    
    self.headerView.timeLabel.text = startTimeStr;
    self.headerView.endTimeLabel.text = endTimeStr;
}


#pragma  mark -- Action

- (void)onDingZhiXuQiuBtn
{
    if (!USER_INFO) {
        [self pushLogoinVC];
        return;
    }else{
        [self goToLogin];
    }
    
}



- (void)goToLogin {
    UserInfoModel * info = USER_INFO;
//    if ([info.companyType isEqualToString:@"4"] || [info.companyType isEqualToString:@"1"] || [info.companyType isEqualToString:@"3"] ) {
        KNCustomTransportVC *customVC = [[KNCustomTransportVC alloc] init];
        customVC.isNotTabBarSubVC = YES;
        customVC.requestModel = self.requestModel;
        [self.navigationController pushViewController:customVC animated:YES];
//    }else{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"\n您的账号尚未完成认证，请认证后继续后续操作\n" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            VerbViewController * vc = [VerbViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }];
//
//        [alert addAction:action1];
//        [alert addAction:action2];
//
//        [self presentViewController:alert animated:YES completion:nil];
//
//    }
}

#pragma mark -- Getter



- (TransportResultDetailHeadView *)headView
{
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TransportResultDetailHeadView class]) owner:self options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, SCREEN_W, 88);
    }
    return _headView;
}

- (KNResultDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"KNResultDetailHeaderView" owner:self options:nil][0];
        _headerView.frame = CGRectMake(0, 0, SCREEN_W, 88);
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
        _footerView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    }
    return _footerView;
}

- (UIView *)scrollBottomView
{
    if (!_scrollBottomView) {
        _scrollBottomView = [[UIView alloc]init];

        _scrollBottomView.backgroundColor = [UIColor redColor];
    }
    return _scrollBottomView;
}

-(UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerView.bottom, SCREEN_W, SCREEN_H-_headerView.bottom-kNavBarHeaderHeight - kiPhoneFooterHeight) style:UITableViewStyleGrouped];
        _KNTableView.rowHeight = UITableViewAutomaticDimension;
        _KNTableView.estimatedRowHeight = 100.0f;
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.bounces = NO;
        _KNTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNResultDetailTbleViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([KNResultDetailTbleViewCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:@"TransportResultHeadCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TransportResultHeadCell class])];
        _KNTableView.tableFooterView = self.footerView;
    }
    return _KNTableView;
}

- (UIButton *)customButton{
    if (!_customButton) {
        UIButton * btn = [[UIButton alloc] init];
        btn.frame = CGRectZero;
        btn.backgroundColor = APP_COLOR_Btn;
        [btn addTarget:self action:@selector(onDingZhiXuQiuBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"定制需求" forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont systemFontOfSize:16];
        _customButton = btn;
    }
    return _customButton;
}

- (KNResultFilterPopView *)menuView{
    if (!_menuView) {
        _menuView = [[KNResultFilterPopView alloc] initWithFrame:CGRectZero];
    }
    return _menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
