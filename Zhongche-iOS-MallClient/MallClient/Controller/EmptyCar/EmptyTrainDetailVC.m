//
//  EmptyTrainDetailVC.m
//  MallClient
//
//  Created by lxy on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyTrainDetailVC.h"
#import "LLBannerView.h"
#import "EntrySelectCell.h"
#import "EmptyCarViewModel.h"
#import "EmptySubmiteOrderShipAndTrainViewController.h"


@interface EmptyTrainDetailVC ()<UIAlertViewDelegate>


@property (nonatomic, strong) EntrySelectCellForConditionsForRetrievalVC *viImgae;
@property (nonatomic, strong) UIScrollView *svGoodsDetail;

@property (nonatomic, strong) UIView       *viHead;
@property (nonatomic, strong) LLBannerView *bannerVi;
@property (nonatomic, strong) UILabel      *lbGoodsStatuse;//箱子认证状态
@property (nonatomic, strong) UILabel      *lbGoodsName;
@property (nonatomic, strong) UILabel      *lbPrice;
@property (nonatomic, strong) UILabel      *lbGoodsNum;
@property (nonatomic, strong) UILabel      *lbCity;


@property (nonatomic, strong) UIView       *viTrainMessage;
@property (nonatomic, strong) UILabel      *lbTrainType;
@property (nonatomic, strong) UILabel      *lbCarryStation;
@property (nonatomic, strong) UILabel      *lbTakeStation;
@property (nonatomic, strong) UILabel      *lbStartTime;
@property (nonatomic, strong) UILabel      *lbEndTime;
@property (nonatomic, strong) UILabel      *lbLeaveTime;

@property (nonatomic, strong) UIView       *viTransportMessage;
@property (nonatomic, strong) UILabel      *lbTransportMessage;

@property (nonatomic, strong) UIView       *viSeller;
@property (nonatomic, strong) UILabel      *lbCompanyName;
@property (nonatomic, strong) UILabel      *lbCompanyPhone;


@property (nonatomic, strong) UIButton     *btnAddShoppingCart;//加入购物车
@property (nonatomic, strong) UIButton     *btnRent;//立即租用

@property (nonatomic, strong) UIButton     *btnCall;

@end

@implementation EmptyTrainDetailVC

-(void)dealloc {
    [self.bannerVi.timer invalidate];
    self.bannerVi = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  加载视图
 */
- (void)bindView {

    self.title = @"商品详情";

    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    self.svGoodsDetail.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.svGoodsDetail];

    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 360);
    [self viHeadMake];
    [self.svGoodsDetail addSubview:self.viHead];

    self.viTrainMessage.frame = CGRectMake(0, self.viHead.bottom + 10, SCREEN_W, 200);
    [self viTrainMessageMake];
    [self.svGoodsDetail addSubview:self.viTrainMessage];


    self.viSeller.frame = CGRectMake(0, self.viTrainMessage.bottom + 10, SCREEN_W, 120);
    [self viSellerMake];
    [self.svGoodsDetail addSubview:self.viSeller];

    self.btnRent.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.btnRent];

}

- (void)viHeadMake {

    [self.viHead addSubview:self.bannerVi];


    self.lbGoodsStatuse.frame = CGRectMake(15, self.bannerVi.bottom + 18 , 45, 15);
    [self.viHead addSubview:self.lbGoodsStatuse];

    self.lbGoodsName.frame = CGRectMake(self.lbGoodsStatuse.right + 5,self.bannerVi.bottom + 14 , SCREEN_W  - self.lbGoodsStatuse.right - 65, 20);
    [self.viHead addSubview:self.lbGoodsName];

    self.lbPrice.frame = CGRectMake(15, self.lbGoodsName.bottom + 10, SCREEN_W - 15, 20);
    [self.viHead addSubview:self.lbPrice];

    self.lbGoodsNum.frame = CGRectMake(15, self.lbPrice.bottom + 10, SCREEN_W - 10, 20);
    [self.viHead addSubview:self.lbGoodsNum];

    self.lbCity.frame = CGRectMake(SCREEN_W - 100,self.bannerVi.bottom + 18 , 90, 20);
    [self.viHead addSubview:self.lbCity];

    [self.viHead addSubview:self.btnCall];


}

