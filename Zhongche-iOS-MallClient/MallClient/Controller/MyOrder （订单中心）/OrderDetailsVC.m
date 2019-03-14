//
//  OrderDetailsVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/21.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "PaymentPageVC.h"
#import "OrderCancellationVC.h"
#import "PaymentBillVC.h"

@interface OrderDetailsVC ()<UIAlertViewDelegate>

@property (nonatomic, strong)UIScrollView * bgView;

@property (nonatomic, strong)UIView * headTitleView;//头部蓝色视图
@property (nonatomic, strong)UILabel * ordetTypeLab;
@property (nonatomic, strong)UILabel * orderIDLab;
@property (nonatomic, strong)UIImageView * qrCodeIgv;
@property (nonatomic, strong)UIView * bigQrCodeIgv;

@property (nonatomic, strong)UIView * addressView;//地址视图
@property (nonatomic, strong)UILabel * startLab;//起始地信息
@property (nonatomic, strong)UILabel * startpNameLab;
@property (nonatomic, strong)UILabel * startpPhoneLab;
@property (nonatomic, strong)UIImageView * startIgv;
@property (nonatomic, strong)UILabel * startaddressLab;
@property (nonatomic, strong)UILabel * endLab;//抵达地信息
@property (nonatomic, strong)UILabel * endpNameLab;
@property (nonatomic, strong)UILabel * endpPhoneLab;
@property (nonatomic, strong)UIImageView * endIgv;
@property (nonatomic, strong)UILabel * endaddressLab;
@property (nonatomic, strong)UIImageView * lastRibbonIgv;//彩带

@property (nonatomic, strong)UIView * branchesView;//运输网点视图
@property (nonatomic, strong)UIImageView * branchesStartIgv;//起运地
@property (nonatomic, strong)UILabel * branchesStartaddressLab;
@property (nonatomic, strong)UIImageView * branchesEndIgv;//抵运地
@property (nonatomic, strong)UILabel * branchesEndaddressLab;
@property (nonatomic, strong)UIImageView * branchesLastRibbonIgv;//网点彩带

@property (nonatomic, strong)UIView * timeView;//时间视图
@property (nonatomic, strong)UILabel * startTimeLab;
@property (nonatomic, strong)UILabel * endTimeLab;

@property (nonatomic, strong)UIView * orderView;//运单视图
@property (nonatomic, strong)UIImageView * orderIgv;
@property (nonatomic, strong)UILabel * capacityTypeLab;
@property (nonatomic, strong)UILabel * goodsNameLab;
@property (nonatomic, strong)UILabel * goodsTypeLab;
@property (nonatomic, strong)UILabel * serviceTypeLab;
@property (nonatomic, strong)UILabel * autonomousBoxNumLab;
@property (nonatomic, strong)UILabel * boxNumLab;
@property (nonatomic, strong)UILabel * noteLab;
@property (nonatomic, strong)UILabel * doorToDoorPriceLab;
@property (nonatomic, strong)UILabel * pointToPointPriceLab;
@property (nonatomic, strong)UILabel * insurancePriceLab;
@property (nonatomic, strong)UILabel * allPriceLab;
@property (nonatomic, strong)UILabel * placeTheOrderLab;

@property (nonatomic, strong)UIView * invoiceView_haveNot;//发票视图
@property (nonatomic, strong)UIView * invoiceView_have;//发票视图
@property (nonatomic, strong)UILabel * invoiceLookUpLab;
@property (nonatomic, strong)UILabel * invoiceTypeLab;
@property (nonatomic, strong)UILabel * projectLab;
@property (nonatomic, strong)UILabel * getInvoicPNameLab;
@property (nonatomic, strong)UILabel * getInvoicPPhoneLab;
@property (nonatomic, strong)UILabel * getInvoicAddressLab;
@property (nonatomic, strong)UILabel * noInvoiceLab;

@property (nonatomic, strong)UIView * completeCheckBillView;//账单部分(已完成)
@property (nonatomic, strong)UIView * goodsCheckBillView;//账单部分(待收货,待发货)
@property (nonatomic, strong)UIView * needPaymentCheckBillView;//账单部分(待付款)
@property (nonatomic, strong)UIButton * checkBillBtn;
@property (nonatomic, strong)UILabel * needPaymentLab;//待付款
@property (nonatomic, strong)UILabel * needConfirmLab;//待确认
@property (nonatomic, strong)UILabel * paymentHasBeenLab;//已付款

@property (nonatomic, strong)UIView * orderProgressView;//订单进展视图

@property (nonatomic, strong)UIView * lastView;//根部视图
@property (nonatomic, strong)UILabel * priceLab;
@property (nonatomic, strong)UIButton * cancelBtn;
@property (nonatomic, strong)UIButton * goPaymentBtn;

@end

@implementation OrderDetailsVC


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage getImageWithColor:APP_COLOR_GRAY_SEARCH_BG andSize:CGSizeMake(1, 1)]];
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
    
    self.addressView.frame = CGRectMake(0, self.headTitleView.bottom, SCREEN_W, 212);
    [self.bgView addSubview:self.addressView];
    
    self.branchesView.frame = CGRectMake(0, self.addressView.bottom + 12, SCREEN_W, 162);
    [self.bgView addSubview:self.branchesView];
    
    self.timeView.frame = CGRectMake(0, self.branchesView.bottom + 12, SCREEN_W, 75);
    [self.bgView addSubview:self.timeView];
    
    self.orderView.frame = CGRectMake(0, self.timeView.bottom + 12, SCREEN_W, 397);
    [self.bgView addSubview:self.orderView];
    
    self.lastView.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.lastView];
}

