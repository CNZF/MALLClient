//
//  OrderDetailsCarVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/6.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailsCarVC.h"
#import "PaymentPageVC.h"
#import "OrderAlertView.h"
#import "MLNavigationController.h"

@interface OrderDetailsCarVC ()

@property (nonatomic, strong) UIScrollView * bgView;

@property (nonatomic, strong) UIView       * headTitleView;//头部蓝色视图
@property (nonatomic, strong) UILabel      * ordetTypeLab;
@property (nonatomic, strong) UILabel      * orderIDLab;
@property (nonatomic, strong) UIButton     * toViewWarehouseIDBtn;//查看

@property (nonatomic, strong) UIView       * addressView;//收还箱视图
@property (nonatomic, strong) UIImageView  * peopleIgv;
@property (nonatomic, strong) UILabel      * peopelNameLab;
@property (nonatomic, strong) UILabel      * peopelPhoneLab;
@property (nonatomic, strong) UIImageView  * startIgv;//起运地
@property (nonatomic, strong) UILabel      * startAddressLab;
@property (nonatomic, strong) UIImageView  * endIgv;//地运抵
@property (nonatomic, strong) UILabel      * endAddressLab;
@property (nonatomic, strong) UIImageView  * addressViewIgv;//网点彩带

@property (nonatomic, strong) UIView       * orderView;//定单视图
@property (nonatomic, strong) UIImageView  * orderIgv;
@property (nonatomic, strong) UILabel      * typeLab;
@property (nonatomic, strong) UILabel      * linesLab;
@property (nonatomic, strong) UILabel      * goodsCodeLab;//商品编号
@property (nonatomic, strong) UILabel      * linePriceLab;//线路金额
@property (nonatomic, strong) UILabel      * allPriceLab;
@property (nonatomic, strong) UILabel      * placeTheOrderLab;

@property (nonatomic, strong) UIView       * detailsVi;//详情
@property (nonatomic, strong) UILabel      * goodsNameLab;//货品名字
@property (nonatomic, strong) UILabel      * capacityBuyDateLab;//运力购买日期
@property (nonatomic, strong) UILabel      * sellerLab;//卖家
@property (nonatomic, strong) UILabel      * sellerPhoneLab;//电话

@property (nonatomic, strong) UILabel      * carNumLab;//车牌号

@property (nonatomic, strong) UILabel      * shipNumLab;//班轮号
@property (nonatomic, strong) UILabel      * openStorehouseLab;//开仓时间
@property (nonatomic, strong) UILabel      * shipmentClosingDateLab;//截止载货时间
@property (nonatomic, strong) UILabel      * leavePortDateLab;//离港时间

@property (nonatomic, strong) UILabel      * trainsNumLab;//班列号
@property (nonatomic, strong) UILabel      * startingTimeLab;//发车时间
@property (nonatomic, strong) UILabel      * abortDateLab;//截止时间

@property (nonatomic, strong) UIButton     * packUpBtn;//收起展开Btn
@property (nonatomic, strong) UIView       * lineVi;
@property (nonatomic, strong) UIView       * orderProgressView;//订单进展视图

@property (nonatomic, strong) UIView       * lastView;//根部视图
@property (nonatomic, strong) UILabel      * priceLab;
@property (nonatomic, strong) UIButton     * cancelBtn;
@property (nonatomic, strong) UIButton     * goPaymentBtn;
@property (nonatomic, strong) UIButton     * completeBtn;//装载收箱
@property (nonatomic, strong) UIButton     * deleteBtn;//删除
@property (nonatomic, strong) UIButton     * callSellerBtn;//联系卖家
@end

@implementation OrderDetailsCarVC

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
    
    if(self.model.transportTypeEnum == landTransportation){
        self.addressView.frame = CGRectMake(0, self.headTitleView.bottom, SCREEN_W, 162);
        self.orderView.frame = CGRectMake(0, self.addressView.bottom + 12, SCREEN_W, 158);
        self.detailsVi.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 156);
    }else {
        self.addressView.frame = CGRectMake(0, self.headTitleView.bottom, SCREEN_W, 50);
        self.orderView.frame = CGRectMake(0, self.addressView.bottom + 12, SCREEN_W, 204);
        if (self.model.transportTypeEnum == trainsTransportation) {
            self.detailsVi.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 206);
        }else if (self.model.transportTypeEnum == shipTransportation) {
            self.detailsVi.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 231);
        }
    }
    [self.bgView addSubview:self.addressView];
    [self.bgView addSubview:self.orderView];
    
    
    self.packUpBtn.frame = CGRectMake(0, self.orderView.bottom - 1, SCREEN_W, 44);
    [self makeButton:self.packUpBtn];
    [self.bgView addSubview:self.packUpBtn];
    
    self.lineVi.frame = CGRectMake(0, self.packUpBtn.bottom, SCREEN_W, 200);
    [self.bgView addSubview:self.lineVi];
    
    self.lastView.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.lastView];
    
    [self bindModel];
}

