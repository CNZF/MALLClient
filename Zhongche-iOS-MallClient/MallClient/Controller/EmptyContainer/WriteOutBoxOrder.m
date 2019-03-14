//
//  WriteOutBoxOrder.m
//  MallClient
//
//  Created by lxy on 2017/3/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "WriteOutBoxOrder.h"
#import "CentainBoxOrderVC.h"
#import "EmptyContainerAddressVC.h"

@interface WriteOutBoxOrder ()

@property (nonatomic, strong) UIScrollView       *svGoodsDetail;

@property (nonatomic, strong) UIView             *viAddressAndContact;//联系人
@property (nonatomic, strong) UILabel            *lbReceieve;//收图标
@property (nonatomic, strong) UILabel            *lbName;//联系人姓名
@property (nonatomic, strong) UILabel            *lbPhone;//联系人电话
@property (nonatomic, strong) UIImageView        *ivAddress1;//定位图标（收）
@property (nonatomic, strong) UIImageView        *ivAddress2;//定位图标（还）
@property (nonatomic, strong) UILabel            *lbCarryAddress;//收箱地址
@property (nonatomic, strong) UILabel            *lbGiveBackAddress;//还箱地址
@property (nonatomic, strong) UIImageView        *ivCell;//箭头
@property (nonatomic, strong) UIImageView        *ivColorLine;//彩带

@property (nonatomic, strong) UIView             *viBoxGoods;//箱子视图

@property (nonatomic, strong) UILabel            *lbGoodsStatuse;//箱子认证状态
@property (nonatomic, strong) UILabel            *lbGoodsName;
@property (nonatomic, strong) UILabel            *lbPrice;
@property (nonatomic, strong) UILabel            *lbDeposit;//押金
@property (nonatomic, strong) UILabel            *lbBoxStatuse;//箱型
@property (nonatomic, strong) UILabel            *lbBoxPosition;//箱子位置
@property (nonatomic, strong) UILabel            *lbBoxNum;//箱子编号
@property (nonatomic, strong) UIButton           *btnUpAndDown;//详细按钮
@property (nonatomic, strong) UILabel            *lbBoxNumber;

@property (nonatomic, strong) UIView             *viUseTime;//使用时间
@property (nonatomic, strong) UILabel            *lbUserTimeTitle;
@property (nonatomic, strong) UIImageView        *ivTime;//日历图标
@property (nonatomic, strong) UILabel            *lbStartTime;
@property (nonatomic, strong) UILabel            *lbStartTimeMessage;
@property (nonatomic, strong) UIButton           *btnStartTime;
@property (nonatomic, strong) UILabel            *lbEndTime;
@property (nonatomic, strong) UILabel            *lbEndTimeMessage;
@property (nonatomic, strong) UIButton           *btnEndTime;
@property (nonatomic, strong) UIImageView        *ivCell1;///箭头
@property (nonatomic, strong) UIImageView        *ivCell2;///箭头
@property (nonatomic, strong) UILabel            *lbDay;

@property (nonatomic, strong) UIView             *viSeller;//卖家信息
@property (nonatomic, strong) UILabel            *lbSellerTitle;
@property (nonatomic, strong) UILabel            *lbSellerCompany;
@property (nonatomic, strong) UILabel            *lbSellerPosition;
@property (nonatomic, strong) UILabel            *lbSellerPhone;

@property (nonatomic, strong) UILabel            *lbBotoom;
@property (nonatomic, strong) UIButton           *btnMoneyDetail;
@property (nonatomic, strong) UIButton           *btnSubmitOrder;
@property (nonatomic, strong) UIView             *viTime;
@property (nonatomic, strong) UIButton           *btnCancle;
@property (nonatomic, strong) UIDatePicker       *datePicker;
@property (nonatomic, assign) int                timeType;//0、开始时间 1、结束时间
@property (nonatomic, strong) NSDate             *startDate;
@property (nonatomic, strong) NSDate             *endDate;
@property (nonatomic, strong) UILabel            *lbTimeStyle;
@property (nonatomic, strong) ContainerModel     *currrentInfo;

@property (nonatomic, strong) UIView             *viNoAddress;
@property (nonatomic, strong) UIButton           *btnAddressChoose1;
@property (nonatomic, strong) UIButton           *btnAddressChoose2;
@property (nonatomic, assign) int                addressType;//0未选择 1选择

@property (nonatomic, strong) UIView             *viPrice;
@property (nonatomic, strong) UIView             *viBackground;
@property (nonatomic, strong) UILabel            *lbRentMessage;
@property (nonatomic, strong) UILabel            *lbDepositMessage;
@property (nonatomic, strong) UILabel            *lbAddMessage;
@property (nonatomic, strong) UILabel            *lbTransportMessage;

@property (nonatomic, assign) int                day;
@property (nonatomic, assign) float              totalPrice;

@property (nonatomic, strong) CityModel *endCity;

@property (nonatomic, assign) BOOL isShow;



@end

