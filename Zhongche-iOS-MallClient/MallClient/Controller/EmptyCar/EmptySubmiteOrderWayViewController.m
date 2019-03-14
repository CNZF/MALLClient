//
//  EmptySubmiteOrderWayViewController.m
//  MallClient
//
//  Created by lxy on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptySubmiteOrderWayViewController.h"
#import "EmptyContainerAddressVC.h"
#import "ZSSearchViewController.h"
#import "GoodsInfo.h"
#import "EmptyAddressViewController.h"
#import "EmptyCarWayOrderCentainerVC.h"

@interface EmptySubmiteOrderWayViewController ()<ZSSearchViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *svGoodsDetail;
@property (nonatomic, strong) UIView       *viNoAddress;
@property (nonatomic, assign) int          addressType;//0未选择 1选择

@property (nonatomic, strong) UIView       *viAddressAndContact;//联系人
@property (nonatomic, strong) UILabel      *lbReceieve;//收图标
@property (nonatomic, strong) UILabel      *lbName;//联系人姓名
@property (nonatomic, strong) UILabel      *lbPhone;//联系人电话
@property (nonatomic, strong) UIImageView  *ivAddress1;//定位图标（收）
@property (nonatomic, strong) UIImageView  *ivAddress2;//定位图标（还）
@property (nonatomic, strong) UILabel      *lbCarryAddress;//收箱地址
@property (nonatomic, strong) UILabel      *lbGiveBackAddress;//还箱地址
@property (nonatomic, strong) UIImageView  *ivCell;//箭头
@property (nonatomic, strong) UIImageView  *ivColorLine;//彩带
@property (nonatomic, strong) UIButton     *btnAddressChoose1;
@property (nonatomic, strong) UIButton     *btnAddressChoose2;

@property (nonatomic, strong) UIView       *viCar;
@property (nonatomic, strong) UIImageView  *ivCar;
@property (nonatomic, strong) UILabel      *lbCarName;
@property (nonatomic, strong) UILabel      *lbPrice;
@property (nonatomic, strong) UILabel      *lbCity;
@property (nonatomic, strong) UILabel      *lbGoodsStatuse;

@property (nonatomic, strong) UIView       *viCarMessage;
@property (nonatomic, strong) UILabel      *lbGoodsNum;
@property (nonatomic, strong) UILabel      *lbCarNum;
@property (nonatomic, strong) UILabel      *lbCarryWeight;
@property (nonatomic, strong) UILabel      *lbTime;

@property (nonatomic, strong) UIView       *viChooseway;
@property (nonatomic, strong) UILabel      *lbChooseway;

@property (nonatomic, strong) UIView       *viSeller;
@property (nonatomic, strong) UILabel      *lbCompanyName;
@property (nonatomic, strong) UILabel      *lbCompanyPhone;

@property (nonatomic, strong) UILabel      *lbDate;
@property (nonatomic, strong) UIView       *viTime;

@property (nonatomic, strong) UILabel      *lbGoods;
@property (nonatomic, strong) UIView       *viGoods;

@property (nonatomic, strong) UIView      *viBottom;
@property (nonatomic, strong) UIButton    *btnNext;
@property (nonatomic, strong) UILabel     *lbTotalPrice;


@property (nonatomic, strong) UIView             *viTimePicker;
@property (nonatomic, strong) UIButton           *btnCancle;
@property (nonatomic, strong) UIDatePicker       *datePicker;

@property (nonatomic, strong) GoodsInfo *goodsInfo;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *endAddress;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UIButton *btnIsShow;

@property (nonatomic, strong) UIView *viRount;

@end

@implementation EmptySubmiteOrderWayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 *  加载视图
 */