-(void)bindModel {
    
    WS(ws);
    [[OrderViewModel new] getEmptyCarOrderDetailsWithOrderId:self.model.ID WithType:self.model.transportTypeEnum callback:^(OrderModelForEmptyCar *model) {
        if (![model.orderState isEqualToString:ws.model.orderState]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                               object:@{
                                                                        @"orderType":@"全部",
                                                                        @"viewTitle":@"空车之爱"
                                                                        }];
        }
        model.transportType = ws.model.transportType;
        model.transportTypeEnum = ws.model.transportTypeEnum;
        model.ID = ws.model.ID;
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
                                 ws.packUpBtn.frame = CGRectMake(0, ws.detailsVi.bottom - 1, SCREEN_W, 44);
                                 ws.lineVi.frame = CGRectMake(0, ws.packUpBtn.bottom, SCREEN_W, 200);
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
                                 ws.packUpBtn.frame = CGRectMake(0, ws.orderView.bottom  - 1, SCREEN_W, 44);
                                 ws.lineVi.frame = CGRectMake(0, ws.packUpBtn.bottom, SCREEN_W, 200);
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
    
    [[self.completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"装载完成" message:@"确认装载已完成？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.delegate = ws;
        [alert show];
    }];
    
    [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除订单" message:@"是否删除订单？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.delegate = ws;
        [alert show];
    }];
    
    [[self.goPaymentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws.navigationController pushViewController:[PaymentPageVC new] animated:YES];
    }];
    
    [[self.callSellerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",ws.model.phone]]];
    }];
    
    [[self.toViewWarehouseIDBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableArray * mArray;
        switch (ws.model.transportTypeEnum) {
            case landTransportation:
                if (ws.model.driverName && ws.model.driverPhone) {
                    [[[OrderAlertView alloc]initWithTitle:@"匹配司机" entryArray:@[[NSString stringWithFormat:@"司机姓名:%@",ws.model.driverName],[NSString stringWithFormat:@"司机电话:%@",ws.model.driverPhone]] annotation:@"" cancelButtonTitle:nil otherButtonTitles:@"确 定"] show];
                }else {
                    [[[OrderAlertView alloc]initWithTitle:@"匹配司机" entryArray:@[@"无司机信息"] annotation:@"" cancelButtonTitle:nil otherButtonTitles:@"确 定"] show];
                }
                break;
            case trainsTransportation:
                mArray = [NSMutableArray new];
                for (id str in ws.model.matchCodeList) {
                    [mArray addObject:[NSString stringWithFormat:@"车号:%@",str]];
                }
                [[[OrderAlertView alloc]initWithTitle:@"匹配车号" entryArray:mArray annotation:@"" cancelButtonTitle:nil otherButtonTitles:@"确 定"] show];
                break;
            case shipTransportation:
                mArray = [NSMutableArray new];
                for (id str in ws.model.matchCodeList) {
                    [mArray addObject:[NSString stringWithFormat:@"仓号:%@",str]];
                }
                [[[OrderAlertView alloc]initWithTitle:@"匹配仓号" entryArray:mArray annotation:@"" cancelButtonTitle:nil otherButtonTitles:@"确 定"] show];
                break;
        }
    }];
}

