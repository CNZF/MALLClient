//
//  UserViewController.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/16.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "MLNavigationController.h"
#import "UserViewModel.h"
#import "AccountViewController.h"
#import "UserInfoVC.h"
#import "DynamicDetailsViewController.h"
#import "IdeaFeedbackVC.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView        *tableHeadView;
@property (nonatomic, strong) UIView        *viHead;
@property (nonatomic, strong) UIImageView   *ivHead;
@property (nonatomic, strong) UILabel       *lbName;
@property (nonatomic, strong) UILabel       *lbHead;
@property (nonatomic, strong) UILabel       *lbAccountAmount;//总资产额度（元）
@property (nonatomic, strong) UILabel       *lbUsedCredit;//已用额度（元）
@property (nonatomic, strong) UILabel       *lbCreditLimit;//信用额度（元）
@property (nonatomic, strong) UIView        *viMoney;
@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, strong) UITableView   *tvList;
@property (nonatomic, strong) NSArray       *arrCellTitle;

@end

@implementation UserViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = NO;

    if (USER_INFO) {
        UserViewModel *vm = [UserViewModel new];

        self.lbHead.text = @"编辑账号>";
        self.lbName.text = @"";
        WS(ws);
        [vm getUserInfoWithUserId:^(UserInfoModel *userInfo) {

            if (userInfo) {
                ws.lbName.text =userInfo.loginName;
                if (!userInfo.accountAmount) {
                    userInfo.accountAmount = @"";
                }
                NSMutableAttributedString * lbAccountAmountText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[userInfo.accountAmount NumberStringToMoneyString]]];
                [lbAccountAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbAccountAmountText.length)];
                [lbAccountAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbAccountAmountText.string rangeOfString:[userInfo.accountAmount NumberStringToMoneyStringGetLastThree]]];
                ws.lbAccountAmount.attributedText = lbAccountAmountText;

                if (!userInfo.usedCredit) {

                    userInfo.usedCredit = @"";
                }
                NSMutableAttributedString * lbUsedCreditText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[userInfo.usedCredit NumberStringToMoneyString]]];
                [lbUsedCreditText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbUsedCreditText.length)];
                [lbUsedCreditText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbUsedCreditText.string rangeOfString:[userInfo.usedCredit NumberStringToMoneyStringGetLastThree]]];
                ws.lbUsedCredit.attributedText = lbUsedCreditText;
                if (!userInfo.creditLimit) {
                    userInfo.creditLimit = @"";
                }
                NSMutableAttributedString * lbCreditLimitText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[userInfo.creditLimit NumberStringToMoneyString]]];
                [lbCreditLimitText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbCreditLimitText.length)];
                [lbCreditLimitText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbCreditLimitText.string rangeOfString:[userInfo.creditLimit NumberStringToMoneyStringGetLastThree]]];
                ws.lbCreditLimit.attributedText = lbCreditLimitText;
                ws.lbName.text = userInfo.loginName;
                ws.userInfo = userInfo;
                [ws.ivHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASEIMGURL,userInfo.icon]] placeholderImage:[UIImage imageNamed:[@"userHead" adS]]];
            }else {

                self.lbHead.text = @"点击登录>";
                self.lbName.text = @"未登录";
                self.lbAccountAmount.text = @"￥0.00";
                self.lbUsedCredit.text = @"￥0.00";
                self.lbCreditLimit.text = @"￥0.00";
                self.ivHead.image = [UIImage imageNamed:@"userHead"];

                UserInfoModel *us = nil;
                [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]]; 


            }

        }];

    }else {

        self.lbHead.text = @"点击登录>";
        self.lbName.text = @"未登录";
        self.lbAccountAmount.text = @"￥0.00";
        self.lbUsedCredit.text = @"￥0.00";
        self.lbCreditLimit.text = @"￥0.00";
        self.ivHead.image = [UIImage imageNamed:@"userHead"];
        
    }


}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {

    [super viewDidLoad];

}

- (void)bindView {

    self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_W, 250 +75);

    self.viHead.frame = CGRectMake(0, -200, SCREEN_W, 450);
    [self.tableHeadView addSubview:self.viHead];

    self.ivHead.frame = CGRectMake(SCREEN_W/2 - 45, 80, 90, 90);
    [self.tableHeadView addSubview:self.ivHead];

    self.lbName.frame = CGRectMake(0, self.ivHead.bottom +10, SCREEN_W, 20);
    [self.tableHeadView addSubview:self.lbName];

    self.lbHead.frame = CGRectMake(0, self.lbName.bottom + 10, SCREEN_W, 10);
    [self.tableHeadView addSubview:self.lbHead];

    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, SCREEN_W, 170)];
    [button addTarget:self action:@selector(pushToNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeadView addSubview:button];

    self.viMoney.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 75);
    [self viMoneyMake];
    [self.tableHeadView addSubview:self.viMoney];

    [self.view addSubview:self.tvList];
    self.tvList.tableHeaderView = self.tableHeadView;
}

