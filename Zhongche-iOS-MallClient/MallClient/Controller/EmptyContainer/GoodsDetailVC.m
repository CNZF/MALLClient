//
//  GoodsDetailVC.m
//  MallClient
//
//  Created by lxy on 2017/1/6.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "LLBannerView.h"
#import "RentBoxVi.h"
#import "WriteOutBoxOrder.h"
#import "EmptyContainerViewModel.h"
#import "ContainerOrderInfo.h"

@interface GoodsDetailVC ()

@property (nonatomic, strong) UIScrollView *svGoodsDetail;


@property (nonatomic, strong) UIView       *viHead;
@property (nonatomic, strong) LLBannerView *bannerVi;
@property (nonatomic, strong) UILabel      *lbGoodsStatuse;//箱子认证状态
@property (nonatomic, strong) UILabel      *lbGoodsName;
@property (nonatomic, strong) UILabel      *lbPrice;
@property (nonatomic, strong) UILabel      *lbDeposit;//押金
@property (nonatomic, strong) UILabel      *lbNum;
@property (nonatomic, strong) UILabel      *lbRemark;

@property (nonatomic, strong) UIView       *viBoxDetail;
@property (nonatomic, strong) UILabel      *lbBoxTitle;
@property (nonatomic, strong) UILabel      *lbBoxPosition;
@property (nonatomic, strong) UILabel      *lbBoxData;//箱子材料
@property (nonatomic, strong) UILabel      *lbBoxVolume;//箱子容积
@property (nonatomic, strong) UILabel      *lbBoxDeadWeight;//自重
@property (nonatomic, strong) UILabel      *lbBoxCarryWeight;//载重
@property (nonatomic, strong) UILabel      *lbBoxStatuse;//状况
@property (nonatomic, strong) UILabel      *lbBoxStruct;//结构
@property (nonatomic, strong) UILabel      *lbBoxDateOfProduction;//出厂年份

@property (nonatomic, strong) UIView       *viSeller;
@property (nonatomic, strong) UILabel      *lbSellerTitle;
@property (nonatomic, strong) UILabel      *lbSellerCompany;
@property (nonatomic, strong) UILabel      *lbSellerPosition;
@property (nonatomic, strong) UILabel      *lbSellerPhone;

@property (nonatomic, strong) UIButton     *btnAddShoppingCart;//加入购物车
@property (nonatomic, strong) UIButton     *btnRent;//立即租用

@property (nonatomic, strong) UIButton     *btnUpAndDown;

@property (nonatomic, strong) RentBoxVi    *viewSear;

@property (nonatomic, strong) ContainerModel *currrentInfo;



@end

@implementation GoodsDetailVC

- (void)dealloc {
    [self.bannerVi.timer invalidate];
    self.bannerVi = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.svGoodsDetail.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.svGoodsDetail];

    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 360);
    [self.svGoodsDetail addSubview:self.viHead];

    [self viHeadMake];

    self.viBoxDetail.frame = CGRectMake(0, self.viHead.bottom + 10, SCREEN_W, 250);
    [self.svGoodsDetail addSubview:self.viBoxDetail];
    [self viBoxDetailMake];


    self.viSeller.frame = CGRectMake(0, self.viBoxDetail.bottom + 10, SCREEN_W, 155);
    [self.svGoodsDetail addSubview:self.viSeller];
    [self viSellerMake];

    self.btnAddShoppingCart.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W/2, 50);
    [self.view addSubview:self.btnAddShoppingCart];

    self.btnRent.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.btnRent];



}

- (void)bindModel {

    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 1; i ++) {
        [arr addObject:[UIImage imageNamed:@"banner_1"]];
        [arr addObject:[UIImage imageNamed:@"banner_2"]];
        [arr addObject:[UIImage imageNamed:@"banner_3"]];
    }
    self.bannerVi.images = arr;

}

