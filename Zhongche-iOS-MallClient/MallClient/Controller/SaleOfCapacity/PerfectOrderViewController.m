//
//  PerfectOrderViewController.m
//  MallClient
//
//  Created by lxy on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "PerfectOrderViewController.h"
#import "OrderCertainTableViewCell.h"
#import "OrderViewModel.h"
#import "SubmitOrderSuccessViewController.h"

@interface PerfectOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView       *viHead;
@property (nonatomic, strong) UILabel      *lbHead1;
@property (nonatomic, strong) UILabel      *lbHead2;
@property (nonatomic, strong) UILabel      *lbMoney;
@property (nonatomic, strong) NSArray      *arrGood;
@property (nonatomic, strong) NSArray      *arrAddress;
@property (nonatomic, strong) NSArray      *arrWDAddress;
@property (nonatomic, strong) NSArray      *arrInvoice;
@property (nonatomic, strong) NSArray      *arrPrice;
@property (nonatomic, strong) NSArray      *arrAll1;
@property (nonatomic, strong) NSArray      *arrGoodText;
@property (nonatomic, strong) NSArray      *arrAddressText;
@property (nonatomic, strong) NSArray      *arrWDAddressText;
@property (nonatomic, strong) NSArray      *arrInvoiceText;
@property (nonatomic, strong) NSArray      *arrPriceText;
@property (nonatomic, strong) NSArray      *arrAll2;
@property (nonatomic, strong) UITableView  *tvList;
@property (nonatomic, strong) UIButton     *btnFoot;

@end

@implementation PerfectOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"订单确认";

    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 114);
    [self headViewMake];
    
    self.tvList.tableHeaderView = self.viHead;
    [self.view addSubview:self.tvList];

    self.btnFoot.frame = CGRectMake(0, self.tvList.bottom, SCREEN_W, 50);
    [self.view addSubview:self.btnFoot];

}

//底部view
- (void)headViewMake {

    self.lbHead1.frame = CGRectMake(15, 20, SCREEN_W - 15, 20);
    self.lbMoney.frame = CGRectMake(SCREEN_W - 210, 20, 200, 20);
    self.lbHead2.frame = CGRectMake(15, self.lbHead1.bottom + 5, 100, 20);

    [self.viHead addSubview:self.lbHead1];
    [self.viHead addSubview:self.lbMoney];
    [self.viHead addSubview:self.lbHead2];

    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 85);
}

- (void)bindModel {


    [self binGoodsModel];
    
    //地址信息
    self.arrAddress = @[@"提货人",@"起运地",@"收货人",@"抵运地"];

    //地址信息
    self.arrWDAddress = @[self.capacityEntry.transportationModel.startStation,self.capacityEntry.transportationModel.endStation];
    //发票信息
    self.arrInvoice = @[@"发票抬头",@"发票类型",@"项目",@"收票人",@"联系电话",@"收票地址"];
    //费用明细
    self.arrPrice   = @[@"运费",@"上门取货费",@"送货上门费",@"总计"];

    self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrWDAddress,self.arrInvoice,self.arrPrice];

    //self.capacityEntry.stStartTime

    self.arrAddressText = @[@"张三 18898787876",@"北京市海淀区西单大悦城",@"王五 18898788787",@"北京市海淀区学院路北京航空航天大学"];
    self.arrAddressText = @[[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.startContacts,self.capacityEntry.contactInfo.startContactsPhone],self.capacityEntry.contactInfo.startAddress,[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.endContacts,self.capacityEntry.contactInfo.endContactsPhone],self.capacityEntry.contactInfo.endAddress];

    self.arrWDAddressText = @[self.capacityEntry.transportationModel.startAddress,self.capacityEntry.transportationModel.endAddress];

    NSString *invoiceType;
    if (self.capacityEntry.invoice.regAddress) {
        invoiceType = @"增值税发票";
    }else {

         invoiceType = @"普通发票";
    }

    float ticketTotalPrice = [self.capacityEntry.priceInfo.ticketTotalPrice floatValue];
    float startAdditionPrice = [self.capacityEntry.priceInfo.startAdditionPrice floatValue];
    float endAdditionPrice = [self.capacityEntry.priceInfo.endAdditionPrice floatValue];
    float orderTotalMoney = [self.capacityEntry.priceInfo.orderTotalMoney floatValue];

    self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@",ticketTotalPrice,self.capacityEntry.boxNum],[NSString stringWithFormat:@"￥%.2f x %@",startAdditionPrice,self.capacityEntry.boxNum],[NSString stringWithFormat:@"￥%.2f x %@",endAdditionPrice,self.capacityEntry.boxNum],[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];

    if ([self.capacityEntry.serviceWay isEqualToString:@"无"]) {

        self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@",ticketTotalPrice,self.capacityEntry.boxNum],@"￥0.00",@"￥0.00",[NSString stringWithFormat:@"￥%.2f ",orderTotalMoney]];
    }
    if (self.capacityEntry.invoice.title) {
        self.arrInvoiceText = @[self.capacityEntry.invoice.title,invoiceType,@"运输费",self.capacityEntry.invoice.contactsName,self.capacityEntry.invoice.contactsTel,self.capacityEntry.invoice.contactsAddress];

         self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrWDAddressText,self.arrInvoiceText,self.arrPriceText];
    }else {

        self.capacityEntry.invoice = [InvoiceModel new];
        self.arrInvoiceText = @[@""];
        self.arrInvoice = @[@"无"];

        self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrWDAddress,self.arrInvoice,self.arrPrice];

        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrWDAddressText,self.arrInvoiceText,self.arrPriceText];
    }

     if (!self.capacityEntry.invoice) {

     }


}