-(void)bindModel {
    WS(ws);
    [[OrderViewModel new] getSaleOfCapacityOrderDetailsWithOrderId:self.model.ID callback:^(OrderModelForCapacity *model) {
        model.ordetType = ws.model.ordetType;
        model.capacityType = ws.model.capacityType;
        model.boxNum = ws.model.boxNum;
        ws.model = model;
        [self updateUIWithModel:model];
    }];
}

-(void)bindAction {
    WS(ws);
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if ([ws.model.ordetType isEqualToString:@"待付款"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"取消订单请联系客服" delegate:nil cancelButtonTitle:@"再想想" otherButtonTitles:@"联系客服", nil];
            alert.delegate = ws;
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"是否取消此订单？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.delegate = ws;
            [alert show];
        }
        
    }];
    
    [[self.goPaymentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.navigationController pushViewController:[PaymentPageVC new] animated:YES];
    }];
    
    
    [[self.checkBillBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        PaymentBillVC * vc = [PaymentBillVC new];
        vc.paymentFlowModelArray = ws.model.paymentFlow;
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

-(void)updateUIWithModel:(OrderModelForCapacity *)model {
    
    self.ordetTypeLab.text = model.ordetType;
    self.orderIDLab.text = [NSString stringWithFormat:@"订单号: %@",model.orderID];
    self.qrCodeIgv.image = [UIImage getQrCodeImageWithString:model.orderID andSize:CGSizeMake(100, 100)];
    self.startpNameLab.text = model.startpName;
    self.startpPhoneLab.text = model.startpPhone;
    self.startaddressLab.text = [NSString stringWithFormat:@"上门取货地址: %@",model.startaddress];
    self.endpNameLab.text = model.endpName;
    self.endpPhoneLab.text = model.endpPhone;
    self.endaddressLab.text = [NSString stringWithFormat:@"送货上门地址: %@",model.endaddress];
    if ([self.startaddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.startaddressLab.font}].width <= self.startaddressLab.width) {
        self.startaddressLab.frame = CGRectMake(self.startaddressLab.left, self.startaddressLab.top, self.startaddressLab.width, 18);
    }
    else
    {
        self.startaddressLab.frame = CGRectMake(self.startaddressLab.left, self.startaddressLab.top, self.startaddressLab.width, 36);
    }
    if ([self.endaddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.endaddressLab.font}].width <= self.endaddressLab.width) {
        self.endaddressLab.frame = CGRectMake(self.endaddressLab.left, self.endaddressLab.top, self.endaddressLab.width, 18);
    }
    else
    {
        self.endaddressLab.frame = CGRectMake(self.endaddressLab.left, self.endaddressLab.top, self.endaddressLab.width, 36);
    }
    
    
    self.branchesStartaddressLab.text = [NSString stringWithFormat:@"起运地: %@",model.startEntrepotNameStr];
    if ([self.branchesStartaddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.branchesStartaddressLab.font}].width <= self.branchesStartaddressLab.width) {
        self.branchesStartaddressLab.frame = CGRectMake(self.branchesStartaddressLab.left, self.branchesStartaddressLab.top, self.branchesStartaddressLab.width, 18);
    }
    else
    {
        self.branchesStartaddressLab.frame = CGRectMake(self.branchesStartaddressLab.left, self.branchesStartaddressLab.top, self.branchesStartaddressLab.width, 36);
    }
    self.branchesEndaddressLab.text = [NSString stringWithFormat:@"抵运地: %@",model.endEntrepotNameStr];
    if ([self.branchesEndaddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.branchesEndaddressLab.font}].width <= self.branchesStartaddressLab.width) {
        self.branchesEndaddressLab.frame = CGRectMake(self.branchesEndaddressLab.left, self.branchesEndaddressLab.top, self.branchesEndaddressLab.width, 18);
    }
    else
    {
        self.branchesEndaddressLab.frame = CGRectMake(self.branchesEndaddressLab.left, self.branchesEndaddressLab.top, self.branchesEndaddressLab.width, 36);
    }
    
    NSDateFormatter * outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableAttributedString * startTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"发货日期: %@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.startTime doubleValue] / 1000]]]];
    [startTime addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT_1 range:NSMakeRange(0,5)];
    [startTime addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLACK_TEXT range:NSMakeRange(5,startTime.length - 5)];
    [startTime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,startTime.length)];
    self.startTimeLab.attributedText = startTime;
    NSMutableAttributedString * endTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预计到达日期: %@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.endTime doubleValue] / 1000]]]];
    [endTime addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT_1 range:NSMakeRange(0,7)];
    [endTime addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLACK_TEXT range:NSMakeRange(7,endTime.length - 7)];
    [endTime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,endTime.length)];
    self.endTimeLab.attributedText = endTime;
    
    [self.orderIgv sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]  placeholderImage:[UIImage imageNamed:@"001.png"]];
    self.capacityTypeLab.text = model.capacityType;
    self.goodsTypeLab.text = [NSString stringWithFormat:@"货品类型: %@",model.capacityType];
    self.goodsNameLab.text = [NSString stringWithFormat:@"货品名称: %@",model.goodsName];
    
    self.serviceTypeLab.text = [NSString stringWithFormat:@"增值服务: %@",model.serviceType];
    
    if ([model.capacityType isEqualToString:@"集装箱运力"]) {
        if([model.autonomousBoxNum intValue] > 0)
        {
            self.autonomousBoxNumLab.text = [NSString stringWithFormat:@"自备箱: 有"];
        }
        else
        {
            self.autonomousBoxNumLab.text = [NSString stringWithFormat:@"自备箱: 无"];
        }
        self.boxNumLab.text = [NSString stringWithFormat:@"箱数: %@",model.boxNum];
    }
    else if ([model.capacityType isEqualToString:@"三农化肥运力"])
    {
        self.autonomousBoxNumLab.text = @"";
        self.boxNumLab.text = [NSString stringWithFormat:@"总重量: %@吨",model.weight];

    }
    else if ([model.capacityType isEqualToString:@"散堆装运力"])
    {
        self.autonomousBoxNumLab.text = [NSString stringWithFormat:@"总体积: %@立方米",model.volume];
        self.boxNumLab.text = [NSString stringWithFormat:@"总重量: %@吨",model.weight];

    }
    
    self.noteLab.text = [NSString stringWithFormat:@"备注: %@",model.note];

    self.doorToDoorPriceLab.text = [NSString stringWithFormat:@"¥%@ x%@",model.doorToDoorPrice,model.boxNum];
