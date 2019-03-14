//
//  SubmiteOrderViewController.m
//  MallClient
//
//  Created by lxy on 2016/12/1.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SubmiteOrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderSwitchTableViewCell.h"
#import "OrderInputTableViewCell.h"
#import "PerfectOrderViewController.h"
#import "AddressManagerViewController.h"
#import "AddressTableViewCell.h"
#import "OrderViewModel.h"
#import "InvoiceListViewController.h"
#import "InvoiceViewModel.h"


@interface SubmiteOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
    UIImageView *imageView;
}
@property (nonatomic, strong) UIView               *viHead;
@property (nonatomic, strong) UIView               *viAddress;
@property (nonatomic, strong) UIView               *viTransportation;
@property (nonatomic, strong) UITableView          *tvList;
@property (nonatomic, assign) int                  insurance;//保险是否展开
@property (nonatomic, assign) int                  invoice;//发票是否展开
@property (nonatomic, assign) int                  remarks;//备注是否展开
@property (nonatomic, strong) UILabel              *lbBotoom;
@property (nonatomic, strong) UIButton             *btnMoneyDetail;
@property (nonatomic, strong) UIButton             *btnSubmitOrder;
@property (nonatomic, strong) UIButton             *btnAddAddress1;
@property (nonatomic, strong) UIButton             *btnAddAddress2;
@property (nonatomic, strong) UIView               *viMessage;
@property (nonatomic, strong) UIButton             *btnAddressInfo;
@property (nonatomic, strong) UIView               *viBackground;
@property (nonatomic, strong) UIView               *viPrice;

@property (nonatomic, strong) UILabel              *lbTicketTotalPrice;
@property (nonatomic, strong) UILabel              *lbAdditionPrice;//上门取货费
@property (nonatomic, strong) UILabel              *lbAdditionServicePrice;//送货上门费
@property (nonatomic, strong) UIPickerView         *payStylePicker;
@property (nonatomic, strong) NSArray              *arrTime;
@property (nonatomic, strong) UIButton             *btnCancle;
@property (nonatomic, strong) UIView               *viTime;

@property (nonatomic, strong) AddressInfo          *startContactInfo;
@property (nonatomic, strong) AddressInfo          *endContactInfo;

@property (nonatomic, strong) AddressTableViewCell *cell1;
@property (nonatomic, strong) AddressTableViewCell *cell2;

@property (nonatomic, strong) InvoiceModel         *defaultInvoiceModel;

@property (nonatomic, strong) UILabel              *lb2;
@property (nonatomic, strong) UILabel              *lb3;

@property (nonatomic, assign) BOOL                 isShow;//是否展开详情

@property (nonatomic, strong) UIButton *btnUpAndDown;

@end

@implementation SubmiteOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        //ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionPrice.text = @"￥0.00";
        ws.lbAdditionServicePrice.text = @"￥0.00";

    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {


        ws.defaultInvoiceModel = info;
        

    }];
}

- (void)bindView {

    self.lbTicketTotalPrice = [self labelWithText:@"" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
    self.lbAdditionPrice = [self labelWithText:@"" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
    self.lbAdditionServicePrice = [self labelWithText:@"" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
    self.lbTicketTotalPrice.frame = CGRectMake(SCREEN_W - 200, 10, 180, 20);
    self.lbAdditionPrice.frame = CGRectMake(SCREEN_W - 200, self.lbTicketTotalPrice.bottom + 10, 180, 20);
    self.lbAdditionServicePrice.frame = CGRectMake(SCREEN_W - 200, self.lbAdditionPrice.bottom + 10, 180, 20);
    [self.viPrice addSubview:self.lbTicketTotalPrice];
    [self.viPrice addSubview:self.lbAdditionPrice];
    [self.viPrice addSubview:self.lbAdditionServicePrice];

    self.insurance = 1;
    self.invoice = 1;
    self.remarks = 1;

    self.title = @"填写订单";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 114);

    //self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150);
    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 );
    self.tvList.tableHeaderView = self.viHead;
    [self.view addSubview:self.tvList];

    [self viHeadMake];

    self.lbBotoom.frame = CGRectMake(0, SCREEN_H - 114, SCREEN_W*2/5, 50);
    [self.view addSubview:self.lbBotoom];

    self.btnMoneyDetail.frame = CGRectMake(self.lbBotoom.right - 1, SCREEN_H - 114, SCREEN_W/5 + 1, 50);
    [self.view addSubview:self.btnMoneyDetail];

    self.btnSubmitOrder.frame = CGRectMake(self.btnMoneyDetail.right, SCREEN_H - 114, SCREEN_W*2/5, 50);
    [self.view addSubview:self.btnSubmitOrder];

    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(0, SCREEN_H - 114, SCREEN_W, 0.5);
    [self.view addSubview:lbLine];


    self.viPrice.frame = CGRectMake(0, SCREEN_H - 114 - 100, SCREEN_W, 100);
    [self.view addSubview:self.viPrice];


    UILabel *lb1 = [self labelWithText:@"运费" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];

    self.lb2 = [self labelWithText:@"上门取货费" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];

    self.lb3 = [self labelWithText:@"送货上门费" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];
//    if ([type isEqualToString:@"点到点"]) {
//        lb2.hidden = YES;
                                                                                                                                                                                                                                                                                                          //    }
    lb1.frame = CGRectMake(20, 10, 100, 20);
    self.lb2.frame = CGRectMake(20, lb1.bottom + 10, 100, 20);
    self.lb3.frame = CGRectMake(20, self.lb2.bottom + 10, 100, 20);
    [self.viPrice addSubview:lb1];
    [self.viPrice addSubview:self.lb2];
    [self.viPrice addSubview:self.lb3];
    self.viPrice.hidden = YES;

    //UILabel *lb3 = [self labelWithText:@"保险费" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY_TEXT_1];





    self.viBackground.frame  = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 150);
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 150);
    [btn addTarget:self action:@selector(moneyDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viBackground addSubview:btn];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.viBackground];
    self.viBackground.hidden = YES;


    self.viTime.frame  = CGRectMake(0, SCREEN_H - 120 - 64 - 15, SCREEN_W, 149);
    [self.view addSubview:self.viTime];

    self.btnCancle = [UIButton new];
    self.btnCancle.frame = CGRectMake(SCREEN_W - 30, 0  , 30, 30);
    [ self.btnCancle addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [ self.btnCancle setImage:[UIImage imageNamed:@"Cancle"] forState:UIControlStateNormal];

    
    self.payStylePicker.frame = CGRectMake(0, 30, SCREEN_W, 110);
    
    [self.viTime addSubview:self.payStylePicker];

    [self.viTime addSubview:self.btnCancle];



}

- (void)bindModel {


    self.capacityEntry.carryGoodsTime = @"06:00 - 08:00";
    self.capacityEntry.payStyle = @"预付款";


        self.capacityEntry.contactInfo.startID = @"-1";
        self.capacityEntry.contactInfo.startContacts = @"请选择";
        self.capacityEntry.contactInfo.startContactsPhone = @"";
        self.capacityEntry.contactInfo.startAddress = @"";
        self.capacityEntry.contactInfo.endID = @"-1";
        self.capacityEntry.contactInfo.endContacts = @"请选择";
        self.capacityEntry.contactInfo.endContactsPhone = @"";
        self.capacityEntry.contactInfo.endAddress = @"";


    self.arrTime = @[@"06:00 - 08:00",@"08:00 - 18:00",@"18:00 - 21:00",@"21:00 - 06:00"];

    self.isShow = NO;
}

