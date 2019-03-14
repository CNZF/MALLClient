
//
//  OrderDetailsContainerVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/6.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailsContainerVC.h"
#import "PaymentPageVC.h"
#import "OrderAlertView.h"
#import "MLNavigationController.h"


@interface OrderDetailsContainerVC ()
@property (nonatomic, strong) UIScrollView * bgView;

@property (nonatomic, strong) UIView       * headTitleView;//头部蓝色视图
@property (nonatomic, strong) UILabel      * ordetTypeLab;
@property (nonatomic, strong) UILabel      * orderIDLab;
@property (nonatomic, strong) UIButton     * toViewContainerIDBtn;//查看已发箱箱号

@property (nonatomic, strong) UIView       * addressView;//收还箱视图
@property (nonatomic, strong) UIImageView  * peopleIgv;
@property (nonatomic, strong) UILabel      * peopelNameLab;
@property (nonatomic, strong) UILabel      * peopelPhoneLab;
@property (nonatomic, strong) UIImageView  * buyersIgv;//收箱地
@property (nonatomic, strong) UILabel      * buyersAddressLab;
@property (nonatomic, strong) UIImageView  * sellerIgv;//还箱地
@property (nonatomic, strong) UILabel      * sellerAddressLab;
@property (nonatomic, strong) UIImageView  * addressViewIgv;//网点彩带

@property (nonatomic, strong) UIView       * orderView;//定单视图
@property (nonatomic, strong) UIImageView  * orderIgv;
@property (nonatomic, strong) UILabel      * containerTypeLab;
@property (nonatomic, strong) UILabel      * orderTypeLab;
@property (nonatomic, strong) UILabel      * containerNumLab;
@property (nonatomic, strong) UILabel      * containerPriceLab;//箱子金额
@property (nonatomic, strong) UILabel      * rentPriceLab;//租金
@property (nonatomic, strong) UILabel      * mortgageLab;//押金
@property (nonatomic, strong) UILabel      * giveBackPriceLab;//异地还箱费
@property (nonatomic, strong) UILabel      * allPriceLab;
@property (nonatomic, strong) UILabel      * placeTheOrderLab;

@property (nonatomic, strong) UIView       * detailsVi;//详情
@property (nonatomic, strong) UILabel      * containerConditionLab;//箱子状况
@property (nonatomic, strong) UILabel      * rentTimeLab;//租赁时间
@property (nonatomic, strong) UILabel      * sellerLab;//卖家
@property (nonatomic, strong) UILabel      * phoneLab;//电话
@property (nonatomic, strong) UILabel      * goodsCodeLab;//商品编号

@property (nonatomic, strong) UIButton     * packUpBtn;//收起展开Btn
@property (nonatomic, strong) UIView       * lineVi;
@property (nonatomic, strong) UIView       * orderProgressView;//订单进展视图

@property (nonatomic, strong) UIView       * lastView;//根部视图
@property (nonatomic, strong) UILabel      * priceLab;
@property (nonatomic, strong) UIButton     * cancelBtn;
@property (nonatomic, strong) UIButton     * goPaymentBtn;
@property (nonatomic, strong) UIButton     * closedBoxBtn;//收箱
@property (nonatomic, strong) UIButton     * deleteBtn;//删除

@end

@implementation OrderDetailsContainerVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
}

-(void)bindView {
    self.bgView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.bgView];
    
    self.headTitleView.frame = CGRectMake(0, 0, SCREEN_W, 97);
    [self.bgView addSubview:self.headTitleView];
    
    if(self.model.orderTypeEnum == buyContainer){
        self.addressView.frame = CGRectMake(0, self.headTitleView.bottom, SCREEN_W, 106);
        self.orderView.frame = CGRectMake(0, self.addressView.bottom + 12, SCREEN_W, 204);
        self.detailsVi.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 131);
    }else {
        self.addressView.frame = CGRectMake(0, self.headTitleView.bottom, SCREEN_W, 162);
        self.orderView.frame = CGRectMake(0, self.addressView.bottom + 12, SCREEN_W, 260);
        self.detailsVi.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 155);
    }
    [self.bgView addSubview:self.addressView];
    [self.bgView addSubview:self.orderView];
    
    
    self.packUpBtn.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 44);
    [self makeButton:self.packUpBtn];
    [self.bgView addSubview:self.packUpBtn];
    
    self.lineVi.frame = CGRectMake(0, self.packUpBtn.bottom, SCREEN_W, 150);
    [self.bgView addSubview:self.lineVi];
    
    self.lastView.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.lastView];
    
    [self bindModel];
}