@implementation WriteOutBoxOrder

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.viBackground.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"填写订单";


    self.svGoodsDetail.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.svGoodsDetail];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];


    CGFloat hight;
    if (!self.isShow) {

        hight = 108;

        [self.btnUpAndDown setImage:[UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];

    }else{

        hight = 210;

        [self.btnUpAndDown setImage:[UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
    }

    if (self.addressType == 0) {

        [self.svGoodsDetail addSubview:self.viNoAddress];
        self.viBoxGoods.frame = CGRectMake(0, self.viNoAddress.bottom + 10, SCREEN_W, hight);

    }else {

        self.viAddressAndContact.frame = CGRectMake(0, 10, SCREEN_W, 165);
        [self viAddressAndContactMake];
        [self.svGoodsDetail addSubview:self.viAddressAndContact];
        self.viBoxGoods.frame = CGRectMake(0, self.viAddressAndContact.bottom + 10, SCREEN_W, hight);

    }




    [self viBoxGoodsMake];
    [self.svGoodsDetail addSubview:self.viBoxGoods];

    self.viUseTime.frame = CGRectMake(0, self.viBoxGoods.bottom + 10, SCREEN_W, 130);
    [self viUseTimeMake];
    [self.svGoodsDetail addSubview:self.viUseTime];



    self.viSeller.frame = CGRectMake(0, self.viUseTime.bottom + 10, SCREEN_W, 155);
    [self viSellerMake];
    [self.svGoodsDetail addSubview:self.viSeller];

    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        self.viUseTime.hidden = YES;

        self.viSeller.frame = CGRectMake(0, self.viBoxGoods.bottom + 10, SCREEN_W, 155);
        [self viSellerMake];
        [self.svGoodsDetail addSubview:self.viSeller];


        self.lbAddMessage.hidden = YES;
        self.lbDepositMessage.hidden = YES;

        self.lbAddMessage.hidden = YES;
        self.lbDepositMessage.hidden = YES;
        self.lbDeposit.hidden = YES;
    }


    self.lbBotoom.frame = CGRectMake(0, SCREEN_H - 114, SCREEN_W*2/5, 50);
    [self.view addSubview:self.lbBotoom];

    self.btnMoneyDetail.frame = CGRectMake(self.lbBotoom.right - 1, SCREEN_H - 114, SCREEN_W/5 + 1, 50);
    [self.view addSubview:self.btnMoneyDetail];

    self.btnSubmitOrder.frame = CGRectMake(self.btnMoneyDetail.right, SCREEN_H - 114, SCREEN_W*2/5, 50);
    [self.view addSubview:self.btnSubmitOrder];



    self.viTime.frame  = CGRectMake(0, SCREEN_H - 180 - 64, SCREEN_W, 180);
    [self.view addSubview:self.viTime];

    [self timeViewMake];



    UIButton *btn = [UIButton new];

    self.viPrice.frame = CGRectMake(0, SCREEN_H - 64 - 50 -130, SCREEN_W, 130);
    self.viBackground.frame = CGRectMake(0, 0, SCREEN_W , SCREEN_H - 50 - 130);
    btn.frame = CGRectMake(0, 0, SCREEN_W , SCREEN_H - 50 - 130);


    if(self.style == 1){


        self.viPrice.frame = CGRectMake(0, SCREEN_H - 64 - 50 - 60, SCREEN_W, 60);
        self.viBackground.frame = CGRectMake(0, 0, SCREEN_W , SCREEN_H - 50 - 60);
        btn.frame = CGRectMake(0, 0, SCREEN_W , SCREEN_H - 50 - 60);
    }

    [self.view addSubview:self.viPrice];

    [btn addTarget:self action:@selector(moneyDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viBackground addSubview:btn];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.viBackground];






    NSTimeInterval secondsPerDay = 24 * 60 * 60;

    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierChinese];

    [calendar setTimeZone:gmt];

    NSDate *date = [NSDate date];

    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];

    components.day-=1;

    [components setHour:0];

    [components setMinute:0];

    [components setSecond: 0];

    NSDate *startDate = [calendar dateFromComponents:components];

    NSDate *today = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];

    NSDate *tomorrow;



    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stDate = [dateFormatter stringFromDate:tomorrow];
    self.lbStartTime.text = stDate;
    self.startDate = tomorrow;

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[tomorrow timeIntervalSince1970]];
    self.containerOrderInfo.strStartDate = timeSp;

}

- (void)bindModel {


    self.currrentInfo = self.containerOrderInfo.containerModel;

    self.lbGoodsStatuse.text = [self.currrentInfo.authenticationStatus isEqualToString:@"1"]?@"认证":@"未认证";
    self.lbGoodsName.text = self.currrentInfo.containerName;


    self.lbPrice.text = [NSString stringWithFormat:@"￥%@ /天/个", [self getMoneyStringWithMoneyNumber:[self.currrentInfo.unitPrice doubleValue]]];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lbPrice.text];


    NSUInteger loc =  self.lbPrice.text.length;
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 8, 8)];

    self.lbPrice.attributedText = AttributedStr;

    if (self.style == 1) {
        self.lbPrice.text = [NSString stringWithFormat:@"￥%@ /个",[self getMoneyStringWithMoneyNumber:[self.currrentInfo.unitPrice doubleValue]]];
        NSRange range;
        range = [self.lbPrice.text rangeOfString:@"/个"];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lbPrice.text];


        [AttributedStr addAttribute:NSFontAttributeName

                              value:[UIFont systemFontOfSize:12]

                              range:NSMakeRange(self.lbPrice.text.length - 6,6)];
        self.lbPrice.attributedText = AttributedStr;
    }

    

    self.lbBoxPosition.text = [NSString stringWithFormat:@"箱子位置：%@",self.currrentInfo.locationName];

    self.lbBoxNum.text = [NSString stringWithFormat:@"商品编号：%@",self.currrentInfo.code];

    self.lbBoxNumber.text = [NSString stringWithFormat:@"数量: %i",self.containerOrderInfo.num];


    switch ([self.currrentInfo.containerStatus intValue]) {
        case 1:
            self.lbBoxStatuse.text = @"箱子状况：新造箱";
            break;

        case 2:
            self.lbBoxStatuse.text = @"箱子状况：完好在用箱";
            break;

        case 3:
            self.lbBoxStatuse.text = @"箱子状况：轻微瑕疵在用箱";
            break;

        case 4:
            self.lbBoxStatuse.text = @"箱子状况：破损在用箱";
            break;

        default:
            break;
    }



    self.lbSellerCompany.text = [NSString stringWithFormat:@"公司：%@",self.currrentInfo.companyName];
    self.lbSellerCompany.attributedText = [self attributedStrWithString:self.lbSellerCompany.text];
    if (!self.currrentInfo.companyAddress) {
        self.currrentInfo.companyAddress = @"无";
    }
    self.lbSellerPosition.text = [NSString stringWithFormat:@"所在地：%@",self.currrentInfo.companyAddress];
    self.lbSellerPosition.attributedText = [self attributedStrWithString:self.lbSellerPosition.text];
    self.lbSellerPhone.text = [NSString stringWithFormat:@"电话：%@",self.currrentInfo.companyPhone];
    self.lbSellerPhone.attributedText = [self attributedStrWithString:self.lbSellerPhone.text];




}

