//
//  AccountViewController.m
//  MallClient
//
//  Created by lxy on 2017/1/24.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTableViewCell.h"
#import "UserViewModel.h"
#import "AcountDetail.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSArray *arr;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"账户列表";
    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;



    UILabel *lb1 = [self labelWithText:@"客户号" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentCenter WithTextColor:[UIColor darkGrayColor]];
    lb1.backgroundColor = [UIColor whiteColor];
    UILabel *lb2 = [self labelWithText:@"客户账号" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentCenter WithTextColor:[UIColor darkGrayColor]];
    lb2.backgroundColor = [UIColor whiteColor];
    UILabel *lb3 = [self labelWithText:@"      当前余额" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentCenter WithTextColor:[UIColor darkGrayColor]];
    lb3.backgroundColor = [UIColor whiteColor];
    UILabel *lb4 = [self labelWithText:@"状态" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentCenter WithTextColor:[UIColor darkGrayColor]];
    lb4.backgroundColor = [UIColor whiteColor];

    lb1.frame = CGRectMake(0, 10, 63, 40);
    lb2.frame = CGRectMake(lb1.right, 10, 109, 40);
    lb3.frame = CGRectMake(lb2.right, 10, SCREEN_W- 63 -109 -65, 40);
    lb4.frame = CGRectMake(lb3.right, 10, 65, 40);

    [self.view addSubview:lb1];
    [self.view addSubview:lb2];
    [self.view addSubview:lb3];
    [self.view addSubview:lb4];

    [self.view addSubview:self.tvList];

}

- (void)getData {

    UserViewModel *vm = [UserViewModel new];

    WS(ws);

    [vm getUserAccountListcallback:^(NSArray *arr) {

        ws.arr = arr;
        [ws.tvList reloadData];

    }];
}

/**
 *  tableViewDelegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *CellIdentifier = @"Celled";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:self options:nil];
    AcountDetail *model = [self.arr objectAtIndex:indexPath.row];

    cell = [array objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lbNo.text = model.customerNum;
    cell.lbPrice.text = model.accountAmount;
    cell.lbAccount.text = model.customerAccount;
    cell.lbStatuse.text = [model.accountStatus isEqualToString:@"0"]?@"正常":@"异常";


    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 5;
}


/**
 *  getter
 */
- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W, SCREEN_H - 40) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;

        _tvList = tableView;
    }
    return _tvList;
}

@end
