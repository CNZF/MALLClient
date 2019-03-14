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
#import "AddressManagerViewController.h"

#import "UserHeadView.h"
#import "AccountCell.h"
#import "MyOrderListCell.h"
#import "MyFunctionCell.h"

#import "UserViewModel.h"
#import "MessageViewModel.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UIView        *tableHeadView;
//@property (nonatomic, strong) UIView        *viHead;
//@property (nonatomic, strong) UIImageView   *ivHead;
//@property (nonatomic, strong) UILabel       *lbName;
//@property (nonatomic, strong) UILabel       *lbHead;
//@property (nonatomic, strong) UILabel       *lbAccountAmount;//总资产额度（元）
//@property (nonatomic, strong) UILabel       *lbUsedCredit;//已用额度（元）
//@property (nonatomic, strong) UILabel       *lbCreditLimit;//信用额度（元）
//@property (nonatomic, strong) UIView        *viMoney;

//@property (nonatomic, strong) NSArray       *arrCellTitle;

@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UserHeadView  * userHeadView;
@property (nonatomic, strong) NSDictionary * dataDic;
@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = NO;
    self.userInfo = nil;
    if (USER_INFO) {
         [self asyncWithUser];
    }
    [self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}


- (void)asyncWithUser
{
    UserInfoModel * info = USER_INFO;
    [[UserViewModel new] loginWithToken:info.token callback:^(UserInfoModel *userInfo) {
        [self.tableView reloadData];
    }];
    

    [[UserViewModel new] getUserOrderList:self.userInfo callback:^(NSDictionary *orderDic) {
        self.dataDic = orderDic;
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AccountCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountCell class]) forIndexPath:indexPath];
        cell.info = USER_INFO;
        return cell;
    }else if (indexPath.section == 1){
        MyOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyOrderListCell class]) forIndexPath:indexPath];
        cell.target = self;
        cell.orderDic  = self.dataDic;
        return cell;
    }else{
        if (!USER_INFO) {
            MyFunctionCell * cell  = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyFunctionCell class]) owner:self options:nil] firstObject];
            cell.target = self;
            return cell;
        }else{
            UserInfoModel * info = USER_INFO;
            MyFunctionCell * cell;
            if ([info.userType isEqualToString:@"11"]) {
               cell  = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyFunctionCell class]) owner:self options:nil] lastObject];
            }else{
              cell  = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyFunctionCell class]) owner:self options:nil] [1];
            }
            cell.target = self;
            return cell;
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.userHeadView;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 80+kNavBarHeaderHeight;
    }else{
        return 15.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UserHeadView *)userHeadView
{
    if (!_userHeadView) {
        _userHeadView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UserHeadView class]) owner:self options:nil] firstObject];
        _userHeadView.frame = CGRectMake(0, 0, SCREEN_W, 80+kNavBarHeaderHeight);
        _userHeadView.target = self;
    }
    return _userHeadView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - kiPhoneFooterHeight-kTabbarHight) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        if (SCREEN_H == 812) {
            tableView.contentInset = UIEdgeInsetsMake(-45, 0, 0, 0);
        }else{
            tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        }
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AccountCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountCell class])];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyOrderListCell class])];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyFunctionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyFunctionCell class])];
        _tableView = tableView;
    }
    return _tableView;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//