- (void)bindView {

    self.title = @"填写订单";


    self.svGoodsDetail.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.svGoodsDetail];

    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;


    CGFloat hight;
    if (!self.isShow) {

        hight = 112;
        self.viCarMessage.hidden = YES;
        [self.btnIsShow setImage:[UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];

    }else{

        hight = 240;
        self.viCarMessage.hidden = NO;
        [self.btnIsShow setImage:[UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
    }





    if (self.addressType == 0) {

        [self.svGoodsDetail addSubview:self.viNoAddress];
        self.viCar.frame = CGRectMake(0, self.viNoAddress.bottom + 10, SCREEN_W, hight);

    }else {

        self.viAddressAndContact.frame = CGRectMake(0, 10, SCREEN_W, 165);
        [self viAddressAndContactMake];
        [self.svGoodsDetail addSubview:self.viAddressAndContact];
        self.viCar.frame = CGRectMake(0, self.viAddressAndContact.bottom + 10, SCREEN_W, hight);


    }

    [self viCarMake];
    [self.svGoodsDetail addSubview:self.viCar];


    self.viRount.frame = CGRectMake(0, self.viCar.bottom + 10, SCREEN_W, 44);
    self.viTime.frame = CGRectMake(0, self.viRount.bottom + 10, SCREEN_W, 44);
    self.viGoods.frame = CGRectMake(0, self.viTime.bottom + 10, SCREEN_W, 44);


    [self.svGoodsDetail addSubview:self.viRount];
    [self.svGoodsDetail addSubview:self.viTime];
    [self.svGoodsDetail addSubview:self.viGoods];

    self.viSeller.frame = CGRectMake(0, self.viGoods.bottom + 10, SCREEN_W, 120);
    [self viSellerMake];
    [self.svGoodsDetail addSubview:self.viSeller];

    [self.view addSubview:self.viBottom];

    self.viTimePicker.frame  = CGRectMake(0, SCREEN_H - 180 - 64, SCREEN_W, 180);
    [self.view addSubview:self.viTimePicker];

    [self timeViewMake];


}

- (void)bindModel {

//    if(self.currentModel){
//
//        self.lbGoodsNum.text = self.currentModel.goodsNum;
//        self.lbCarNum.text = self.currentModel.carNum;
//        self.lbCarryWeight.text = self.currentModel.carCarryWeight;
//        self.lbTime.text = self.currentModel.produceYear;
//        self.lbCarName.text = self.currentModel.name;
//        self.lbPrice.text = self.currentModel.price;
//        self.lbCity.text = self.currentModel.city;
//
//        self.lbCompanyName.text = self.currentModel.sellerCompany;
//        self.lbPhone.text = self.currentModel.phone;
//        
//    }

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

- (void)viCarMake {

    [self.viCar addSubview:self.ivCar];
    [self.viCar addSubview:self.lbCarName];
    [self.viCar addSubview:self.lbGoodsStatuse];
    [self.viCar addSubview:self.lbPrice];
    [self.viCar addSubview:self.lbCity];
    [self.viCar addSubview:self.btnIsShow];


    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, self.lbCity.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viCar addSubview:lbLine];

    self.viCarMessage.frame = CGRectMake(0, lbLine.bottom + 10, SCREEN_W, 110);
    [self viCarMessageMake];
    [self.viCar addSubview:self.viCarMessage];

}

- (void)viCarMessageMake {


    //lbGoodsNum

    self.lbGoodsNum.frame = CGRectMake(15,  5, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbGoodsNum];
    self.lbCarNum.frame = CGRectMake(15,  self.lbGoodsNum.bottom + 10, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbCarNum];
    self.lbCarryWeight.frame = CGRectMake(15, self.lbCarNum.bottom + 10, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbCarryWeight];
    self.lbTime.frame = CGRectMake(15, self.lbCarryWeight .bottom + 10, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbTime];

}

- (void)viSellerMake {

    UILabel *lbTitle = [self labelWithText:@"卖家信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTitle.frame = CGRectMake(15, 15, SCREEN_W - 15, 20);
    [self.viSeller addSubview:lbTitle];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, lbTitle.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viSeller addSubview:lbLine];

    self.lbCompanyName.frame = CGRectMake(15, lbLine.bottom + 15, SCREEN_W - 15, 10);
    [self.viSeller addSubview:self.lbCompanyName];

    self.lbCompanyPhone.frame = CGRectMake(15, self.lbCompanyName.bottom + 10, SCREEN_W - 15, 10);
    [self.viSeller addSubview:self.lbCompanyPhone];


}

- (void)centainAction {

    self.viTimePicker.hidden = YES;
    NSDate *date = self.datePicker.date;
    self.startDate = date;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stDate = [dateFormatter stringFromDate:date];
    self.lbDate.text = stDate;

    [self checkButton];
}

//选择地址
-(void)addressChooseAction {

    EmptyAddressViewController *vc = [EmptyAddressViewController new];
    vc.currentModel = self.currentModel;
    if(self.addressType == 1){

        vc.name = self.lbName.text;
        vc.phone = self.lbPhone.text;
        vc.tvStart.text = self.startAddress;
        vc.tvEnd.text = self.endAddress;


    }
    [self.navigationController pushViewController:vc animated:YES];
    WS(ws);

    [vc returnInfo:^(NSString *name, NSString *phone, NSString *startFullName, NSString *endFullName) {

        ws.lbName.text = name;
        ws.lbPhone.text = phone;
        ws.startAddress = startFullName;
        ws.endAddress = endFullName;

        if (!ws.currentModel.currentLine.startParentAddress) {
            ws.currentModel.currentLine.startParentAddress  =@"";
        }

        if (!ws.currentModel.currentLine.endParentAddress) {
            ws.currentModel.currentLine.endParentAddress  =@"";
        }
        ws.lbCarryAddress.text = [NSString stringWithFormat:@"起运地：%@%@%@",ws.currentModel.currentLine.startParentAddress,ws.currentModel.currentLine.startCity,startFullName];
        ws.lbGiveBackAddress.text = [NSString stringWithFormat:@"抵运地：%@%@%@",ws.currentModel.currentLine.endParentAddress,ws.currentModel.currentLine.endCity,endFullName];

        if ([ws.lbCarryAddress.text sizeWithAttributes:@{NSFontAttributeName:ws.lbCarryAddress.font}].width <= ws.lbCarryAddress.width) {
            ws.lbCarryAddress.frame = CGRectMake(40,self.lbName.bottom + 15, SCREEN_W - 80, 26);
        }else {

            ws.lbCarryAddress.frame = CGRectMake(40,self.lbName.bottom + 15, SCREEN_W - 80, 40);
        }

        if ([ws.lbGiveBackAddress.text sizeWithAttributes:@{NSFontAttributeName:ws.lbGiveBackAddress.font}].width <= ws.lbGiveBackAddress.width) {
            ws.lbGiveBackAddress.frame = CGRectMake(40,self.ivAddress1.bottom + 23, SCREEN_W - 80, 26);
        }else {

            ws.lbGiveBackAddress.frame = CGRectMake(40,self.ivAddress1.bottom + 23, SCREEN_W - 80, 40);
            
        }
        
        ws.addressType = 1;
        [self bindView];
        [self checkButton];

    }];

}

- (void)checkButton {

    if (self.addressType == 1&&self.goodsInfo &&self.startDate) {


        self.btnNext.backgroundColor = APP_COLOR_BLUE_BTN;
    }
}

//时间选择

- (void)timeViewMake {

    [self.viTimePicker addSubview:self.btnCancle];
    [self.viTimePicker addSubview:self.datePicker];
    
}

- (void)dateAction{

    self.viTimePicker.hidden = NO;
}

- (void)chooseGoodsAction {

    ZSSearchViewController * vc = [ZSSearchViewController new];
    vc.vcDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)getGood:(GoodsInfo *)goods {
    self.goodsInfo = goods;

    self.lbGoods.text = goods.name;

    [self checkButton];
}

- (void)nextAction {

    if (self.addressType == 1&&self.goodsInfo &&self.startDate) {

        EmptyCarWayOrderCentainerVC *vc= [EmptyCarWayOrderCentainerVC new];
        vc.startTime = self.startDate;
        vc.name = self.lbName.text;
        vc.phone  = self.lbPhone.text;
        vc.startAddress = self.startAddress;
        vc.endAddress = self.endAddress;
        vc.goods = self.goodsInfo;
        vc.currentModel = self.currentModel;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)upAndDownAction {

    self.isShow  = !self.isShow;
    [self bindView];
}

/**
 *  getter
 */

- (UIScrollView *)svGoodsDetail {

    if (!_svGoodsDetail) {
        _svGoodsDetail = [UIScrollView new];
        _svGoodsDetail.contentSize = CGSizeMake(SCREEN_W, 700);

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
        label.text = @"起运地：北京市海淀区东升西小口文龙家园二里2号楼一单元704";
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
        label.frame = CGRectMake(40,self.lbCarryAddress.bottom + 15, SCREEN_W - 80, 40);
        label.text = @"抵运地：北京市海淀区东升西小口文龙家园二里2号楼一单元704";
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
        lb.textColor = [UIColor blackColor];
        lb.frame = CGRectMake(40,10 , SCREEN_W - 40, 20);
        lb.font = [UIFont systemFontOfSize:14];
        UIImageView *ivLine = [UIImageView new];
        ivLine.image = [UIImage imageNamed:@"colorLine"];
        ivLine.frame = CGRectMake(0, 43, SCREEN_W, 1);
        [_viNoAddress addSubview:iv];
        [_viNoAddress addSubview:lb];
        [_viNoAddress addSubview:ivLine];
        [_viNoAddress addSubview:self.btnAddressChoose1];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 15, 7, 13);

        [_viNoAddress addSubview:imageView];





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

/*****************************车辆信息*****************************/

- (UIView *)viCar {
    if (!_viCar) {
        _viCar = [UIView new];
        _viCar.backgroundColor = [UIColor whiteColor];

    }
    return _viCar;
}

- (UIImageView *)ivCar {
    if (!_ivCar) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"001"];
        imageView.frame = CGRectMake(15, 20, 70, 70);
        if (self.currentModel.imgArr.count > 0) {
            [imageView sd_setImageWithURL:[self.currentModel.imgArr objectAtIndex:0]];
        }





        _ivCar = imageView;
    }
    return _ivCar;
}

- (UILabel *)lbCarName {
    if (!_lbCarName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = self.currentModel.name;
        label.frame = CGRectMake(self.ivCar.right + 10, 20, 150, 20);



        _lbCarName = label;
    }
    return _lbCarName;
}

- (UILabel *)lbGoodsStatuse {
    if (!_lbGoodsStatuse) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = APP_COLOR_ORANGE_BTN_TEXT.CGColor;
        if (self.currentModel.certification) {
            label.text  = self.currentModel.certification;
        }else {
            label.hidden = YES;
        }

        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(SCREEN_W - 60, 20, 45, 15);
        label.font = [UIFont systemFontOfSize:8];



        _lbGoodsStatuse = label;
    }
    return _lbGoodsStatuse;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor redColor];
        

        label.frame = CGRectMake(self.ivCar.right + 10, self.lbCarName.bottom + 10, 150, 20);


        if ([self.currentModel.currentLine.price intValue]) {

            label.text = [NSString stringWithFormat:@"￥%@ 起",[self getMoneyStringWithMoneyNumber:[self.currentModel.currentLine.price doubleValue]]];
            NSRange range;
            range = [label.text rangeOfString:@"起"];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


            [AttributedStr addAttribute:NSForegroundColorAttributeName

                                  value:APP_COLOR_GRAY999

                                  range:NSMakeRange(range.location,label.text.length - range.location)];
            [AttributedStr addAttribute:NSFontAttributeName

                                  value:[UIFont systemFontOfSize:10]

                                  range:NSMakeRange(label.text.length - 4, 4)];
            label.attributedText = AttributedStr;
        }else {

            label.textColor = APP_COLOR_BLUE_BTN;
            label.text = @"电询";
        }

        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbCity {
    if (!_lbCity) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY999;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = self.currentModel.city;
        label.frame = CGRectMake(self.ivCar.right + 10, self.lbPrice.bottom + 7, 150, 20);
        
        
        _lbCity = label;
    }
    return _lbCity;
}