- (void)binGoodsModel {
       self.arrGood    = @[@"货品类型",@"货品名称",@"总重量",@"服务方式",@"发货开始",@"备注"];
}

- (void) certainAction {

    WS(ws);
    OrderViewModel *vm = [OrderViewModel new];
    [vm SubmiteSaleOfCapacityOrderWthCapacityInfo:self.capacityEntry callback:^(NSString *orderNo) {

        //通知订单中心进行更新
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                           object:@{
                                                                    @"orderType":@"全部",
                                                                    @"viewTitle":@"我要运力"
                                                                    }];
        
        SubmitOrderSuccessViewController *vc = [SubmitOrderSuccessViewController new];
        vc.stOrderNo = orderNo;
        vc.type = capacity;
        [ws.navigationController pushViewController:vc animated:YES];
        
    }];
}


/**
 *
 *  @param tableView delegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.arrAll1.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSArray *arr = [self.arrAll1 objectAtIndex:section];
    return arr.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 3 )) {

        return 44;

    }

    if (indexPath.section == 3 && indexPath.row == 6) {

        return 44;
    }

    if (indexPath.section == 2) {

        return 44;
    }


    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *CellIdentifier = @"Celled";
        OrderCertainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderCertainTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSArray *arr1 = [self.arrAll1 objectAtIndex:indexPath.section];
        cell.lbTitle.text = [arr1 objectAtIndex:indexPath.row];
        NSArray *arr2 = [self.arrAll2 objectAtIndex:indexPath.section];
        cell.lbText.text = [arr2 objectAtIndex:indexPath.row];

    if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 3 )) {

        cell.lbText.numberOfLines = 0;
        
    }

    if (indexPath.section == 3 && indexPath.row == 5) {

        cell.lbText.numberOfLines = 0;
    }

    if (indexPath.section == 2 ) {

        cell.lbText.numberOfLines = 0;
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 29;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (self.capacityEntry.invoice) {
        switch ((int)section) {
            case 1:
                return [NSString stringWithFormat:@"增值服务  (%@)",self.capacityEntry.serviceWay];
                break;
            case 2:
                return @"运输网点";
                break;
            case 3:
                return @"发票信息";
                break;
            case 4:
                return @"费用明细";
                break;

            default:
                break;
        }
    }

    switch ((int)section) {
        case 1:
            return @"地址信息";
            break;

        case 2:
            return @"费用明细";
            break;

        default:
            break;
    }

    return @"";
}

/**
 *  getter
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;

        _tvList = tableView;
    }
    return _tvList;
}

- (UIView *)viHead {

    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = [UIColor whiteColor];

    }
    return _viHead;
}

- (UILabel *)lbHead1 {

    if (!_lbHead1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = [NSString stringWithFormat:@"%@ — %@",self.capacityEntry.startPlace.name,self.capacityEntry.endPlace.name];

        _lbHead1 = label;
    }
    return _lbHead1;
}

- (UILabel *)lbHead2 {

    if (!_lbHead2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = [NSString stringWithFormat:@"%i日送达",[self.capacityEntry.transportationModel.expectTime intValue]/1440];



        _lbHead2 = label;
    }
    return _lbHead2;
}

- (UILabel *)lbMoney {

    if (!_lbMoney) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        if (!self.capacityEntry.priceInfo.orderTotalMoney) {
            self.capacityEntry.priceInfo.orderTotalMoney = @"";
        }
        NSString *stMoney = [self.capacityEntry.priceInfo.orderTotalMoney NumberStringToMoneyString];
        NSMutableAttributedString * labelText = [[NSMutableAttributedString alloc] initWithString:stMoney];
        [labelText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,labelText.length)];
        [labelText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[labelText.string rangeOfString:[self.capacityEntry.priceInfo.orderTotalMoney NumberStringToMoneyStringGetLastThree]]];
        label.attributedText = labelText;
        label.textAlignment = NSTextAlignmentRight;

        _lbMoney = label;
    }
    return _lbMoney;
}

- (UIButton *)btnFoot {

    if (!_btnFoot) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确定下单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        [button addTarget:self action:@selector(certainAction) forControlEvents:UIControlEventTouchUpInside];

        _btnFoot = button;
    }
    return _btnFoot;
}

@end


#pragma mark - 集装箱运力
@implementation PerfectOrderViewController_Container : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood  = @[@"货品类型",@"货品名称",@"箱型箱类",@"用箱数量",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"集装箱",self.capacityEntry.goodsInfo.name,self.capacityEntry.box.name,[NSString stringWithFormat:@"%@个",self.capacityEntry.boxNum],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
}

@end
#pragma mark - 散堆装运力
@implementation PerfectOrderViewController_InBulk : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"总重量",@"总体积",@"服务方式",@"发货日期",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue] sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [self stDateToString:[outputFormatter stringFromDate:endate]];


    self.arrGoodText    = @[@"散堆装",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],[NSString stringWithFormat:@"%@m³",self.capacityEntry.volume],self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];

    if (self.capacityEntry.weight.length == 0) {

        self.arrGood    = @[@"货品类型",@"货品名称",@"总体积",@"服务方式",@"发货日期",@"到达时间",@"备注"];
        self.arrGoodText    = @[@"散堆装",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@m³",self.capacityEntry.volume],self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
    }

    if (self.capacityEntry.volume.length == 0) {

        self.arrGood    = @[@"货品类型",@"货品名称",@"总重量",@"服务方式",@"发货日期",@"到达时间",@"备注"];
        self.arrGoodText    = @[@"散堆装",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
    }
}

- (void)bindModel {

    [self binGoodsModel];
    //地址信息
    self.arrAddress = @[@"提货人",@"起运地",@"收货人",@"抵运地"];
    //发票信息
    self.arrInvoice = @[@"发票抬头",@"发票类型",@"项目",@"收票人",@"联系电话",@"收票地址"];
    //费用明细
    self.arrPrice   = @[@"运费",@"附加费",@"总计"];

    self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrInvoice,self.arrPrice];

    //self.capacityEntry.stStartTime

    self.arrAddressText = @[@"张三 18898787876",@"北京市海淀区西单大悦城",@"王五 18898788787",@"北京市海淀区学院路北京航空航天大学"];
    self.arrAddressText = @[[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.startContacts,self.capacityEntry.contactInfo.startContactsPhone],self.capacityEntry.contactInfo.startAddress,[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.endContacts,self.capacityEntry.contactInfo.endContactsPhone],self.capacityEntry.contactInfo.endAddress];

    NSString *invoiceType;
    if (self.capacityEntry.invoice.regAddress) {
        invoiceType = @"增值税发票";
    }else {

        invoiceType = @"普通发票";
    }

    float ticketTotalPrice = [self.capacityEntry.priceInfo.ticketTotalPrice floatValue];
    float additionPrice = [self.capacityEntry.priceInfo.startAdditionPrice floatValue] + [self.capacityEntry.priceInfo.endAdditionPrice floatValue];
    float orderTotalMoney = [self.capacityEntry.priceInfo.orderTotalMoney floatValue];

    if ([self.capacityEntry.priceInfo.stackType isEqualToString:@"w"]) {
        self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@",ticketTotalPrice,self.capacityEntry.weight],[NSString stringWithFormat:@"￥%.2f ",additionPrice],[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];
    }else {
        self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@ x 系数",ticketTotalPrice,self.capacityEntry.volume],[NSString stringWithFormat:@"￥%.2f ",additionPrice],[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];
    }


    if ([self.capacityEntry.serviceWay isEqualToString:@"点到点"]) {

        if ([self.capacityEntry.priceInfo.stackType isEqualToString:@"w"]) {
            self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@",ticketTotalPrice,self.capacityEntry.weight],@"￥00.00",[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];
        }else {
            self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@ x 系数",ticketTotalPrice,self.capacityEntry.volume],@"￥00.00",[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];
        }
    }
    if (self.capacityEntry.invoice) {
        self.arrInvoiceText = @[self.capacityEntry.invoice.title,invoiceType,@"运输费",self.capacityEntry.invoice.contactsName,self.capacityEntry.invoice.contactsTel,self.capacityEntry.invoice.contactsAddress];

        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrInvoiceText,self.arrPriceText];
    }else {
        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrPriceText];
        self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrPrice];
    }
}

@end

#pragma mark - 三农化肥运力
@implementation PerfectOrderViewController_Fertilizer : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"总重量",@"服务方式",@"发货开始",@"备注"];
    self.arrAddress = @[@"提货人",@"起运地",@"收货人",@"还箱地"];


    self.arrGoodText    = @[@"三农化肥",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,self.capacityEntry.remark];
}

- (void)bindModel {

    [self binGoodsModel];
    //地址信息
    self.arrAddress = @[@"提货人",@"起运地",@"收货人",@"抵运地"];
    //发票信息
    self.arrInvoice = @[@"发票抬头",@"发票类型",@"项目",@"收票人",@"联系电话",@"收票地址"];
    //费用明细
    self.arrPrice   = @[@"运费",@"附加费",@"总计"];

    self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrInvoice,self.arrPrice];

    //self.capacityEntry.stStartTime

    self.arrAddressText = @[@"张三 18898787876",@"北京市海淀区西单大悦城",@"王五 18898788787",@"北京市海淀区学院路北京航空航天大学"];
    self.arrAddressText = @[[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.startContacts,self.capacityEntry.contactInfo.startContactsPhone],self.capacityEntry.contactInfo.startAddress,[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.endContacts,self.capacityEntry.contactInfo.endContactsPhone],self.capacityEntry.contactInfo.endAddress];

    NSString *invoiceType;
    if (self.capacityEntry.invoice.regAddress) {
        invoiceType = @"增值税发票";
    }else {
        invoiceType = @"普通发票";
    }

    float ticketTotalPrice = [self.capacityEntry.priceInfo.ticketTotalPrice floatValue];
    float additionPrice = [self.capacityEntry.priceInfo.additionPrice floatValue];
    float orderTotalMoney = [self.capacityEntry.priceInfo.orderTotalMoney floatValue];
    self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@吨",ticketTotalPrice,self.capacityEntry.weight],[NSString stringWithFormat:@"￥%.2f x %@吨",additionPrice,self.capacityEntry.weight],[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];

    if ([self.capacityEntry.serviceWay isEqualToString:@"点到点"]) {

        self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@吨",ticketTotalPrice,self.capacityEntry.weight],@"￥00.00",[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];
    }
    if (self.capacityEntry.invoice) {
        
        self.arrInvoiceText = @[self.capacityEntry.invoice.title,invoiceType,@"运输费",self.capacityEntry.invoice.contactsName,self.capacityEntry.invoice.contactsTel,self.capacityEntry.invoice.contactsAddress];
        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrInvoiceText,self.arrPriceText];
    }else {
        
        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrPriceText];
        self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrPrice];
    }
}

@end

#pragma mark - 一带一路运力
@implementation PerfectOrderViewController_OneBeltOneRoad : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"箱型箱类",@"用箱数量",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"一带一路",self.capacityEntry.goodsInfo.name,self.capacityEntry.box.name,[NSString stringWithFormat:@"%@个",self.capacityEntry.boxNum],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
}

@end

#pragma mark - 快速配送运力
@implementation PerfectOrderViewController_QuickGo : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"箱型箱类",@"用箱数量",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"一带一路",self.capacityEntry.goodsInfo.name,self.capacityEntry.box.name,[NSString stringWithFormat:@"%@个",self.capacityEntry.boxNum],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
}

@end

#pragma mark - 冷链运力
@implementation PerfectOrderViewController_ColdChain : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"用箱数量",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"冷链",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@个",self.capacityEntry.boxNum],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
}
@end

#pragma mark - 大件运力
@implementation PerfectOrderViewController_Big : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"件数",@"重量",@"最大单件重量",@"最大单件尺寸",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"大件",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@个",self.capacityEntry.boxNum],[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],[NSString stringWithFormat:@"%@吨",self.capacityEntry.biggestWeight],[NSString stringWithFormat:@"长%@cm 宽%@cm 高%@cm",self.capacityEntry.longCm,self.capacityEntry.wideCm,self.capacityEntry.highCm],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];


}
@end

#pragma mark - 商品车运力
@implementation PerfectOrderViewController_ForCar : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"用车数量",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"冷链",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@辆",self.capacityEntry.boxNum],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];
}
@end

#pragma mark - 液态运力
@implementation PerfectOrderViewController_Liquid : PerfectOrderViewController

- (void)binGoodsModel {

    self.arrGood    = @[@"货品类型",@"货品名称",@"总重量",@"自备箱",@"服务方式",@"发货时间",@"到达时间",@"备注"];

    NSDate *date = [self stDateToDate:self.capacityEntry.stStartTime];
    NSDate *endate = [NSDate dateWithTimeInterval:[self.capacityEntry.transportationModel.expectTime intValue]*60 sinceDate:date];

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stEndTime = [outputFormatter stringFromDate:endate];

    self.arrGoodText    = @[@"冷链",self.capacityEntry.goodsInfo.name,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],self.capacityEntry.isOwnBox,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,stEndTime,self.capacityEntry.remark];



}

- (void)bindModel {


    [self binGoodsModel];
    //地址信息
    self.arrAddress = @[@"提货人",@"起运地",@"收货人",@"抵运地"];

    //地址信息
    self.arrWDAddress = @[self.capacityEntry.transportationModel.startStation,self.capacityEntry.transportationModel.endStation];
    //发票信息
    self.arrInvoice = @[@"发票抬头",@"发票类型",@"项目",@"收票人",@"联系电话",@"收票地址"];
    //费用明细
    self.arrPrice   = @[@"运费",@"服务费",@"总计"];

    self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrWDAddress,self.arrInvoice,self.arrPrice];

    //self.capacityEntry.stStartTime

    self.arrAddressText = @[@"张三 18898787876",@"北京市海淀区西单大悦城",@"王五 18898788787",@"北京市海淀区学院路北京航空航天大学"];
    self.arrAddressText = @[[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.startContacts,self.capacityEntry.contactInfo.startContactsPhone],self.capacityEntry.contactInfo.startAddress,[NSString stringWithFormat:@"%@ %@",self.capacityEntry.contactInfo.endContacts,self.capacityEntry.contactInfo.endContactsPhone],self.capacityEntry.contactInfo.endAddress];

    self.self.arrWDAddressText = @[self.capacityEntry.transportationModel.startAddress,self.capacityEntry.transportationModel.endAddress];

    NSString *invoiceType;
    if (self.capacityEntry.invoice.regAddress) {
        invoiceType = @"增值税发票";
    }else {

        invoiceType = @"普通发票";
    }



    float ticketTotalPrice = [self.capacityEntry.priceInfo.ticketTotalPrice floatValue];
    float additionPrice = [self.capacityEntry.priceInfo.additionPrice floatValue];
    float orderTotalMoney = [self.capacityEntry.priceInfo.orderTotalMoney floatValue];
    self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@吨",ticketTotalPrice,self.capacityEntry.weight],[NSString stringWithFormat:@"￥%.2f x %@吨",additionPrice,self.capacityEntry.weight],[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];

    if ([self.capacityEntry.serviceWay isEqualToString:@"点到点"]) {

        self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@吨",ticketTotalPrice,self.capacityEntry.weight],@"￥00.00",[NSString stringWithFormat:@"￥%.2f",orderTotalMoney]];
    }


    if ([self.capacityEntry.serviceWay isEqualToString:@"无"]) {

        self.arrPriceText   = @[[NSString stringWithFormat:@"￥%.2f x %@",ticketTotalPrice,self.capacityEntry.boxNum],@"￥0.00",@"￥0.00",[NSString stringWithFormat:@"￥%.2f ",orderTotalMoney]];
    }
    if (self.capacityEntry.invoice.title) {
        self.arrInvoiceText = @[self.capacityEntry.invoice.title,invoiceType,@"运输费",self.capacityEntry.invoice.contactsName,self.capacityEntry.invoice.contactsTel,self.capacityEntry.invoice.contactsAddress];

        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrWDAddressText,self.arrInvoiceText,self.arrPriceText];
    }else {

        self.capacityEntry.invoice = [InvoiceModel new];
        self.arrInvoiceText = @[@""];
        self.arrInvoice = @[@"无"];

        self.arrAll1 = @[self.arrGood,self.arrAddress,self.arrWDAddress,self.arrInvoice,self.arrPrice];

        self.arrAll2 = @[self.arrGoodText,self.arrAddressText,self.arrWDAddressText,self.arrInvoiceText,self.arrPriceText];
    }
    
    if (!self.capacityEntry.invoice) {
        
    }
    
    
}
@end