- (void)getData {

    EmptyContainerViewModel *vm = [EmptyContainerViewModel new];
    WS(ws);
    
    [vm selectEmptyContainerWithID:self.ID callback:^(ContainerModel *info) {

        //banner图片处理
        NSMutableArray * arr = [NSMutableArray array];

        NSString *stImgUrls = info.photoUrl;
        if ([stImgUrls containsString:@"☼"]) {

            for (NSString *st in [stImgUrls componentsSeparatedByString:@"☼"]) {
                [arr addObject:[NSString stringWithFormat:@"%@%@",BASEIMGURL,st]];
            }

        }else {
            
            if (stImgUrls) {
                [arr addObject:[NSString stringWithFormat:@"%@%@",BASEIMGURL,stImgUrls]];
            }


        }

        self.bannerVi.images = arr;
        self.viewSear = [RentBoxVi new];
        if(arr.count >0){


            [ws.viewSear.ivTransport sd_setImageWithURL:[NSURL URLWithString:arr[0]]];
        }

        //箱子信息处理

        ws.currrentInfo = info;
        [self bindView];

        if([info.returnType isEqualToString:@"可异地还箱"]){

            ws.lbRemark.text = info.returnType;
            
        }else {

            ws.lbRemark.text = @"只限同城";

        }

        [self hidenAction];

    }];

}

//箱子信息收缩
- (void)hidenAction {

    self.lbBoxCarryWeight.hidden = !self.lbBoxCarryWeight.hidden;
    self.lbBoxDeadWeight.hidden = self.lbBoxCarryWeight.hidden;
    self.lbBoxStruct.hidden = self.lbBoxCarryWeight.hidden;
    self.lbBoxStatuse.hidden = self.lbBoxCarryWeight.hidden;
    self.lbBoxDateOfProduction.hidden = self.lbBoxCarryWeight.hidden;

    [self.btnUpAndDown setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    self.viBoxDetail.frame = CGRectMake(0, self.viHead.bottom + 10, SCREEN_W, 250);
    [self.svGoodsDetail addSubview:self.viBoxDetail];

    if (self.lbBoxCarryWeight.isHidden) {

        self.viBoxDetail.frame = CGRectMake(0, self.viHead.bottom + 10, SCREEN_W, 130);
        [self.svGoodsDetail addSubview:self.viBoxDetail];
        [self.btnUpAndDown setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    }

    self.viSeller.frame = CGRectMake(0, self.viBoxDetail.bottom + 10, SCREEN_W, 155);
    [self.svGoodsDetail addSubview:self.viSeller];

}

//顶部view
- (void)viHeadMake {

    [self.viHead addSubview:self.bannerVi];

    self.lbGoodsStatuse.frame = CGRectMake(15, self.bannerVi.bottom + 18 , 26, 13);
    [self.viHead addSubview:self.lbGoodsStatuse];

    self.lbGoodsName.frame = CGRectMake(self.lbGoodsStatuse.right + 10,self.bannerVi.bottom + 14 , SCREEN_W - self.lbGoodsStatuse.right - 10, 20);
    [self.viHead addSubview:self.lbGoodsName];

    self.lbPrice.frame = CGRectMake(15, self.lbGoodsName.bottom + 10, SCREEN_W - 15, 20);
    [self.viHead addSubview:self.lbPrice];

    if (self.currrentInfo) {
        self.lbGoodsStatuse.text = [self.currrentInfo.authenticationStatus isEqualToString:@"1"]?@"认证":@"未认证";
        self.lbGoodsName.text = self.currrentInfo.containerName;
        self.lbPrice.text = [NSString stringWithFormat:@"￥%@ /天/个",[self.currrentInfo.unitPrice NumberStringToMoneyString]];
        NSString *st = self.lbPrice.text;
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];

        NSUInteger loc =  st.length;

        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:11.0]
                              range:NSMakeRange(loc - 8, 8)];


//        [AttributedStr.string rangeOfString:[NSString stringWithFormat:@"%@ /天/个",[self.currrentInfo.unitPrice NumberStringToMoneyStringGetLastThree]]];

        self.lbPrice.attributedText = AttributedStr;
        if (!self.currrentInfo.deposit) {
            self.currrentInfo.deposit = @"";
        }
//        NSMutableAttributedString * lbDepositText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"押金:￥%@/个",[self.currrentInfo.deposit NumberStringToMoneyString]]];
//        [lbDepositText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0,lbDepositText.length)];
//        [lbDepositText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8.0f] range:[lbDepositText.string rangeOfString:[self.currrentInfo.deposit NumberStringToMoneyStringGetLastThree]]];
        self.lbDeposit.text = [NSString stringWithFormat:@"押金:￥%@/个",[self.currrentInfo.deposit NumberStringToMoneyString]];
        NSString *st1 = self.lbDeposit.text;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:st1];

        NSUInteger loc1 =  st1.length;

        [AttributedStr1 addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:8.0]
                              range:NSMakeRange(loc1 - 5, 5)];

        self.lbDeposit.attributedText = AttributedStr1;
        
        if(self.style == 1){

            self.lbPrice.text = [NSString stringWithFormat:@"￥%@ /个",[self.currrentInfo.unitPrice NumberStringToMoneyString]];
            st = self.lbPrice.text;
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:st];
            loc =  st.length;
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:11.0]
                                  range:NSMakeRange(loc - 6, 6)];
            self.lbPrice.attributedText = AttributedStr;

            [self.btnRent setTitle:@"立即购买" forState:UIControlStateNormal];

        }
        self.lbNum.text = [NSString stringWithFormat:@"库存：%@个",self.currrentInfo.storageNumber];

        if([self.currrentInfo.storageNumber intValue]> 99) {

            self.lbNum.text = @"充足";

        }
        self.lbRemark.text = self.currrentInfo.returnType;
    }

    [self.viHead addSubview:self.lbDeposit];
    [self.viHead addSubview:self.lbNum];
    [self.viHead addSubview:self.lbRemark];



}

