//
//  EmptyCarDetailVC.m
//  MallClient
//
//  Created by lxy on 2017/3/28.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarDetailVC.h"
#import "LLBannerView.h"
#import "EntrySelectCell.h"
#import "EmptyCarViewModel.h"
#import "EmptySubmiteOrderWayViewController.h"
#import "EmptyCarLineModel.h"

@interface EmptyCarDetailVC ()<EntrySelectCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) EntrySelectCellForConditionsForRetrievalVC *viImgae;
@property (nonatomic, strong) UIScrollView *svGoodsDetail;

@property (nonatomic, strong) UIView       *viHead;
@property (nonatomic, strong) LLBannerView *bannerVi;
@property (nonatomic, strong) UILabel      *lbGoodsStatuse;//箱子认证状态
@property (nonatomic, strong) UILabel      *lbGoodsName;
@property (nonatomic, strong) UILabel      *lbPrice;
@property (nonatomic, strong) UILabel      *lbGoodsNum;
@property (nonatomic, strong) UILabel      *lbCity;


@property (nonatomic, strong) UIView       *viCarMessage;
@property (nonatomic, strong) UILabel      *lbCarNum;
@property (nonatomic, strong) UILabel      *lbCarryWeight;
@property (nonatomic, strong) UILabel      *lbTime;

@property (nonatomic, strong) UIView       *viTransportMessage;
@property (nonatomic, strong) UILabel      *lbTransportMessage;

@property (nonatomic, strong) UIView       *viSeller;
@property (nonatomic, strong) UILabel      *lbCompanyName;
@property (nonatomic, strong) UILabel      *lbCompanyPhone;


@property (nonatomic, strong) UIButton     *btnAddShoppingCart;//加入购物车
@property (nonatomic, strong) UIButton     *btnRent;//立即租用

@property (nonatomic, strong) UILabel      *lbWayTitle;

@property (nonatomic, strong) UIButton     *btnCall;

@property (nonatomic, strong) NSString *stSelectedId;

@end

@implementation EmptyCarDetailVC

-(void)dealloc {
    [self.bannerVi.timer invalidate];
    self.bannerVi = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.stSelectedId = self.current.shopVehicleLineId;

}

/**
 *  加载视图
 */
- (void)bindView {

    self.title = @"商品详情";

    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    self.svGoodsDetail.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.svGoodsDetail];


    [self viHeadMake];
    [self.svGoodsDetail addSubview:self.viHead];

    self.viCarMessage.frame = CGRectMake(0, self.viHead.bottom + 10, SCREEN_W, 160);

    if (self.viHead.bottom == 0) {

        self.viCarMessage.frame = CGRectMake(0, 400, SCREEN_W, 160);
    }
    [self viCarMessageMake];
    [self.svGoodsDetail addSubview:self.viCarMessage];

    self.viTransportMessage.frame = CGRectMake(0, self.viCarMessage.bottom + 10, SCREEN_W, 110);
    [self viTransportMessageMake];
    [self.svGoodsDetail addSubview:self.viTransportMessage];

    self.viSeller.frame = CGRectMake(0, self.viTransportMessage.bottom + 10, SCREEN_W, 120);
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

    if([self.lbGoodsStatuse isHidden]){

         self.lbGoodsName.frame = CGRectMake( 15,self.bannerVi.bottom + 14 , SCREEN_W  - self.lbGoodsStatuse.right - 65, 20);
    }


    [self.viHead addSubview:self.lbGoodsName];

    self.lbPrice.frame = CGRectMake(15, self.lbGoodsName.bottom + 10, SCREEN_W - 15, 20);
    [self.viHead addSubview:self.lbPrice];

    self.lbGoodsNum.frame = CGRectMake(15, self.lbPrice.bottom + 10, SCREEN_W - 10, 20);
    [self.viHead addSubview:self.lbGoodsNum];

    self.lbCity.frame = CGRectMake(SCREEN_W - 110,self.bannerVi.bottom + 18 , 100, 20);
    [self.viHead addSubview:self.lbCity];

    UILabel *lbLine = [UILabel new];
    lbLine.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    lbLine.frame = CGRectMake(0, self.lbGoodsNum.bottom + 15, SCREEN_W, 1);
    [self.viHead addSubview:lbLine];


    UILabel *lbWayTitle= [self labelWithText:@"选择路线" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbWayTitle.frame = CGRectMake(15, lbLine.bottom + 15, SCREEN_W - 10, 20);
    [self.viHead addSubview:lbWayTitle];
    self.lbWayTitle = lbWayTitle;
//
//    self.viImgae = [EntrySelectCellForConditionsForRetrievalVC new];
//    CGFloat hight = [self.viImgae loadViewWithEntrys:@[@"上海市到北京市",@"东莞市到三亚"] WithWidth:SCREEN_W- 40];
//    self.viImgae.frame = CGRectMake(20, lbWayTitle.bottom + 10, SCREEN_W - 40, hight);
//
//    self.viImgae.cellDelegate = self;
//
//    [self.viHead addSubview:self.viImgae];

    [self.viHead addSubview:self.btnCall];


    
}