//    self.pointToPointPriceLab.text = [NSString stringWithFormat:@"¥%@",model.pointToPointPrice];
    self.pointToPointPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.pickupPrice floatValue]];
    self.insurancePriceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.deliveryPrice floatValue]];

    NSMutableAttributedString * allPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计: ¥%@(%@)",[model.allPrice NumberStringToMoneyString],model.payTypeCode]];
    [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLACK_TEXT range:NSMakeRange(0,3)];
    [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(3,[[NSString stringWithFormat:@"共计: ¥%@(%@)",[model.allPrice NumberStringToMoneyString],model.payTypeCode] rangeOfString:[NSString stringWithFormat:@"(%@)",model.payTypeCode]].location - 3)];
    [allPrice addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY2 range:[[NSString stringWithFormat:@"共计: ¥%@(%@)",[model.allPrice NumberStringToMoneyString],model.payTypeCode] rangeOfString:[NSString stringWithFormat:@"(%@)",model.payTypeCode]]];
    
    [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,3)];
    [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(3,[[NSString stringWithFormat:@"共计: ¥%@(%@)",[model.allPrice NumberStringToMoneyString],model.payTypeCode] rangeOfString:@"."].location - 3)];
    [allPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange([[NSString stringWithFormat:@"共计: ¥%@(%@)",[model.allPrice NumberStringToMoneyString],model.payTypeCode] rangeOfString:@"."].location,model.payTypeCode.length+5)];
    self.allPriceLab.attributedText = allPrice;
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    self.placeTheOrderLab.text = [NSString stringWithFormat:@"下单时间: %@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.placeTheOrderTime doubleValue] / 1000]]];

    UIView * checkBillView;
    if ([model.ordetType isEqualToString:@"待付款"]) {
        
        
        checkBillView = self.needPaymentCheckBillView;
        checkBillView.frame = CGRectMake(0, self.orderView.bottom + 12, SCREEN_W, 44);
        self.needPaymentLab.text = [NSString stringWithFormat:@"¥%.2f",[model.waitPrice floatValue]];
        
        
    }else if([model.ordetType isEqualToString:@"已完成"]) {
        
        
        checkBillView = self.completeCheckBillView;
        checkBillView.frame = CGRectMake(0, self.orderView.bottom + 12, SCREEN_W, 90);
        self.paymentHasBeenLab.text = [NSString stringWithFormat:@"¥%@",model.paidPrice];
        
        
    }else if ([model.ordetType isEqualToString:@"待收货"] || [model.ordetType isEqualToString:@"待发货"]) {
        
        
        checkBillView = self.goodsCheckBillView;
        checkBillView.frame = CGRectMake(0, self.orderView.bottom + 12, SCREEN_W, 150);
        self.needPaymentLab.text = [NSString stringWithFormat:@"¥%.2f",[model.waitPrice floatValue]];
        self.paymentHasBeenLab.text = [NSString stringWithFormat:@"¥%.2f",[model.paidPrice floatValue]];
        self.needConfirmLab.text = [NSString stringWithFormat:@"¥%.2f",[model.unconfirmedPrice floatValue]];
        
        
    }
    else {
        
        
        checkBillView = self.needPaymentCheckBillView;
        checkBillView.frame = CGRectMake(0, self.orderView.bottom, SCREEN_W, 0);
        
    }
    [self.bgView addSubview:checkBillView];
    
    
    UIView * invoiceView;
    if (!model.invoice_0.title) {
        invoiceView = self.invoiceView_haveNot;
        self.invoiceView_haveNot.frame = CGRectMake(0, checkBillView.bottom + 12, SCREEN_W, 44);
        [self.bgView addSubview:self.invoiceView_haveNot];
        [self.invoiceView_have removeFromSuperview];

    }
    else
    {
        invoiceView = self.invoiceView_have;

        self.invoiceView_have.frame = CGRectMake(0, checkBillView.bottom + 12, SCREEN_W, 205);
        [self.bgView addSubview:self.invoiceView_have];
        [self.invoiceView_haveNot removeFromSuperview];

    }
    [self updateOrderProgressViewWithArray:model.orderProgress WithInvoiceView:invoiceView];

    self.invoiceLookUpLab.text = [NSString stringWithFormat:@"发票抬头: %@",model.invoice_0.title];
    self.invoiceTypeLab.text = [NSString stringWithFormat:@"发票类型: %@",model.invoice_0.typeStr];
    self.projectLab.text = [NSString stringWithFormat:@"项目: %@",model.invoice_0.content];
    self.getInvoicPNameLab.text = [NSString stringWithFormat:@"收票人姓名: %@",model.invoice_0.contactsName];
    self.getInvoicPPhoneLab.text = [NSString stringWithFormat:@"收票人电话: %@",model.invoice_0.contactsTel];
    self.getInvoicAddressLab.text = model.invoice_0.contactsAddress;

    if ([self.getInvoicAddressLab.text sizeWithAttributes:@{NSFontAttributeName:self.getInvoicAddressLab.font}].width <= self.getInvoicAddressLab.width) {
        self.getInvoicAddressLab.frame = CGRectMake(self.getInvoicAddressLab.left, self.getInvoicAddressLab.top, self.getInvoicAddressLab.width, 15);
    }
    else
    {
        self.getInvoicAddressLab.frame = CGRectMake(self.getInvoicAddressLab.left, self.getInvoicAddressLab.top, self.getInvoicAddressLab.width, 35);
    }

    
    
    NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[model.price NumberStringToMoneyString]]];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED1 range:NSMakeRange(0,price.length)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 3,3)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 3)];
    self.priceLab.attributedText = price;
    
}