-(void)bindModel {
    
    WS(ws);
    [[OrderViewModel new] getEmptyContainerOrderDetailsWithOrderId:self.model.ID callback:^(OrderModelForEmptyContainer *model) {
        if (![ws.model.orderState isEqualToString:model.orderState]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                               object:@{
                                                                        @"orderType":@"全部",
                                                                        @"viewTitle":@"空箱之家"
                                                                        }];
        }
        ws.model = model;
        [self updateUIWithModel:model];
    }];
}

-(void)bindAction {
    WS(ws);
    [[self.packUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([ws.packUpBtn.titleLabel.text isEqualToString:@"更多信息"]) {
            [ws.bgView addSubview:ws.detailsVi];
            [ws.bgView sendSubviewToBack:ws.detailsVi];
            [UIView animateWithDuration:0.5
                             animations:^{
                                 ws.packUpBtn.frame = CGRectMake(0, ws.detailsVi.bottom, SCREEN_W, 44);
                                 ws.lineVi.frame = CGRectMake(0, ws.packUpBtn.bottom, SCREEN_W, 150);
                                 ws.orderProgressView.frame = CGRectMake(ws.orderProgressView.left,ws.packUpBtn.bottom + 12, ws.orderProgressView.width, ws.orderProgressView.height);
                             }
            ];
            [ws.packUpBtn setTitle:@"收起" forState:UIControlStateNormal];
            [ws.packUpBtn setImage:[UIImage imageNamed:[@"Clip 4" adS]] forState:UIControlStateNormal];
            [self makeButton:ws.packUpBtn];
            ws.bgView.contentSize = CGSizeMake(SCREEN_W, ws.orderProgressView.bottom + 50);

        }else {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 ws.packUpBtn.frame = CGRectMake(0, ws.orderView.bottom, SCREEN_W, 44);
                                 ws.lineVi.frame = CGRectMake(0, ws.packUpBtn.bottom, SCREEN_W, 150);
                                 ws.orderProgressView.frame = CGRectMake(ws.orderProgressView.left,ws.packUpBtn.bottom + 12, ws.orderProgressView.width, ws.orderProgressView.height);
                             }
                             completion:^(BOOL finished) {
                                 [ws.detailsVi removeFromSuperview];
                             }];
            [ws.packUpBtn setTitle:@"更多信息" forState:UIControlStateNormal];
            [ws.packUpBtn setImage:[UIImage imageNamed:[@"down" adS]] forState:UIControlStateNormal];
            [self makeButton:ws.packUpBtn];
            ws.bgView.contentSize = CGSizeMake(SCREEN_W, ws.orderProgressView.bottom + 50);
        }
    }];
    
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"是否取消此订单？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.delegate = ws;
        [alert show];
    }];
    
    [[self.closedBoxBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (ws.model.orderTypeEnum == buyContainer) {
            [[OrderViewModel new]emptyContainerOrderOperateWithOrderId:ws.model.ID WithType:COMPLETED callback:^(NSString *str) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                                   object:@{
                                                                            @"orderType":@"全部",
                                                                            @"viewTitle":@"空箱之家"
                                                                            }];
                NSMutableArray * array = [[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
                [array removeObjectAtIndex:array.count-1];
                OrderDetailsContainerVC *vc = [OrderDetailsContainerVC new];
                vc.model = ws.model;
                ws.model.orderState = @"已完成";
                [array addObject:vc];
                [ws.navigationController pushViewController:vc animated:NO];
                [((MLNavigationController *)(ws.navigationController)).screenShotsList removeLastObject];
                [ws.navigationController setViewControllers:array animated:NO];

            }];
        } else if (ws.model.orderTypeEnum == rentContainer) {
            [[OrderViewModel new]emptyContainerOrderOperateWithOrderId:ws.model.ID WithType:WAIT_ACCEPT_BOX callback:^(NSString *str) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                                   object:@{
                                                                            @"orderType":@"全部",
                                                                            @"viewTitle":@"空箱之家"
                                                                            }];
                NSMutableArray * array = [[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
                [array removeObjectAtIndex:array.count-1];
                OrderDetailsContainerVC *vc = [OrderDetailsContainerVC new];
                vc.model = ws.model;
                ws.model.orderState = @"待箱主收箱";
                [array addObject:vc];
                [ws.navigationController pushViewController:vc animated:NO];
                [((MLNavigationController *)(ws.navigationController)).screenShotsList removeLastObject];
                [ws.navigationController setViewControllers:array animated:NO];

            }];
        }
    }];
    
    [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除订单" message:@"是否删除订单？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.delegate = ws;
        [alert show];
    }];
    
    [[self.goPaymentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws.navigationController pushViewController:[PaymentPageVC new] animated:YES];
    }];
 
    [[self.toViewContainerIDBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableArray * arr = [NSMutableArray new];
        for (id dic in ws.model.arrOrderContainerCode) {
            [arr addObject:dic[@"containerCode"]];
        }
        [[[OrderAlertView alloc]initWithTitle:@"已发箱号" entryArray:arr annotation:[NSString stringWithFormat:@"共:%d个",(int)arr.count] cancelButtonTitle:nil otherButtonTitles:@"确定"]show];
    }];
}