- (void)viCarMessageMake {

    UILabel *lbTitle = [self labelWithText:@"车辆信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTitle.frame = CGRectMake(15, 15, SCREEN_W - 15, 20);
    [self.viCarMessage addSubview:lbTitle];
    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, lbTitle.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viCarMessage addSubview:lbLine];

    self.lbCarNum.frame = CGRectMake(15, lbLine.bottom + 15, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbCarNum];
    self.lbCarryWeight.frame = CGRectMake(15, self.lbCarNum.bottom + 20, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbCarryWeight];
    self.lbTime.frame = CGRectMake(15, self.lbCarryWeight .bottom + 20, SCREEN_W - 15, 10);
    [self.viCarMessage addSubview:self.lbTime];


}

- (void)viTransportMessageMake {

    UILabel *lbTitle = [self labelWithText:@"运力信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
    lbTitle.frame = CGRectMake(15, 15, SCREEN_W - 15, 20);
    [self.viTransportMessage addSubview:lbTitle];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, lbTitle.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viTransportMessage addSubview:lbLine];

    self.lbTransportMessage.frame = CGRectMake(15, lbLine.bottom + 20, SCREEN_W - 15, 10);
    [self.viTransportMessage addSubview:self.lbTransportMessage];


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

        self.lbGoodsNum.text = [NSString stringWithFormat:@"商品编号：%@",self.current.goodsNum];
        if (self.current.currentLine) {
            if([self.current.currentLine.price intValue]) {
                NSMutableAttributedString * lbPriceText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.current.price NumberStringToMoneyString]]];
                [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbPriceText.length)];
                [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:[lbPriceText.string rangeOfString:[self.current.price NumberStringToMoneyStringGetLastThree]]];
                self.lbPrice.attributedText = lbPriceText;
            }else {
                self.lbPrice.textColor = APP_COLOR_BLUE_BTN;
                self.lbPrice.text = @"电询";

            }

        }else {
            self.lbPrice.text = @"*请选择线路*";
        }

        self.viImgae = [EntrySelectCellForConditionsForRetrievalVC new];
        NSMutableArray *arrRount = [NSMutableArray array];
        for (EmptyCarLineModel *info in self.current.arrRouts) {

            [arrRount addObject:info.lineStr];

        }

        if (self.current.arrRouts) {
            NSMutableArray *arrLines = [NSMutableArray array];
            for (EmptyCarLineModel *info in self.current.arrRouts) {
                [arrLines addObject:info.lineStr];
                if ([info.ID isEqualToString:self.stSelectedId]) {

                    self.current.currentLine = info;

                    if ([info.price floatValue]>0) {
                        NSMutableAttributedString * lbPriceText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[info.price NumberStringToMoneyString]]];
                        [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbPriceText.length)];
                        [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:[lbPriceText.string rangeOfString:[info.price NumberStringToMoneyStringGetLastThree]]];
                        self.lbPrice.attributedText = lbPriceText;
                    }else {

                        self.lbPrice.textColor = APP_COLOR_BLUE_BTN;
                        self.lbPrice.text = @"电询";

                    }

                    
                }
            }
            CGFloat hight = [self.viImgae loadViewWithEntrys:arrLines WithWidth:SCREEN_W- 40 WithSelectStr:self.current.currentLine.lineStr];
            self.viImgae.frame = CGRectMake(20, self.lbWayTitle.bottom + 10, SCREEN_W - 40, hight);

            self.viImgae.cellDelegate = self;

            [self.viHead addSubview:self.viImgae];


            self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 420 + hight);

            _svGoodsDetail.contentSize = CGSizeMake(SCREEN_W, 900 + hight);



        }
               //self.lbGoodsStatuse.text =

        self.lbCarNum.text = [NSString stringWithFormat:@"车牌号：%@",self.current.carNum];
        self.lbCarNum.attributedText = [self attributedStrWithString:self.lbCarNum.text];

        self.lbCarryWeight.text = [NSString stringWithFormat:@"载重量：%@吨",self.current.carCarryWeight];
        self.lbCarryWeight.attributedText = [self attributedStrWithString:self.lbCarryWeight.text];

        self.lbTime.text = [NSString stringWithFormat:@"出厂年份：%@",[self stDateToString:self.current.produceYear]];
        self.lbTime.attributedText = [self attributedStrWithString:self.lbTime.text];

        if(self.current.capacityMessage){

            self.lbTransportMessage.text = self.current.capacityMessage;

        }else{

            self.lbTransportMessage.text = @"无";
            
        }


        if (!self.current.sellerCompany) {
            self.current.sellerCompany = @"无";
        }

        if (!self.current.phone) {
            self.current.phone = @"无";
        }


        self.lbCompanyName.text = [NSString stringWithFormat:@"公司：%@",self.current.sellerCompany];
        self.lbCompanyName.attributedText = [self attributedStrWithString:self.lbCompanyName.text];



        self.lbCompanyPhone.text = [NSString stringWithFormat:@"电话：%@",self.current.phone];

        if (self.current.certification) {
            self.lbGoodsStatuse.text = self.current.certification;
        }else {
            self.lbGoodsStatuse.hidden = YES;

        }

        self.bannerVi.images = self.current.imgArr;

        self.lbCity.text = self.current.city;
        if (self.current.brand) {
            self.lbGoodsName.text = [NSString stringWithFormat:@"%@(%@)",self.current.type,self.current.brand];

        } else {
            self.lbGoodsName.text = [NSString stringWithFormat:@"%@",self.current.type];

        }

        
    }
}