- (UIView *)viCarMessage {
    if (!_viCarMessage) {
        _viCarMessage = [UIView new];
        _viCarMessage.backgroundColor = [UIColor whiteColor];

    }
    return _viCarMessage;
}

- (UILabel *)lbCarNum {
    if (!_lbCarNum) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.text = [NSString stringWithFormat:@"车牌号：%@",self.currentModel.carNum];



        _lbCarNum = label;
    }
    return _lbCarNum;
}

- (UILabel *)lbCarryWeight {
    if (!_lbCarryWeight) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.text = [NSString stringWithFormat:@"载重量：%@吨",self.currentModel.carCarryWeight];

        _lbCarryWeight = label;
    }
    return _lbCarryWeight;
}

- (UILabel *)lbTime {
    if (!_lbTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.text = [NSString stringWithFormat:@"出厂年份：%@", [self stDateToString:self.currentModel.produceYear]];

        _lbTime = label;
    }
    return _lbTime;
}

- (UILabel *)lbGoodsNum {
    if (!_lbGoodsNum) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY_TEXT_1;

        label.text = [NSString stringWithFormat:@"商品编号：%@",self.currentModel.goodsNum];

        _lbGoodsNum = label;
    }
    return _lbGoodsNum;
}

- (UIButton *)btnIsShow {
    if (!_btnIsShow) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"详细" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(upAndDownAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(SCREEN_W - 100, self.lbGoodsStatuse.bottom + 20, 100, 40);



        _btnIsShow = button;
    }
    return _btnIsShow;
}

