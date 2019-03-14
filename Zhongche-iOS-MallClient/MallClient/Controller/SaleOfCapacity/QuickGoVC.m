//
//  QuickGoVC.m
//  MallClient
//
//  Created by lxy on 2017/9/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "QuickGoVC.h"
#import "HotCapacityCell.h"
#import "CapacityViewModel.h"
#import "ContainerCapacityController.h"
#import "ZCCityListViewController.h"

@interface QuickGoVC ()<UITableViewDelegate,UITableViewDataSource,ZCCityListViewControllerDelagate>

@property (nonatomic, strong) UITableView    *tbv;
@property (nonatomic, strong) UIButton       *btnStart;
@property (nonatomic, strong) UIButton       *btnEnd;
@property (nonatomic, strong) UIView         *viBottom;
@property (nonatomic, strong) UIButton       *clickBtn;

@property (nonatomic, strong) CityModel      *startPlace;
@property (nonatomic, strong) CityModel      *endPlace;


@end

@implementation QuickGoVC


- (void)bindView {

    self.title = @"快速配送";

    self.btnStart.frame = CGRectMake(0, 0, SCREEN_W/2, 50);
    [self.view addSubview:self.btnStart];

    self.btnEnd.frame = CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, 50);
    [self.view addSubview:self.btnEnd];

    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = APP_COLOR_GRAY999;
    lbLine.frame = CGRectMake(SCREEN_W/2,10,0.5,30);
    [self.view addSubview:lbLine];

    self.viBottom.frame = CGRectMake(0, self.btnStart.bottom, SCREEN_W, 12);
    [self.view addSubview:self.viBottom];

    self.tbv.frame = CGRectMake(0, 62, SCREEN_W, SCREEN_H - 24 - 62);
    [self.view addSubview:self.tbv];


}

- (void)bindModel {

}


- (void)getData {

    WS(ws);

    [[CapacityViewModel new]selectQuickCapacityWithStartCity:self.startPlace WithEndCity:self.endPlace callback:^(NSArray *arr) {

        ws.dataArray = [NSMutableArray arrayWithArray:arr];

        [ws.tbv reloadData];
        

    }];

}

- (void)chooseCity:(UIButton *)btn {

    ZCCityListViewController * vc = [ZCCityListViewController new];
    vc.getCityDelagate = self;
    vc.fromNaviC = NO;
    self.clickBtn = btn;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{

    }];

}


-(void)getCityModel:(CityModel *)cityModel {

    if (self.clickBtn == self.btnStart) {
        [self.btnStart setTitle:cityModel.name forState:UIControlStateNormal];
        [self.btnStart setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.startPlace = cityModel;
    }

    else if (self.clickBtn == self.btnEnd)
    {
        [self.btnEnd setTitle:cityModel.name forState:UIControlStateNormal];
        [self.btnEnd setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        self.endPlace = cityModel;


    }

    [self getData];

}


#pragma mark - Tabview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HotCapacityCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCapacityCell class]) forIndexPath:indexPath];
    cell.boxName.hidden = YES;

    CapacityEntryModel *model = self.dataArray[indexPath.row];
    [cell loadUIWithmodel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lbDay.text = [NSString stringWithFormat:@"%@天",model.day];
    cell.lbDistance.text = [NSString stringWithFormat:@"%@km",model.mileage];




    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 77;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section >= self.dataArray.count - 1) {
//
//        if (indexPath.row == 0) {
//            return;
//        }
        ContainerCapacityController * vc = [ContainerCapacityController_QuickGo new];
        vc.isFromHot = YES;
        vc.caModel = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
//    }
}


//getter
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

- (UIButton *)btnStart {
    if (!_btnStart) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"起运地->" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY999 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];



        _btnStart = button;
    }
    return _btnStart;
}

- (UIButton *)btnEnd {
    if (!_btnEnd) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"抵运地->" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY999 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];


        _btnEnd = button;
    }
    return _btnEnd;
}


- (UIView *)viBottom {
    if (!_viBottom) {
        _viBottom = [UIView new];
        _viBottom.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    }
    return _viBottom;
}


@end