//联系人
- (void)viAddressAndContactMake {

    [self.viAddressAndContact addSubview:self.lbReceieve];
    [self.viAddressAndContact addSubview:self.lbName];
    [self.viAddressAndContact addSubview:self.lbPhone];
    [self.viAddressAndContact addSubview:self.lbCarryAddress];
    [self.viAddressAndContact addSubview:self.lbGiveBackAddress];

    [self.viAddressAndContact addSubview:self.ivAddress1];
    [self.viAddressAndContact addSubview:self.ivAddress2];
    [self.viAddressAndContact addSubview:self.ivColorLine];
    [self.viAddressAndContact addSubview:self.ivCell];

    self.btnAddressChoose2.frame = CGRectMake(0, 10, SCREEN_W, 165);
    [self.viAddressAndContact addSubview:self.btnAddressChoose2];


}

//箱子
- (void)viBoxGoodsMake {

    [self.viBoxGoods addSubview:self.ivBoxGoods];
    [self.viBoxGoods addSubview:self.lbGoodsStatuse];
    [self.viBoxGoods addSubview:self.lbGoodsName];
    [self.viBoxGoods addSubview:self.lbPrice];
    [self.viBoxGoods addSubview:self.lbDeposit];
    [self.viBoxGoods addSubview:self.lbBoxStatuse];
    [self.viBoxGoods addSubview:self.lbBoxPosition];
    [self.viBoxGoods addSubview:self.lbBoxNum];
    [self.viBoxGoods addSubview:self.btnUpAndDown];
    [self.viBoxGoods addSubview:self.lbBoxNumber];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, self.btnUpAndDown.bottom, SCREEN_W, 0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viBoxGoods addSubview:lbLine];


}

//箱子使用时间
- (void)viUseTimeMake {

    [self.viUseTime addSubview:self.lbUserTimeTitle];
    [self.viUseTime addSubview:self.ivTime];
    [self.viUseTime addSubview:self.lbStartTime];
    [self.viUseTime addSubview:self.lbStartTimeMessage];
    [self.viUseTime addSubview:self.lbEndTime];
    [self.viUseTime addSubview:self.lbEndTimeMessage];
    [self.viUseTime addSubview:self.btnStartTime];
    [self.viUseTime addSubview:self.btnEndTime];
    [self.viUseTime addSubview:self.ivCell1];
    [self.viUseTime addSubview:self.ivCell2];
    [self.viUseTime addSubview:self.lbDay];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, self.lbUserTimeTitle.bottom + 5, SCREEN_W, 0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viUseTime addSubview:lbLine];

}

//卖家信息
- (void)viSellerMake{

    self.lbSellerTitle.frame = CGRectMake(15, 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerTitle];

    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(0, self.lbSellerTitle.bottom + 10, SCREEN_W , 1);
    [self.viSeller addSubview:lbLine];

    self.lbSellerCompany.frame = CGRectMake(15, lbLine.bottom + 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerCompany];

    self.lbSellerPosition.frame = CGRectMake(15, self.lbSellerCompany.bottom + 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerPosition];

    self.lbSellerPhone.frame = CGRectMake(15, self.lbSellerPosition.bottom + 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerPhone];    
    
}

//时间选择
- (void)timeViewMake {

    [self.viTime addSubview:self.btnCancle];
    [self.viTime addSubview:self.datePicker];
    [self.viTime addSubview:self.lbTimeStyle];

}

//选择时间按钮
- (void)timeChooseAction:(UIButton *)btn {



    self.viTime.hidden = NO;





    if (btn == self.btnStartTime) {

        self.timeType = 0;
        self.lbTimeStyle.text = @"开始日期";

        self.datePicker.minimumDate = [self stDateToDate:[self stDateToString:self.currrentInfo.startDate]];
        self.datePicker.maximumDate = [self stDateToDate:[self stDateToString:self.currrentInfo.endDate]];

        if (self.endDate) {
            self.datePicker.maximumDate = self.endDate;
        }



    }else {

        self.timeType = 1;
        self.lbTimeStyle.text = @"结束日期";

        self.datePicker.minimumDate = self.startDate;
        self.datePicker.maximumDate = [self stDateToDate:[self stDateToString:self.currrentInfo.endDate]];


    }


}