/*****************************已选线路信息*****************************/

- (UIView *)viRount {
    if (!_viRount) {
        _viRount = [UIView new];
        _viRount.frame = CGRectMake(0, self.viCar.bottom + 10, SCREEN_W, 44);
        _viRount.backgroundColor = [UIColor whiteColor];
        UILabel *lbTitle = [UILabel new];
        lbTitle.font = [UIFont systemFontOfSize:14];
        lbTitle.frame = CGRectMake(15, 0, 80, 44);
        lbTitle.text = @"已选线路";
        [_viRount addSubview:lbTitle];
        UILabel *lbRout = [UILabel new];
        lbRout.frame = CGRectMake(lbTitle.right, 0, SCREEN_W - lbTitle.right - 22, 44);
        lbRout.textAlignment = NSTextAlignmentRight;
        lbRout.textColor = [UIColor lightGrayColor];
        lbRout.text = self.currentModel.currentLine.lineStr;
        lbRout.font = [UIFont systemFontOfSize:14];
        [_viRount addSubview:lbRout];

    }
    return _viRount;
}


/*****************************卖家信息*****************************/

- (UIView *)viSeller {
    if (!_viSeller) {
        _viSeller = [UIView new];
        _viSeller.backgroundColor = [UIColor whiteColor];
    }
    return _viSeller;
}

