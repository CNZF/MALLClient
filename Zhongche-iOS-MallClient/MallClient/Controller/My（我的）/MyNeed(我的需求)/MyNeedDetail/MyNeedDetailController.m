//
//  MyNeedDetailController.m
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyNeedDetailController.h"
#import "MyNeedDetailCellTwoLine.h"
#import "MyNeedDetailCellThreeLine.h"
#import "MyNeedDetailCellFourLine.h"
#import "MyNeedModel.h"
@interface MyNeedDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation MyNeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"需求信息";
    self.titleArray = @[@"基本信息",@"发运信息",@"联系人信息",@"货品信息",@"收/发货人",@"上门服务"];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H- kNavBarHeaderHeight - kiPhoneFooterHeight );
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight= UITableViewAutomaticDimension;

    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyNeedDetailCellTwoLine class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyNeedDetailCellTwoLine class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyNeedDetailCellThreeLine class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyNeedDetailCellThreeLine class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyNeedDetailCellFourLine class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyNeedDetailCellFourLine class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ||indexPath.section == 4) {
        MyNeedDetailCellFourLine * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyNeedDetailCellFourLine class]) forIndexPath:indexPath];
        [cell setModel:self.needModel index:indexPath.section];
        return cell;
    }else if (indexPath.section == 1 ||indexPath.section == 2) {
        
        MyNeedDetailCellThreeLine * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyNeedDetailCellThreeLine class]) forIndexPath:indexPath];
        [cell setModel:self.needModel index:indexPath.section];
        return cell;
    }else{
        MyNeedDetailCellTwoLine * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyNeedDetailCellTwoLine class]) forIndexPath:indexPath];
        [cell setModel:self.needModel index:indexPath.section];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 36)];
    view.backgroundColor = [HelperUtil colorWithHexString:@"f8f8f8"];
    UILabel * headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W, 36)];
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.font = [UIFont systemFontOfSize:14];
    headLabel.textColor = [HelperUtil colorWithHexString:@"999999"];
    headLabel.text = self.titleArray[section];
    [view addSubview:headLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
@end