//加载订单对象
-(void)updateUIWithModel:(OrderModelForEmptyCar *)model {
    
    self.ordetTypeLab.text = model.orderState;
    self.orderIDLab.text = [NSString stringWithFormat:@"订单号: %@",model.orderID];
    
    self.peopelNameLab.text = model.peopelName;
    self.peopelPhoneLab.text = model.peopelPhone;
    
    self.startAddressLab.text = [NSString stringWithFormat:@"起运地: %@",model.startAddress];
    if ([self.startAddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.startAddressLab.font}].width <= self.startAddressLab.width) {
        self.startAddressLab.frame = CGRectMake(self.startAddressLab.left, self.startAddressLab.top, self.startAddressLab.width, 18);
    }
    else
    {
        self.startAddressLab.frame = CGRectMake(self.startAddressLab.left, self.startAddressLab.top, self.startAddressLab.width, 36);
    }
    
    self.endAddressLab.text = [NSString stringWithFormat:@"抵运地: %@",model.endAddress];
    if ([self.endAddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.endAddressLab.font}].width <= self.endAddressLab.width) {
        self.endAddressLab.frame = CGRectMake(self.endAddressLab.left, self.endAddressLab.top, self.endAddressLab.width, 18);
    }
    else
    {
        self.endAddressLab.frame = CGRectMake(self.endAddressLab.left, self.endAddressLab.top, self.endAddressLab.width, 36);
    }
    
    [self.orderIgv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEIMGURL,model.imgUrl]]  placeholderImage:[UIImage imageNamed:@"001.png"]];

    self.typeLab.text = model.transportType;
    self.linesLab.text = model.lineName;
    if (self.linesLab.width < [self.linesLab.text sizeWithAttributes:@{NSFontAttributeName:self.linesLab.font}].width) {
        self.linesLab.frame = CGRectMake(self.typeLab.right + 7, 20, SCREEN_W - 130, 30);
        self.goodsCodeLab.frame = CGRectMake(90, 58, SCREEN_W - 105, 15);
    } else {
        self.linesLab.frame = CGRectMake(self.typeLab.right + 7, 20, SCREEN_W - 130, 18);
        self.goodsCodeLab.frame = CGRectMake(90, 50, SCREEN_W - 105, 15);
    }
    
    
    self.goodsCodeLab.text = [NSString stringWithFormat:@"商品编号:%@",model.goodsCode];
    if([model.linePrice floatValue] > 0){
        NSMutableAttributedString * linePriceLabText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@x%@TEU",[model.linePrice NumberStringToMoneyString],model.buyNum]];
        [linePriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,linePriceLabText.length)];
        [linePriceLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[linePriceLabText.string rangeOfString:[model.linePrice NumberStringToMoneyStringGetLastThree]]];
        self.linePriceLab.attributedText = linePriceLabText;

    }else {
        self.linePriceLab.text = @"电询";
    }
    NSMutableAttributedString * allPrice;
    if ([model.price intValue]) {
        allPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计: ¥%@",[model.price NumberStringToMoneyString]]];
        [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLACK_TEXT range:NSMakeRange(0,3)];
        [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(3,allPrice.length - 3)];
        
        [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,3)];
        [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(3,allPrice.length - 3)];
        [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[allPrice.string rangeOfString:[model.price NumberStringToMoneyStringGetLastThree]]];

    } else {
        allPrice = [[NSMutableAttributedString alloc] initWithString:@"共计: 电询"];
        [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLACK_TEXT range:NSMakeRange(0,3)];
        [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLUE_BTN range:NSMakeRange(3,allPrice.length - 3)];
        
        [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,3)];
        [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(3,allPrice.length - 3)];
    }
    self.allPriceLab.attributedText = allPrice;
    NSDateFormatter * outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.placeTheOrderLab.text = [NSString stringWithFormat:@"下单时间: %@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.create_time doubleValue] / 1000]]];
    self.goodsNameLab.text = [NSString stringWithFormat:@"货品名称:%@",model.goodsName];
    self.capacityBuyDateLab.text = [NSString stringWithFormat:@"运力购买日期:%@",[self stDateToString:model.capacityBuyDate]];
    self.sellerLab.text = [NSString stringWithFormat:@"卖家:%@",model.seller];
    if(model.phone) {
        self.sellerPhoneLab.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    }else {
        self.sellerPhoneLab.text = [NSString stringWithFormat:@"电话:"];
    }
    self.carNumLab.text = [NSString stringWithFormat:@"车牌号:%@",model.carNum];
    self.shipNumLab.text = [NSString stringWithFormat:@"班轮:%@",model.shipNum];
    self.openStorehouseLab.text = [NSString stringWithFormat:@"开仓时间:%@",[self stDateToString:model.openStorehouse]];
    self.shipmentClosingDateLab.text = [NSString stringWithFormat:@"截载时间:%@",[self stDateToString:model.shipmentClosingDate]];
    self.leavePortDateLab.text = [NSString stringWithFormat:@"离港时间:%@",[self stDateToString:model.leavePortDate]];
    self.trainsNumLab.text = [NSString stringWithFormat:@"班列:%@",model.trainsNum];
    self.startingTimeLab.text = [NSString stringWithFormat:@"发车日期:%@",[self stDateToString:model.startingTime]];
    self.abortDateLab.text = [NSString stringWithFormat:@"接货截止日期:%@",[self stDateToString:model.abortDate]];
    
    
    [self updateOrderProgressViewWithArray:model.orderProgress WithBefourView:self.packUpBtn];
    NSMutableAttributedString * price;
    if([model.price intValue]){
        price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[model.price NumberStringToMoneyString]]];
        [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(0,price.length)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 3,3)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 3)];
    } else {
        price = [[NSMutableAttributedString alloc] initWithString:@"电询"];
        [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLUE_BTN range:NSMakeRange(0,price.length)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length)];
    }
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
        
        if ([self.model.orderState isEqualToString:@"已完成"] || [self.model.orderState isEqualToString:@"待装载"]){
            
            self.toViewWarehouseIDBtn.frame = CGRectMake(SCREEN_W - 115, 25, 75, 30);
            [view addSubview:self.toViewWarehouseIDBtn];
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

-(UIButton *)toViewWarehouseIDBtn {
    if (!_toViewWarehouseIDBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = APP_COLOR_WHITE.CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        if(self.model.transportTypeEnum == landTransportation) {
            [btn setTitle:@"查看司机" forState:UIControlStateNormal];
        }else if(self.model.transportTypeEnum == trainsTransportation){
            [btn setTitle:@"查看车号" forState:UIControlStateNormal];
        }
        else if(self.model.transportTypeEnum == shipTransportation){
            [btn setTitle:@"查看仓号" forState:UIControlStateNormal];
        }
        _toViewWarehouseIDBtn = btn;
    }
    return _toViewWarehouseIDBtn;
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
        
        
        if (self.model.transportTypeEnum == landTransportation) {
            self.startIgv.frame = CGRectMake(15, 53, 10, 11);
            [view addSubview:self.startIgv];
            
            self.startAddressLab.frame = CGRectMake(40, 50, SCREEN_W - 80, 36);
            [view addSubview:self.startAddressLab];

            self.endIgv.frame = CGRectMake(15, 109, 10, 11);
            [view addSubview:self.endIgv];
            
            self.endAddressLab.frame = CGRectMake(40, 106, SCREEN_W - 80, 36);
            [view addSubview:self.endAddressLab];
            
            self.addressViewIgv.frame = CGRectMake(0, 160, SCREEN_W, 2);
            [view addSubview:self.addressViewIgv];
        }else {
            self.addressViewIgv.frame = CGRectMake(0, 48, SCREEN_W, 2);
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

- (UIImageView *)startIgv {
    if (!_startIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _startIgv = imageView;
    }
    return _startIgv;
}

- (UILabel *)startAddressLab {
    if (!_startAddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _startAddressLab = label;
    }
    return _startAddressLab;
}

- (UIImageView *)endIgv {
    if (!_endIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _endIgv = imageView;
    }
    return _endIgv;
}

- (UILabel *)endAddressLab {
    if (!_endAddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _endAddressLab = label;
    }
    return _endAddressLab;
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
        
        self.typeLab.frame = CGRectMake(self.orderIgv.right + 20, 21,30, 18);
        [view addSubview:self.typeLab];
        
        self.linesLab.frame = CGRectMake(self.typeLab.right + 7, 20, SCREEN_W - 130, 18);
        [view addSubview:self.linesLab];
        
        self.goodsCodeLab.frame = CGRectMake(90, 50, SCREEN_W - 105, 15);
        [view addSubview:self.goodsCodeLab];
        
        UIView * line_01 = [UIView new];
        line_01.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line_01.frame = CGRectMake(0, 90, SCREEN_W, 0.5);
        [view addSubview:line_01];
        
        if(self.model.transportTypeEnum == landTransportation){
            UIView * vi = [UIView new];
            vi.frame = CGRectMake(0, 91, SCREEN_W, 66);
            vi.backgroundColor = APP_COLOR_WHITE_BG;
            [view addSubview:vi];
            
            self.allPriceLab.frame = CGRectMake(15, 12, SCREEN_W - 30, 16);
            [vi addSubview:self.allPriceLab];
            
            self.placeTheOrderLab.frame = CGRectMake(15, 36, SCREEN_W - 30, 16);
            [vi addSubview:self.placeTheOrderLab];
            
            UIView * line_02 = [UIView new];
            line_02.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
            line_02.frame = CGRectMake(0, 66, SCREEN_W, 0.5);
            [vi addSubview:line_02];
        } else {
                        
            UIView * vi = [UIView new];
            vi.frame = CGRectMake(0, 91, SCREEN_W, 113);
            vi.backgroundColor = APP_COLOR_WHITE_BG;
            [view addSubview:vi];
            
            UILabel * lab = [UILabel new];
            lab.frame = CGRectMake(15, 16, 100, 15);
            lab.font = [UIFont systemFontOfSize:14.f];
            lab.text = @"线路金额:";
            lab.textColor = APP_COLOR_GRAY2;
            [vi addSubview:lab];
            
            self.linePriceLab.frame = CGRectMake(100, 16, SCREEN_W - 115, 15);
            [vi addSubview:self.linePriceLab];
            
            
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

-(UILabel *)typeLab
{
    if (!_typeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:11.0f];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = APP_COLOR_RED1;
        lab.layer.borderWidth = 0.5;
        lab.layer.borderColor = APP_COLOR_RED1.CGColor;
        _typeLab = lab;
    }
    return _typeLab;
}

- (UILabel *)linesLab {
    if (!_linesLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.numberOfLines = 0;
        _linesLab = label;
    }
    return _linesLab;
}

- (UILabel *)goodsCodeLab {
    if (!_goodsCodeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _goodsCodeLab = label;
    }
    return _goodsCodeLab;
}


- (UILabel *)linePriceLab {
    if (!_linePriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _linePriceLab = label;
    }
    return _linePriceLab;
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

-(UIView *)detailsVi {
    if (!_detailsVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_WHITE;
        
        self.goodsNameLab.frame = CGRectMake(15, 20, SCREEN_W - 30, 15);
        [vi addSubview:self.goodsNameLab];
        
        if (self.model.transportTypeEnum == landTransportation) {
            self.carNumLab.frame = CGRectMake(15, self.goodsNameLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.carNumLab];
            
            self.capacityBuyDateLab.frame = CGRectMake(15, self.carNumLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.capacityBuyDateLab];
        } else if(self.model.transportTypeEnum == trainsTransportation){
            self.trainsNumLab.frame = CGRectMake(15, self.goodsNameLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.trainsNumLab];
            
            self.startingTimeLab.frame = CGRectMake(15, self.trainsNumLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.startingTimeLab];
            
            self.abortDateLab.frame = CGRectMake(15, self.startingTimeLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.abortDateLab];
            
            self.capacityBuyDateLab.frame = CGRectMake(15, self.abortDateLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.capacityBuyDateLab];
        }  else if(self.model.transportTypeEnum == shipTransportation){
            self.shipNumLab.frame = CGRectMake(15, self.goodsNameLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.shipNumLab];
            
            self.openStorehouseLab.frame = CGRectMake(15, self.shipNumLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.openStorehouseLab];
            
            self.shipmentClosingDateLab.frame = CGRectMake(15, self.openStorehouseLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.shipmentClosingDateLab];
            
            self.leavePortDateLab.frame = CGRectMake(15, self.shipmentClosingDateLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.leavePortDateLab];
            
            self.capacityBuyDateLab.frame = CGRectMake(15, self.leavePortDateLab.bottom + 10, SCREEN_W - 30, 15);
            [vi addSubview:self.capacityBuyDateLab];
        }
        
        
        self.sellerLab.frame = CGRectMake(15, self.capacityBuyDateLab.bottom + 10, SCREEN_W - 30, 15);
        [vi addSubview:self.sellerLab];
        
        self.sellerPhoneLab.frame = CGRectMake(15, self.sellerLab.bottom + 10, SCREEN_W - 30, 15);
        [vi addSubview:self.sellerPhoneLab];
        
        _detailsVi = vi;
    }
    return _detailsVi;
}

-(UILabel *)goodsNameLab {
    if (!_goodsNameLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _goodsNameLab = lab;
    }
    return _goodsNameLab;
}

-(UILabel *)capacityBuyDateLab {
    if (!_capacityBuyDateLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _capacityBuyDateLab = lab;
    }
    return _capacityBuyDateLab;
}

-(UILabel *)sellerLab {
    if (!_sellerLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _sellerLab = lab;
    }
    return _sellerLab;
}

-(UILabel *)sellerPhoneLab {
    if (!_sellerPhoneLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _sellerPhoneLab = lab;
    }
    return _sellerPhoneLab;
}

-(UILabel *)carNumLab {
    if (!_carNumLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _carNumLab = lab;
    }
    return _carNumLab;
}

-(UILabel *)shipNumLab {
    if (!_shipNumLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _shipNumLab = lab;
    }
    return _shipNumLab;
}

-(UILabel *)openStorehouseLab {
    if (!_openStorehouseLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _openStorehouseLab = lab;
    }
    return _openStorehouseLab;
}

-(UILabel *)shipmentClosingDateLab {
    if (!_shipmentClosingDateLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _shipmentClosingDateLab = lab;
    }
    return _shipmentClosingDateLab;
}


-(UILabel *)leavePortDateLab {
    if (!_leavePortDateLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _leavePortDateLab = lab;
    }
    return _leavePortDateLab;
}

-(UILabel *)trainsNumLab {
    if (!_trainsNumLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _trainsNumLab = lab;
    }
    return _trainsNumLab;
}

-(UILabel *)startingTimeLab {
    if (!_startingTimeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _startingTimeLab = lab;
    }
    return _startingTimeLab;
}
-(UILabel *)abortDateLab {
    if (!_abortDateLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY666;
        _abortDateLab = lab;
    }
    return _abortDateLab;
}

-(UIButton *)packUpBtn {
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

-(UIView *)lineVi {
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
        }else if ([self.model.orderState isEqualToString:@"待装载"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            [view addSubview:self.priceLab];
            
            self.completeBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.completeBtn];
        }else if ([self.model.orderState isEqualToString:@"待审核"] || [self.model.orderState isEqualToString:@"待调度"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            [view addSubview:self.priceLab];
            
        }else if ([self.model.orderState isEqualToString:@"待支付"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            self.priceLab.textAlignment = NSTextAlignmentLeft;
            [view addSubview:self.priceLab];
            
            self.cancelBtn.frame = CGRectMake(SCREEN_W - 180, 10, 78, 30);
            [view addSubview:self.cancelBtn];
            
            if ([self.model.price floatValue] > 0) {
                self.goPaymentBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
                [view addSubview:self.goPaymentBtn];
            }
            else {
                self.callSellerBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
                [view addSubview:self.callSellerBtn];
            }
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

- (UIButton *)callSellerBtn {
    if (!_callSellerBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"联系卖家" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _callSellerBtn = button;
    }
    return _callSellerBtn;
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

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"装载完成" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _completeBtn = button;
    }
    return _completeBtn;
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
            [[OrderViewModel new]emptyCarOrderOperateWithOrderId:self.model.ID WithType:CallOff WithTransportType:self.model.transportTypeEnum Withcallback:^(NSString *str) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                                   object:@{
                                                                            @"orderType":@"全部",
                                                                            @"viewTitle":@"空车之爱"
                                                                            }];
                NSMutableArray * array = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                [array removeObjectAtIndex:array.count-1];
                OrderDetailsCarVC *vc = [OrderDetailsCarVC new];
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
                                                                        @"viewTitle":@"空车之爱"
                                                                        }];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if([alertView.title isEqualToString:@"装载完成"]) {
        if(buttonIndex == 1)
        {
            WS(ws);
            [[OrderViewModel new]emptyCarOrderOperateWithOrderId:self.model.ID WithType:Accomplish WithTransportType:self.model.transportTypeEnum Withcallback:^(NSString *str) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                                   object:@{
                                                                            @"orderType":@"全部",
                                                                            @"viewTitle":@"空车之爱"
                                                                            }];
                NSMutableArray * array = [[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
                [array removeObjectAtIndex:array.count-1];
                OrderDetailsCarVC *vc = [OrderDetailsCarVC new];
                vc.model = ws.model;
                ws.model.orderState = @"已完成";
                [array addObject:vc];
                [ws.navigationController pushViewController:vc animated:NO];
                [((MLNavigationController *)(ws.navigationController)).screenShotsList removeLastObject];
                [ws.navigationController setViewControllers:array animated:NO];

            }];

        }
    }
    
}


@end