//
//    self.userInfo = USER_INFO;
//
//    if (self.userInfo) {
//        self.lbName.text =self.userInfo.loginName;
//        if (!self.userInfo.accountAmount) {
//            self.userInfo.accountAmount = @"";
//        }
//        NSMutableAttributedString * lbAccountAmountText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.userInfo.accountAmount NumberStringToMoneyString]]];
//        [lbAccountAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbAccountAmountText.length)];
//        [lbAccountAmountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbAccountAmountText.string rangeOfString:[self.userInfo.accountAmount NumberStringToMoneyStringGetLastThree]]];
//        self.lbAccountAmount.attributedText = lbAccountAmountText;
//
//        if (!self.userInfo.usedCredit) {
//
//            self.userInfo.usedCredit = @"";
//        }
//        NSMutableAttributedString * lbUsedCreditText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.userInfo.usedCredit NumberStringToMoneyString]]];
//        [lbUsedCreditText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbUsedCreditText.length)];
//        [lbUsedCreditText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbUsedCreditText.string rangeOfString:[self.userInfo.usedCredit NumberStringToMoneyStringGetLastThree]]];
//        self.lbUsedCredit.attributedText = lbUsedCreditText;
//        if (!self.userInfo.creditLimit) {
//            self.userInfo.creditLimit = @"";
//        }
//        NSMutableAttributedString * lbCreditLimitText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.userInfo.creditLimit NumberStringToMoneyString]]];
//        [lbCreditLimitText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbCreditLimitText.length)];
//        [lbCreditLimitText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbCreditLimitText.string rangeOfString:[self.userInfo.creditLimit NumberStringToMoneyStringGetLastThree]]];
//        self.lbCreditLimit.attributedText = lbCreditLimitText;
//        self.lbName.text = self.userInfo.loginName;
//        self.lbHead.text = @"编辑账号>";
//        self.userInfo = self.userInfo;
//        [self.ivHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASEIMGURL,self.userInfo.icon]] placeholderImage:[UIImage imageNamed:[@"userHead" adS]]];
//    }else {
//        self.lbHead.text = @"点击登录>";
//        self.lbName.text = @"未登录";
//        self.lbAccountAmount.text = @"￥0.00";
//        self.lbUsedCredit.text = @"￥0.00";
//        self.lbCreditLimit.text = @"￥0.00";
//        self.ivHead.image = [UIImage imageNamed:@"userHead"];
//
//    }
//
//
//}
//w