/**
 *  加载方法
 */
- (void)bindAction {
}

/**
 *  网络强求数据
 */
- (void)getData {

    WS(ws);

    [[EmptyCarViewModel new] getVehicleDetail:self.current callBack:^(EmptyCarModel *emptyCarModel) {


        ws.current = emptyCarModel;

        [self bindModel];

        [self bindView];
    }];

}

- (void)rentAction {

    if(USER_INFO){

        if (self.current.currentLine) {
            EmptySubmiteOrderWayViewController *vc= [EmptySubmiteOrderWayViewController new];
            vc.currentModel = self.current;
            [self.navigationController pushViewController:vc animated:YES];

        }else {

            [[Toast shareToast]makeText:@"请选择线路" aDuration:1];
        }
    }else {

        [self pushLogoinVC];
    }



}

- (void)callAction {

    UIAlertView *alert;

    if (![self.current.phone isEqualToString:@"无"]) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定拨打卖家电话？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.stTelephone = self.current.phone;

        [alert show];
    }else {

        [[Toast shareToast]makeText:@"该卖家未提供联系电话" aDuration:1];
    }

    
}


/**

 代理（不用实现）
 */

-(void)tabviewNeedReloadDataForIndexPath:(NSIndexPath *)indexPath{

}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath{


    EmptyCarLineModel *info =  [self.current.arrRouts objectAtIndex:row];
    self.current.currentLine =info;

    if (self.current.currentLine) {
        if([self.current.currentLine.price floatValue] >0) {

            NSMutableAttributedString * lbPriceText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[info.price NumberStringToMoneyString]]];
            [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbPriceText.length)];
            [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:[lbPriceText.string rangeOfString:[info.price NumberStringToMoneyStringGetLastThree]]];
            self.lbPrice.attributedText = lbPriceText;

        }else {
            self.lbPrice.textColor = APP_COLOR_BLUE_BTN;
            self.lbPrice.text = @"电询";

        }

    }else {
        self.lbPrice.text = @"*请选择线路*";
    }


}

-(void)plusSignHiddenCellClick{

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
        //_svGoodsDetail.contentSize = CGSizeMake(SCREEN_W, 900);

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
        label.text = @"载重车（上海大众）";



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
        label.text = @"*请选择路线";
        label.textColor = [UIColor redColor];


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
        label.text = @"上海市";

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
        label.text = @"车牌号：京B977654";



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
        label.text = @"载重量：45吨";

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
        label.text = @"出厂年份：2016-10-11";

        _lbTime = label;
    }
    return _lbTime;
}

- (UIView *)viTransportMessage {
    if (!_viTransportMessage) {
        _viTransportMessage = [UIView new];
        _viTransportMessage.backgroundColor = [UIColor whiteColor];

    }
    return _viTransportMessage;
}

- (UILabel *)lbTransportMessage {
    if (!_lbTransportMessage) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = APP_COLOR_GRAY999;
        label.text = @"10天到达，请务必准时发货";



        _lbTransportMessage = label;
    }
    return _lbTransportMessage;
}

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