- (void)updateOrderProgressViewWithArray:(NSArray*)orderProgress WithInvoiceView:(UIView *)invoiceView {
    
    if (orderProgress.count <= 0) {
        [self.orderProgressView removeFromSuperview];
        self.bgView.contentSize = CGSizeMake(SCREEN_W,invoiceView.bottom + 50);
        return ;
    }
    self.orderProgressView.frame = CGRectMake(0,invoiceView.bottom + 12, SCREEN_W, 44 + 77 * orderProgress.count);
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
    line_01.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    line_01.frame = CGRectMake(0, 43, SCREEN_W, 1);
    [self.orderProgressView addSubview:line_01];
    
    UIView * line_02 = [UIView new];
    line_02.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    line_02.frame = CGRectMake(26.5, 74, 1,60 + 77 * (orderProgress.count - 1));
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
        circle.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
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
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line.frame = CGRectMake(58, 122 + 77 * i, SCREEN_W - 58, 1);
        [self.orderProgressView addSubview:line];
        
        
        if (i == 0) {
            circle.backgroundColor = APP_COLOR_BLUE_BTN;
            circle.frame = CGRectMake(20, 65, 15, 15);
            circle.layer.cornerRadius = 7.5;
            lab_name.textColor = APP_COLOR_BLUE_BTN;
        }
    }
}

- (void)addBigrqCodeIgv {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.bigQrCodeIgv];;
}

- (void)deleteBigrqCodeIgv {
    [self.bigQrCodeIgv removeFromSuperview];
}

#pragma mark - 属性懒加载
-(UIScrollView *)bgView {
    if (!_bgView) {
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
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
        
        if ([self.model.ordetType isEqualToString:@"待收货"] || [self.model.ordetType isEqualToString:@"待发货"]){
            UIView * bg = [UIView new];
            bg.backgroundColor  = APP_COLOR_WHITE;
            bg.frame = CGRectMake(SCREEN_W - 50 - 20, 22, 50, 50);
            [view addSubview:bg];
            
            self.qrCodeIgv. frame = CGRectMake(3, 3, 44, 44);
            [bg addSubview:self.qrCodeIgv];
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

-(UIImageView *)qrCodeIgv {
    if (!_qrCodeIgv) {
        UIImageView * img= [UIImageView new];
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(addBigrqCodeIgv)];
        [img addGestureRecognizer:tap];
        _qrCodeIgv = img;
    }
    return _qrCodeIgv;
}

-(UIView *)bigQrCodeIgv {
    if (!_bigQrCodeIgv) {
        UIView * view = [UIView new];
        view.frame = [UIScreen mainScreen].bounds;
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        UIImageView * img = [UIImageView new];
        img.frame = CGRectMake(SCREEN_W / 2 - 100, SCREEN_H / 2 - 100, 200, 200);
        img.image = [UIImage getQrCodeImageWithString:self.model.orderID andSize:CGSizeMake(400, 400)];

        [view addSubview:img];
        
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(deleteBigrqCodeIgv)];
        [view addGestureRecognizer:tap];
        
        _bigQrCodeIgv = view;
    }
    return _bigQrCodeIgv;
}

- (UIView *)addressView {
    if (!_addressView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;

        self.startLab.frame = CGRectMake(10, 22, 20, 12);
        [view addSubview:self.startLab];
    
        self.startpNameLab.frame = CGRectMake(40, 16, 80, 24);
        [view addSubview:self.startpNameLab];
    
        self.startpPhoneLab.frame = CGRectMake(120, 20, SCREEN_W - 140, 16);
        [view addSubview:self.startpPhoneLab];
    
        self.startIgv.frame = CGRectMake(15, 52, 10, 11);
        [view addSubview:self.startIgv];
    
        self.startaddressLab.frame = CGRectMake(40, 49, SCREEN_W - 80, 36);
        [view addSubview:self.startaddressLab];
        
        self.endLab.frame = CGRectMake(10, 118, 20, 12);
        [view addSubview:self.endLab];
        
        self.endpNameLab.frame = CGRectMake(40, 111, 80, 24);
        [view addSubview:self.endpNameLab];
        
        self.endpPhoneLab.frame = CGRectMake(120, 115, SCREEN_W - 140, 16);
        [view addSubview:self.endpPhoneLab];
        
        self.endIgv.frame = CGRectMake(15, 150, 10, 11);
        [view addSubview:self.endIgv];
        
        self.endaddressLab.frame = CGRectMake(40, 146, SCREEN_W - 80, 36);
        [view addSubview:self.endaddressLab];
        
        self.lastRibbonIgv.frame = CGRectMake(0, 210, SCREEN_W, 2);
        [view addSubview:self.lastRibbonIgv];
        
        _addressView = view;
    }
    return _addressView;
}

//地址视图
- (UILabel *)startLab {
    if (!_startLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"起";
        _startLab = label;
    }
    return _startLab;
}

//起始地信息
- (UILabel *)startpNameLab {
    if (!_startpNameLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        _startpNameLab = label;
    }
    return _startpNameLab;
}

- (UILabel *)startpPhoneLab {
    if (!_startpPhoneLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        _startpPhoneLab = label;
    }
    return _startpPhoneLab;
}

- (UIImageView *)startIgv {
    if (!_startIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _startIgv = imageView;
    }
    return _startIgv;
}

- (UILabel *)startaddressLab {
    if (!_startaddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _startaddressLab = label;
    }
    return _startaddressLab;
}

//抵达地信息
- (UILabel *)endLab {
    if (!_endLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"终";
        _endLab = label;
    }
    return _endLab;
}

- (UILabel *)endpNameLab {
    if (!_endpNameLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        _endpNameLab = label;
    }
    return _endpNameLab;
}

- (UILabel *)endpPhoneLab {
    if (!_endpPhoneLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        _endpPhoneLab = label;
    }
    return _endpPhoneLab;
}

- (UIImageView *)endIgv {
    if (!_endIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _endIgv = imageView;
    }
    return _endIgv;
}

- (UILabel *)endaddressLab {
    if (!_endaddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _endaddressLab = label;
    }
    return _endaddressLab;
}

- (UIImageView *)lastRibbonIgv {
    if (!_lastRibbonIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"colorLine" adS]];
        _lastRibbonIgv = imageView;
    }
    return _lastRibbonIgv;
}

