//
//  CentainBoxOrderVC.m
//  MallClient
//
//  Created by lxy on 2017/3/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "CentainBoxOrderVC.h"
#import "EmptyContainerViewModel.h"
#import "SubmitOrderSuccessViewController.h"

@interface CentainBoxOrderVC ()

@property (nonatomic, strong) UIScrollView   *svOrder;
@property (nonatomic, strong) UIButton       *btnSubmit;
@property (nonatomic, strong) ContainerModel *currrentInfo;


@end

@implementation CentainBoxOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  加载视图
 */
- (void)bindView {

    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"订单确认";

    self.svOrder.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.svOrder];

    /**
     *  箱子
     */
    self.currrentInfo = self.containerOrderInfo.containerModel;
    UILabel *lbBoxName = [self labelWithText:self.currrentInfo.containerName WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbBoxName.frame = CGRectMake(15, 26, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbBoxName];

    UILabel *lbBoxStatuse = [self labelWithText:@"箱况：新造箱" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    switch ([self.currrentInfo.containerStatus intValue]) {
        case 1:
            lbBoxStatuse.text = @"箱子状况：新造箱";
            break;

        case 2:
            lbBoxStatuse.text = @"箱子状况：完好在用箱";
            break;

        case 3:
            lbBoxStatuse.text = @"箱子状况：轻微瑕疵在用箱";
            break;

        case 4:
            lbBoxStatuse.text = @"箱子状况：破损在用箱";
            break;

        default:
            break;
    }
    lbBoxStatuse.frame = CGRectMake(15, lbBoxName.bottom + 15, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbBoxStatuse];

    UILabel *lbBoxType = [self labelWithText:@"业务类型：租用" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbBoxType.frame = CGRectMake(15, lbBoxStatuse.bottom + 10, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbBoxType];

    UILabel *lbBoxNum = [self labelWithText:[NSString stringWithFormat:@"数   量：%i个",self.containerOrderInfo.num] WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbBoxNum.frame = CGRectMake(SCREEN_W - 110, lbBoxStatuse.bottom + 10, 100, 20);
    [self.svOrder addSubview:lbBoxNum];

    /**
     *  联系人
     */
    UILabel *lbCantastTitle = [self labelWithText:@"联系人" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbCantastTitle.frame = CGRectMake(15, lbBoxNum.bottom + 30, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbCantastTitle];

    UILabel *lbName = [self labelWithText:@"姓名" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbName.frame = CGRectMake(15, lbCantastTitle.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbName];

    UILabel *lbNameMessage = [self labelWithText:self.containerOrderInfo.name WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbNameMessage.frame = CGRectMake(lbName.right + 10, lbCantastTitle.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbNameMessage];

    UILabel *lbPhone = [self labelWithText:@"联系电话" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbPhone.frame = CGRectMake(15, lbNameMessage.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbPhone];

    UILabel *lbPhoneMessage = [self labelWithText:self.containerOrderInfo.phone WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbPhoneMessage.frame = CGRectMake(lbName.right + 10, lbNameMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbPhoneMessage];


    UILabel *lbAddressTitle = [self labelWithText:@"地址信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbAddressTitle.frame = CGRectMake(15, lbPhoneMessage.bottom + 30, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbAddressTitle];

    UILabel *lbStart = [self labelWithText:@"收箱地" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbStart.frame = CGRectMake(15, lbAddressTitle.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbStart];

    UILabel *lbStartMessage = [self labelWithText:[NSString stringWithFormat:@"%@ %@",self.containerOrderInfo.startFullName,self.containerOrderInfo.startStation.name] WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbStartMessage.frame = CGRectMake(lbName.right + 10, lbAddressTitle.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    lbStartMessage.numberOfLines = 0;
    [self.svOrder addSubview:lbStartMessage];

    UILabel *lbEnd = [self labelWithText:@"还箱地" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbEnd.frame = CGRectMake(15, lbStartMessage.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbEnd];

    UILabel *lbEndMessage = [self labelWithText:[NSString stringWithFormat:@"%@ %@",self.containerOrderInfo.endFullName,self.containerOrderInfo.endStation.name] WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbEndMessage.frame = CGRectMake(lbName.right + 10, lbStartMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    lbEndMessage.numberOfLines = 0;
    [self.svOrder addSubview:lbEndMessage];





    UILabel *lbTimeTitle = [self labelWithText:@"租赁时间" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTimeTitle.frame = CGRectMake(15, lbEndMessage.bottom + 30, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbTimeTitle];

    UILabel *lbStTime = [self labelWithText:@"租赁开始日期：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbStTime.frame = CGRectMake(15, lbTimeTitle.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbStTime];

    UILabel *lbStTimeMessage = [self labelWithText:self.containerOrderInfo.startDate WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbStTimeMessage.frame = CGRectMake(lbName.right + 10, lbTimeTitle.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbStTimeMessage];


    UILabel *lbDay = [self labelWithText:[NSString stringWithFormat:@"(%i天)",self.containerOrderInfo.day] WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbDay.frame = CGRectMake(230, lbTimeTitle.bottom + 25, 50, 20);
    [self.svOrder addSubview:lbDay];

    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        //买箱

        lbEnd.hidden = YES;
        lbEndMessage.hidden = YES;
        lbDay.hidden = YES;
        
    }

    UILabel *lbEndTime = [self labelWithText:@"租赁终止日期：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbEndTime.frame = CGRectMake(15, lbStTimeMessage.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbEndTime];   

    UILabel *lbEndTimeMessage = [self labelWithText:self.containerOrderInfo.endDate WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbEndTimeMessage.frame = CGRectMake(lbName.right + 10, lbStTimeMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbEndTimeMessage];

    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        lbTimeTitle.hidden = YES;
        lbStTime.hidden = YES;
        lbStTimeMessage.hidden = YES;
        lbEndTime.hidden = YES;
        lbEndTimeMessage.hidden = YES;

        lbEndTimeMessage.frame = CGRectMake(15, lbEndMessage.bottom + 30, SCREEN_W - 15, 1);
        [self.svOrder addSubview:lbEndTimeMessage];

        lbBoxType.text = @"业务类型：售卖";

    }


    UILabel *lbSellerTitle = [self labelWithText:@"卖家信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbSellerTitle.frame = CGRectMake(15, lbEndTimeMessage.bottom + 30, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbSellerTitle];

    UILabel *lbSeller = [self labelWithText:@"卖家" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbSeller.frame = CGRectMake(15, lbSellerTitle.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbSeller];

    UILabel *lbSellerMessage = [self labelWithText:self.currrentInfo.companyName WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbSellerMessage.frame = CGRectMake(lbName.right + 10, lbSellerTitle.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbSellerMessage];

    UILabel *lbSellertel = [self labelWithText:@"联系电话" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbSellertel.frame = CGRectMake(15, lbSellerMessage.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbSellertel];

    UILabel *lbSellertelMessage = [self labelWithText:self.currrentInfo.companyPhone WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbSellertelMessage.frame = CGRectMake(lbName.right + 10, lbSellerMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbSellertelMessage];


    UILabel *lbPriceTitle = [self labelWithText:@"费用明细" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbPriceTitle.frame = CGRectMake(15, lbSellertelMessage.bottom + 30, SCREEN_W - 15, 20);
    [self.svOrder addSubview:lbPriceTitle];

    UILabel *lbRent = [self labelWithText:@"租金：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbRent.frame = CGRectMake(15, lbPriceTitle.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbRent];

    UILabel *lbRentMessage = [UILabel new];
    if (!self.containerOrderInfo.containerModel.unitPrice) {
        self.containerOrderInfo.containerModel.unitPrice = @"";
    }
    NSMutableAttributedString * lbRentMessageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ x %i个 x %i天",[self.containerOrderInfo.containerModel.unitPrice  NumberStringToMoneyString],self.containerOrderInfo.num,self.containerOrderInfo.day]];
    [lbRentMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbRentMessageText.length)];
    [lbRentMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbRentMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.unitPrice  NumberStringToMoneyStringGetLastThree]]];
    lbRentMessage.attributedText = lbRentMessageText;
    lbRentMessage.textAlignment = NSTextAlignmentRight;
    lbRentMessage.textColor = [UIColor blackColor];
    
    
    lbRentMessage.frame = CGRectMake(lbName.right + 10, lbPriceTitle.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbRentMessage];

    UILabel *lbDeposit = [self labelWithText:@"押金：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    
    lbDeposit.frame = CGRectMake(15, lbRentMessage.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbDeposit];
    if (!self.containerOrderInfo.containerModel.deposit) {
        self.containerOrderInfo.containerModel.deposit = @"";
    }
    UILabel *lbDepositMessage = [UILabel new];
    NSMutableAttributedString * lbDepositMessageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ x %i个",[self.containerOrderInfo.containerModel.deposit NumberStringToMoneyString],self.containerOrderInfo.num]];
    [lbDepositMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbDepositMessageText.length)];
    [lbDepositMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbDepositMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.deposit NumberStringToMoneyStringGetLastThree]]];
    lbDepositMessage.attributedText = lbDepositMessageText;
    lbDepositMessage.textAlignment = NSTextAlignmentRight;
    lbDepositMessage.textColor = [UIColor blackColor];
    
    
    lbDepositMessage.frame = CGRectMake(lbName.right + 10, lbRentMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbDepositMessage];


    UILabel *lbAdd = [self labelWithText:@"异地还箱费：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbAdd.frame = CGRectMake(15, lbDepositMessage.bottom + 10, 110, 20);
    [self.svOrder addSubview:lbAdd];
    UILabel *lbAddMessage = [UILabel new];
    if(!self.containerOrderInfo.containerModel.offsiteReturnBoxPrice) {
        self.containerOrderInfo.containerModel.offsiteReturnBoxPrice = @"";
    }
    NSMutableAttributedString * lbAddMessageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ x %i个",[self.containerOrderInfo.containerModel.offsiteReturnBoxPrice NumberStringToMoneyString],self.containerOrderInfo.num]];
    [lbAddMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbAddMessageText.length)];
    [lbAddMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbAddMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.offsiteReturnBoxPrice NumberStringToMoneyStringGetLastThree]]];
    lbAddMessage.attributedText = lbAddMessageText;
    lbAddMessage.textAlignment = NSTextAlignmentRight;
    lbAddMessage.textColor = [UIColor blackColor];
    lbAddMessage.frame = CGRectMake(lbName.right + 10, lbDepositMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    [self.svOrder addSubview:lbAddMessage];

    UILabel *lbTransport = [self labelWithText:@"运费：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
    lbTransport.frame = CGRectMake(15, lbAddMessage.bottom + 10, 110, 20);
    //[self.svOrder addSubview:lbTransport];

    UILabel *lbTransportMessage = [self labelWithText:@"¥200.00" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
    lbTransportMessage.frame = CGRectMake(lbName.right + 10, lbAddMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
    //[self.svOrder addSubview:lbTransportMessage];



    UILabel *lbTotalPrice = [self labelWithText:@"共计：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTotalPrice.frame = CGRectMake(15, lbTransportMessage.bottom + 10, 50, 20);

    [self.svOrder addSubview:lbTotalPrice];

    UILabel *lbTotalPriceMessage = [self labelWithText:[NSString stringWithFormat:@"%.2f",self.containerOrderInfo.totalPrice] WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor redColor]];
    lbTotalPriceMessage.frame = CGRectMake(lbTotalPrice.right + 5, lbTransportMessage.bottom + 10, SCREEN_W - 80, 20);
    lbTotalPriceMessage.attributedText = [self totalMoneyStyleWith:lbTotalPriceMessage.text];
    [self.svOrder addSubview:lbTotalPriceMessage];

    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        lbRent.text = @"箱子金额";
        lbDeposit.hidden = YES;
        lbDepositMessage.hidden = YES;
        lbAdd.hidden = YES;
        lbAddMessage.hidden = YES;
        lbTotalPrice.frame = CGRectMake(15, lbRentMessage.bottom + 10, 110, 20);
        lbTotalPriceMessage.frame = CGRectMake(lbName.right + 10, lbRentMessage.bottom + 10, SCREEN_W - lbName.right - 20, 20);
        [self.svOrder addSubview:lbTotalPrice];
        [self.svOrder addSubview:lbTotalPriceMessage];
        if (!self.containerOrderInfo.containerModel.unitPrice) {
            self.containerOrderInfo.containerModel.unitPrice = @"";
        }
        lbRentMessageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ x %i个 ",[self.containerOrderInfo.containerModel.unitPrice NumberStringToMoneyString],self.containerOrderInfo.num]];
        [lbRentMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbRentMessageText.length)];
        [lbRentMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbRentMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.unitPrice NumberStringToMoneyStringGetLastThree]]];
        lbRentMessage.attributedText = lbRentMessageText;

    }

    self.btnSubmit.frame =CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.btnSubmit];



}

//金钱富文本

- (NSMutableAttributedString *)totalMoneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"¥%@",ticketTotalPrice];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:stTicketTotalPrice];

    NSUInteger loc = stTicketTotalPrice.length;

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:11.0]

                          range:NSMakeRange(loc - 3, 3)];


    //    [AttributedStr addAttribute:NSForegroundColorAttributeName
    //                          value:APP_COLOR_GRAY2
    //                          range:NSMakeRange(loc - 2, 2)];

    return AttributedStr;
    
}

//提交订单事件
- (void)submitAction {

    EmptyContainerViewModel *vm = [EmptyContainerViewModel new];

    WS(ws);
    [vm submitOrderWithOrderInfo:self.containerOrderInfo callback:^(NSString *orderNo) {

        //通知订单中心进行更新
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                           object:@{
                                                                    @"orderType":@"全部",
                                                                    @"viewTitle":@"空箱之家"
                                                                    }];
        SubmitOrderSuccessViewController *vc= [SubmitOrderSuccessViewController new];
        vc.stOrderNo = orderNo;
        vc.type = emptyContainer;
        [ws.navigationController pushViewController:vc animated:YES];

    }];
}

/**
 *  getter
 */

- (UIScrollView *)svOrder {
    if (!_svOrder) {
        _svOrder = [UIScrollView new];
        _svOrder.contentSize = CGSizeMake(SCREEN_W, 800);
    }
    return _svOrder;
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];


        _btnSubmit = button;
    }
    return _btnSubmit;
}



@end
