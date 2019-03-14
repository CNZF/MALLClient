//
//  StationVC.m
//  MallClient
//
//  Created by lxy on 2017/3/23.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "StationVC.h"


@interface StationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSArray *arrInfo;

@end

@implementation StationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"网点选择";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.tvList];
}

- (void)bindModel {

    self.arrInfo = [NSArray new];
}

- (void)getData {


    EmptyContainerViewModel *vm = [EmptyContainerViewModel new];
    WS(ws);
    [vm selectStationWithCode:self.code callback:^(NSArray *arr) {

        ws.arrInfo = arr;
        [ws.tvList reloadData];
    }];
}



/**
 *  UITableViewDelegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    }

    cell.imageView.image = [UIImage imageNamed:@"address"];
    StationModel *info = [self.arrInfo objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    StationModel *info = [self.arrInfo objectAtIndex:indexPath.row];
    [self.stationDelegate getStationModel:info];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  getter
 */
- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        _tvList = tableView;
    }
    return _tvList;
}

@end