//1111111111111
- (UIView *)branchesView {
    if (!_branchesView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16.0];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.text = @"运输网点地址";
        lab.frame = CGRectMake(20, 12, SCREEN_W - 40 , 20);
        [view addSubview:lab];
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line.frame = CGRectMake(0, 44, SCREEN_W, 1);
        [view addSubview:line];
        
        self.branchesStartIgv.frame = CGRectMake(15, 65, 10, 11);
        [view addSubview:self.branchesStartIgv];
        
        self.branchesStartaddressLab.frame = CGRectMake(40, 60, SCREEN_W - 80, 36);
        [view addSubview:self.branchesStartaddressLab];

        
        self.branchesEndIgv.frame = CGRectMake(15, 115, 10, 11);
        [view addSubview:self.branchesEndIgv];
        
        self.branchesEndaddressLab.frame = CGRectMake(40, 110, SCREEN_W - 80, 36);
        [view addSubview:self.branchesEndaddressLab];
        
        self.branchesLastRibbonIgv.frame = CGRectMake(0, 160, SCREEN_W, 2);
        [view addSubview:self.branchesLastRibbonIgv];
        
        _branchesView = view;
    }
    return _branchesView;
}

- (UIImageView *)branchesStartIgv {
    if (!_branchesStartIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _branchesStartIgv = imageView;
    }
    return _branchesStartIgv;
}

- (UILabel *)branchesStartaddressLab {
    if (!_branchesStartaddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _branchesStartaddressLab = label;
    }
    return _branchesStartaddressLab;
}

- (UIImageView *)branchesEndIgv {
    if (!_branchesEndIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _branchesEndIgv = imageView;
    }
    return _branchesEndIgv;
}

- (UILabel *)branchesEndaddressLab {
    if (!_branchesEndaddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _branchesEndaddressLab = label;
    }
    return _branchesEndaddressLab;
}

- (UIImageView *)branchesLastRibbonIgv {
    if (!_branchesLastRibbonIgv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:[@"colorLine" adS]];
        _branchesLastRibbonIgv = imageView;
    }
    return _branchesLastRibbonIgv;
}

- (UIView *)timeView {
    if (!_timeView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;

        self.startTimeLab.frame = CGRectMake(15, 10, SCREEN_W - 30, 20);
        [view addSubview:self.startTimeLab];
        
        self.endTimeLab.frame = CGRectMake(15, 40, SCREEN_W - 30, 20);
        [view addSubview:self.endTimeLab];
        
        _timeView = view;
    }
    return _timeView;
}

- (UILabel *)startTimeLab {
    if (!_startTimeLab) {
        UILabel* label = [[UILabel alloc]init];
        _startTimeLab = label;
    }
    return _startTimeLab;
}

- (UILabel *)endTimeLab {
    if (!_endTimeLab) {
        UILabel* label = [[UILabel alloc]init];
        _endTimeLab = label;
    }
    return _endTimeLab;
}