- (void) viHeadMake {

    self.viAddress.frame = CGRectMake(0, 0, SCREEN_W, 87*2);
    [self.viHead addSubview:self.viAddress];


    self.btnAddAddress1.frame = CGRectMake(0, 0, SCREEN_W, 87);
    [self.viHead addSubview:self.btnAddAddress1];

    self.btnAddAddress2.frame = CGRectMake(0, 87, SCREEN_W, 87);
    [self.viHead addSubview:self.btnAddAddress2];


    [self viAddressMake];



    self.viTransportation.frame  =CGRectMake(0, self.viAddress.bottom + 10, SCREEN_W, 110);
    [self viTransportationmake];
    [self.viHead addSubview:self.viTransportation];

    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
    [self viMessageMake];

    self.viMessage.hidden = YES;
    [self.viHead addSubview:self.viMessage];

}

- (void) viAddressMake {

//    UIImageView *ivAddress = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address"]];
//    ivAddress.frame = CGRectMake(20, 15, 10, 11);
//    [self.viAddress addSubview:ivAddress];
//
//    UILabel *lbAddress = [UILabel new];
//    lbAddress.frame = CGRectMake(ivAddress.right + 10, 10, 120, 20);
//    lbAddress.text = @"设置地址信息";
//    lbAddress.textColor = APP_COLOR_GRAY_TEXT_1;
//    lbAddress.font = [UIFont systemFontOfSize:14];
//    [self.viAddress addSubview:lbAddress];
//
//    UIImageView *ivArror = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell"]];
//    ivArror.frame = CGRectMake(SCREEN_W-20, 15.5, 7, 13);
//    [self.viAddress addSubview:ivArror];
//
//    UIImageView *viLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colorLine"]];
//    viLine.frame = CGRectMake(0, 43, SCREEN_W, 1);
//    [self.viAddress addSubview:viLine];




    self.cell1 = [AddressTableViewCell new];
    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil];
    self.cell1 = [array1 objectAtIndex:0];

    self.cell1.frame = CGRectMake(0, 0, SCREEN_W, 87);
    self.cell1.lbName.text = self.capacityEntry.contactInfo.startContacts;
    self.cell1.lbPhone.text = self.capacityEntry.contactInfo.startContactsPhone;
    self.cell1.laAddress.text = self.capacityEntry.contactInfo.startAddress;
    [self.viAddress addSubview:self.cell1];



    self.cell2 = [AddressTableViewCell new];
    NSArray *array2 = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil];
    self.cell2 = [array2 objectAtIndex:0];
    self.cell2.lbName.text = self.capacityEntry.contactInfo.endContacts;
    self.cell2.lbPhone.text = self.capacityEntry.contactInfo.endContactsPhone;
    self.cell2.laAddress.text = self.capacityEntry.contactInfo.endAddress;
    self.cell2.lbAddressType.text = @"收";

    self.cell2.frame = CGRectMake(0, 87, SCREEN_W, 87);
    [self.viAddress addSubview:self.cell2];


    if (imageView) {
        [imageView removeFromSuperview];
    }
    imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:[@"colorLine" adS]];
    imageView.frame = CGRectMake(0, self.viAddress.bottom - 2, SCREEN_W, 2);
    [self.viAddress addSubview:imageView];
}

- (void) viTransportationmake {

    UIImageView *ivTransport = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s1"]];
    ivTransport.frame = CGRectMake(20, 20, 70, 70);
    [self.viTransportation addSubview:ivTransport];

    UILabel *lbTranspor1 = [self labelWithText:[NSString stringWithFormat:@"%@ — %@",self.capacityEntry.startPlace.name,self.capacityEntry.endPlace.name] WithFont:[UIFont systemFontOfSize:16] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTranspor1.frame = CGRectMake(ivTransport.right + 10, 20, SCREEN_W - ivTransport.right - 10, 20);
    [self.viTransportation addSubview:lbTranspor1];

    UILabel *lbTranspor2 = [self labelWithText:[NSString stringWithFormat:@"%i日送达",[self.capacityEntry.transportationModel.expectTime intValue]/1440] WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbTranspor2.frame = CGRectMake(ivTransport.right + 10, lbTranspor1.bottom + 8, SCREEN_W - ivTransport.right - 10, 20);
    [self.viTransportation addSubview:lbTranspor2];

    _btnUpAndDown = [UIButton new];
    [_btnUpAndDown setImage:[UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];
    [_btnUpAndDown setTitle:@" 详细" forState:UIControlStateNormal];
    [_btnUpAndDown setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    _btnUpAndDown.frame = CGRectMake(SCREEN_W - 80, lbTranspor2.bottom + 8, 60, 20);
    [_btnUpAndDown addTarget:self action:@selector(upAndDownAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnUpAndDown.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.viTransportation addSubview:_btnUpAndDown];

    UILabel *lbTranspor3 = [UILabel new];
    lbTranspor3.frame = CGRectMake(ivTransport.right + 10, lbTranspor2.bottom + 8, SCREEN_W - ivTransport.right - 10, 20);

    lbTranspor3.text = [NSString stringWithFormat:@"￥%.2f起",[self.capacityEntry.transportationModel.ticketTotal floatValue]];

    lbTranspor3.font = [UIFont systemFontOfSize:16];
    lbTranspor3.textColor = APP_COLOR_RED1;

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:lbTranspor3.text];

    NSUInteger loc = lbTranspor3.text.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 4, 4)];

    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:APP_COLOR_GRAY_TEXT_1

                          range:NSMakeRange(loc - 1, 1)];

    lbTranspor3.attributedText = AttributedStr;
    [self.viTransportation addSubview:lbTranspor3];


}

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"箱型箱类",
                                 @"货物名称",
                                 @"用箱数量",
                                 @"自备箱",
                                 @"发货日期",
                                 @"增值服务"];
    NSArray *arrMessage = @[self.capacityEntry.box.name,self.capacityEntry.goodsInfo.name,self.capacityEntry.boxNum,self.capacityEntry.isOwnBox,self.capacityEntry.stStartTime,self.capacityEntry.serviceWay];

    CGFloat boom = 10;


    for (int i =0; i<6; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }



}