//取消按钮
- (void)centainAction {

    self.viTime.hidden = YES;
    NSDate *date = [self getNowDateFromatAnDate :self.datePicker.date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stDate = [dateFormatter stringFromDate:date];

    if (self.timeType == 0) {

        self.lbStartTime.text = stDate;
        self.startDate = date;
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        self.containerOrderInfo.strStartDate = timeSp;

    }else {

        self.lbEndTime.text = stDate;
        self.endDate = date;
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        self.containerOrderInfo.strEndDate = timeSp;

    }


    if (self.startDate && self.endDate) {

        NSDateFormatter *date = [[NSDateFormatter alloc]init];
        [date setDateFormat:@"yyyy-MM-dd"];

        long start = (long)[self.startDate timeIntervalSince1970]*1;
        long end = (long)[self.endDate timeIntervalSince1970]*1;
        long value = end - start;
        long day = value / (24 * 3600);


        self.day = (int)day + 1;
        self.lbDay.text = [NSString stringWithFormat:@"（%d天）",self.day];

    }


    self.totalPrice = [self.containerOrderInfo.containerModel.unitPrice intValue] * self.containerOrderInfo.num * self.day+ [self.containerOrderInfo.containerModel.deposit intValue]* self.containerOrderInfo.num + [self.containerOrderInfo.containerModel.offsiteReturnBoxPrice intValue]* self.containerOrderInfo.num;
    self.lbBotoom.text = [NSString stringWithFormat:@"%.2f",self.totalPrice];
    self.lbBotoom.attributedText = [self totalMoneyStyleWith:self.lbBotoom.text];
}

//价格视图
- (void)moneyDetailAction{

    self.viBackground.hidden = !self.viBackground.hidden;
    self.viPrice.hidden = !self.viPrice.hidden;

    if ([self.viBackground isHidden]) {

        [self.btnMoneyDetail setImage: [UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
    }else {

        [self.btnMoneyDetail setImage: [UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];

    }

    /**
     *  @property (nonatomic, strong) UILabel            *lbRentMessage;
     @property (nonatomic, strong) UILabel            *lbDepositMessage;
     @property (nonatomic, strong) UILabel            *lbAddMessage;
     @property (nonatomic, strong) UILabel            *lbTransportMessage;
     *
     */



   

    if (![self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {
        if (!self.containerOrderInfo.containerModel.unitPrice) {
            self.containerOrderInfo.containerModel.unitPrice= @"";
        }
        NSMutableAttributedString * lbRentMessageText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@ x %i个 x %i天",[self.containerOrderInfo.containerModel.unitPrice NumberStringToMoneyString],self.containerOrderInfo.num,self.day]];
        [lbRentMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbRentMessageText.length)];
        [lbRentMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbRentMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.unitPrice NumberStringToMoneyStringGetLastThree]]];
        self.lbRentMessage.attributedText = lbRentMessageText;
        if (!self.containerOrderInfo.containerModel.deposit) {
            self.containerOrderInfo.containerModel.deposit = @"";
        }
        NSMutableAttributedString * lbDepositMessageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ x %i个",[self.containerOrderInfo.containerModel.deposit NumberStringToMoneyString],self.containerOrderInfo.num]];
        [lbDepositMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbDepositMessageText.length)];
        [lbDepositMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbDepositMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.deposit NumberStringToMoneyStringGetLastThree]]];
        self.lbDepositMessage.attributedText = lbDepositMessageText;
        self.lbAddMessage.text = [NSString stringWithFormat:@"￥%@ x %i个",self.containerOrderInfo.containerModel.offsiteReturnBoxPrice,self.containerOrderInfo.num];
        NSMutableAttributedString * lbAddMessageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ x %i个",[self.containerOrderInfo.containerModel.offsiteReturnBoxPrice NumberStringToMoneyString],self.containerOrderInfo.num]];
        [lbAddMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbAddMessageText.length)];
        [lbAddMessageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbAddMessageText.string rangeOfString:[self.containerOrderInfo.containerModel.offsiteReturnBoxPrice NumberStringToMoneyStringGetLastThree]]];
        self.lbAddMessage.attributedText = lbAddMessageText;

    }


}

//收缩按钮点击事件
- (void)upAndDownAction {

    self.isShow  = !self.isShow;
    [self bindView];
}

/**
 *  文字转富文本
 *
 *  @param st 文字
 *
 *  @return 富文本
 */

- (NSMutableAttributedString *)attributedStrWithString:(NSString *)st {


    NSRange range;
    NSString *tmpStr = st;
    range = [tmpStr rangeOfString:@"："];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tmpStr];


    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:[UIColor blackColor]

                          range:NSMakeRange(range.location,tmpStr.length - range.location)];
    
    return AttributedStr;
}

//金钱富文本