- (UIView *)orderView {
    if (!_orderView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        self.orderIgv.frame = CGRectMake(15, 20, 70, 70);
        [view addSubview:self.orderIgv];
        
        self.capacityTypeLab.frame = CGRectMake(100, 18, SCREEN_W - 115, 18);
        [view addSubview:self.capacityTypeLab];
 
        self.goodsTypeLab.frame = CGRectMake(100, 48, SCREEN_W - 115, 15);
        [view addSubview:self.goodsTypeLab];
        
        self.goodsNameLab.frame = CGRectMake(100, 75, SCREEN_W - 115, 15);
        [view addSubview:self.goodsNameLab];
        
        UIView * line_01 = [UIView new];
        line_01.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line_01.frame = CGRectMake(0, 110, SCREEN_W, 1);
        [view addSubview:line_01];
        
        self.serviceTypeLab.frame = CGRectMake(15, 127, SCREEN_W - 30, 15);
        [view addSubview:self.serviceTypeLab];
        
        self.autonomousBoxNumLab.frame = CGRectMake(15, 152, SCREEN_W / 2 - 15, 15);
        [view addSubview:self.autonomousBoxNumLab];
        
        self.boxNumLab.frame = CGRectMake(SCREEN_W / 2, 152, SCREEN_W / 2 - 15, 15);
        [view addSubview:self.boxNumLab];
        
        
        UIView * line_02 = [UIView new];
        line_02.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line_02.frame = CGRectMake(15, 182, SCREEN_W, 1);
        [view addSubview:line_02];

        self.noteLab.frame = CGRectMake(15, 198, SCREEN_W - 30, 15);
        [view addSubview:self.noteLab];
        
        UIView * line_03 = [UIView new];
        line_03.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line_03.frame = CGRectMake(15, 228, SCREEN_W, 1);
        [view addSubview:line_03];
        
        UILabel * doorToDoor = [UILabel new];
        doorToDoor.frame = CGRectMake(15, 245, 100, 15);
        doorToDoor.font = [UIFont systemFontOfSize:14.f];
        doorToDoor.text = @"运费:";
        doorToDoor.textColor = APP_COLOR_GRAY2;
        [view addSubview:doorToDoor];
        
        self.doorToDoorPriceLab.frame = CGRectMake(115, 245, SCREEN_W - 130, 15);
        [view addSubview:self.doorToDoorPriceLab];
        
        UILabel * pointToPoint = [UILabel new];
        pointToPoint.font = [UIFont systemFontOfSize:14.f];
        pointToPoint.frame = CGRectMake(15, 270, 100, 15);
        pointToPoint.text = @"上门取货费:";
        pointToPoint.textColor = APP_COLOR_GRAY2;
        [view addSubview:pointToPoint];
        
        self.pointToPointPriceLab.frame = CGRectMake(115, 270, SCREEN_W - 130, 15);
        [view addSubview:self.pointToPointPriceLab];

        UILabel * insurancePrice = [UILabel new];
        insurancePrice.font = [UIFont systemFontOfSize:14.f];
        insurancePrice.frame = CGRectMake(15, 295, 100, 15);
        insurancePrice.text = @"送货上门费:";
        insurancePrice.textColor = APP_COLOR_GRAY2;
        [view addSubview:insurancePrice];
        
        self.insurancePriceLab.frame = CGRectMake(115, 295, SCREEN_W - 130, 15);
        [view addSubview:self.insurancePriceLab];

        UIView * line_04 = [UIView new];
        line_04.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line_04.frame = CGRectMake(15, 325, SCREEN_W, 1);
        [view addSubview:line_04];
        
        self.allPriceLab.frame = CGRectMake(15, 344, SCREEN_W - 30, 16);
        [view addSubview:self.allPriceLab];
        
        self.placeTheOrderLab.frame = CGRectMake(15, 366, SCREEN_W - 30, 16);
        [view addSubview:self.placeTheOrderLab];

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

- (UILabel *)capacityTypeLab {
    if (!_capacityTypeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_BLACK_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];

        _capacityTypeLab = label;
    }
    return _capacityTypeLab;
}

- (UILabel *)goodsNameLab {
    if (!_goodsNameLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _goodsNameLab = label;
    }
    return _goodsNameLab;
}

- (UILabel *)goodsTypeLab {
    if (!_goodsTypeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _goodsTypeLab = label;
    }
    return _goodsTypeLab;
}

- (UILabel *)serviceTypeLab {
    if (!_serviceTypeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _serviceTypeLab = label;
    }
    return _serviceTypeLab;
}

- (UILabel *)autonomousBoxNumLab {
    if (!_autonomousBoxNumLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _autonomousBoxNumLab = label;
    }
    return _autonomousBoxNumLab;
}

- (UILabel *)boxNumLab {
    if (!_boxNumLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _boxNumLab = label;
    }
    return _boxNumLab;
}

- (UILabel *)noteLab {
    if (!_noteLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];

        _noteLab = label;
    }
    return _noteLab;
}

- (UILabel *)doorToDoorPriceLab {
    if (!_doorToDoorPriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;

        _doorToDoorPriceLab = label;
    }
    return _doorToDoorPriceLab;
}

- (UILabel *)pointToPointPriceLab {
    if (!_pointToPointPriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _pointToPointPriceLab = label;
    }
    return _pointToPointPriceLab;
}