//箱子详情
- (void)viBoxDetailMake {

    self.lbBoxTitle.frame = CGRectMake(15, 10, SCREEN_W - 15, 20);
    [self.viBoxDetail addSubview:self.lbBoxTitle];

    self.btnUpAndDown.frame = CGRectMake(SCREEN_W - 40, 10, 30, 20);
    [self.viBoxDetail addSubview:self.btnUpAndDown];

    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(15, self.lbBoxTitle.bottom + 10, SCREEN_W - 15, 1);
    [self.viBoxDetail addSubview:lbLine];

    self.lbBoxPosition.frame = CGRectMake(15, lbLine.bottom + 10, SCREEN_W - 15, 20);
    [self.viBoxDetail addSubview:self.lbBoxPosition];

    self.lbBoxData.frame = CGRectMake(15, self.lbBoxPosition.bottom + 10, 100, 20);
    [self.viBoxDetail addSubview:self.lbBoxData];

    self.lbBoxVolume.frame = CGRectMake(self.lbBoxData.right, self.lbBoxPosition.bottom + 10, SCREEN_W - self.lbBoxData.right, 20);
    [self.viBoxDetail addSubview:self.lbBoxVolume];

    self.lbBoxDeadWeight.frame = CGRectMake(15, self.lbBoxData.bottom + 10, 100, 20);
    [self.viBoxDetail addSubview:self.lbBoxDeadWeight];

    self.lbBoxCarryWeight.frame = CGRectMake(self.lbBoxDeadWeight.right, self.lbBoxData.bottom + 10, SCREEN_W - self.lbBoxData.right, 20);
    [self.viBoxDetail addSubview:self.lbBoxCarryWeight];

    self.lbBoxStatuse.frame = CGRectMake(15, self.lbBoxCarryWeight.bottom + 10, SCREEN_W - 15, 20);
    [self.viBoxDetail addSubview:self.lbBoxStatuse];

    self.lbBoxStruct.frame = CGRectMake(15, self.lbBoxStatuse.bottom + 10, SCREEN_W - 15, 20);
    [self.viBoxDetail addSubview:self.lbBoxStruct];

    self.lbBoxDateOfProduction.frame = CGRectMake(15, self.lbBoxStruct.bottom + 10, SCREEN_W - 15, 20);
    [self.viBoxDetail addSubview:self.lbBoxDateOfProduction];

    if (self.currrentInfo) {


        self.lbBoxPosition.text = [NSString stringWithFormat:@"箱子位置：%@",self.currrentInfo.locationName];
        self.lbBoxPosition.attributedText = [self attributedStrWithString:self.lbBoxPosition.text];
        self.lbBoxData.text = [NSString stringWithFormat:@"材料：%@",self.currrentInfo.material];
        self.lbBoxData.attributedText = [self attributedStrWithString:self.lbBoxData.text];
        if(self.currrentInfo.volume) {

            self.lbBoxVolume.text = [NSString stringWithFormat:@"容积：%@m³",self.currrentInfo.volume];

        }else {

            self.lbBoxVolume.text = @"容积：-m³";
        }

        self.lbBoxVolume.attributedText = [self attributedStrWithString:self.lbBoxVolume.text];
        self.lbBoxDeadWeight.text = [NSString stringWithFormat:@"自重：%@吨",self.currrentInfo.selfWeight];
        self.lbBoxDeadWeight.attributedText = [self attributedStrWithString:self.lbBoxDeadWeight.text];
        self.lbBoxCarryWeight.text = [NSString stringWithFormat:@"载重：%@吨",self.currrentInfo.loadWeight];
        self.lbBoxCarryWeight.attributedText = [self attributedStrWithString:self.lbBoxCarryWeight.text];

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

        self.lbBoxStatuse.attributedText = [self attributedStrWithString:self.lbBoxStatuse.text];

        self.lbBoxStruct.text = [NSString stringWithFormat:@"箱子结构：%@",self.currrentInfo.structureName];
        self.lbBoxStruct.attributedText = [self attributedStrWithString:self.lbBoxStruct.text];
        self.lbBoxDateOfProduction.text = [NSString stringWithFormat:@"出厂年份：%@",[self stDateToString:self.currrentInfo.manufactureDate]];
        self.lbBoxDateOfProduction.attributedText = [self attributedStrWithString:self.lbBoxDateOfProduction.text];


    }

    if(self.style == 1){

        self.lbDeposit.hidden = YES;
        self.lbRemark.hidden = YES;
        self.lbNum.frame = CGRectMake(SCREEN_W*2/3, self.lbPrice.bottom + 15, SCREEN_W/3, 15);
        [self.viHead addSubview:self.lbNum];
    }

}

