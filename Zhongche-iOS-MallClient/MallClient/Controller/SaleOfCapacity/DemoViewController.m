//
//  DemoViewController.m
//  MallClient
//
//  Created by lxy on 2017/2/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "DemoViewController.h"
#import "NewTransportTableViewCell.h"

@interface DemoViewController ()

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];//不能放init处
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"点击section展开收缩row";

    //1.定义全局tableView

    //2.初始化_tableView
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //3.设置代理，头文件也要包含 UITableViewDelegate,UITableViewDataSource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //4.添加_tableView
    [self.view addSubview:self.tableView];


    self.tableView.tableFooterView = [[UIView alloc]init];


    _sectionArray = [NSArray arrayWithObjects:@"好友",@"家人",@"朋友",@"同学",@"陌生人",@"黑名单", nil];

    _rowArray = [NSArray arrayWithObjects:@"张三",@"李四",@"王五",@"未命名",@"未命名", nil];
}

- (void)bindView {

    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:self.tableView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_rowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Celled";
    NewTransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewTransportTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSString *st = @"10000.00元/箱";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 3, 3)];

    cell.lbMoney.attributedText = AttributedStr;

    cell.btnChoose.layer.borderWidth = 1;
    cell.btnChoose.layer.borderColor =  [APP_COLOR_BLUE_BTN CGColor];
    [cell.btnChoose setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];




    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
        return 147;
    }
    return 0;
}
//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86 + 10;
}
//section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{



    UIView * vi = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 96)];
    header.backgroundColor = [UIColor whiteColor];
    UIView *viDay = [UIView new];
    viDay.frame = CGRectMake(20, 43 - 27.5, 55, 55);
    viDay.layer.borderWidth = 1;
    viDay.layer.borderColor =  [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    [header addSubview:viDay];

    UILabel *lbDay = [self labelWithText:@"5" WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbDay.frame = CGRectMake(0, 5, 55, 30);
    lbDay.text = @"5";
    [viDay addSubview:lbDay];

    UILabel *lbText = [self labelWithText:@"日达" WithFont:[UIFont systemFontOfSize:10] WithTextAlignment:NSTextAlignmentCenter WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbText.frame = CGRectMake(0, lbDay.bottom, 55, 10);
    lbText.text = @"日达";
    [viDay addSubview:lbText];


    UIImageView *ivDingzhi = [UIImageView new];
    ivDingzhi.image = [UIImage imageNamed:@"dingzhi1"];
    ivDingzhi.frame = CGRectMake(0, 0, 44, 44);
    [header addSubview:ivDingzhi];

    UILabel *lbTime = [self labelWithText:@"预计抵达 2016-10-30" WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
    lbTime.frame = CGRectMake(viDay.right + 5, 5, SCREEN_W - viDay.right - 5, 15);
    lbTime.text = @"预计抵达 2016-10-30";
    [viDay addSubview:lbTime];


    UILabel *lbMoney = [UILabel new];
    lbMoney.frame = CGRectMake(viDay.right + 5, lbText.bottom  - 10, SCREEN_W - viDay.right - 5, 15);
    [viDay addSubview:lbMoney];
    lbMoney.textColor  = [UIColor redColor];


    NSString *st = @"10000.00元/箱 起";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

    NSUInteger loc =  st.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 8, 8)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 5, 5)];

    lbMoney.attributedText = AttributedStr;

    UIImageView *ivUpDanDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"upAction1"]];
    ivUpDanDown.frame = CGRectMake(SCREEN_W - 40, 33, 21, 21);
    [header addSubview:ivUpDanDown];

    UIView *viFoot = [UIView new];
    viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viFoot.frame = CGRectMake(0, 86, SCREEN_W, 10);
    [header addSubview:viFoot];
//
//
//    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;

    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [header addGestureRecognizer:singleRecognizer];//添加一个手势监测；

    return header;
}

#pragma mark 展开收缩section中cell 手势监听
-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    NSInteger didSection = recognizer.view.tag;

    if (!_showDic) {
        _showDic = [[NSMutableDictionary alloc]init];
    }

    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
    if (![_showDic objectForKey:key]) {
        [_showDic setObject:@"1" forKey:key];

    }else{
        [_showDic removeObjectForKey:key];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  getter
 */

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;

        _tableView = tableView;
    }
    return _tableView;
}



@end