- (UILabel *)insurancePriceLab {
    if (!_insurancePriceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        
        _insurancePriceLab = label;
    }
    return _insurancePriceLab;
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

- (UIView *)invoiceView_have {
    if (!_invoiceView_have) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        self.invoiceLookUpLab.frame = CGRectMake(15, 20,  SCREEN_W - 30, 15);
        [view addSubview:self.invoiceLookUpLab];
        
        self.invoiceTypeLab.frame = CGRectMake(15, 45,  SCREEN_W - 30, 15);
        [view addSubview:self.invoiceTypeLab];
        
        self.projectLab.frame = CGRectMake(15, 70,  SCREEN_W - 30, 15);
        [view addSubview:self.projectLab];
        
        self.getInvoicPNameLab.frame = CGRectMake(15, 95,  SCREEN_W - 30, 15);
        [view addSubview:self.getInvoicPNameLab];
        
        self.getInvoicPPhoneLab.frame = CGRectMake(15, 120,  SCREEN_W - 30, 15);
        [view addSubview:self.getInvoicPPhoneLab];
        
        UILabel * getInvoicAddress = [UILabel new];
        getInvoicAddress.font = [UIFont systemFontOfSize:14.f];
        getInvoicAddress.frame = CGRectMake(15, 145, 100, 15);
        getInvoicAddress.text = @"收票人地址:";
        getInvoicAddress.textColor = APP_COLOR_GRAY_TEXT_1;
        [view addSubview:getInvoicAddress];
        
        self.getInvoicAddressLab.frame = CGRectMake(95, 145, SCREEN_W - 120, 30);
        [view addSubview:self.getInvoicAddressLab];
        
        _invoiceView_have = view;
    }
    return _invoiceView_have;
}

- (UIView *)invoiceView_haveNot {
    if (!_invoiceView_haveNot) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        self.noInvoiceLab.frame = CGRectMake(15, 14, SCREEN_W - 30, 13);
        [view addSubview:self.noInvoiceLab];
        _invoiceView_haveNot = view;
    }
    return _invoiceView_haveNot;
}

- (UILabel *)invoiceLookUpLab {
    if (!_invoiceLookUpLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];

        _invoiceLookUpLab = label;
    }
    return _invoiceLookUpLab;
}

- (UILabel *)invoiceTypeLab {
    if (!_invoiceTypeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];

        _invoiceTypeLab = label;
    }
    return _invoiceTypeLab;
}

- (UILabel *)projectLab {
    if (!_projectLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _projectLab = label;
    }
    return _projectLab;
}

- (UILabel *)getInvoicPNameLab {
    if (!_getInvoicPNameLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _getInvoicPNameLab = label;
    }
    return _getInvoicPNameLab;
}

- (UILabel *)getInvoicPPhoneLab {
    if (!_getInvoicPPhoneLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _getInvoicPPhoneLab = label;
    }
    return _getInvoicPPhoneLab;
}

- (UILabel *)getInvoicAddressLab {
    if (!_getInvoicAddressLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        _getInvoicAddressLab = label;
    }
    return _getInvoicAddressLab;
}

- (UILabel *)noInvoiceLab {
    if (!_noInvoiceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"发票信息: 无";

        _noInvoiceLab = label;
    }
    return _noInvoiceLab;
}

- (UIView *)orderProgressView {
    if (!_orderProgressView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        _orderProgressView = view;
    }
    return _orderProgressView;
}

-(UIView *)needPaymentCheckBillView {
    if (!_needPaymentCheckBillView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        
        UILabel * lab = [UILabel new];
        lab.text = @"待付款金额:";
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.frame = CGRectMake(15, 13, SCREEN_W - 30, 15);
        [view addSubview:lab];
        
        self.needPaymentLab.frame = CGRectMake(15, 13, SCREEN_W - 30, 15);
        [view addSubview:self.needPaymentLab];
        
        
        _needPaymentCheckBillView = view;
    }
    return _needPaymentCheckBillView;
}


-(UIView *)completeCheckBillView {
    if (!_completeCheckBillView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        
        UILabel * lab = [UILabel new];
        lab.text = @"支付流水";
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.frame = CGRectMake(15, 12, SCREEN_W - 30, 18);
        [view addSubview:lab];
        
        self.checkBillBtn.frame = CGRectMake(SCREEN_W - 50, 6, 35, 44);
        [self makeButton:self.checkBillBtn];
        [view addSubview:self.checkBillBtn];
        
        UIView * line = [UIView new];
        line.frame = CGRectMake(0, 44, SCREEN_W, 1);
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line];
        
        UILabel * lab1 = [UILabel new];
        lab1.text = @"已付款金额:";
        lab1.font = [UIFont systemFontOfSize:14.f];
        lab1.textColor = APP_COLOR_GRAY2;
        lab1.frame = CGRectMake(15, 58, SCREEN_W - 30, 15);
        [view addSubview:lab1];
        
        self.paymentHasBeenLab.frame = CGRectMake(15, 58, SCREEN_W - 30, 15);
        [view addSubview:self.paymentHasBeenLab];
        
        _completeCheckBillView = view;
    }
    return _completeCheckBillView;
}