//加载订单对象
-(void)updateUIWithModel:(OrderModelForEmptyContainer *)model {
    
    self.ordetTypeLab.text = model.orderState;
    self.orderIDLab.text = [NSString stringWithFormat:@"订单号: %@",model.orderID];
    
    self.peopelNameLab.text = model.peopelName;
    self.peopelPhoneLab.text = model.buyerContactsPhone;
    
    self.buyersAddressLab.text = [NSString stringWithFormat:@"收箱地: %@",model.buyersAddress];
    if ([self.buyersAddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.buyersAddressLab.font}].width <= self.buyersAddressLab.width) {
        self.buyersAddressLab.frame = CGRectMake(self.buyersAddressLab.left, self.buyersAddressLab.top, self.buyersAddressLab.width, 18);
    }
    else
    {
        self.buyersAddressLab.frame = CGRectMake(self.buyersAddressLab.left, self.buyersAddressLab.top, self.buyersAddressLab.width, 36);
    }
    
    self.sellerAddressLab.text = [NSString stringWithFormat:@"还箱地: %@",model.sellerAddress];
    if ([self.sellerAddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.sellerAddressLab.font}].width <= self.sellerAddressLab.width) {
        self.sellerAddressLab.frame = CGRectMake(self.sellerAddressLab.left, self.sellerAddressLab.top, self.sellerAddressLab.width, 18);
    }
    else
    {
        self.sellerAddressLab.frame = CGRectMake(self.sellerAddressLab.left, self.sellerAddressLab.top, self.sellerAddressLab.width, 36);
    }
    
    
    [self.orderIgv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEIMGURL,model.imgUrl]]  placeholderImage:[UIImage imageNamed:@"001.png"]];
    
    self.containerTypeLab.text = model.containerType;
    self.orderTypeLab.text = [NSString stringWithFormat:@"业务类型:%@",model.orderType];
    self.containerNumLab.text = [NSString stringWithFormat:@"数量: %@",model.containerNum];
    if (!model.containerPrice) {
        model.containerPrice = @"";
    }
    NSMutableAttributedString * containerPriceLabText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@x%@个",[model.containerPrice NumberStringToMoneyString],model.containerNum]];
    [containerPriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,containerPriceLabText.length)];
    [containerPriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[containerPriceLabText.string rangeOfString:[model.containerPrice NumberStringToMoneyStringGetLastThree]]];
    self.containerPriceLab.attributedText = containerPriceLabText;
    if (!model.rentPrice) {
        model.rentPrice = @"";
    }
    NSMutableAttributedString * rentPriceLabText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@x%@个x%@天",[model.rentPrice NumberStringToMoneyString],model.containerNum,model.rentdays]];
    [rentPriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,rentPriceLabText.length)];
    [rentPriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[rentPriceLabText.string rangeOfString:[model.rentPrice NumberStringToMoneyStringGetLastThree]]];
    self.rentPriceLab.attributedText = rentPriceLabText;
    if (!model.mortgage) {
        model.mortgage = @"";
    }
    NSMutableAttributedString * mortgageLabText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@x%@个",[model.mortgage NumberStringToMoneyString],model.containerNum]];
    [mortgageLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,mortgageLabText.length)];
    [mortgageLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[mortgageLabText.string rangeOfString:[model.mortgage NumberStringToMoneyStringGetLastThree]]];
    self.mortgageLab.attributedText = mortgageLabText;
    if (!model.giveBackPrice) {
        model.giveBackPrice = @"";
    }
    NSMutableAttributedString * giveBackPriceLabText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@x%@个",[model.giveBackPrice NumberStringToMoneyString],model.containerNum]];
    [giveBackPriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,giveBackPriceLabText.length)];
    [giveBackPriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[giveBackPriceLabText.string rangeOfString:[model.giveBackPrice NumberStringToMoneyStringGetLastThree]]];
    self.giveBackPriceLab.attributedText = giveBackPriceLabText;
    
    NSMutableAttributedString * allPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计: ¥%@",[model.price NumberStringToMoneyString]]];
    [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLACK_TEXT range:NSMakeRange(0,3)];
    [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(3,allPrice.length - 3)];
    
    [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,3)];
    [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(3,allPrice.length - 3)];
    [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[allPrice.string rangeOfString:[model.price NumberStringToMoneyStringGetLastThree]]];
    self.allPriceLab.attributedText = allPrice;
    NSDateFormatter * outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.placeTheOrderLab.text = [NSString stringWithFormat:@"下单时间: %@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.createTime doubleValue] / 1000]]];
    self.containerConditionLab.text = [NSString stringWithFormat:@"箱况:%@",model.containerCondition];
    self.rentTimeLab.text = [NSString stringWithFormat:@"租赁日期：%@至%@",[self stDateToString:model.startTime],[self stDateToString:model.endTime]];
    self.sellerLab.text = [NSString stringWithFormat:@"卖家:%@",model.companyName];
    self.phoneLab.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    self.goodsCodeLab.text = [NSString stringWithFormat:@"商品编号:%@",model.goodsCode];

    [self updateOrderProgressViewWithArray:model.orderProgress WithBefourView:self.packUpBtn];
    
    NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[model.price NumberStringToMoneyString]]];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(0,price.length)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 3,3)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 3)];
    self.priceLab.attributedText = price;
    
}