- (NSMutableAttributedString *)totalMoneyStyleWith:(NSString *)st {

    NSString *ticketTotalPrice = [self getMoneyStringWithMoneyNumber:[st doubleValue]];
    NSString *stTicketTotalPrice = [NSString stringWithFormat:@"￥%@",ticketTotalPrice];
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

- (void)submitOrderAction {




    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        //买箱子

        if (self.containerOrderInfo.name) {

            self.containerOrderInfo.startDate = self.lbStartTime.text;
            self.containerOrderInfo.endDate = self.lbEndTime.text;
            self.containerOrderInfo.day = self.day;
            self.containerOrderInfo.totalPrice = self.totalPrice;

            CentainBoxOrderVC *vc= [CentainBoxOrderVC new];
            vc.containerOrderInfo = self.containerOrderInfo;
            if (![self.viBackground isHidden]) {

                [self moneyDetailAction];
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
        }



    }else {

        if (self.startDate && self.endDate && self.containerOrderInfo.endStation) {

            self.containerOrderInfo.startDate = self.lbStartTime.text;
            self.containerOrderInfo.endDate = self.lbEndTime.text;
            self.containerOrderInfo.day = self.day;
            self.containerOrderInfo.totalPrice = self.totalPrice;

            CentainBoxOrderVC *vc= [CentainBoxOrderVC new];
            vc.containerOrderInfo = self.containerOrderInfo;
            if (![self.viBackground isHidden]) {

                [self moneyDetailAction];
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
        }


        
    }

    



}

//选择地址
-(void)addressChooseAction {

    EmptyContainerAddressVC *vc = [EmptyContainerAddressVC new];
    vc.containerOrderInfo = self.containerOrderInfo;

    if (self.endCity) {

        vc.endCity = self.endCity;
    }
    [self.navigationController pushViewController:vc animated:YES];
    WS(ws);


    [vc returnInfo:^(NSString *name, NSString *phone, StationModel *startStation, StationModel *endStation, NSString *startFullName, NSString *endFullName,CityModel *endCity) {
        ws.addressType = 1;
        ws.lbName.text = name;
        ws.lbPhone.text = phone;
        ws.lbCarryAddress.text = [NSString stringWithFormat:@"%@ %@",startFullName,startStation.name];

        if ([ws.lbCarryAddress.text sizeWithAttributes:@{NSFontAttributeName:ws.lbCarryAddress.font}].width <= ws.lbCarryAddress.width) {
            ws.lbCarryAddress.frame = CGRectMake(40,self.lbName.bottom + 15, SCREEN_W - 80, 26);
        }else {

            ws.lbCarryAddress.frame = CGRectMake(40,self.lbName.bottom + 15, SCREEN_W - 80, 40);
        }

        ws.lbGiveBackAddress.text = [NSString stringWithFormat:@"%@ %@",endFullName,endStation.name];

        if ([ws.lbGiveBackAddress.text sizeWithAttributes:@{NSFontAttributeName:ws.lbGiveBackAddress.font}].width <= ws.lbGiveBackAddress.width) {
            ws.lbGiveBackAddress.frame = CGRectMake(40,self.ivAddress1.bottom + 23, SCREEN_W - 80, 26);
        }else {

            ws.lbGiveBackAddress.frame = CGRectMake(40,self.ivAddress1.bottom + 23, SCREEN_W - 80, 40);

        }
        ws.containerOrderInfo.startStation = startStation;
        ws.containerOrderInfo.endStation = endStation;
        ws.containerOrderInfo.startFullName = startFullName;
        ws.containerOrderInfo.endFullName = endFullName;
        ws.containerOrderInfo.name = name;
        ws.containerOrderInfo.phone = phone;

        ws.endCity = endCity;
        if ([ws.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {


            ws.ivAddress2.hidden = YES;
            ws.lbGiveBackAddress.hidden = YES;
        }
        [self bindView];
    }];


}


/**
 *  getter
 */

- (UIScrollView *)svGoodsDetail {

    if (!_svGoodsDetail) {
        _svGoodsDetail = [UIScrollView new];
        _svGoodsDetail.contentSize = CGSizeMake(SCREEN_W, 800);

    }
    return _svGoodsDetail;
}

/*****************************地址联系人信息*****************************/

- (UIView *)viAddressAndContact {
    if (!_viAddressAndContact) {
        _viAddressAndContact = [UIView new];
        _viAddressAndContact.backgroundColor = [UIColor whiteColor];

    }
    return _viAddressAndContact;
}

- (UILabel *)lbReceieve {
    if (!_lbReceieve) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.frame = CGRectMake(14, 22, 12, 12);
        label.text = @"收";



        _lbReceieve = label;
    }
    return _lbReceieve;
}

- (UILabel *)lbName {
    if (!_lbName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"赵四";
        label.frame = CGRectMake(40, 20, 50, 20);


        _lbName = label;
    }
    return _lbName;
}

- (UILabel *)lbPhone {
    if (!_lbPhone) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"18818181188";
        label.frame = CGRectMake(self.lbName.right +10, 20, 120, 20);



        _lbPhone = label;
    }
    return _lbPhone;
}

- (UIImageView *)ivAddress1 {
    if (!_ivAddress1) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"address"];
        imageView.frame = CGRectMake(14, self.lbName.bottom + 22, 10, 11);


        _ivAddress1 = imageView;
    }
    return _ivAddress1;
}

- (UIImageView *)ivAddress2 {
    if (!_ivAddress2) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"address"];
        imageView.frame = CGRectMake(14, self.lbCarryAddress.bottom + 22, 10, 11);

        _ivAddress2 = imageView;
    }
    return _ivAddress2;
}

- (UILabel *)lbCarryAddress {
    if (!_lbCarryAddress) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.frame = CGRectMake(40,self.lbName.bottom + 15, SCREEN_W - 80, 40);
        label.text = @"收箱地：北京市海淀区东升西小口文龙家园二里2号楼一单元704";
        label.numberOfLines = 0;



        _lbCarryAddress = label;
    }
    return _lbCarryAddress;
}

- (UILabel *)lbGiveBackAddress {
    if (!_lbGiveBackAddress) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.frame = CGRectMake(40,self.ivAddress1.bottom + 15, SCREEN_W - 80, 40);
        label.text = @"还箱地：北京市海淀区东升西小口文龙家园二里2号楼一单元704";
        label.numberOfLines = 0;



        _lbGiveBackAddress = label;
    }
    return _lbGiveBackAddress;
}