//
//- (void)bindView {
//
//    self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_W, 250 +75);
//
//    self.viHead.frame = CGRectMake(0, -200, SCREEN_W, 450);
//    [self.tableHeadView addSubview:self.viHead];
//
//    self.ivHead.frame = CGRectMake(SCREEN_W/2 - 45, 80, 90, 90);
//    [self.tableHeadView addSubview:self.ivHead];
//
//    self.lbName.frame = CGRectMake(0, self.ivHead.bottom +10, SCREEN_W, 20);
//    [self.tableHeadView addSubview:self.lbName];
//
//    self.lbHead.frame = CGRectMake(0, self.lbName.bottom + 10, SCREEN_W, 10);
//    [self.tableHeadView addSubview:self.lbHead];
//
//    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, SCREEN_W, 170)];
//    [button addTarget:self action:@selector(pushToNextView) forControlEvents:UIControlEventTouchUpInside];
//    [self.tableHeadView addSubview:button];
//
//    self.viMoney.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 75);
//    [self viMoneyMake];
//    [self.tableHeadView addSubview:self.viMoney];
//
//    [self.view addSubview:self.tvList];
//    self.tvList.tableHeaderView = self.tableHeadView;
//}
//
//- (void)bindModel {
//    self.arrCellTitle = @[@"我的地址",@"账户列表",@"关于互联运力",@"客服电话",@"法律声明", @"意见反馈"];
//}
//
////流水账视图
//- (void)viMoneyMake {
//
//    self.lbAccountAmount.frame = CGRectMake(0, 10, SCREEN_W/3, 30);
//    self.lbUsedCredit.frame = CGRectMake(SCREEN_W/3, 10, SCREEN_W/3, 30);
//    self.lbCreditLimit.frame = CGRectMake(SCREEN_W*2/3, 10, SCREEN_W/3, 30);
//
//    [self.viMoney addSubview:self.lbAccountAmount];
//    [self.viMoney addSubview:self.lbUsedCredit];
//    [self.viMoney addSubview:self.lbCreditLimit];
//
//
//    UILabel *lb1 = [self labelWithText:@"总资产" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY2];
//
//    UILabel *lb2 = [self labelWithText:@"总负债" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY2];
//
//    UILabel *lb3 = [self labelWithText:@"后付款限额" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY2];
//
//    lb1.frame = CGRectMake(0, 40, SCREEN_W/3, 20);
//    lb2.frame = CGRectMake(SCREEN_W/3, 40, SCREEN_W/3, 20);
//    lb3.frame = CGRectMake(SCREEN_W*2/3, 40, SCREEN_W/3, 20);
//
//    [self.viMoney addSubview:lb1];
//    [self.viMoney addSubview:lb2];
//    [self.viMoney addSubview:lb3];
//
//}
//
////跳转页面事件
//- (void)pushToNextView {
//
//    if (USER_INFO) {
//
//        UserInfoVC *vc = [UserInfoVC new];
//        [self.navigationController pushViewController:vc animated:YES];
//
//
//    }else {
//        MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
//        [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self presentViewController:vc animated:YES completion:^{
//
//        }];
//
//    }
//}
//
//
///**
// *  tableViewDelegate
// *
// */
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return self.arrCellTitle.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//
//    return 1;
//
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *CellIdentifier = @"Cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if(cell == nil){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//
//    }
//
//    cell.textLabel.text = [self.arrCellTitle objectAtIndex:indexPath.section];
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//
//    if (indexPath.section == 3) {
//
//        cell.detailTextLabel.text = APP_CUSTOMER_SERVICE;
//
//    }
//
//
//    return cell;
//
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section == 0) {
//        AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
//        vc.title = @"我的地址";
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//
//
//    if (indexPath.section == 1) {
//        //AccountViewController.h
//
//        if (USER_INFO) {
//            [self.navigationController pushViewController:[AccountViewController new] animated:YES];
//        }else {
//            [[Toast shareToast]makeText:@"请先登录" aDuration:1];
//        }
//
//    }
//
//    if (indexPath.section == 2) {
//
//        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
//        vc.title = @"关于互联运力";
//        vc.urlStr = @"http://weixin.unitransdata.com/weixinrest/companyIntroduce.jsp";
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//    if(indexPath.section == 3){
//
//        [self callAction];
//    }
//
//    if(indexPath.section == 4){
//
//        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
//        vc.title = @"服务条款和隐私策略";
//        vc.urlStr = [NSString stringWithFormat:@"%@/mallrest/serviceitem.jsp",BASEURL];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//    if(indexPath.section == 5){
//
//        [self.navigationController pushViewController:[IdeaFeedbackVC new] animated:YES];
//    }
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 60;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [UIView new];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return section == 5?15:CGFLOAT_MIN;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [UIView new];
//}
//
///**
// *  getter
// */
//
//- (UIView *)viHead {
//
//    if (!_viHead) {
//        _viHead = [UIView new];
//        _viHead.backgroundColor = APP_COLOR_BLUE_BTN;
//    }
//    return _viHead;
//}
//
//- (UIImageView *)ivHead {
//    if (!_ivHead) {
//        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView.image = [UIImage imageNamed:@"userHead"];
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 45;
////        imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//
//        _ivHead = imageView;
//    }
//    return _ivHead;
//}
//
//- (UILabel *)lbHead {
//
//    if (!_lbHead) {
//        UILabel* label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = APP_COLOR_PURPLE;
//        label.font = [UIFont systemFontOfSize:12.0f];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"点击登录>";
//
//        _lbHead = label;
//    }
//    return _lbHead;
//}
//
//- (UILabel *)lbName {
//
//    if (!_lbName) {
//        UILabel* label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:18.0f];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"未登录";
//
//
//        _lbName = label;
//    }
//    return _lbName;
//}
//
//- (UIView *)viMoney {
//
//    if (!_viMoney) {
//        _viMoney = [UIView new];
//        _viMoney.backgroundColor = [UIColor whiteColor];
//
//    }
//    return _viMoney;
//}
//
//- (UILabel *)lbAccountAmount {
//
//    if (!_lbAccountAmount) {
//        UILabel* label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont systemFontOfSize:18.0f];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"￥0.00";
//
//        _lbAccountAmount = label;
//    }
//    return _lbAccountAmount;
//}
//
//- (UILabel *)lbUsedCredit{
//
//    if (!_lbUsedCredit) {
//        UILabel* label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont systemFontOfSize:18.0f];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"￥0.00";
//
//        _lbUsedCredit = label;
//    }
//    return _lbUsedCredit;
//}
//
//- (UILabel *)lbCreditLimit{
//
//    if (!_lbCreditLimit) {
//        UILabel* label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont systemFontOfSize:18.0f];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"￥0.00";
//
//        _lbCreditLimit = label;
//    }
//    return _lbCreditLimit;
//}
//
//- (UIView *)tableHeadView {
//    if (!_tableHeadView) {
//        _tableHeadView = [UIView new];
//
//    }
//    return _tableHeadView;
//}




@end