//加载订单过程
- (void)updateOrderProgressViewWithArray:(NSArray*)orderProgress WithBefourView:(UIView *)view {
    
    if (orderProgress.count <= 0) {
        [self.orderProgressView removeFromSuperview];
        self.bgView.contentSize = CGSizeMake(SCREEN_W,view.bottom + 50);
        return ;
    }
    self.orderProgressView.frame = CGRectMake(0,view.bottom + 12, SCREEN_W, 44 + 77 * orderProgress.count);
    [self.bgView addSubview:self.orderProgressView];
    
    self.bgView.contentSize = CGSizeMake(SCREEN_W, self.orderProgressView.bottom + 50);
    
    for (UIView * view in self.orderProgressView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UILabel * title = [UILabel new];
    title.font = [UIFont systemFontOfSize:16.0f];
    title.textColor = APP_COLOR_BLACK_TEXT;
    title.text = @"订单进展";
    title.frame = CGRectMake(15, 10, SCREEN_W - 30, 19);
    [self.orderProgressView addSubview:title];
    
    UIView * line_01 = [UIView new];
    line_01.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    line_01.frame = CGRectMake(0, 43, SCREEN_W, 0.5);
    [self.orderProgressView addSubview:line_01];
    
    UIView * line_02 = [UIView new];
    line_02.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    line_02.frame = CGRectMake(26.5, 74, 0.5,60 + 77 * (orderProgress.count - 1));
    [self.orderProgressView addSubview:line_02];
    
    OrderProgressModel * model;
    UIView * circle;
    UILabel * lab_name;
    UILabel * lab_time;
    UIView * line;
    
    NSDateFormatter * outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    for (int i = 0;i < orderProgress.count; i ++)
    {
        model = orderProgress[i];
        
        circle = [UIView new];
        circle.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        circle.frame = CGRectMake(22,65 + 77 * i, 10, 10);
        circle.layer.cornerRadius = 5;
        circle.layer.masksToBounds = YES;
        [self.orderProgressView addSubview:circle];
        
        
        lab_name = [UILabel new];
        lab_name.text = model.name;
        lab_name.textColor = APP_COLOR_BLACK_TEXT;
        lab_name.font = [UIFont systemFontOfSize:14.0f];
        lab_name.frame = CGRectMake(58, 65 + 77 * i, SCREEN_W - 80, 13);
        [self.orderProgressView addSubview:lab_name];
        
        
        lab_time = [UILabel new];
        lab_time.text = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue] / 1000]];
        lab_time.textColor = APP_COLOR_GRAY2;
        lab_time.font = [UIFont systemFontOfSize:12.0f];
        lab_time.frame = CGRectMake(58, 91 + 77 * i, SCREEN_W - 80, 13);
        [self.orderProgressView addSubview:lab_time];
        
        
        line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        line.frame = CGRectMake(58, 122 + 77 * i, SCREEN_W - 58, 0.5);
        [self.orderProgressView addSubview:line];
        
        
        if (i == 0) {
            circle.backgroundColor = APP_COLOR_BLUE_BTN;
            circle.frame = CGRectMake(20, 65, 15, 15);
            circle.layer.cornerRadius = 7.5;
            lab_name.textColor = APP_COLOR_BLUE_BTN;
        }
    }
}