- (void) addressManagerAction1 {

    AddressManagerViewController *vc = [AddressManagerViewController new];
    vc.title = @"起运地";
    vc.type = @"1";
    vc.stCity = self.capacityEntry.startPlace.name;
    vc.cityCode = self.capacityEntry.startPlace.code;
    if (self.startContactInfo) {
        vc.currentInfo = self.startContactInfo;
    }


    [self.navigationController pushViewController:vc animated:YES];
    WS(ws);
    [vc returnInfo:^(AddressInfo *info) {
        if (info) {
            ws.capacityEntry.contactInfo.startID = info.ID;
            ws.capacityEntry.contactInfo.startContacts = info.contacts;
            ws.capacityEntry.contactInfo.startContactsPhone = @"";
            ws.capacityEntry.contactInfo.startContactsPhone = info.contactsPhone;
            ws.capacityEntry.contactInfo.startAddress = info.address;
            ws.startContactInfo = info;
            ws.cell1.lbName.text = ws.capacityEntry.contactInfo.startContacts;
            ws.cell1.lbPhone.text = ws.capacityEntry.contactInfo.startContactsPhone;
            ws.cell1.laAddress.text = ws.capacityEntry.contactInfo.startAddress;
            ws.cell2.lbName.text = ws.capacityEntry.contactInfo.endContacts;
            ws.cell2.lbPhone.text = ws.capacityEntry.contactInfo.endContactsPhone;
            ws.cell2.laAddress.text = ws.capacityEntry.contactInfo.endAddress;

            if(![ws.capacityEntry.contactInfo.endID isEqualToString:@"-1"]) {
                OrderViewModel *vm = [OrderViewModel new];
                WS(ws);
                [vm getOrderPriceWithCapacityInfo:ws.capacityEntry callback:^(PriceInfo *priceInfo) {

                    ws.capacityEntry.priceInfo = priceInfo;

                    ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
                    ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.startAdditionPrice];
                    ws.lbAdditionServicePrice.attributedText = [self moneyStyleWith:priceInfo.endAdditionPrice];
                    ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
                    
                    
                    
                }];
            }

        }
    }];

}

- (void) addressManagerAction2 {

    AddressManagerViewController *vc = [AddressManagerViewController new];
    vc.title = @"抵运地";
    vc.type = @"2";
    vc.stCity = self.capacityEntry.endPlace.name;
    vc.cityCode = self.capacityEntry.endPlace.code;
    if (self.endContactInfo) {
        vc.currentInfo = self.endContactInfo;
    }

    [self.navigationController pushViewController:vc animated:YES];

    WS(ws);
    [vc returnInfo:^(AddressInfo *info) {
        if (info) {
            ws.capacityEntry.contactInfo.endID = info.ID;
            ws.capacityEntry.contactInfo.endContacts = info.contacts;
            ws.capacityEntry.contactInfo.endContactsPhone = @"";
            ws.capacityEntry.contactInfo.endContactsPhone = info.contactsPhone;
            ws.capacityEntry.contactInfo.endAddress = info.address;
            ws.endContactInfo = info;
            ws.cell1.lbName.text = ws.capacityEntry.contactInfo.startContacts;
            ws.cell1.lbPhone.text = ws.capacityEntry.contactInfo.startContactsPhone;
            ws.cell1.laAddress.text = ws.capacityEntry.contactInfo.startAddress;
            ws.cell2.lbName.text = ws.capacityEntry.contactInfo.endContacts;
            ws.cell2.lbPhone.text = ws.capacityEntry.contactInfo.endContactsPhone;
            ws.cell2.laAddress.text = ws.capacityEntry.contactInfo.endAddress;
            if(![ws.capacityEntry.contactInfo.startID isEqualToString:@"-1"]) {
                OrderViewModel *vm = [OrderViewModel new];
                WS(ws);
                [vm getOrderPriceWithCapacityInfo:ws.capacityEntry callback:^(PriceInfo *priceInfo) {

                    ws.capacityEntry.priceInfo = priceInfo;

                    ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
                    ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.startAdditionPrice];
                    ws.lbAdditionServicePrice.attributedText = [self moneyStyleWith:priceInfo.endAdditionPrice];
                    ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];



                }];
            }
        }

    }];
    
}

- (void) cancelAction {

    self.viTime.hidden = YES;

}

//金钱富文本

- (NSMutableAttributedString *)moneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@",ticketTotalPrice, self.capacityEntry.boxNum];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                       value:APP_COLOR_GRAY2
                       range:NSMakeRange(loc - 2, 2)];
    
    return AttributedStr;
    
}

//金钱富文本

- (NSMutableAttributedString *)totalMoneyStyleWith:(NSString *)st {

    float tatal = [st floatValue];
    st = [NSString stringWithFormat:@"%.2f",tatal];
    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    if ([st doubleValue] == 0) {
        ticketTotalPrice = @"0";
    }
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@",ticketTotalPrice];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 3, 3)];
    return AttributedStr;




//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value:APP_COLOR_GRAY2
//                          range:NSMakeRange(loc - 2, 2)];


    
}

/**
 *  保险展开
 *
 */

- (void)insuranceAction:(UISwitch *)sw {

    if ([sw isOn]) {
        self.insurance = 2;
        [self.tvList reloadData];
    }else {
        self.insurance = 1;
        [self.tvList reloadData];

    }

}

/**
 *  发票展开
 *
 */

- (void)invoiceAction:(UISwitch *)sw {

    if ([sw isOn]) {
        self.invoice = 2;

        self.capacityEntry.invoice = self.defaultInvoiceModel;
        [self.tvList reloadData];
    }else {
        self.invoice = 1;
        self.capacityEntry.invoice = nil;
        [self.tvList reloadData];

    }
    
}


/**
 *  备注展开
 *
 */
- (void)remarksAction:(UISwitch *)sw {

    if ([sw isOn]) {
        self.remarks = 2;

        [self.tvList reloadData];
    }else {
        self.remarks = 1;
        self.capacityEntry.remark  =@"";
        [self.tvList reloadData];

    }
    
}