- (void)viTrainMessageMake {

    UILabel *lbTitle = [self labelWithText:@"班列信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTitle.frame = CGRectMake(15, 15, SCREEN_W - 15, 20);
    [self.viTrainMessage addSubview:lbTitle];
    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, lbTitle.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viTrainMessage addSubview:lbLine];

    self.lbTrainType.frame = CGRectMake(15, lbLine.bottom + 15, SCREEN_W - 15, 10);
    [self.viTrainMessage addSubview:self.lbTrainType];

    self.lbCarryStation.frame = CGRectMake(15, self.lbTrainType.bottom + 10, SCREEN_W - 15, 10);
    [self.viTrainMessage addSubview:self.lbCarryStation];

    self.lbTakeStation.frame = CGRectMake(15, self.lbCarryStation .bottom + 10, SCREEN_W - 15, 10);
    [self.viTrainMessage addSubview:self.lbTakeStation];

    self.lbStartTime.frame = CGRectMake(15, self.lbTakeStation .bottom + 10, SCREEN_W - 15, 10);
    [self.viTrainMessage addSubview:self.lbStartTime];

    self.lbEndTime.frame = CGRectMake(15, self.lbStartTime .bottom + 10, SCREEN_W - 15, 10);
    [self.viTrainMessage addSubview:self.lbEndTime];

    self.lbLeaveTime.frame = CGRectMake(15, self.lbEndTime .bottom + 10, SCREEN_W - 15, 10);
    [self.viTrainMessage addSubview:self.lbLeaveTime];



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

/**
 *  加载模型
 */
- (void)bindModel {

    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 1; i ++) {
        [arr addObject:[UIImage imageNamed:@"banner_1"]];
        [arr addObject:[UIImage imageNamed:@"banner_2"]];
        [arr addObject:[UIImage imageNamed:@"banner_3"]];
    }
    self.bannerVi.images = arr;

    if (self.current) {

        self.lbGoodsName.text = self.current.name;
        self.lbGoodsStatuse.text = self.current.certification;
        if ([self.current.price floatValue]>0) {
            NSMutableAttributedString * lbPriceText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@/TEU",[self.current.price NumberStringToMoneyString]]];
            [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbPriceText.length)];
            [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:[lbPriceText.string rangeOfString:[self.current.price NumberStringToMoneyStringGetLastThree]]];
            self.lbPrice.attributedText = lbPriceText;
        }else {

            self.lbPrice.textColor = APP_COLOR_BLUE_BTN;
            self.lbPrice.text = @"电询";

        }

        self.lbGoodsNum.text = [NSString stringWithFormat:@"商品编号：%@",self.current.goodsNum];
        self.lbCity.text = [NSString stringWithFormat:@"剩余：%@ TEU",self.current.leftNum];
        if ([self.current.leftNum intValue]>99) {
            self.lbCity.text = @"剩余：充足";
        }

        self.lbTrainType.text = [NSString stringWithFormat:@"班列类型：%@",self.current.trainsType];
        self.lbTrainType.attributedText = [self attributedStrWithString:self.lbTrainType.text];

        self.lbCarryStation.text = [NSString stringWithFormat:@"始发站：%@",self.current.trainStartStation];
        self.lbCarryStation.attributedText = [self attributedStrWithString:self.lbCarryStation.text];

        self.lbTakeStation.text = [NSString stringWithFormat:@"终点站：%@",self.current.trainEndStation];
        self.lbTakeStation.attributedText = [self attributedStrWithString:self.lbTakeStation.text];

        self.lbStartTime.text = [NSString stringWithFormat:@"发车日期：%@",[self stDateToString:self.current.trainStartTime]];
        self.lbStartTime.attributedText = [self attributedStrWithString:self.lbStartTime.text];

        self.lbEndTime.text = [NSString stringWithFormat:@"接货截止日期：%@",[self stDateToString:self.current.trainEndTime]];
        self.lbEndTime.attributedText = [self attributedStrWithString:self.lbEndTime.text];

        if (!self.current.sellerCompany) {
            self.current.sellerCompany = @"无";
        }

        if (!self.current.phone) {
            self.current.phone = @"无";
        }
        self.lbCompanyName.text = [NSString stringWithFormat:@"公司：%@",self.current.sellerCompany];
        self.lbCompanyName.attributedText = [self attributedStrWithString:self.lbCompanyName.text];
        self.lbCompanyPhone.text = [NSString stringWithFormat:@"电话：%@",self.current.phone];

        self.bannerVi.images = self.current.imgArr;

        if (self.current.certification) {
            self.lbGoodsStatuse.text = self.current.certification;
        }else {
            self.lbGoodsStatuse.hidden = YES;

            self.lbGoodsName.frame = CGRectMake( 15,self.bannerVi.bottom + 14 , SCREEN_W  - self.lbGoodsStatuse.right - 65, 20);
            [self.viHead addSubview:self.lbGoodsName];

        }



    }
}

/**
 *  网络强求数据
 */