#pragma mark - 属性懒加载
-(UIScrollView *)bgView {
    if (!_bgView) {
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _bgView = scrollView;
    }
    return _bgView;
}

-(UIView *)headTitleView {
    if (!_headTitleView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_BLUE_BTN;
        
        self.ordetTypeLab. frame = CGRectMake(40, 25, SCREEN_W - 80, 16);
        [view addSubview:self.ordetTypeLab];
        
        self.orderIDLab. frame = CGRectMake(40, self.ordetTypeLab.bottom + 15, SCREEN_W - 80, 16);
        [view addSubview:self.orderIDLab];
        
        if ([self.model.orderState isEqualToString:@"待箱主收箱"] || [self.model.orderState isEqualToString:@"待买家收箱"] || [self.model.orderState isEqualToString:@"已完成"] || [self.model.orderState isEqualToString:@"已取消"]){
            
            self.toViewContainerIDBtn.frame = CGRectMake(SCREEN_W - 115, 25, 100, 30);
            [view addSubview:self.toViewContainerIDBtn];
        }
        _headTitleView = view;
    }
    return _headTitleView;
}

-(UILabel *)ordetTypeLab {
    if (!_ordetTypeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:18.f];
        lab.textColor = APP_COLOR_WHITE;
        
        _ordetTypeLab = lab;
    }
    return _ordetTypeLab;
}

-(UILabel *)orderIDLab {
    if (!_orderIDLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_WHITE;
        
        _orderIDLab = lab;
    }
    return _orderIDLab;
}

-(UIButton *)toViewContainerIDBtn {
    if (!_toViewContainerIDBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"查看已发箱号" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = APP_COLOR_WHITE.CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _toViewContainerIDBtn = btn;
    }
    return _toViewContainerIDBtn;
}

//收还箱地视图
- (UIView *)addressView {
    if (!_addressView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        self.peopleIgv.frame = CGRectMake(15, 18, 10, 11);
        [view addSubview:self.peopleIgv];
        
        self.peopelNameLab.frame = CGRectMake(40, 16, 80, 16);
        [view addSubview:self.peopelNameLab];
        
        self.peopelPhoneLab.frame = CGRectMake(120, 16, SCREEN_W - 140, 16);
        [view addSubview:self.peopelPhoneLab];
        
        self.buyersIgv.frame = CGRectMake(15, 53, 10, 11);
        [view addSubview:self.buyersIgv];
        
        self.buyersAddressLab.frame = CGRectMake(40, 50, SCREEN_W - 80, 36);
        [view addSubview:self.buyersAddressLab];

        if (self.model.orderTypeEnum == buyContainer) {
            
            self.addressViewIgv.frame = CGRectMake(0, 104, SCREEN_W, 2);
            [view addSubview:self.addressViewIgv];
        }else {
            self.sellerIgv.frame = CGRectMake(15, 109, 10, 11);
            [view addSubview:self.sellerIgv];
            
            self.sellerAddressLab.frame = CGRectMake(40, 106, SCREEN_W - 80, 36);
            [view addSubview:self.sellerAddressLab];
            
            self.addressViewIgv.frame = CGRectMake(0, 160, SCREEN_W, 2);
            [view addSubview:self.addressViewIgv];
        }
        
        _addressView = view;
    }
    return _addressView;
}

- (UIImageView *)peopleIgv {
    if (!_peopleIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"联系人 copy" adS]];
        _peopleIgv = imageView;
    }
    return _peopleIgv;
}

- (UILabel *)peopelNameLab {
    if (!_peopelNameLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        _peopelNameLab = label;
    }
    return _peopelNameLab;
}