- (void)moneyDetailAction {

    self.viBackground.hidden = !self.viBackground.hidden;
    self.viPrice.hidden = !self.viPrice.hidden;
    if ([self.viBackground isHidden]) {
          [self.btnMoneyDetail setImage: [UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
    }else {

        [self.btnMoneyDetail setImage: [UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];

    }
}

- (void)submitOrderAction {


    if(!self.capacityEntry.remark) {

        self.capacityEntry.remark  =@"";

    }



        if ([self.capacityEntry.contactInfo.startID intValue]==-1) {

            [[Toast shareToast]makeText:@"起运地未选择" aDuration:1];
        }

        else if ([self.capacityEntry.contactInfo.endID intValue]==-1) {

            [[Toast shareToast]makeText:@"抵运地未选择" aDuration:1];

        }else if(self.invoice == 2 && !self.capacityEntry.invoice){

            [[Toast shareToast]makeText:@"未选择发票" aDuration:1];


        }else{

            self.viBackground.hidden = YES;
            self.viPrice.hidden = YES;
            [self.btnMoneyDetail setImage: [UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];

            PerfectOrderViewController *vc = (PerfectOrderViewController *)[self getControllerWithBaseName:@"PerfectOrderViewController"];


            vc.capacityEntry = self.capacityEntry;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }

}

- (void)upAndDownAction:(UIButton *)btn {

    self.isShow = !self.isShow;
    self.viMessage.hidden = !self.isShow;

    if (self.isShow) {

        [btn setImage:[UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];

        self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150);

    }else {

        [btn setImage:[UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];

         self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296);

    }

    self.tvList.tableHeaderView = self.viHead;

}

/**
 *
 *  @param tableView delegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    if (section == 2) {
//        return self.insurance;
//    }

    if (section == 2) {
        return self.invoice;
    }

    if (section == 3) {
        return self.remarks;
    }

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if(indexPath.section == 0){
        static NSString *CellIdentifier = @"Celled";
        OrderSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderSwitchTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.lbTitle.text = @"取货时间";
        cell.lbDetail.text = self.capacityEntry.carryGoodsTime;


        
        return cell;

    }

    if(indexPath.section == 1){
        static NSString *CellIdentifier = @"Celled";
        OrderSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderSwitchTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.lbTitle.text = @"支付类型";
        cell.lbDetail.text = self.capacityEntry.payStyle;


        return cell;
        
    }

//    //===============保险==================
//
//     if(indexPath.section == 2){
//
//         if (indexPath.row == 0) {
//             static NSString *CellIdentifier = @"Celled";
//             OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//             NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
//             cell = [array objectAtIndex:0];
//             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//             cell.lbTitle.text = @"货物保险";
//             cell.lbText.text  =@"3‰费率  0元";
//             [cell.switchButton addTarget:self action:@selector(insuranceAction:) forControlEvents:UIControlEventValueChanged];
//             if (self.insurance == 1) {
//                 [cell.switchButton setOn:NO];
//             }else {
//
//                 [cell.switchButton setOn:YES];
//
//             }
//
//             return cell;
//
//         }
//
//         if (indexPath.row == 1) {
//             static NSString *CellIdentifier = @"Celled";
//             OrderInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//             NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
//             cell = [array objectAtIndex:0];
//             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//             cell.lbTitle.text = @"保价定金";
//             cell.tvText.text = @"30万";
//             
//             
//             return cell;
//
//         }
//
//}

    //===============发票==================

    if(indexPath.section == 2){


        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"Celled";
            OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.lbTitle.text = @"发票信息";
            cell.lbText.text  =@"";
            [cell.switchButton addTarget:self action:@selector(invoiceAction:) forControlEvents:UIControlEventValueChanged];
            if (self.invoice == 1) {
                [cell.switchButton setOn:NO];
            }else {

                [cell.switchButton setOn:YES];

            }

            return cell;
            
        }


        if(indexPath.row == 1){
            static NSString *CellIdentifier = @"Celled";
            OrderSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderSwitchTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.lbTitle.text = @"发票类型";
            if (self.capacityEntry.invoice) {
                cell.lbDetail.text = self.capacityEntry.invoice.title;
            }else {

                cell.lbDetail.text = @"未选择";

            }

            cell.lbDetail.textColor = APP_COLOR_GRAY2;

            
            return cell;
            
        }

//        if(indexPath.row == 3){
//            static NSString *CellIdentifier = @"Celled";
//            OrderSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderSwitchTableViewCell" owner:self options:nil];
//            cell = [array objectAtIndex:0];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            cell.lbTitle.text = @"项目";
//            cell.lbDetail.text = @"建材";
//
//
//            return cell;
//
//        }



    }

     //===============备注==================

    if(indexPath.section == 3){

        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"Celled";
            OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.lbTitle.text = @"备注";
            cell.lbText.text  =@"";
            [cell.switchButton addTarget:self action:@selector(remarksAction:) forControlEvents:UIControlEventValueChanged];
            if (self.remarks == 1) {
                [cell.switchButton setOn:NO];
            }else {

                [cell.switchButton setOn:YES];

            }

            return cell;

        }

        if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"Celled";
            OrderInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.lbTitle.text = @"";
            cell.tfText.placeholder = @"请输入备注";
            if (self.capacityEntry.remark) {
                cell.tfText.text = self.capacityEntry.remark;
            }
            cell.tfText.delegate = self;
            cell.tfText.tag = 13;
            cell.tfText.hidden = NO;
            cell.tvText.hidden = YES;


            return cell;
            
        }
    }



    return nil;


}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {


    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2 &&indexPath.row == 1) {

        InvoiceListViewController *vc  =[InvoiceListViewController new];
        vc.currentmodel = self.capacityEntry.invoice;

        [self.navigationController pushViewController:vc animated:YES];

        WS(ws);

        //选择发票回调发票
        [vc returnText:^(InvoiceModel *invoiceModel) {
            if (invoiceModel) {
                ws.capacityEntry.invoice = invoiceModel;
                [ws.tvList reloadData];
            }

        }];
        
    }

    if (indexPath.row ==0 && indexPath.section == 0) {
        //选择取货时间

        self.viTime.hidden = NO;
    }

    if (indexPath.row ==0 && indexPath.section == 1) {

        if([self.capacityEntry.payStyle isEqualToString:@"预付款"]){

            //支付类型
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"付款类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预付款（已选）",@"后付款", nil];

            [sheet showInView:self.view];

        }else if([self.capacityEntry.payStyle isEqualToString:@"后付款"]){
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"付款类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预付款",@"后付款（已选）", nil];

            [sheet showInView:self.view];

        }else {

            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"付款类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预付款",@"后付款", nil];

            [sheet showInView:self.view];

        }



    }




    
}


/**
 *  pickdelegate
 *
 */

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return self.arrTime.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [self.arrTime objectAtIndex:row];
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //self.transpoetation.carInfo = [self.arrCar objectAtIndex:row];
    self.capacityEntry.carryGoodsTime = [self.arrTime objectAtIndex:row];

    [self.tvList reloadData];
}


/**
 *
 *  @param textField delegate
 *
 */

- (void)textFieldDidEndEditing:(UITextField *)textField;{

    //11、总重量

    if( textField.tag == 11){

        self.capacityEntry.totalWeight = textField.text;
        [self getData];


    }


    //12、总体积

    if( textField.tag == 12){

        self.capacityEntry.volume = textField.text;
        [self getData];
        
        
    }

    //13、备注

    if( textField.tag == 13){

        self.capacityEntry.remark = textField.text;
        [self.tvList reloadData];


    }
    
}



/**
 *  UIActionSheetDelegate
 *

 */

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {


    self.capacityEntry.payStyle = buttonIndex==0?@"预付款":@"后付款";
    [self.tvList reloadData];


}


/**
 *  getter
 */

- (UIView *)viAddress {
    if (!_viAddress) {
        _viAddress = [UIView new];
        _viAddress.backgroundColor = [UIColor whiteColor];

    }
    return _viAddress;
}

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    }
    return _viHead;
}

- (UIView *)viTransportation {
    if (!_viTransportation) {
        _viTransportation = [UIView new];
        _viTransportation.backgroundColor = [UIColor whiteColor];
    }
    return _viTransportation;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _tvList = tableView;
    }
    return _tvList;
}

- (UILabel *)lbBotoom {

    if (!_lbBotoom) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"￥1200";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];



        _lbBotoom = label;
    }
    return _lbBotoom;
}

- (UIButton *)btnMoneyDetail {

    if (!_btnMoneyDetail) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"明细" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setImage: [UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moneyDetailAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];

        _btnMoneyDetail = button;
    }
    return _btnMoneyDetail;
}

- (UIButton *)btnSubmitOrder {
    if (!_btnSubmitOrder) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        [button addTarget:self action:@selector(submitOrderAction) forControlEvents:UIControlEventTouchUpInside];

        _btnSubmitOrder = button;
    }
    return _btnSubmitOrder;
}

- (UIButton *)btnAddAddress1 {

    if (!_btnAddAddress1) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addressManagerAction1) forControlEvents:UIControlEventTouchUpInside];
//        if ([self.capacityEntry.serviceWay isEqualToString:@"点到点"]||[self.capacityEntry.serviceWay isEqualToString:@"点到门"]) {
//
//            button.enabled = NO;
//        }

        


        _btnAddAddress1 = button;
    }
    return _btnAddAddress1;
}