//卖家view
- (void)viSellerMake{

    self.lbSellerTitle.frame = CGRectMake(15, 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerTitle];

    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine.frame = CGRectMake(15, self.lbSellerTitle.bottom + 10, SCREEN_W - 15, 1);
    [self.viSeller addSubview:lbLine];

    self.lbSellerCompany.frame = CGRectMake(15, lbLine.bottom + 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerCompany];

    self.lbSellerPosition.frame = CGRectMake(15, self.lbSellerCompany.bottom + 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerPosition];

    self.lbSellerPhone.frame = CGRectMake(15, self.lbSellerPosition.bottom + 10, SCREEN_W - 15, 20);
    [self.viSeller addSubview:self.lbSellerPhone];

    if (self.currrentInfo) {
        if (!self.currrentInfo.companyName) {
            self.currrentInfo.companyName = @"无";
        }
        self.lbSellerCompany.text = [NSString stringWithFormat:@"公司：%@",self.currrentInfo.companyName];
        self.lbSellerCompany.attributedText = [self attributedStrWithString:self.lbSellerCompany.text];

        if (!self.currrentInfo.companyAddress) {
            self.currrentInfo.companyAddress = @"无";
        }
        self.lbSellerPosition.text = [NSString stringWithFormat:@"所在地：%@",self.currrentInfo.companyAddress];
        self.lbSellerPosition.attributedText = [self attributedStrWithString:self.lbSellerPosition.text];

        if (!self.currrentInfo.companyPhone) {
            self.currrentInfo.companyPhone = @"无";
        }
        self.lbSellerPhone.text = [NSString stringWithFormat:@"电话：%@",self.currrentInfo.companyPhone];
        self.lbSellerPhone.attributedText = [self attributedStrWithString:self.lbSellerPhone.text];
    }



}

//加入购物车
- (void)addShoppingCartAction {

    [[Toast shareToast]makeText:@"加入购物车成功" aDuration:1];

}