- (UILabel *)peopelPhoneLab {
    if (!_peopelPhoneLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        _peopelPhoneLab = label;
    }
    return _peopelPhoneLab;
}

- (UIImageView *)buyersIgv {
    if (!_buyersIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _buyersIgv = imageView;
    }
    return _buyersIgv;
}

- (UILabel *)buyersAddressLab {
    if (!_buyersAddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _buyersAddressLab = label;
    }
    return _buyersAddressLab;
}

- (UIImageView *)sellerIgv {
    if (!_sellerIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _sellerIgv = imageView;
    }
    return _sellerIgv;
}

- (UILabel *)sellerAddressLab {
    if (!_sellerAddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _sellerAddressLab = label;
    }
    return _sellerAddressLab;
}

- (UIImageView *)addressViewIgv {
    if (!_addressViewIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"colorLine" adS]];
        _addressViewIgv = imageView;
    }
    return _addressViewIgv;
}

- (UIView *)orderView {
    if (!_orderView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        self.orderIgv.frame = CGRectMake(15, 20, 50, 50);
        [view addSubview:self.orderIgv];
        
        self.containerTypeLab.frame = CGRectMake(90, 20, SCREEN_W - 105, 18);
        [view addSubview:self.containerTypeLab];
        
        self.orderTypeLab.frame = CGRectMake(90, 50, SCREEN_W - 105, 15);
        [view addSubview:self.orderTypeLab];
        
        self.containerNumLab.frame = CGRectMake(100, 50, SCREEN_W - 150, 15);
        [view addSubview:self.containerNumLab];
        
        UIView * line_01 = [UIView new];
        line_01.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line_01.frame = CGRectMake(0, 90.5, SCREEN_W, 0.5);
        [view addSubview:line_01];
        
        if(self.model.orderTypeEnum == buyContainer){
            UIView * vi = [UIView new];
            vi.frame = CGRectMake(0, 91, SCREEN_W, 113);
            vi.backgroundColor = APP_COLOR_WHITEBG;
            [view addSubview:vi];
            
            UILabel * lab = [UILabel new];
            lab.frame = CGRectMake(15, 16, 100, 15);
            lab.font = [UIFont systemFontOfSize:14.f];
            lab.text = @"箱子金额:";
            lab.textColor = APP_COLOR_GRAY2;
            [vi addSubview:lab];
            
            self.containerPriceLab.frame = CGRectMake(100, 16, SCREEN_W - 115, 15);
            [vi addSubview:self.containerPriceLab];
            
            
            UIView * line_02 = [UIView new];
            line_02.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            line_02.frame = CGRectMake(15, 45, SCREEN_W - 15, 0.5);
            [vi addSubview:line_02];
            
            self.allPriceLab.frame = CGRectMake(15, 59, SCREEN_W - 30, 16);
            [vi addSubview:self.allPriceLab];
            
            self.placeTheOrderLab.frame = CGRectMake(15, 83, SCREEN_W - 30, 16);
            [vi addSubview:self.placeTheOrderLab];
            
            UIView * line_03 = [UIView new];
            line_03.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            line_03.frame = CGRectMake(0, 112, SCREEN_W, 0.5);
            [vi addSubview:line_03];
        } else {
            UIView * vi = [UIView new];
            vi.frame = CGRectMake(0, 91, SCREEN_W, 169);
            vi.backgroundColor = APP_COLOR_WHITEBG;
            [view addSubview:vi];
            
            UILabel * rentlab = [UILabel new];
            rentlab.frame = CGRectMake(15, 16, 100, 15);
            rentlab.font = [UIFont systemFontOfSize:14.f];
            rentlab.text = @"租金:";
            rentlab.textColor = APP_COLOR_GRAY2;
            [vi addSubview:rentlab];
            
            self.rentPriceLab.frame = CGRectMake(100, 16, SCREEN_W - 115, 15);
            [vi addSubview:self.rentPriceLab];
            
            UILabel * mortgage = [UILabel new];
            mortgage.frame = CGRectMake(15, 43, 100, 15);
            mortgage.font = [UIFont systemFontOfSize:14.f];
            mortgage.text = @"押金:";
            mortgage.textColor = APP_COLOR_GRAY2;
            [vi addSubview:mortgage];
            
            self.mortgageLab.frame = CGRectMake(100, 43, SCREEN_W - 115, 15);
            [vi addSubview:self.mortgageLab];
            
            UILabel * giveBackPrice = [UILabel new];
            giveBackPrice.frame = CGRectMake(15, 69, 100, 15);
            giveBackPrice.font = [UIFont systemFontOfSize:14.f];
            giveBackPrice.text = @"异地还箱费:";
            giveBackPrice.textColor = APP_COLOR_GRAY2;
            [vi addSubview:giveBackPrice];
            
            self.giveBackPriceLab.frame = CGRectMake(100, 69, SCREEN_W - 115, 15);
            [vi addSubview:self.giveBackPriceLab];
            
            UIView * line_02 = [UIView new];
            line_02.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            line_02.frame = CGRectMake(15, 100, SCREEN_W - 15, 0.5);
            [vi addSubview:line_02];
            
            self.allPriceLab.frame = CGRectMake(15, 116, SCREEN_W - 30, 16);
            [vi addSubview:self.allPriceLab];
            
            self.placeTheOrderLab.frame = CGRectMake(15, 138, SCREEN_W - 30, 16);
            [vi addSubview:self.placeTheOrderLab];
            
            UIView * line_03 = [UIView new];
            line_03.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            line_03.frame = CGRectMake(0, 168, SCREEN_W, 0.5);
            [vi addSubview:line_03];
        }
        _orderView = view;
    }
    return _orderView;
}