- (UILabel *)lbCompanyName {
    if (!_lbCompanyName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = [NSString stringWithFormat:@"公司：%@",self.currentModel.sellerCompany];
        label.textColor = APP_COLOR_GRAY666;
        label.attributedText = [self attributedStrWithString:label.text];



        _lbCompanyName = label;
    }
    return _lbCompanyName;
}

- (UILabel *)lbCompanyPhone {
    if (!_lbCompanyPhone) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY666;
        label.text = [NSString stringWithFormat:@"电话：%@",self.currentModel.phone];
        label.attributedText = [self attributedStrWithString:label.text];


        _lbCompanyPhone = label;
    }
    return _lbCompanyPhone;
}

/*****************************运输日期*****************************/

- (UIView *)viTime {
    if (!_viTime) {
        _viTime = [UIView new];
        _viTime.frame = CGRectMake(0, self.viRount.bottom + 10, SCREEN_W, 44);
        _viTime.backgroundColor = [UIColor whiteColor];
        UILabel *lbTitle = [UILabel new];
        lbTitle.font = [UIFont systemFontOfSize:14];
        lbTitle.frame = CGRectMake(15, 0, 80, 44);
        lbTitle.text = @"运输日期";
        [_viTime addSubview:lbTitle];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 15, 7, 13);
        [_viTime addSubview:imageView];

        self.lbDate.frame = CGRectMake(SCREEN_W - 127, 0, 100, 44);
        self.lbDate.textAlignment = NSTextAlignmentRight;
        self.lbDate.textColor = [UIColor lightGrayColor];
        self.lbDate.text = @"未选择";
        [_viTime addSubview:self.lbDate];

        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, SCREEN_W, 44);
        [btn addTarget:self action:@selector(dateAction) forControlEvents:UIControlEventTouchUpInside];
        [_viTime addSubview:btn];


    }
    return _viTime;
}