//立即租用
- (void)rentAction {



    if(USER_INFO){

        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        self.viewSear.lbDeposit.text = self.lbDeposit.text;
        self.viewSear.lbGoodsName.text = self.lbGoodsName.text;
        self.viewSear.lbPrice.text = [NSString stringWithFormat:@"￥%@ /天/个",self.currrentInfo.unitPrice];

        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.viewSear.lbPrice.text];


        [AttributedStr addAttribute:NSFontAttributeName

                              value:[UIFont systemFontOfSize:12]

                              range:NSMakeRange(self.viewSear.lbPrice.text.length - 8,8)];
        self.viewSear.lbPrice.attributedText = AttributedStr;
        self.viewSear.lbGoodsStatuse.text = self.lbGoodsStatuse.text;
        self.viewSear.lbNum.text = self.lbNum.text;


        [self.viewSear.btnboom addTarget:self action:@selector(boomAction) forControlEvents:UIControlEventTouchUpInside];

        self.viewSear.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);

        if(self.style == 1){

            self.viewSear.lbDeposit.hidden = YES;

            self.viewSear.lbPrice.text = [NSString stringWithFormat:@"￥%@ /个",self.currrentInfo.unitPrice];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.viewSear.lbPrice.text];


            [AttributedStr addAttribute:NSFontAttributeName

                                  value:[UIFont systemFontOfSize:12]

                                  range:NSMakeRange(self.viewSear.lbPrice.text.length - 6,6)];
            self.viewSear.lbPrice.attributedText = AttributedStr;
            
        }
        
        [window addSubview:self.viewSear];
    }else {

        [self pushLogoinVC];
    }


}

//弹框确定按钮
-(void)boomAction {

    

        [self.viewSear removeFromSuperview];

        ContainerOrderInfo *orderInfo = [ContainerOrderInfo new];
        orderInfo.containerModel = self.currrentInfo;
        orderInfo.sentType = self.viewSear.btnStyleChoose.titleLabel.text;
        orderInfo.num = self.viewSear.num;

        if (self.style == 0) {

            orderInfo.type = @"CONTAINER_RENTSALE_TYPE_RENT";
        }else {
            orderInfo.type = @"CONTAINER_RENTSALE_TYPE_SALE";
        }


        //self.currrentInfo.storageNumber
    if(orderInfo.num > 0){

        if (orderInfo.num >[self.currrentInfo.storageNumber intValue] ) {
            [[Toast shareToast]makeText:@"数量不够" aDuration:1];
        }else {

            WriteOutBoxOrder *vc = [WriteOutBoxOrder new];

            vc.containerOrderInfo = orderInfo;
            vc.style = self.style;
            vc.ivBoxGoods.image = self.viewSear.ivTransport.image;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else {

        [[Toast shareToast]makeText:@"数量不能为0" aDuration:1];
    }

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

/*****************************商品信息*****************************/

-(LLBannerView *)bannerVi {
    if (!_bannerVi) {
        _bannerVi = [LLBannerView new];
        _bannerVi.frame = CGRectMake(0, 0, SCREEN_W, 243);


    }
    return _bannerVi;
}

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = [UIColor whiteColor];

    }
    return _viHead;
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
        label.text  = @"认证";
        label.textAlignment = NSTextAlignmentCenter;


        _lbGoodsStatuse = label;
    }
    return _lbGoodsStatuse;
}

- (UILabel *)lbGoodsName {
    if (!_lbGoodsName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"25英尺板架式汽车集装箱";



        _lbGoodsName = label;
    }
    return _lbGoodsName;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"￥120 /天/个";
        NSRange range;
        range = [label.text rangeOfString:@"/天/个"];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


        [AttributedStr addAttribute:NSFontAttributeName

                              value:[UIFont systemFontOfSize:12]

                              range:NSMakeRange(range.location,label.text.length - range.location)];
        label.attributedText = AttributedStr;



        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbDeposit {

    if (!_lbDeposit) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"押金：¥7000";
        label.frame = CGRectMake(10, self.lbPrice.bottom + 15, SCREEN_W/3, 15);


        _lbDeposit = label;
    }
    return _lbDeposit;
}