- (UIImageView *)orderIgv {
    if (!_orderIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        _orderIgv = imageView;
    }
    return _orderIgv;
}

- (UILabel *)containerTypeLab {
    if (!_containerTypeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        
        _containerTypeLab = label;
    }
    return _containerTypeLab;
}
- (UILabel *)orderTypeLab {
    if (!_orderTypeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _orderTypeLab = label;
    }
    return _orderTypeLab;
}

- (UILabel *)containerNumLab {
    if (!_containerNumLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _containerNumLab = label;
    }
    return _containerNumLab;
}

- (UILabel *)containerPriceLab {
    if (!_containerPriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _containerPriceLab = label;
    }
    return _containerPriceLab;
}

- (UILabel *)rentPriceLab {
    if (!_rentPriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _rentPriceLab = label;
    }
    return _rentPriceLab;
}

- (UILabel *)mortgageLab {
    if (!_mortgageLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _mortgageLab = label;
    }
    return _mortgageLab;
}

- (UILabel *)giveBackPriceLab {
    if (!_giveBackPriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _giveBackPriceLab = label;
    }
    return _giveBackPriceLab;
}

- (UILabel *)allPriceLab {
    if (!_allPriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentRight;
        _allPriceLab = label;
    }
    return _allPriceLab;
}

- (UILabel *)placeTheOrderLab {
    if (!_placeTheOrderLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _placeTheOrderLab = label;
    }
    return _placeTheOrderLab;
}

- (UIView *)detailsVi {
    if (!_detailsVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_WHITE;
        
        self.containerConditionLab.frame = CGRectMake(15, 20, SCREEN_W - 30, 15);
        [vi addSubview:self.containerConditionLab];
        
        if (self.model.orderTypeEnum == buyContainer) {
            self.sellerLab.frame = CGRectMake(15, 45, SCREEN_W - 30, 15);
            [vi addSubview:self.sellerLab];
            
        }
        else {
            self.rentTimeLab.frame = CGRectMake(15, 45, SCREEN_W - 30, 15);
            [vi addSubview:self.rentTimeLab];
            
            self.sellerLab.frame = CGRectMake(15, 70, SCREEN_W - 30, 15);
            [vi addSubview:self.sellerLab];
        }
        
        self.phoneLab.frame = CGRectMake(15, self.sellerLab.bottom + 10, SCREEN_W - 30, 15);
        [vi addSubview:self.phoneLab];
        
        
        self.goodsCodeLab.frame = CGRectMake(15, self.phoneLab.bottom + 10, SCREEN_W - 30, 15);
        [vi addSubview:self.goodsCodeLab];
        
        _detailsVi = vi;
    }
    return _detailsVi;
}

- (UILabel *)containerConditionLab {
    if (!_containerConditionLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _containerConditionLab = lab;
    }
    return _containerConditionLab;
}

- (UILabel *)rentTimeLab {
    if (!_rentTimeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _rentTimeLab = lab;
    }
    return _rentTimeLab;
}