- (UIButton *)btnAddAddress2 {

    if (!_btnAddAddress2) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addressManagerAction2) forControlEvents:UIControlEventTouchUpInside];
//        if ([self.capacityEntry.serviceWay isEqualToString:@"点到点"]||[self.capacityEntry.serviceWay isEqualToString:@"门到点"]) {
//
//            button.enabled = NO;
//        }


        _btnAddAddress2 = button;
    }
    return _btnAddAddress2;
}

- (UIView *)viMessage {
    if (!_viMessage) {
        _viMessage = [UIView new];
        _viMessage.backgroundColor = [UIColor whiteColor];

    }
    return _viMessage;
}

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.alpha = 0.7;
        _viBackground.backgroundColor = [UIColor blackColor];

    }
    return _viBackground;
}

- (UIView *)viPrice {
    if (!_viPrice) {
        _viPrice = [UIView new];
        _viPrice.backgroundColor = [UIColor whiteColor];

    }
    return _viPrice;
}

- (UIPickerView *)payStylePicker {
    if (!_payStylePicker) {
        _payStylePicker = [UIPickerView new];
        _payStylePicker.delegate = self;
        _payStylePicker.dataSource = self;
        _payStylePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return _payStylePicker;
}

- (UIView *)viTime {

    if (!_viTime) {
        _viTime = [UIView new];
        _viTime.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _viTime.hidden = YES;
        
    }
    return _viTime;
}




@end

#pragma mark - 集装箱运力
@implementation SubmiteOrderViewController_Container : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"箱型箱类",@"货物名称",@"用箱数量",@"自备箱",@"发货日期",@"增值服务"];
    NSArray *arrMessage = @[self.capacityEntry.box.name,self.capacityEntry.goodsInfo.name,self.capacityEntry.boxNum,self.capacityEntry.isOwnBox,self.capacityEntry.stStartTime,self.capacityEntry.serviceWay];

    CGFloat boom = 10;


    for (int i =0; i<6; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;
        
    }
    
    
    
}

@end
#pragma mark - 散堆装运力
@implementation SubmiteOrderViewController_InBulk : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle;
    NSArray *arrMessage;

    if (self.capacityEntry.volume.length >0 && self.capacityEntry.weight.length >0) {

       arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"总重量",@"总体积"];
       arrMessage = @[@"散堆装",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],[NSString stringWithFormat:@"%@m³",self.capacityEntry.volume]];
    }

    if (self.capacityEntry.weight.length == 0) {

        arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"总体积"];
        arrMessage = @[@"散堆装",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,[NSString stringWithFormat:@"%@m³",self.capacityEntry.volume]];
    }

    if (self.capacityEntry.volume.length == 0) {

        arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"总重量"];
        arrMessage = @[@"散堆装",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight]];
    }


    CGFloat boom = 10;


    for (int i =0; i<arrMessageTitle.count; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }

//    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150 +54);

//    UIView *viInpute = [UIView new];
//    viInpute.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    viInpute.frame = CGRectMake(0, self.viMessage.bottom, SCREEN_W, 70 + 64);
//    OrderInputTableViewCell *cell = [ OrderInputTableViewCell new];
//    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
//    cell = [array objectAtIndex:0];
//    cell.frame  =CGRectMake(0, 20, SCREEN_W, 44);
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.lbTitle.text = @"总重量";
//    cell.tfText.placeholder = @"单位（吨）";
//    cell.tvText.hidden = YES;
//    cell.tfText.hidden = NO;
//    cell.tfText.delegate = self;
//    cell.tfText.tag = 11;
//    cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
//    [viInpute addSubview:cell];
//
//
//    OrderInputTableViewCell *cell1 = [ OrderInputTableViewCell new];
//    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
//    cell1 = [array1 objectAtIndex:0];
//    cell1.frame  =CGRectMake(0, 74, SCREEN_W, 44);
//    cell1.backgroundColor = [UIColor whiteColor];
//    cell1.lbTitle.text = @"总体积";
//    cell1.tfText.placeholder = @"单位（立方米）";
//    cell1.tvText.hidden = YES;
//    cell1.tfText.hidden = NO;
//    cell1.tfText.delegate = self;
//    cell1.tfText.tag = 12;
//    cell1.tfText.keyboardType = UIKeyboardTypeNumberPad;
//    [viInpute addSubview:cell1];
//
//
//    [self.viHead addSubview:viInpute];

//    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
//
//    self.tvList.tableHeaderView = self.viHead;

//    self.btnUpAndDown.hidden = YES;
//    self.viMessage.hidden = NO;
//    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296);

}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lb2.text = @"服务费";
        ws.lb3.text = @"";

        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionServicePrice.hidden = YES;



    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {
        
        
        ws.defaultInvoiceModel = info;
        
        
    }];

//    self.btnUpAndDown.hidden = YES;
//    self.viMessage.hidden = NO;
//    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
//    [self.viHead addSubview:self.viMessage];
//    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
//
//    self.tvList.tableHeaderView = self.viHead;
}


//金钱富文本

- (NSMutableAttributedString *)moneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@",ticketTotalPrice, self.capacityEntry.weight];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY2
                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;
    
}

- (NSMutableAttributedString *)moneyStyleWith1:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@ x系数",ticketTotalPrice, self.capacityEntry.volume];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY2
                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;
    
}

- (NSMutableAttributedString *)moneyStyleWith2:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@",ticketTotalPrice];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 3, 3)];



    return AttributedStr;
    
}

- (void) addressManagerAction1 {

    AddressManagerViewController *vc = [AddressManagerViewController new];
    vc.title = @"起运地";
    vc.type = @"1";
    vc.stCity = self.capacityEntry.startPlace.name;
    vc.cityCode = self.capacityEntry.startPlace.code;
    if (self.startContactInfo) {
        vc.currentInfo = self.startContactInfo;
    }


    [self.navigationController pushViewController:vc animated:YES];
    WS(ws);
    [vc returnInfo:^(AddressInfo *info) {
        if (info) {
            ws.capacityEntry.contactInfo.startID = info.ID;
            ws.capacityEntry.contactInfo.startContacts = info.contacts;
            ws.capacityEntry.contactInfo.startContactsPhone = @"";
            ws.capacityEntry.contactInfo.startContactsPhone = info.contactsPhone;
            ws.capacityEntry.contactInfo.startAddress = info.address;
            ws.startContactInfo = info;
            ws.cell1.lbName.text = ws.capacityEntry.contactInfo.startContacts;
            ws.cell1.lbPhone.text = ws.capacityEntry.contactInfo.startContactsPhone;
            ws.cell1.laAddress.text = ws.capacityEntry.contactInfo.startAddress;
            ws.cell2.lbName.text = ws.capacityEntry.contactInfo.endContacts;
            ws.cell2.lbPhone.text = ws.capacityEntry.contactInfo.endContactsPhone;
            ws.cell2.laAddress.text = ws.capacityEntry.contactInfo.endAddress;

            if(![ws.capacityEntry.contactInfo.endID isEqualToString:@"-1"]) {
                OrderViewModel *vm = [OrderViewModel new];
                WS(ws);
                [vm getOrderPriceWithCapacityInfo:ws.capacityEntry callback:^(PriceInfo *priceInfo) {

                    ws.capacityEntry.priceInfo = priceInfo;

                    ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
                    ws.lbAdditionPrice.attributedText = [self moneyStyleWith2:priceInfo.additionPrice];

                    ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];

                    if([priceInfo.stackType isEqualToString:@"v"]){

                        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith1:priceInfo.ticketTotalPrice];
                        ws.lbAdditionPrice.attributedText = [self moneyStyleWith1:priceInfo.additionPrice];

                        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];

                    }



                }];
            }

        }
    }];

}

