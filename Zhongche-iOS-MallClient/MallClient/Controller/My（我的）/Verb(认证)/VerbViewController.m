//
//  VerbViewController.m
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "VerbViewController.h"
#import "VerbCell.h"
#import "PersonalAuthenticationVC.h"
#import "EnterpriseNameAuthenticationManagerVC.h"
#import "EnterpriseValueAuthenticationVC.h"
#import "AccManViewController.h"
#import "UserViewModel.h"

@interface VerbViewController ()  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;

@end

@implementation VerbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的认证";
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserInfoModel * info = USER_INFO;
    [[UserViewModel new] loginWithToken:info.token callback:^(UserInfoModel *userInfo) {
        [self.tableView reloadData];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerbCell * cell  = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VerbCell class]) owner:self options:nil] firstObject];
    cell.index = indexPath.row;
   
    [cell setInfo:USER_INFO WithIndex:indexPath.row];
    return cell;
}

#pragma mark ---Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel * info = USER_INFO;
    if (indexPath.row == 0) {
        if (info.userName) {
            AccManViewController * controller = [[AccManViewController alloc] initWithNibName:NSStringFromClass([AccManViewController class]) bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            PersonalAuthenticationVC *vc = [PersonalAuthenticationVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.row == 1) {
        if (info.userName  == nil) {
             [[Toast shareToast]makeText:@"请先进行实名认证" aDuration:1];
            return;
        }
        if ([info.authStatus intValue]  == 1 || [info.authStatus intValue]  == 2) {
            return;
        }else{
            EnterpriseNameAuthenticationManagerVC *vc = [EnterpriseNameAuthenticationManagerVC new];
            vc.status = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.row == 2) {
        if (info.userName  == nil) {
            [[Toast shareToast]makeText:@"请先进行实名认证" aDuration:1];
            return;
        }
        if (info.authStatus  == nil || [info.authStatus intValue]  == 3 || [info.authStatus intValue] == 0) {
            [[Toast shareToast]makeText:@"请先通过企业实名认证" aDuration:1];
            return;
        }
        if ([info.quaAuthStatus intValue]  == 1 || [info.quaAuthStatus intValue]  == 2 ) {
            return;
        }else{
            EnterpriseValueAuthenticationVC *vc = [EnterpriseValueAuthenticationVC new];
            vc.status = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - kiPhoneFooterHeight-kTabbarHight) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        _tableView = tableView;
    }
    return _tableView;
}
@end