- (UILabel *)lbDate {
    if (!_lbDate) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0f];



        _lbDate = label;
    }
    return _lbDate;
}



/*****************************货品名称*****************************/

- (UIView *)viGoods {
    if (!_viGoods) {
        _viGoods = [UIView new];
        _viGoods.frame = CGRectMake(0, self.viTime.bottom + 10, SCREEN_W, 44);
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, SCREEN_W, 44);
        [btn addTarget:self action:@selector(chooseGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [_viGoods addSubview:btn];
        _viGoods.backgroundColor = [UIColor whiteColor];
        UILabel *lbTitle = [UILabel new];
        lbTitle.font = [UIFont systemFontOfSize:14];
        lbTitle.frame = CGRectMake(15, 0, 80, 44);
        lbTitle.text = @"货品名称";
        [_viGoods addSubview:lbTitle];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 15, 7, 13);
        [_viGoods addSubview:imageView];

        self.lbGoods.frame = CGRectMake(SCREEN_W - 127, 0, 100, 44);
        self.lbGoods.textAlignment = NSTextAlignmentRight;
        self.lbGoods.textColor = [UIColor lightGrayColor];
        self.lbGoods.text = @"未选择";
        [_viGoods addSubview:self.lbGoods];

    }
    return _viGoods;
}

- (UILabel *)lbGoods {
    if (!_lbGoods) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0f];



        _lbGoods = label;
    }
    return _lbGoods;
}


- (UIButton *)btnNext {
    if (!_btnNext) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_GRAY_BTN_1];
        [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(SCREEN_W - 150, 0, 150, 50);



        _btnNext = button;
    }
    return _btnNext;
}

- (UIView *)viBottom {
    if (!_viBottom) {
        _viBottom = [UIView new];
        _viBottom.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
        _viBottom.backgroundColor = [UIColor whiteColor];
        [_viBottom addSubview:self.btnNext];
        [_viBottom addSubview:self.lbTotalPrice];

    }
    return _viBottom;
}

- (UILabel *)lbTotalPrice {
    if (!_lbTotalPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.textColor = [UIColor redColor];


        if ([self.currentModel.currentLine.price intValue]) {

            label.text = [NSString stringWithFormat:@"￥%@",[self getMoneyStringWithMoneyNumber:[self.currentModel.currentLine.price doubleValue]]];
            NSRange range;
            range = [label.text rangeOfString:@".00"];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];

            [AttributedStr addAttribute:NSFontAttributeName

                                  value:[UIFont systemFontOfSize:14]

                                  range:NSMakeRange(range.location,label.text.length - range.location)];
            label.attributedText = AttributedStr;
        }else {

            label.textColor = APP_COLOR_BLUE_BTN;
            label.text = @"电询";
        }

        label.frame = CGRectMake(15, 0, 200, 50);




        _lbTotalPrice = label;
    }
    return _lbTotalPrice;
}

//时间选择

- (UIView *)viTimePicker {

    if (!_viTimePicker) {
        _viTimePicker = [UIView new];
        _viTimePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _viTimePicker.hidden = YES;

    }
    return _viTimePicker;
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










@end