- (void) addressManagerAction2 {

    AddressManagerViewController *vc = [AddressManagerViewController new];
    vc.title = @"抵运地";
    vc.type = @"2";
    vc.stCity = self.capacityEntry.endPlace.name;
    vc.cityCode = self.capacityEntry.endPlace.code;
    if (self.endContactInfo) {
        vc.currentInfo = self.endContactInfo;
    }

    [self.navigationController pushViewController:vc animated:YES];

    WS(ws);
    [vc returnInfo:^(AddressInfo *info) {
        if (info) {
            ws.capacityEntry.contactInfo.endID = info.ID;
            ws.capacityEntry.contactInfo.endContacts = info.contacts;
            ws.capacityEntry.contactInfo.endContactsPhone = @"";
            ws.capacityEntry.contactInfo.endContactsPhone = info.contactsPhone;
            ws.capacityEntry.contactInfo.endAddress = info.address;
            ws.endContactInfo = info;
            ws.cell1.lbName.text = ws.capacityEntry.contactInfo.startContacts;
            ws.cell1.lbPhone.text = ws.capacityEntry.contactInfo.startContactsPhone;
            ws.cell1.laAddress.text = ws.capacityEntry.contactInfo.startAddress;
            ws.cell2.lbName.text = ws.capacityEntry.contactInfo.endContacts;
            ws.cell2.lbPhone.text = ws.capacityEntry.contactInfo.endContactsPhone;
            ws.cell2.laAddress.text = ws.capacityEntry.contactInfo.endAddress;
            if(![ws.capacityEntry.contactInfo.startID isEqualToString:@"-1"]) {
                OrderViewModel *vm = [OrderViewModel new];
                WS(ws);
                [vm getOrderPriceWithCapacityInfo:ws.capacityEntry callback:^(PriceInfo *priceInfo) {

                    ws.capacityEntry.priceInfo = priceInfo;

                    ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
                    ws.lbAdditionPrice.attributedText = [self moneyStyleWith2:priceInfo.additionPrice];

                    ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
                    
                    
                    
                }];
            }
        }
        
    }];
    
}



@end

#pragma mark - 三农化肥运力
@implementation SubmiteOrderViewController_Fertilizer : SubmiteOrderViewController



- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"总重量"];
    NSArray *arrMessage = @[@"三农",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight]];

    CGFloat boom = 10;


    for (int i =0; i<arrMessageTitle.count; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150 +54);

    //    UIView *viInpute = [UIView new];
    //    viInpute.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    viInpute.frame = CGRectMake(0, self.viMessage.bottom, SCREEN_W, 70 + 64);
    //    OrderInputTableViewCell *cell = [ OrderInputTableViewCell new];
    //    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell = [array objectAtIndex:0];
    //    cell.frame  =CGRectMake(0, 20, SCREEN_W, 44);
    //    cell.backgroundColor = [UIColor whiteColor];
    //    cell.lbTitle.text = @"总重量";
    //    cell.tfText.placeholder = @"单位（吨）";
    //    cell.tvText.hidden = YES;
    //    cell.tfText.hidden = NO;
    //    cell.tfText.delegate = self;
    //    cell.tfText.tag = 11;
    //    cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell];
    //
    //
    //    OrderInputTableViewCell *cell1 = [ OrderInputTableViewCell new];
    //    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell1 = [array1 objectAtIndex:0];
    //    cell1.frame  =CGRectMake(0, 74, SCREEN_W, 44);
    //    cell1.backgroundColor = [UIColor whiteColor];
    //    cell1.lbTitle.text = @"总体积";
    //    cell1.tfText.placeholder = @"单位（立方米）";
    //    cell1.tvText.hidden = YES;
    //    cell1.tfText.hidden = NO;
    //    cell1.tfText.delegate = self;
    //    cell1.tfText.tag = 12;
    //    cell1.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell1];
    //
    //
    //    [self.viHead addSubview:viInpute];

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296);

}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lb2.text = @"服务费";
        ws.lb3.text = @"";

        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionServicePrice.hidden = YES;



    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {


        ws.defaultInvoiceModel = info;


    }];

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
    //    [self.viHead addSubview:self.viMessage];
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;
}

//金钱富文本

- (NSMutableAttributedString *)moneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@",ticketTotalPrice, self.capacityEntry.weight];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY2
                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;
    
}

@end

#pragma mark - 一带一路运力
@implementation SubmiteOrderViewController_OneBeltOneRoad : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"箱型箱类",@"货物名称",@"用箱数量",@"自备箱",@"发货日期",@"增值服务"];
    NSArray *arrMessage = @[self.capacityEntry.box.name,self.capacityEntry.goodsInfo.name,self.capacityEntry.boxNum,self.capacityEntry.isOwnBox,self.capacityEntry.stStartTime,self.capacityEntry.serviceWay];

    CGFloat boom = 10;


    for (int i =0; i<6; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;
        
    }
    
    
    
}

@end

#pragma mark - 冷链运力
@implementation SubmiteOrderViewController_ColdChain : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"箱数"];
    NSArray *arrMessage = @[@"冷链",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,self.capacityEntry.boxNum];

    CGFloat boom = 10;


    for (int i =0; i<arrMessageTitle.count; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150 +54);

    //    UIView *viInpute = [UIView new];
    //    viInpute.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    viInpute.frame = CGRectMake(0, self.viMessage.bottom, SCREEN_W, 70 + 64);
    //    OrderInputTableViewCell *cell = [ OrderInputTableViewCell new];
    //    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell = [array objectAtIndex:0];
    //    cell.frame  =CGRectMake(0, 20, SCREEN_W, 44);
    //    cell.backgroundColor = [UIColor whiteColor];
    //    cell.lbTitle.text = @"总重量";
    //    cell.tfText.placeholder = @"单位（吨）";
    //    cell.tvText.hidden = YES;
    //    cell.tfText.hidden = NO;
    //    cell.tfText.delegate = self;
    //    cell.tfText.tag = 11;
    //    cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell];
    //
    //
    //    OrderInputTableViewCell *cell1 = [ OrderInputTableViewCell new];
    //    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell1 = [array1 objectAtIndex:0];
    //    cell1.frame  =CGRectMake(0, 74, SCREEN_W, 44);
    //    cell1.backgroundColor = [UIColor whiteColor];
    //    cell1.lbTitle.text = @"总体积";
    //    cell1.tfText.placeholder = @"单位（立方米）";
    //    cell1.tvText.hidden = YES;
    //    cell1.tfText.hidden = NO;
    //    cell1.tfText.delegate = self;
    //    cell1.tfText.tag = 12;
    //    cell1.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell1];
    //
    //
    //    [self.viHead addSubview:viInpute];

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296);

}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lb2.text = @"服务费";
        ws.lb3.text = @"";

        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionServicePrice.hidden = YES;



    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {


        ws.defaultInvoiceModel = info;


    }];

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
    //    [self.viHead addSubview:self.viMessage];
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;
}