- (UILabel *)lbNum {
    if (!_lbNum) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"库存：99个";
        label.frame = CGRectMake(SCREEN_W/3, self.lbPrice.bottom + 15, SCREEN_W/3, 15);


        _lbNum = label;
    }
    return _lbNum;
}

- (UILabel *)lbRemark {
    if (!_lbRemark) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"支持异地还箱";
        label.frame = CGRectMake(SCREEN_W*2/3, self.lbPrice.bottom + 15, SCREEN_W/3, 15);


        _lbRemark = label;
    }
    return _lbRemark;
}

/*****************************箱子信息*****************************/

- (UIView *)viBoxDetail {
    if (!_viBoxDetail) {
        _viBoxDetail = [UIView new];
        _viBoxDetail.frame = CGRectMake(0, self.viHead.bottom + 10, SCREEN_W, 250);
        _viBoxDetail.backgroundColor = [UIColor whiteColor];


    }
    return _viBoxDetail;
}

- (UILabel *)lbBoxTitle {
    if (!_lbBoxTitle) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"箱子信息";



        _lbBoxTitle = label;
    }
    return _lbBoxTitle;
}

- (UILabel *)lbBoxPosition {
    if (!_lbBoxPosition) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"箱子位置：宁夏回族自治区";
        label.attributedText = [self attributedStrWithString:label.text];

        _lbBoxPosition = label;
    }
    return _lbBoxPosition;
}

- (UILabel *)lbBoxData {
    if (!_lbBoxData) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"材料：刚";
        label.attributedText = [self attributedStrWithString:label.text];



        _lbBoxData = label;
    }
    return _lbBoxData;
}

- (UILabel *)lbBoxVolume {

    if (!_lbBoxVolume) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"容积：35m³";
        label.attributedText = [self attributedStrWithString:label.text];

        


        _lbBoxVolume = label;
    }
    return _lbBoxVolume;
}

- (UILabel *)lbBoxDeadWeight {

    if (!_lbBoxDeadWeight) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"自重：45吨";
        label.attributedText = [self attributedStrWithString:label.text];



        _lbBoxDeadWeight = label;
    }
    return _lbBoxDeadWeight;
}

- (UILabel *)lbBoxCarryWeight {
    if (!_lbBoxCarryWeight) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"载重：40吨";
        label.attributedText = [self attributedStrWithString:label.text];



        _lbBoxCarryWeight = label;
    }
    return _lbBoxCarryWeight;
}

- (UILabel *)lbBoxStatuse {
    if (!_lbBoxStatuse) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];

        label.text = @"箱子状况：新造箱";
        label.attributedText = [self attributedStrWithString:label.text];

        _lbBoxStatuse = label;
    }
    return _lbBoxStatuse;
}

- (UILabel *)lbBoxStruct {
    if (!_lbBoxStruct) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"箱子结构：密闭固定式集装箱";
        label.attributedText = [self attributedStrWithString:label.text];


        _lbBoxStruct = label;
    }
    return _lbBoxStruct;
}

- (UILabel *)lbBoxDateOfProduction {
    if (!_lbBoxDateOfProduction) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"出厂年份：2016-10-11";
        label.attributedText = [self attributedStrWithString:label.text];

        _lbBoxDateOfProduction = label;
    }
    return _lbBoxDateOfProduction;
}

- (UIButton *)btnUpAndDown {
    if (!_btnUpAndDown) {
        UIButton *button = [[UIButton alloc]init];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hidenAction) forControlEvents:UIControlEventTouchUpInside];



        _btnUpAndDown = button;
    }
    return _btnUpAndDown;
}


/*****************************卖家信息*****************************/

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

- (UIButton *)btnAddShoppingCart {

    if (!_btnAddShoppingCart) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"加入购物车" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addShoppingCartAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];


        _btnAddShoppingCart = button;
    }
    return _btnAddShoppingCart;
}

- (UIButton *)btnRent {
    if (!_btnRent) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"立即下单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        [button addTarget:self action:@selector(rentAction) forControlEvents:UIControlEventTouchUpInside];



        _btnRent = button;
    }
    return _btnRent;
}




@end
