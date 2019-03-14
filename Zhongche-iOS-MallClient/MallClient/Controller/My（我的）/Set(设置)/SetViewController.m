//
//  SetViewController.m
//  MallClient
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "DynamicDetailsViewController.h"
#import "IdeaFeedbackVC.h"

@interface SetViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray * arrCellTitle;
@property (nonatomic, strong) NSArray * arrCellImage;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.arrCellTitle = @[@"关于互联运力",@"客服电话",@"法律声明", @"意见反馈"];
    self.arrCellImage = @[@"about",@"Group 15",@"Group 14", @"Group 17"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrCellTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetCell * cell  = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SetCell class]) owner:self options:nil] firstObject];
    [cell setIndex:indexPath.section titleArray:self.arrCellTitle imageArray:self.arrCellImage];
    return cell;
}

#pragma mark ---Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
        vc.title = @"关于互联运力";
        vc.urlStr = ABOUT;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        [self callAction];
    }
    if (indexPath.section == 2) {
        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
        vc.title = @"服务条款和隐私策略";
        vc.urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,AboutProtocal];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3) {
        [self.navigationController pushViewController:[IdeaFeedbackVC new] animated:YES];
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
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - kiPhoneFooterHeight-kTabbarHight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SetCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SetCell class])];
        _tableView = tableView;
    }
    return _tableView;
}
@end
