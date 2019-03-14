//
//  EmptyCarWayOrderCentainerVC.m
//  MallClient
//
//  Created by lxy on 2017/3/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarWayOrderCentainerVC.h"
#import "EmptyCarViewModel.h"
#import "SubmitOrderSuccessViewController.h"

@interface EmptyCarWayOrderCentainerVC ()

@property (nonatomic, strong) UIScrollView *svGoodsDetail;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation EmptyCarWayOrderCentainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"订单确认";

    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    self.svGoodsDetail.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 50 - 64);
    [self.view addSubview:self.svGoodsDetail];

    UIView *view1 = [UIView new];
    view1.frame = CGRectMake(0, 10, SCREEN_W, 240);
    view1.backgroundColor = [UIColor whiteColor];
    [self.svGoodsDetail addSubview:view1];


    UILabel *lbRout = [self labelWithText:[NSString stringWithFormat:@"%@%@ - %@%@",self.currentModel.currentLine.startParentAddress,self.currentModel.currentLine.startCity,self.currentModel.currentLine.endParentAddress,self.currentModel.currentLine.endCity] WithFont:[UIFont systemFontOfSize:20] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];



    UILabel *lbPrice = [self labelWithText:@"" WithFont:[UIFont systemFontOfSize:18] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor redColor]];

    if(![self.currentModel.currentLine.price intValue]){

        lbPrice.textColor = APP_COLOR_BLUE_BTN;
        lbPrice.text = @"电询";
    } else {
        NSMutableAttributedString * lbPriceText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",[self.currentModel.currentLine.price NumberStringToMoneyString]]];
        [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0,lbPriceText.length)];
        [lbPriceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[lbPriceText.string rangeOfString:[self.currentModel.currentLine.price NumberStringToMoneyStringGetLastThree]]];
        lbPrice.attributedText = lbPriceText;
    }

    lbRout.frame =  CGRectMake(15, 20, SCREEN_W - 15, 20);
    lbPrice.frame = CGRectMake(15, 50, 135, 20);
    [view1 addSubview:lbRout];
    [view1 addSubview:lbPrice];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, lbPrice.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view1 addSubview:lbLine];




    NSArray *arr = @[[NSString stringWithFormat:@"商品编号：%@",self.currentModel.goodsNum],[NSString stringWithFormat:@"车牌号：%@",self.currentModel.carNum],[NSString stringWithFormat:@"载重量：%@吨",self.currentModel.carCarryWeight],[NSString stringWithFormat:@"出厂年份：%@",[self stDateToString:self.currentModel.produceYear]]];

    CGFloat bottom = lbLine.bottom + 15;

    for (NSString *st in arr) {

        UILabel *lbMessage = [self labelWithText:st WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];
        lbMessage.attributedText = [self attributedStrWithString:lbMessage.text];

        lbMessage.frame = CGRectMake(15, bottom, SCREEN_W - 15, 20);
        bottom = lbMessage.bottom + 10;
        [view1 addSubview:lbMessage];


    }

    bottom = view1.bottom;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stDate = [dateFormatter stringFromDate:self.startTime];

    NSArray *arr1 = @[[NSString stringWithFormat:@"运输日期：%@",stDate],[NSString stringWithFormat:@"货品名称：%@",self.goods.name]];

    for (NSString *st in arr1) {

        UIView *vi = [UIView new];
        vi.backgroundColor = [UIColor whiteColor];
        vi.frame = CGRectMake(0, bottom + 15, SCREEN_W, 44);
        UILabel *lbMessage = [self labelWithText:st WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];
        lbMessage.frame = CGRectMake(15, 0, SCREEN_W - 15, 44);

        lbMessage.attributedText = [self attributedStrWithString:lbMessage.text];
        [vi addSubview:lbMessage];
        [self.svGoodsDetail addSubview:vi];
        bottom = vi.bottom;
    }

    UILabel *lbAddressTitle = [self labelWithText:@"地址信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];
    lbAddressTitle.frame = CGRectMake(15, bottom + 10, SCREEN_W - 15, 20);
    [self.svGoodsDetail addSubview:lbAddressTitle];

    UIView *view3 = [UIView new];
    view3.frame = CGRectMake(0, lbAddressTitle.bottom + 15, SCREEN_W, 100);
    view3.backgroundColor = [UIColor whiteColor];
    [self.svGoodsDetail addSubview:view3];

    NSArray *arr3 = @[[NSString stringWithFormat:@"联系人：%@   %@",self.name,self.phone],[NSString stringWithFormat:@"起运地：%@%@%@",self.currentModel.currentLine.startParentAddress,self.currentModel.currentLine.startCity,self.startAddress],[NSString stringWithFormat:@"抵运地：%@%@%@",self.currentModel.currentLine.endParentAddress,self.currentModel.currentLine.endCity,self.endAddress]];

    bottom = 10;

    for (NSString *st in arr3) {

        UILabel *lbMessage = [self labelWithText:st WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];

        lbMessage.attributedText = [self attributedStrWithString:lbMessage.text];
        lbMessage.frame = CGRectMake(15, bottom, SCREEN_W - 15, 20);
        bottom = lbMessage.bottom + 10;
        [view3 addSubview:lbMessage];


    }




    UILabel *lbSellerTitle = [self labelWithText:@"卖家信息" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];
    lbSellerTitle.frame = CGRectMake(15, view3.bottom + 10, SCREEN_W - 15, 20);
    [self.svGoodsDetail addSubview:lbSellerTitle];

    UIView *view2 = [UIView new];
    view2.frame = CGRectMake(0, lbSellerTitle.bottom + 15, SCREEN_W, 80);
    view2.backgroundColor = [UIColor whiteColor];
    [self.svGoodsDetail addSubview:view2];


    NSArray *arr2 = @[[NSString stringWithFormat:@"公司：%@",self.currentModel.sellerCompany],[NSString stringWithFormat:@"电话：%@",self.currentModel.phone]];

    bottom = 10;

    for (NSString *st in arr2) {

        UILabel *lbMessage = [self labelWithText:st WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];

        lbMessage.attributedText = [self attributedStrWithString:lbMessage.text];
        lbMessage.frame = CGRectMake(15, bottom, SCREEN_W - 15, 20);
        bottom = lbMessage.bottom + 10;
        [view2 addSubview:lbMessage];
        
        
    }
    
    [self.view addSubview:self.btnSubmit];
    
    
    
}

//提交按钮事件
- (void)submitAction {


    EmptyOrderModel *orderInfo = [EmptyOrderModel new];
    orderInfo.emptyCarInfo = self.currentModel;
    orderInfo.contactPhone = self.phone;
    orderInfo.contactName = self.name;
    orderInfo.time = self.startTime;
    orderInfo.goodsInfo = self.goods;
    orderInfo.startAddress = self.startAddress;
    orderInfo.endAddress = self.endAddress;

    EmptyCarViewModel *vm = [EmptyCarViewModel new];
    WS(ws);
    [vm submitVehicleOrder:orderInfo callBack:^(NSString *orderCode) {

        //通知订单中心进行更新
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                           object:@{
                                                                    @"orderType":@"全部",
                                                                    @"viewTitle":@"空车之爱"
                                                                    }];
        SubmitOrderSuccessViewController *vc= [SubmitOrderSuccessViewController new];
        vc.stOrderNo = orderCode;
        vc.type = emptyCar;
        [ws.navigationController pushViewController:vc animated:YES];

    }];


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

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = APP_COLOR_BLUE_BTN;
        [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);



        _btnSubmit = button;
    }
    return _btnSubmit;
}




@end