-(UIView *)goodsCheckBillView {
    if (!_goodsCheckBillView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        
        UILabel * lab = [UILabel new];
        lab.text = @"支付流水";
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.frame = CGRectMake(15, 12, SCREEN_W - 30, 18);
        [view addSubview:lab];
        
        self.checkBillBtn.frame = CGRectMake(SCREEN_W - 40, 6, 35, 44);
        [self makeButton:self.checkBillBtn];
        [view addSubview:self.checkBillBtn];
        
        UIView * line = [UIView new];
        line.frame = CGRectMake(0, 44, SCREEN_W, 1);
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line];
        
        UILabel * lab1 = [UILabel new];
        lab1.text = @"待付款金额:";
        lab1.font = [UIFont systemFontOfSize:14.f];
        lab1.textColor = APP_COLOR_GRAY2;
        lab1.frame = CGRectMake(15, 58, SCREEN_W - 30, 15);
        [view addSubview:lab1];
        
        self.needPaymentLab.frame = CGRectMake(15, lab1.top, SCREEN_W - 30, 15);
        [view addSubview:self.needPaymentLab];
        
        UILabel * lab2 = [UILabel new];
        lab2.text = @"已付款金额:";
        lab2.font = [UIFont systemFontOfSize:14.f];
        lab2.textColor = APP_COLOR_GRAY2;
        lab2.frame = CGRectMake(15, lab1.bottom + 12, SCREEN_W - 30, 15);
        [view addSubview:lab2];
        
        self.paymentHasBeenLab.frame = CGRectMake(15, lab2.top, SCREEN_W - 30, 15);
        [view addSubview:self.paymentHasBeenLab];
        
        UILabel * lab3 = [UILabel new];
        lab3.text = @"待确认金额:";
        lab3.font = [UIFont systemFontOfSize:14.f];
        lab3.textColor = APP_COLOR_GRAY2;
        lab3.frame = CGRectMake(15, lab2.bottom + 12, SCREEN_W - 30, 15);
        [view addSubview:lab3];
        
        self.needConfirmLab.frame = CGRectMake(15, lab3.top, SCREEN_W - 30, 15);
        [view addSubview:self.needConfirmLab];
        
        _goodsCheckBillView = view;
    }
    return _goodsCheckBillView;
}

-(UIButton *)checkBillBtn {
    if(!_checkBillBtn)
    {
        UIButton * btn = [UIButton new];
        [btn setImage:[[UIImage imageNamed:[@"Back Chevron Copy 2" adS]] modifyTheImg] forState:UIControlStateNormal];
        [btn setTitle:@"明细" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        _checkBillBtn = btn;
    }
    return _checkBillBtn;
}

-(UILabel *)needPaymentLab {
    if (!_needPaymentLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.textAlignment = NSTextAlignmentRight;
        _needPaymentLab = lab;
    }
    return  _needPaymentLab;
}

-(UILabel *)needConfirmLab {
    if (!_needConfirmLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.textAlignment = NSTextAlignmentRight;
        _needConfirmLab = lab;
    }
    return  _needConfirmLab;
}

-(UILabel *)paymentHasBeenLab {
    if (!_paymentHasBeenLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.textAlignment = NSTextAlignmentRight;
        _paymentHasBeenLab = lab;
    }
    return  _paymentHasBeenLab;
}

- (UIView *)lastView {
    if (!_lastView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        if ([self.model.ordetType isEqualToString:@"已取消"]||
            [self.model.ordetType isEqualToString:@"待退款"]||
            [self.model.ordetType isEqualToString:@"已完成"]) {
            
            
            self.priceLab.frame = CGRectMake(27, 18, SCREEN_W - 54, 16);
            [view addSubview:self.priceLab];
        }
        else if ([self.model.ordetType isEqualToString:@"待付款"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            self.priceLab.textAlignment = NSTextAlignmentLeft;
            [view addSubview:self.priceLab];
            
            self.cancelBtn.frame = CGRectMake(SCREEN_W - 180, 10, 78, 30);
            [view addSubview:self.cancelBtn];
            
            self.goPaymentBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.goPaymentBtn];
        }
        else if ([self.model.ordetType isEqualToString:@"待发货"] || [self.model.ordetType isEqualToString:@"待收货"]) {
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            self.priceLab.textAlignment = NSTextAlignmentLeft;
            [view addSubview:self.priceLab];
            
            self.goPaymentBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.goPaymentBtn];
            

        }
        else if ([self.model.ordetType isEqualToString:@"待确认"]) {
            
            self.priceLab.frame = CGRectMake(20, 18, SCREEN_W - 210, 16);
            self.priceLab.textAlignment = NSTextAlignmentLeft;
            [view addSubview:self.priceLab];
            
            self.cancelBtn.frame = CGRectMake(SCREEN_W - 93, 10, 78, 30);
            [view addSubview:self.cancelBtn];
        }
        _lastView = view;
    }
    return _lastView;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentRight;
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
        button.layer.borderWidth = 1;
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
        button.layer.borderWidth = 1;
        button.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _goPaymentBtn = button;
    }
    return _goPaymentBtn;
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"取消订单"])
    {
        if ([self.model.ordetType isEqualToString:@"待付款"]) {
            if(buttonIndex == 1)
            {

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",APP_CUSTOMER_SERVICE]]];
            }
        }
        else
        {
            if(buttonIndex == 1)
            {
                
                WS(ws);
                [[OrderViewModel new]cancelSaleOfCapacityOrderDetailsWithOrderId:self.model.ID callback:^(NSString *str) {

                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshIWantToCapacity"
                                                                       object:@{
                                                                                @"orderType":@"全部",
                                                                                @"viewTitle":@"我要运力"
                                                                                }];
                    [ws.navigationController pushViewController:[OrderCancellationVC new] animated:YES];
                    
                }];
            }
        }
    }
}

- (void)makeButton:(UIButton *)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.frame.size.width * 2, 0.0,0.0)];//文字距离
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width * 2 - btn.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

@end