- (UILabel *)sellerLab {
    if (!_sellerLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _sellerLab = lab;
    }
    return _sellerLab;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _phoneLab = lab;
    }
    return _phoneLab;
}

- (UILabel *)goodsCodeLab {
    if (!_goodsCodeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _goodsCodeLab = lab;
    }
    return _goodsCodeLab;
}

- (UIButton *)packUpBtn {
    if (!_packUpBtn) {
        UIButton * btn = [UIButton new];
        btn.backgroundColor = APP_COLOR_WHITE;
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btn setTitle:@"更多信息" forState:UIControlStateNormal];//Clip 4
        [btn setImage:[UIImage imageNamed:[@"down" adS]] forState:UIControlStateNormal];
        
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line.frame = CGRectMake(0, 0, SCREEN_W, 0.5);
        [btn addSubview:line];
        _packUpBtn = btn;
    }
    return _packUpBtn;
}

- (UIView *)lineVi {
    if (!_lineVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        
        _lineVi = vi;
    }
    return _lineVi;
}

- (UIView *)orderProgressView {
    if (!_orderProgressView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        _orderProgressView = view;
    }
    return _orderProgressView;
}

- (UIView *)lastView {
    if (!_lastView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        if ([self.model.orderState isEqualToString:@"已取消"] || [self.model.orderState isEqualToString:@"已完成"]) {
            
            self.priceLab.frame = CGRectMake(27, 18, SCREEN_W - 54, 16);
            [view addSubview:self.priceLab];
            
            self.deleteBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.deleteBtn];
        }else if ([self.model.orderState isEqualToString:@"待买家收箱"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            [view addSubview:self.priceLab];
            
            self.closedBoxBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.closedBoxBtn];
        }else if ([self.model.orderState isEqualToString:@"待审核"] || [self.model.orderState isEqualToString:@"待箱主发箱"] || [self.model.orderState isEqualToString:@"待箱主收箱"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            [view addSubview:self.priceLab];
            
        }else if ([self.model.orderState isEqualToString:@"待支付"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            self.priceLab.textAlignment = NSTextAlignmentLeft;
            [view addSubview:self.priceLab];
            
            self.cancelBtn.frame = CGRectMake(SCREEN_W - 180, 10, 78, 30);
            [view addSubview:self.cancelBtn];
            
            self.goPaymentBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.goPaymentBtn];
            

        }
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line.frame = CGRectMake(0, 0, SCREEN_W, 0.5);
        [view addSubview:line];
        _lastView = view;
    }
    return _lastView;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        _priceLab = label;
    }
    return _priceLab;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消订单" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [APP_COLOR_GRAY2 CGColor];
        
        _cancelBtn = button;
    }
    return _cancelBtn;
}

- (UIButton *)goPaymentBtn {
    if (!_goPaymentBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"去付款" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _goPaymentBtn = button;
    }
    return _goPaymentBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"删除订单" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [APP_COLOR_GRAY2 CGColor];
        button.hidden = YES;
        _deleteBtn = button;
    }
    return _deleteBtn;
}

- (UIButton *)closedBoxBtn {
    if (!_closedBoxBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确认收箱" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _closedBoxBtn = button;
    }
    return _closedBoxBtn;
}

- (void)makeButton:(UIButton *)btn {
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.frame.size.width * 2, 0.0,0.0)];//文字距离
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width * 2 - btn.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"取消订单"])
    {
        if(buttonIndex == 1)
        {
            WS(ws);
            [[OrderViewModel new]emptyContainerOrderOperateWithOrderId:self.model.ID WithType:CANCEL callback:^(NSString *str) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                                   object:@{
                                                                            @"orderType":@"全部",
                                                                            @"viewTitle":@"空箱之家"
                                                                            }];
                NSMutableArray * array = [[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
                [array removeObjectAtIndex:array.count-1];
                OrderDetailsContainerVC *vc = [OrderDetailsContainerVC new];
                vc.model = ws.model;
                ws.model.orderState = @"已取消";
                [array addObject:vc];
                [ws.navigationController pushViewController:vc animated:NO];
                [((MLNavigationController *)(ws.navigationController)).screenShotsList removeLastObject];
                [ws.navigationController setViewControllers:array animated:NO];

            }];
        }
    } else if([alertView.title isEqualToString:@"删除订单"]) {
        if(buttonIndex == 1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                               object:@{
                                                                        @"orderType":@"全部",
                                                                        @"viewTitle":@"空箱之家"
                                                                        }];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