- (void)bindModel {
    self.arrCellTitle = @[@"账户列表",@"关于互联运力",@"客服电话",@"法律声明", @"意见反馈"];
}

//流水账视图
- (void)viMoneyMake {

    self.lbAccountAmount.frame = CGRectMake(0, 10, SCREEN_W/3, 30);
    self.lbUsedCredit.frame = CGRectMake(SCREEN_W/3, 10, SCREEN_W/3, 30);
    self.lbCreditLimit.frame = CGRectMake(SCREEN_W*2/3, 10, SCREEN_W/3, 30);

    [self.viMoney addSubview:self.lbAccountAmount];
    [self.viMoney addSubview:self.lbUsedCredit];
    [self.viMoney addSubview:self.lbCreditLimit];


    UILabel *lb1 = [self labelWithText:@"总资产" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY2];

    UILabel *lb2 = [self labelWithText:@"总负债" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY2];

    UILabel *lb3 = [self labelWithText:@"后付款限额" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY2];

    lb1.frame = CGRectMake(0, 40, SCREEN_W/3, 20);
    lb2.frame = CGRectMake(SCREEN_W/3, 40, SCREEN_W/3, 20);
    lb3.frame = CGRectMake(SCREEN_W*2/3, 40, SCREEN_W/3, 20);

    [self.viMoney addSubview:lb1];
    [self.viMoney addSubview:lb2];
    [self.viMoney addSubview:lb3];

}

//跳转页面事件
- (void)pushToNextView {


    

    if (USER_INFO) {

        UserInfoVC *vc = [UserInfoVC new];
        [self.navigationController pushViewController:vc animated:YES];


    }else {
        MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:vc animated:YES completion:^{

        }];

    }
}


/**
 *  tableViewDelegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.arrCellTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    }

    cell.textLabel.text = [self.arrCellTitle objectAtIndex:indexPath.section];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    if (indexPath.section == 2) {

        cell.detailTextLabel.text = APP_CUSTOMER_SERVICE;

    }

    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    


    if (indexPath.section == 0) {
        //AccountViewController.h

        if (USER_INFO) {
            [self.navigationController pushViewController:[AccountViewController new] animated:YES];
        }else {
            [[Toast shareToast]makeText:@"请先登录" aDuration:1];
        }

    }

    if (indexPath.section == 1) {

        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
        vc.title = @"关于互联运力";
        vc.urlStr = @"http://weixin.unitransdata.com/weixinrest/companyIntroduce.jsp";
        [self.navigationController pushViewController:vc animated:YES];
    }

    if(indexPath.section == 2){

        [self callAction];
    }

    if(indexPath.section == 3){

        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
        vc.title = @"服务条款和隐私策略";
        vc.urlStr = [NSString stringWithFormat:@"%@/mallrest/serviceitem.jsp",BASEURL];
        [self.navigationController pushViewController:vc animated:YES];
    }

    if(indexPath.section == 4){

        [self.navigationController pushViewController:[IdeaFeedbackVC new] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

/**
 *  getter
 */

- (UIView *)viHead {

    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = APP_COLOR_BLUE_BTN;
    }
    return _viHead;
}

- (UIImageView *)ivHead {
    if (!_ivHead) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"userHead"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 45;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;

        
        _ivHead = imageView;
    }
    return _ivHead;
}

- (UILabel *)lbHead {

    if (!_lbHead) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_PURPLE;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"点击登录>";

        _lbHead = label;
    }
    return _lbHead;
}

- (UILabel *)lbName {

    if (!_lbName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"未登录";


        _lbName = label;
    }
    return _lbName;
}

- (UIView *)viMoney {

    if (!_viMoney) {
        _viMoney = [UIView new];
        _viMoney.backgroundColor = [UIColor whiteColor];

    }
    return _viMoney;
}

- (UILabel *)lbAccountAmount {

    if (!_lbAccountAmount) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"￥0.00";

        _lbAccountAmount = label;
    }
    return _lbAccountAmount;
}

- (UILabel *)lbUsedCredit{

    if (!_lbUsedCredit) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"￥0.00";

        _lbUsedCredit = label;
    }
    return _lbUsedCredit;
}

- (UILabel *)lbCreditLimit{

    if (!_lbCreditLimit) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"￥0.00";

        _lbCreditLimit = label;
    }
    return _lbCreditLimit;
}

- (UIView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [UIView new];

    }
    return _tableHeadView;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_W, SCREEN_H - 24) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tvList = tableView;
    }
    return _tvList;
}



@end