@end

#pragma mark - 大件运力
@implementation SubmiteOrderViewController_Big : SubmiteOrderViewController

- (void) viHeadMake {

    self.viAddress.frame = CGRectMake(0, 0, SCREEN_W, 87*2);
    [self.viHead addSubview:self.viAddress];


    self.btnAddAddress1.frame = CGRectMake(0, 0, SCREEN_W, 87);
    [self.viHead addSubview:self.btnAddAddress1];

    self.btnAddAddress2.frame = CGRectMake(0, 87, SCREEN_W, 87);
    [self.viHead addSubview:self.btnAddAddress2];


    [self viAddressMake];



    self.viTransportation.frame  =CGRectMake(0, self.viAddress.bottom + 10, SCREEN_W, 110);
    [self viTransportationmake];
    [self.viHead addSubview:self.viTransportation];

    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 200);
    [self viMessageMake];

    self.viMessage.hidden = YES;
    [self.viHead addSubview:self.viMessage];
    
}

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始", @"重量",@"件数",@"最大单件重量",@"长宽高"];
    NSArray *arrMessage = @[@"大件",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight],self.capacityEntry.boxNum,[NSString stringWithFormat:@"%@吨",self.capacityEntry.biggestWeight],[NSString stringWithFormat:@"%@cm、%@cm、%@cm",self.capacityEntry.longCm,self.capacityEntry.wideCm,self.capacityEntry.highCm]];


    CGFloat boom = 10;


    for (int i =0; i<arrMessageTitle.count; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }



}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lb2.text = @"服务费";
        ws.lb3.text = @"";

        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionServicePrice.hidden = YES;



    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {


        ws.defaultInvoiceModel = info;


    }];

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
    //    [self.viHead addSubview:self.viMessage];
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;
}


- (void) addressManagerAction1 {

    AddressManagerViewController *vc = [AddressManagerViewController new];
    vc.title = @"起运地";
    vc.type = @"1";
    vc.stCity = self.capacityEntry.startPlace.name;
    vc.cityCode = self.capacityEntry.startPlace.code;
    if (self.startContactInfo) {
        vc.currentInfo = self.startContactInfo;
    }


    [self.navigationController pushViewController:vc animated:YES];
    WS(ws);
    [vc returnInfo:^(AddressInfo *info) {
        if (info) {
            ws.capacityEntry.contactInfo.startID = info.ID;
            ws.capacityEntry.contactInfo.startContacts = info.contacts;
            ws.capacityEntry.contactInfo.startContactsPhone = @"";
            ws.capacityEntry.contactInfo.startContactsPhone = info.contactsPhone;
            ws.capacityEntry.contactInfo.startAddress = info.address;
            ws.startContactInfo = info;
            ws.cell1.lbName.text = ws.capacityEntry.contactInfo.startContacts;
            ws.cell1.lbPhone.text = ws.capacityEntry.contactInfo.startContactsPhone;
            ws.cell1.laAddress.text = ws.capacityEntry.contactInfo.startAddress;
            ws.cell2.lbName.text = ws.capacityEntry.contactInfo.endContacts;
            ws.cell2.lbPhone.text = ws.capacityEntry.contactInfo.endContactsPhone;
            ws.cell2.laAddress.text = ws.capacityEntry.contactInfo.endAddress;

            if(![ws.capacityEntry.contactInfo.endID isEqualToString:@"-1"]) {
                OrderViewModel *vm = [OrderViewModel new];
                WS(ws);
                [vm getOrderPriceWithCapacityInfo:ws.capacityEntry callback:^(PriceInfo *priceInfo) {

                    ws.capacityEntry.priceInfo = priceInfo;

                    ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
                    ws.lbAdditionPrice.attributedText = [self moneyStyleWith2:priceInfo.additionPrice];

                    ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];

                    if([priceInfo.stackType isEqualToString:@"v"]){

                        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith1:priceInfo.ticketTotalPrice];
                        ws.lbAdditionPrice.attributedText = [self moneyStyleWith1:priceInfo.additionPrice];

                        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];

                    }



                }];
            }

        }
    }];

}

- (void) addressManagerAction2 {

    AddressManagerViewController *vc = [AddressManagerViewController new];
    vc.title = @"抵运地";
    vc.type = @"2";
    vc.stCity = self.capacityEntry.endPlace.name;
    vc.cityCode = self.capacityEntry.endPlace.code;
    if (self.endContactInfo) {
        vc.currentInfo = self.endContactInfo;
    }

    [self.navigationController pushViewController:vc animated:YES];

    WS(ws);
    [vc returnInfo:^(AddressInfo *info) {
        if (info) {
            ws.capacityEntry.contactInfo.endID = info.ID;
            ws.capacityEntry.contactInfo.endContacts = info.contacts;
            ws.capacityEntry.contactInfo.endContactsPhone = @"";
            ws.capacityEntry.contactInfo.endContactsPhone = info.contactsPhone;
            ws.capacityEntry.contactInfo.endAddress = info.address;
            ws.endContactInfo = info;
            ws.cell1.lbName.text = ws.capacityEntry.contactInfo.startContacts;
            ws.cell1.lbPhone.text = ws.capacityEntry.contactInfo.startContactsPhone;
            ws.cell1.laAddress.text = ws.capacityEntry.contactInfo.startAddress;
            ws.cell2.lbName.text = ws.capacityEntry.contactInfo.endContacts;
            ws.cell2.lbPhone.text = ws.capacityEntry.contactInfo.endContactsPhone;
            ws.cell2.laAddress.text = ws.capacityEntry.contactInfo.endAddress;
            if(![ws.capacityEntry.contactInfo.startID isEqualToString:@"-1"]) {
                OrderViewModel *vm = [OrderViewModel new];
                WS(ws);
                [vm getOrderPriceWithCapacityInfo:ws.capacityEntry callback:^(PriceInfo *priceInfo) {

                    ws.capacityEntry.priceInfo = priceInfo;

                    ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
                    ws.lbAdditionPrice.attributedText = [self moneyStyleWith2:priceInfo.additionPrice];
                    
                    ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
                    
                    
                    
                }];
            }
        }
        
    }];
    
}


//金钱富文本

- (NSMutableAttributedString *)moneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@",ticketTotalPrice, self.capacityEntry.weight];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY2
                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;

}

- (NSMutableAttributedString *)moneyStyleWith1:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@ x系数",ticketTotalPrice, self.capacityEntry.volume];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY2
                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;

}

- (NSMutableAttributedString *)moneyStyleWith2:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@",ticketTotalPrice];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 3, 3)];
    
    
    
    return AttributedStr;
    
}

@end