- (UIImageView *)ivCell {
    if (!_ivCell) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 80, 7, 13);


        _ivCell = imageView;
    }
    return _ivCell;
}

- (UIImageView *)ivColorLine {
    if (!_ivColorLine) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"colorLine"];
        imageView.frame = CGRectMake(0, 164, SCREEN_W, 1);


        _ivColorLine = imageView;
    }
    return _ivColorLine;
}

- (UIView *)viNoAddress {
    if (!_viNoAddress) {
        _viNoAddress = [UIView new];
        _viNoAddress.backgroundColor = [UIColor whiteColor];
        _viNoAddress.frame = CGRectMake(0, 0, SCREEN_W, 44);
        self.btnAddressChoose1.frame = CGRectMake(0, 0, SCREEN_W, 44);
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"address"];
        iv.frame = CGRectMake(15, 13, 10, 11);
        UILabel *lb = [UILabel new];
        lb.text = @"设置收货信息";
        lb.textColor = APP_COLOR_GRAY_TEXT_1;
        lb.frame = CGRectMake(40,10 , SCREEN_W - 40, 20);
        lb.font = [UIFont systemFontOfSize:14];
        UIImageView *ivLine = [UIImageView new];
        ivLine.image = [UIImage imageNamed:@"colorLine"];
        ivLine.frame = CGRectMake(0, 43, SCREEN_W, 1);
        [_viNoAddress addSubview:iv];
        [_viNoAddress addSubview:lb];
        [_viNoAddress addSubview:ivLine];
        [_viNoAddress addSubview:self.btnAddressChoose1];

        UIImageView *ivCell = [UIImageView new];
        ivCell.image = [UIImage imageNamed:@"cell"];
        ivCell.frame = CGRectMake(SCREEN_W - 20, 15, 7, 13);
        [_viNoAddress addSubview:ivCell];





    }
    return _viNoAddress;
}

- (UIButton *)btnAddressChoose1 {
    if (!_btnAddressChoose1) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addressChooseAction) forControlEvents:UIControlEventTouchUpInside];


        _btnAddressChoose1 = button;
    }
    return _btnAddressChoose1;
}

- (UIButton *)btnAddressChoose2 {
    if (!_btnAddressChoose2) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addressChooseAction) forControlEvents:UIControlEventTouchUpInside];

        _btnAddressChoose2 = button;
    }
    return _btnAddressChoose2;
}


/*****************************箱子信息*****************************/

- (UIView *)viBoxGoods {
    if (!_viBoxGoods) {
        _viBoxGoods = [UIView new];
        _viBoxGoods.backgroundColor = [UIColor whiteColor];

    }
    return _viBoxGoods;
}

- (UIImageView *)ivBoxGoods {
    if (!_ivBoxGoods) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"s1"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(14, 28, 70, 58);

        _ivBoxGoods = imageView;
    }
    return _ivBoxGoods;
}

- (UILabel *)lbGoodsStatuse {
    if (!_lbGoodsStatuse) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = APP_COLOR_RED_TEXT.CGColor;
        label.text = [self.currrentInfo.authenticationStatus isEqualToString:@"1"]?@"认证":@"未认证";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame  = CGRectMake(self.ivBoxGoods.right + 10, 15, 26, 13);


        _lbGoodsStatuse = label;
    }
    return _lbGoodsStatuse;
}

- (UILabel *)lbGoodsName {
    if (!_lbGoodsName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"25英尺板架式汽车集装箱";
        label.frame = CGRectMake(self.lbGoodsStatuse.right + 10, 15, SCREEN_W - self.lbGoodsStatuse.right - 20, 18);



        _lbGoodsName = label;
    }
    return _lbGoodsName;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"￥120 /天/个";
        NSRange range;
        range = [label.text rangeOfString:@"/天/个"];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


        [AttributedStr addAttribute:NSFontAttributeName

                              value:[UIFont systemFontOfSize:12]

                              range:NSMakeRange(range.location,label.text.length - range.location)];
        label.attributedText = AttributedStr;
        label.frame  = CGRectMake(self.ivBoxGoods.right + 10, self.lbGoodsName.bottom+ 15, SCREEN_W - self.ivBoxGoods.right -20, 13);



        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbDeposit {

    if (!_lbDeposit) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        if (!self.containerOrderInfo.containerModel.deposit) {
            self.containerOrderInfo.containerModel.deposit = @"";
        }
        label.text = [NSString stringWithFormat:@"押金：￥%@/个",[self.containerOrderInfo.containerModel.deposit  NumberStringToMoneyString]];

        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


        NSUInteger loc =  label.text.length;
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:11.0]
                              range:NSMakeRange(loc - 5, 5)];

        label.attributedText = AttributedStr;

        label.frame = CGRectMake(0, self.lbPrice.bottom + 15, SCREEN_W/3, 15);
        label.frame  = CGRectMake(self.ivBoxGoods.right + 10, self.lbPrice.bottom+ 15, SCREEN_W - self.ivBoxGoods.right -20, 13);

        
        
        _lbDeposit = label;
    }
    return _lbDeposit;
}

- (UILabel *)lbBoxNum {
    if (!_lbBoxNum) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];

        label.text = @"商品编号：679088476656";
        label.frame = CGRectMake(15, self.lbDeposit.bottom + 30, SCREEN_W - 30, 20);

        _lbBoxNum = label;
    }
    return _lbBoxNum;
}