- (void)getData {

    WS(ws);

    [[EmptyCarViewModel new] getVehicleDetail:self.current callBack:^(EmptyCarModel *emptyCarModel) {

        ws.current = emptyCarModel;
        [self bindModel];
        
    }];
    
}

- (void)rentAction {


    if(USER_INFO){


        EmptySubmiteOrderShipAndTrainViewController *vc = [EmptySubmiteOrderShipAndTrainViewController new];
        vc.type = 0;
        vc.currentModel = self.current;
        [self.navigationController pushViewController:vc animated:YES];

    }else {

        [self pushLogoinVC];
    }

}

- (void)callAction {

    UIAlertView *alert;

    if (self.current.phone) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定拨打卖家电话？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.stTelephone = self.current.phone;

        [alert show];
    }else {

        [[Toast shareToast]makeText:@"该卖家未提供联系电话" aDuration:1];
    }
    
    
}

/**
 *  alertView代理
 *
 *  @param alertView   delegate
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {

        UIWebView * callWebview = [[UIWebView alloc]init];

        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.stTelephone]]]];

        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        
    }
}


/**
 *  getter
 */

- (UIScrollView *)svGoodsDetail {

    if (!_svGoodsDetail) {
        _svGoodsDetail = [UIScrollView new];
        _svGoodsDetail.contentSize = CGSizeMake(SCREEN_W, 900);

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
        label.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        label.backgroundColor = APP_COLOR_ORANGE_BG;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = APP_COLOR_ORANGE_BTN_TEXT.CGColor;
        label.text  = @"资质认证";
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
        label.text = @"班列：DS7986";



        _lbGoodsName = label;
    }
    return _lbGoodsName;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"￥120.00/TEU";
        label.textColor = [UIColor redColor];
        NSRange range;
        range = [label.text rangeOfString:@"/TEU"];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


        [AttributedStr addAttribute:NSForegroundColorAttributeName

                              value:APP_COLOR_GRAY999

                              range:NSMakeRange(range.location,label.text.length - range.location)];
        label.attributedText = AttributedStr;


        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbGoodsNum {
    if (!_lbGoodsNum) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = APP_COLOR_GRAY2;
        label.text = @"商品编号：847576476547";



        _lbGoodsNum = label;
    }
    return _lbGoodsNum;
}

- (UILabel *)lbCity {
    if (!_lbCity) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = APP_COLOR_GRAY2;
        label.text = @"剩余：46TEU";
        label.textAlignment = NSTextAlignmentRight;

        _lbCity = label;
    }
    return _lbCity;
}

- (UIButton *)btnCall {
    if (!_btnCall) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"Callicon"] forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREEN_W - 50, self.lbCity.bottom + 15, 40, 40);

        _btnCall = button;
    }
    return _btnCall;
}


/*****************************火车信息*****************************/

- (UIView *)viTrainMessage {
    if (!_viTrainMessage) {
        _viTrainMessage = [UIView new];
        _viTrainMessage.backgroundColor = [UIColor whiteColor];

    }
    return _viTrainMessage;
}

- (UILabel *)lbTrainType {
    if (!_lbTrainType) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY666;
        label.text = @"班列类型：快速班车";



        _lbTrainType = label;
    }
    return _lbTrainType;
}

- (UILabel *)lbCarryStation {
    if (!_lbCarryStation) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];

        label.textColor = APP_COLOR_GRAY666;
        label.text = @"始发站：北京站";

        _lbCarryStation = label;
    }
    return _lbCarryStation;
}

- (UILabel *)lbTakeStation {
    if (!_lbTakeStation) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];

        label.textColor = APP_COLOR_GRAY666;
        label.text = @"终点站：上海北站";

        _lbTakeStation = label;
    }
    return _lbTakeStation;
}

- (UILabel *)lbStartTime {
    if (!_lbStartTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];

        label.textColor = APP_COLOR_GRAY666;
        label.text = @"发车日期：2016-10-11";

        _lbStartTime = label;
    }
    return _lbStartTime;
}

- (UILabel *)lbEndTime {
    if (!_lbEndTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];

        label.textColor = APP_COLOR_GRAY666;
        label.text = @"接货截止日期：2016-10-11";

        _lbEndTime = label;
    }
    return _lbEndTime;
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
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"公司：潮州港务发展有限公司";
        label.textColor = APP_COLOR_GRAY666;



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
        label.text = @"电话：18765432134";
        label.hidden = YES;

        _lbCompanyPhone = label;
    }
    return _lbCompanyPhone;
}

/*****************************底部按钮*****************************/

- (UIButton *)btnAddShoppingCart {

    if (!_btnAddShoppingCart) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"加入购物车" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(addShoppingCartAction) forControlEvents:UIControlEventTouchUpInside];
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