#pragma mark - 商品车运力
@implementation SubmiteOrderViewController_ForCar : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"用车数量"];
    NSArray *arrMessage = @[@"商品车",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,self.capacityEntry.boxNum];

    CGFloat boom = 10;


    for (int i =0; i<arrMessageTitle.count; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150 +54);

    //    UIView *viInpute = [UIView new];
    //    viInpute.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    viInpute.frame = CGRectMake(0, self.viMessage.bottom, SCREEN_W, 70 + 64);
    //    OrderInputTableViewCell *cell = [ OrderInputTableViewCell new];
    //    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell = [array objectAtIndex:0];
    //    cell.frame  =CGRectMake(0, 20, SCREEN_W, 44);
    //    cell.backgroundColor = [UIColor whiteColor];
    //    cell.lbTitle.text = @"总重量";
    //    cell.tfText.placeholder = @"单位（吨）";
    //    cell.tvText.hidden = YES;
    //    cell.tfText.hidden = NO;
    //    cell.tfText.delegate = self;
    //    cell.tfText.tag = 11;
    //    cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell];
    //
    //
    //    OrderInputTableViewCell *cell1 = [ OrderInputTableViewCell new];
    //    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell1 = [array1 objectAtIndex:0];
    //    cell1.frame  =CGRectMake(0, 74, SCREEN_W, 44);
    //    cell1.backgroundColor = [UIColor whiteColor];
    //    cell1.lbTitle.text = @"总体积";
    //    cell1.tfText.placeholder = @"单位（立方米）";
    //    cell1.tvText.hidden = YES;
    //    cell1.tfText.hidden = NO;
    //    cell1.tfText.delegate = self;
    //    cell1.tfText.tag = 12;
    //    cell1.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell1];
    //
    //
    //    [self.viHead addSubview:viInpute];

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296);

}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lb2.text = @"服务费";
        ws.lb3.text = @"";

        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionServicePrice.hidden = YES;



    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {


        ws.defaultInvoiceModel = info;


    }];

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
    //    [self.viHead addSubview:self.viMessage];
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;
}


@end

#pragma mark - 液态运力
@implementation SubmiteOrderViewController_Liquid : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"货品类型",@"货物名称",@"增值服务",@"发货开始",@"总重量"];
    NSArray *arrMessage = @[@"液态",self.capacityEntry.goodsInfo.name,self.capacityEntry.serviceWay,self.capacityEntry.stStartTime,[NSString stringWithFormat:@"%@吨",self.capacityEntry.weight]];


    CGFloat boom = 10;


    for (int i =0; i<arrMessageTitle.count; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;

    }

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 150 +54);

    //    UIView *viInpute = [UIView new];
    //    viInpute.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    viInpute.frame = CGRectMake(0, self.viMessage.bottom, SCREEN_W, 70 + 64);
    //    OrderInputTableViewCell *cell = [ OrderInputTableViewCell new];
    //    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell = [array objectAtIndex:0];
    //    cell.frame  =CGRectMake(0, 20, SCREEN_W, 44);
    //    cell.backgroundColor = [UIColor whiteColor];
    //    cell.lbTitle.text = @"总重量";
    //    cell.tfText.placeholder = @"单位（吨）";
    //    cell.tvText.hidden = YES;
    //    cell.tfText.hidden = NO;
    //    cell.tfText.delegate = self;
    //    cell.tfText.tag = 11;
    //    cell.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell];
    //
    //
    //    OrderInputTableViewCell *cell1 = [ OrderInputTableViewCell new];
    //    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"OrderInputTableViewCell" owner:self options:nil];
    //    cell1 = [array1 objectAtIndex:0];
    //    cell1.frame  =CGRectMake(0, 74, SCREEN_W, 44);
    //    cell1.backgroundColor = [UIColor whiteColor];
    //    cell1.lbTitle.text = @"总体积";
    //    cell1.tfText.placeholder = @"单位（立方米）";
    //    cell1.tvText.hidden = YES;
    //    cell1.tfText.hidden = NO;
    //    cell1.tfText.delegate = self;
    //    cell1.tfText.tag = 12;
    //    cell1.tfText.keyboardType = UIKeyboardTypeNumberPad;
    //    [viInpute addSubview:cell1];
    //
    //
    //    [self.viHead addSubview:viInpute];

    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296);

}

- (void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);

    if(!self.capacityEntry.totalWeight){
        self.capacityEntry.totalWeight = @"1";

    }
    if(!self.capacityEntry.volume){

        self.capacityEntry.volume = @"1";

    }


    [vm getOrderPriceWithCapacityInfo:self.capacityEntry callback:^(PriceInfo *priceInfo) {

        ws.capacityEntry.priceInfo = priceInfo;

        ws.lbTicketTotalPrice.attributedText  = [self moneyStyleWith:priceInfo.ticketTotalPrice];
        ws.lbAdditionPrice.attributedText = [self moneyStyleWith:priceInfo.additionPrice];
        ws.lb2.text = @"服务费";
        ws.lb3.text = @"";

        ws.lbBotoom.attributedText = [self totalMoneyStyleWith:priceInfo.orderTotalMoney];
        ws.lbAdditionServicePrice.hidden = YES;



    }];

    InvoiceViewModel *inVm = [InvoiceViewModel new];
    [inVm getCompanyDefaultInvoiceWithType:@"INVOICE_TYPE_VALUE_ADD_TAX" callback:^(InvoiceModel *info) {


        ws.defaultInvoiceModel = info;


    }];

    //    self.btnUpAndDown.hidden = YES;
    //    self.viMessage.hidden = NO;
    //    self.viMessage.frame = CGRectMake(0, self.viTransportation.bottom, SCREEN_W, 150);
    //    [self.viHead addSubview:self.viMessage];
    //    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 296 + 220 + 64);
    //
    //    self.tvList.tableHeaderView = self.viHead;
}

//金钱富文本

- (NSMutableAttributedString *)moneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@ x%@",ticketTotalPrice, self.capacityEntry.weight];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 6, 6)];


    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:APP_COLOR_GRAY2
                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;
    
}


@end

//SubmiteOrderViewController_QuickGo

#pragma mark - 一带一路运力
@implementation SubmiteOrderViewController_QuickGo : SubmiteOrderViewController

- (void)viMessageMake {


    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(20, 0, SCREEN_W, 0.5);
    [self.viMessage addSubview:lbLine];
    NSArray *arrMessageTitle = @[@"箱型箱类",@"货物名称",@"用箱数量",@"自备箱",@"发货日期",@"增值服务"];
    NSArray *arrMessage = @[self.capacityEntry.box.name,self.capacityEntry.goodsInfo.name,self.capacityEntry.boxNum,self.capacityEntry.isOwnBox,self.capacityEntry.stStartTime,self.capacityEntry.serviceWay];

    CGFloat boom = 10;


    for (int i =0; i<6; i++) {

        UILabel *lbTitle = [UILabel new];
        lbTitle.frame = CGRectMake(20, boom, 60, 20);
        lbTitle.text = [arrMessageTitle objectAtIndex:i];
        lbTitle.font = [UIFont systemFontOfSize:13];
        lbTitle.textColor = APP_COLOR_GRAY2;
        UILabel *lbMessage = [UILabel new];
        lbMessage.frame = CGRectMake(100, boom, SCREEN_W - 100, 20);
        lbMessage.text = [arrMessage objectAtIndex:i];
        lbMessage.font = [UIFont systemFontOfSize:13];
        lbMessage.textColor = APP_COLOR_GRAY_TEXT_1;

        [self.viMessage addSubview:lbTitle];
        [self.viMessage addSubview:lbMessage];

        boom  =  lbMessage.bottom;
        
    }
    
    
    
}

@end