- (UILabel *)lbBoxPosition{
    if (!_lbBoxPosition) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];

        label.text = @"箱子位置：宁西回族自治区";
        label.frame = CGRectMake(15, self.lbBoxNum.bottom + 10, SCREEN_W - 30, 20);

        _lbBoxPosition = label;
    }
    return _lbBoxPosition;
}

- (UILabel *)lbBoxStatuse {
    if (!_lbBoxStatuse) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];

        label.text = @"箱型：新造箱";
        label.frame = CGRectMake(15, self.lbBoxPosition.bottom + 10, SCREEN_W - 30, 20);


        _lbBoxStatuse = label;
    }
    return _lbBoxStatuse;
}

- (UILabel *)lbBoxNumber {
    if (!_lbBoxNumber) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.attributedText = [self attributedStrWithString:@"数量：5"];
        label.frame = CGRectMake(SCREEN_W - 70, self.lbBoxPosition.bottom + 10, 60, 20);

        _lbBoxNumber = label;
    }
    return _lbBoxNumber;
}

- (UIButton *)btnUpAndDown {
    if (!_btnUpAndDown) {
        UIButton *button = [[UIButton alloc]init];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
        [button setTitle:@" 详细" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(upAndDownAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(SCREEN_W - 80, self.lbPrice.bottom, 70, 44);



        _btnUpAndDown = button;
    }
    return _btnUpAndDown;
}


/*****************************箱子使用时间*****************************/

- (UIView *)viUseTime {
    if (!_viUseTime) {
        _viUseTime = [UIView new];
        _viUseTime.backgroundColor = [UIColor whiteColor];

    }
    return _viUseTime;
}

- (UILabel *)lbUserTimeTitle {
    if (!_lbUserTimeTitle) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"箱子使用时间";
        label.frame = CGRectMake(15, 15, SCREEN_W - 15, 20);



        _lbUserTimeTitle = label;
    }
    return _lbUserTimeTitle;
}

- (UIImageView *)ivTime {
    if (!_ivTime) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"The calendar"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(15, 80, 10, 11);


        _ivTime = imageView;
    }
    return _ivTime;
}

- (UILabel *)lbStartTime {
    if (!_lbStartTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"未选择";
        label.frame = CGRectMake(self.ivTime.right + 20, 61, 100, 20);



        _lbStartTime = label;
    }
    return _lbStartTime;
}

- (UIButton *)btnStartTime {

    if (!_btnStartTime) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(timeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(self.ivTime.right + 20, 61, SCREEN_W, 20);



        _btnStartTime = button;
    }
    return _btnStartTime;
}

- (UILabel *)lbEndTime {
    if (!_lbEndTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"未选择";
        label.frame = CGRectMake(self.ivTime.right + 20, self.lbStartTime.bottom + 15, 100, 20);

        _lbEndTime = label;
    }
    return _lbEndTime;
}

- (UIButton *)btnEndTime {

    if (!_btnEndTime) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(timeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(self.ivTime.right + 20, self.lbStartTime.bottom + 15, SCREEN_W, 20);


        _btnEndTime = button;
    }
    return _btnEndTime;
}

- (UILabel *)lbStartTimeMessage {
    if (!_lbStartTimeMessage) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.frame = CGRectMake(self.lbStartTime.right + 10, 61, 60, 20);
        label.text = @"开始日期";



        _lbStartTimeMessage = label;
    }
    return _lbStartTimeMessage;
}

- (UILabel *)lbEndTimeMessage{
    if (!_lbEndTimeMessage) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];

        label.frame = CGRectMake(self.lbStartTime.right + 10, self.lbStartTime.bottom + 16, 60, 20);
        label.text = @"结束日期";


        _lbEndTimeMessage = label;
    }
    return _lbEndTimeMessage;
}

- (UILabel *)lbDay {

    if (!_lbDay) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.frame = CGRectMake(self.lbStartTimeMessage.right + 5, 77, 60, 20);



        _lbDay = label;
    }
    return _lbDay;
}

- (UIImageView *)ivCell1 {
    if (!_ivCell1) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 63, 7, 13);

        _ivCell1 = imageView;
    }
    return _ivCell1;
}

- (UIImageView *)ivCell2 {
    if (!_ivCell2) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 98, 7, 13);

        _ivCell2 = imageView;
    }
    return _ivCell2;
}


/*****************************卖家信息时间*****************************/

- (UIView *)viSeller {
    if (!_viSeller) {
        _viSeller = [UIView new];
        _viSeller.backgroundColor = [UIColor whiteColor];

    }
    return _viSeller;
}

- (UILabel *)lbSellerTitle {
    if (!_lbSellerTitle) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"卖家信息";



        _lbSellerTitle = label;
    }
    return _lbSellerTitle;
}

- (UILabel *)lbSellerCompany {
    if (!_lbSellerCompany) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"公司：潮州港务发展有限公司";
        label.attributedText = [self attributedStrWithString:label.text];



        _lbSellerCompany = label;
    }
    return _lbSellerCompany;
}

- (UILabel *)lbSellerPosition {
    if (!_lbSellerPosition) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"所在地：安徽省潮州市";
        label.attributedText = [self attributedStrWithString:label.text];



        _lbSellerPosition = label;
    }
    return _lbSellerPosition;
}

- (UILabel *)lbSellerPhone {
    if (!_lbSellerPhone) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"电话：18765432256";
        label.attributedText = [self attributedStrWithString:label.text];
        
        
        
        _lbSellerPhone = label;
    }
    return _lbSellerPhone;
}

/*****************************底部按钮*****************************/

- (UILabel *)lbBotoom {

    if (!_lbBotoom) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"1200.00";
        self.totalPrice = [self.containerOrderInfo.containerModel.unitPrice intValue] * self.containerOrderInfo.num + [self.containerOrderInfo.containerModel.deposit intValue]* self.containerOrderInfo.num + [self.containerOrderInfo.containerModel.offsiteReturnBoxPrice intValue];
        label.text = [NSString stringWithFormat:@"%.2f",self.totalPrice];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.attributedText = [self totalMoneyStyleWith:label.text];



        _lbBotoom = label;
    }
    return _lbBotoom;
}

- (UIButton *)btnMoneyDetail {

    if (!_btnMoneyDetail) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@" 明细" forState:UIControlStateNormal];
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

- (UIView *)viTime {

    if (!_viTime) {
        _viTime = [UIView new];
        _viTime.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _viTime.hidden = YES;

    }
    return _viTime;
}

- (UIButton *)btnCancle {
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];

        button.frame = CGRectMake(SCREEN_W - 45, 5  , 40, 25);
        [ button addTarget:self action:@selector(centainAction) forControlEvents:UIControlEventTouchUpInside];
        [ button setBackgroundColor:APP_COLOR_BLUE_BTN ];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;

        _btnCancle = button;
    }
    return _btnCancle;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [UIDatePicker new];
        _datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, SCREEN_W, 60)];
        _datePicker.frame = CGRectMake(0, self.btnCancle.bottom, SCREEN_W, 110);
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (UILabel *)lbTimeStyle{
    if (!_lbTimeStyle) {
        UILabel* label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, SCREEN_W, 40);
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;

        _lbTimeStyle = label;
    }
    return _lbTimeStyle;
}

- (UIView *)viPrice {
    if (!_viPrice) {
        _viPrice = [UIView new];
        _viPrice.hidden = YES;
        _viPrice.backgroundColor = [UIColor whiteColor];
        UILabel *lbRent = [self labelWithText:@"租金：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
        if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

            lbRent.text = @"箱子金额";
        }

        lbRent.frame = CGRectMake(15,  10, 110, 20);
        [_viPrice addSubview:lbRent];

        _lbRentMessage = [self labelWithText:@"¥100.00 * 2个 * 2天" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
        _lbRentMessage.frame = CGRectMake(lbRent.right + 10, 10, SCREEN_W - lbRent.right - 20, 20);
        [_viPrice addSubview:_lbRentMessage];

        UILabel *lbDeposit = [self labelWithText:@"押金：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
        lbDeposit.frame = CGRectMake(15, _lbRentMessage.bottom + 10, 110, 20);
        [_viPrice addSubview:lbDeposit];




        _lbDepositMessage = [self labelWithText:@"¥50.00 * 2个" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
        _lbDepositMessage.frame = CGRectMake(lbRent.right + 10, _lbRentMessage.bottom + 10, SCREEN_W - lbRent.right - 20, 20);
        [_viPrice addSubview:_lbDepositMessage];


        UILabel *lbAdd = [self labelWithText:@"异地还箱费：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
        lbAdd.frame = CGRectMake(15, _lbDepositMessage.bottom + 10, 110, 20);
        [_viPrice addSubview:lbAdd];

        _lbAddMessage = [self labelWithText:@"¥250.00" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
        _lbAddMessage.frame = CGRectMake(lbRent.right + 10, _lbDepositMessage.bottom + 10, SCREEN_W - lbRent.right - 20, 20);
        [_viPrice addSubview:_lbAddMessage];

        UILabel *lbTransport = [self labelWithText:@"运费：" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY2];
        lbTransport.frame = CGRectMake(15, _lbAddMessage.bottom + 10, 110, 20);
        //[_viPrice addSubview:lbTransport];

        _lbTransportMessage = [self labelWithText:@"¥200.00" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentRight WithTextColor:[UIColor blackColor]];
        _lbTransportMessage.frame = CGRectMake(lbRent.right + 10, _lbAddMessage.bottom + 10, SCREEN_W - lbRent.right - 20, 20);
        //[_viPrice addSubview:_lbTransportMessage];


        if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

            lbDeposit.hidden = YES;
            _lbDepositMessage.hidden = YES;
            lbAdd.hidden = YES;

            _lbAddMessage.hidden = YES;
            if (!self.containerOrderInfo.containerModel.unitPrice) {
                self.containerOrderInfo.containerModel.unitPrice = @"";
            }
            NSMutableAttributedString * lbRentMessage = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ x %i个",[self.containerOrderInfo.containerModel.unitPrice NumberStringToMoneyString],self.containerOrderInfo.num]];
            [lbRentMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,lbRentMessage.length)];
            [lbRentMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbRentMessage.string rangeOfString:[self.containerOrderInfo.containerModel.unitPrice NumberStringToMoneyStringGetLastThree]]];
            _lbRentMessage.attributedText = lbRentMessage;
            self.totalPrice = [self.containerOrderInfo.containerModel.unitPrice intValue] * self.containerOrderInfo.num;

            self.lbBotoom.text = [NSString stringWithFormat:@"%.2f",self.totalPrice];
            self.lbBotoom.attributedText = [self totalMoneyStyleWith:self.lbBotoom.text];
            
        }
    }
    return _viPrice;
}

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.backgroundColor = [UIColor blackColor];
        _viBackground.alpha = 0.4;
        _viBackground.hidden = YES;
    }
    return _viBackground;
}

@end
