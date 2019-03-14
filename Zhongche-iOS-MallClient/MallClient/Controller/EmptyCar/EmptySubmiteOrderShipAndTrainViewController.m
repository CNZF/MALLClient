//
//  EmptySubmiteOrderShipAndTrainViewController.m
//  MallClient
//
//  Created by lxy on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptySubmiteOrderShipAndTrainViewController.h"
#import "EmptyContainerAddressVC.h"
#import "ZSSearchViewController.h"
#import "GoodsInfo.h"
#import "EmptyAddressViewController.h"
#import "EmptyCarWayOrderCentainerVC.h"
#import "EmptyCarTrainOrShipOrderCentainerVC.h"

@interface EmptySubmiteOrderShipAndTrainViewController ()<UITextFieldDelegate,ZSSearchViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *svGoodsDetail;
@property (nonatomic, strong) UIView       *viNoAddress;
@property (nonatomic, assign) int          addressType;//0未选择 1选择

@property (nonatomic, strong) UIView       *viAddressAndContact;//联系人
@property (nonatomic, strong) UILabel      *lbReceieve;//收图标
@property (nonatomic, strong) UILabel      *lbName;//联系人姓名
@property (nonatomic, strong) UILabel      *lbPhone;//联系人电话
@property (nonatomic, strong) UIButton     *btnAddressChoose1;
@property (nonatomic, strong) UIButton     *btnAddressChoose2;
@property (nonatomic, strong) UIImageView  *ivCell;//箭头
@property (nonatomic, strong) UIImageView  *ivColorLine;//彩带


@property (nonatomic, strong) UIView       *viGoods;
@property (nonatomic, strong) UIImageView  *ivGoods;
@property (nonatomic, strong) UILabel      *lbGoodsName;
@property (nonatomic, strong) UILabel      *lbPrice;
@property (nonatomic, strong) UILabel      *lbCity;
@property (nonatomic, strong) UILabel      *lbGoodsStatuse;
@property (nonatomic, strong) UIView       *viGoodsMessage;


@property (nonatomic, strong) UIView       *viNum;
@property (nonatomic, strong) UIImageView  *ivAddAndReduce;
@property (nonatomic, strong) UITextField  *tfNum;

@property (nonatomic, assign) int          num;
@property (nonatomic, strong) UIButton     *btnAdd;
@property (nonatomic, strong) UIButton     *btnReduce;

@property (nonatomic, strong) UIView       *viSeller;
@property (nonatomic, strong) UILabel      *lbCompanyName;
@property (nonatomic, strong) UILabel      *lbCompanyPhone;

@property (nonatomic, strong) UILabel      *lbDate;
@property (nonatomic, strong) UIView       *viTime;

@property (nonatomic, strong) UILabel      *lbGoods;
@property (nonatomic, strong) UIView       *viCarryGoods;

@property (nonatomic, strong) UIView       *viBottom;
@property (nonatomic, strong) UIButton     *btnNext;
@property (nonatomic, strong) UILabel      *lbTotalPrice;

@property (nonatomic, strong) UIView       *viTimePicker;
@property (nonatomic, strong) UIButton     *btnCancle;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) GoodsInfo    *goodsInfo;

@property (nonatomic, strong) NSDate       *startDate;

@property (nonatomic, assign) BOOL         isShow;
@property (nonatomic, strong) UIButton     *btnIsShow;

@end

@implementation EmptySubmiteOrderShipAndTrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 1;
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
        self.viGoodsMessage.hidden = YES;
        [self.btnIsShow setImage:[UIImage imageNamed:@"DownAction"] forState:UIControlStateNormal];

    }else{

        if(self.type == 1){
             hight = 350;
        }else{

            hight = 320;
        }

        self.viGoodsMessage.hidden = NO;
        [self.btnIsShow setImage:[UIImage imageNamed:@"UPAction"] forState:UIControlStateNormal];
    }


    if (self.addressType == 0) {

        [self.svGoodsDetail addSubview:self.viNoAddress];

        self.viGoods.frame = CGRectMake(0, self.viNoAddress.bottom + 10, SCREEN_W, hight);

        if(self.type == 1){

            self.viGoods.frame = CGRectMake(0, self.viNoAddress.bottom + 10, SCREEN_W, hight);
        }

    }else {

        self.viAddressAndContact.frame = CGRectMake(0, 10, SCREEN_W, 50);
        self.btnAddressChoose2.frame = CGRectMake(0, 0, SCREEN_W, 50);
        [self.viAddressAndContact addSubview:self.btnAddressChoose2];

        [self viAddressAndContactMake];
        [self.svGoodsDetail addSubview:self.viAddressAndContact];
        self.viGoods.frame = CGRectMake(0, self.viAddressAndContact.bottom + 10, SCREEN_W, hight);

         if(self.type == 1){

             self.viGoods.frame = CGRectMake(0, self.viAddressAndContact.bottom + 10, SCREEN_W, hight);
         }

    }

    [self viGoodsMake];
    [self.svGoodsDetail addSubview:self.viGoods];

    self.viNum.frame = CGRectMake(0, self.viGoods.bottom + 10, SCREEN_W, 44);
    [self.svGoodsDetail addSubview:self.viNum];

    self.viTime.frame = CGRectMake(0, self.viNum.bottom + 10, SCREEN_W, 44);
    [self.svGoodsDetail addSubview:self.viTime];

    self.viCarryGoods.frame = CGRectMake(0, self.viTime.bottom + 10, SCREEN_W, 44);
    [self.svGoodsDetail addSubview:self.viCarryGoods];

    self.viSeller.frame = CGRectMake(0, self.viCarryGoods.bottom + 10, SCREEN_W, 120);
    [self viSellerMake];
    [self.svGoodsDetail addSubview:self.viSeller];

    [self.view addSubview:self.viBottom];


    self.viTimePicker.frame  = CGRectMake(0, SCREEN_H - 180 - 64, SCREEN_W, 180);
    [self.view addSubview:self.viTimePicker];

    [self timeViewMake];


    if (self.currentModel.certification) {
        self.lbGoodsStatuse.text = self.currentModel.certification;
    }else {
        self.lbGoodsStatuse.hidden = YES;
    }




}

- (void)bindModel {

    [self viGoodsMessageMake];
}

//联系人
- (void)viAddressAndContactMake {

    [self.viAddressAndContact addSubview:self.lbReceieve];
    [self.viAddressAndContact addSubview:self.lbName];
    [self.viAddressAndContact addSubview:self.lbPhone];
    [self.viAddressAndContact addSubview:self.ivCell];
    [self.viAddressAndContact addSubview:self.ivColorLine];

    
    
}

//商品视图
- (void)viGoodsMake {

    [self.viGoods addSubview:self.ivGoods];
    [self.viGoods addSubview:self.lbGoodsName];
    [self.viGoods addSubview:self.lbGoodsStatuse];
    [self.viGoods addSubview:self.lbPrice];
    [self.viGoods addSubview:self.lbCity];
    [self.viGoods addSubview:self.btnIsShow];

    UILabel *lbLine = [UILabel new];
    lbLine.frame = CGRectMake(0, self.lbCity.bottom + 15, SCREEN_W, -0.5);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viGoods addSubview:lbLine];

    self.viGoodsMessage.frame = CGRectMake(0, lbLine.bottom + 10, SCREEN_W, 200);
//    [self viGoodsMessageMake];
    [self.viGoods addSubview:self.viGoodsMessage];

}

//商品详情视图
- (void)viGoodsMessageMake {


    NSArray *arr;
    if (self.type == 0) {
        arr = @[[NSString stringWithFormat:@"商品编号：%@",self.currentModel.goodsNum],[NSString stringWithFormat:@"班列类型：%@",self.currentModel.trainsType],[NSString stringWithFormat:@"始发站：%@",self.currentModel.trainStartStation],[NSString stringWithFormat:@"终点站：%@",self.currentModel.trainEndStation],[NSString stringWithFormat:@"发车日期：%@",[self stDateToString:self.currentModel.trainStartTime]],[NSString stringWithFormat:@"接货截止日期：%@",[self stDateToString:self.currentModel.trainEndTime]]];
    }else {



        arr = @[[NSString stringWithFormat:@"商品编号：%@",self.currentModel.goodsNum],[NSString stringWithFormat:@"航次：%@",self.currentModel.shipNum],[NSString stringWithFormat:@"装货港：%@",self.currentModel.shipStartStation],[NSString stringWithFormat:@"卸货港：%@",self.currentModel.shipEndStation],[NSString stringWithFormat:@"开仓时间：%@",[self stDateToString:self.currentModel.shipStartTime]],[NSString stringWithFormat:@"截载时间：%@",[self stDateToString:self.currentModel.shipEndTime]],[NSString stringWithFormat:@"离港时间：%@",[self stDateToString:self.currentModel.shipLeaveTime]]];


    }



    CGFloat bottom = 0;

    for (NSString *st in arr) {

        UILabel *lb = [self labelWithText:st WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY666];
        lb.frame = CGRectMake(15, bottom +10, SCREEN_W - 15, 20);
        bottom = lb.bottom;
        [self.viGoodsMessage addSubview:lb];
    }
}

//卖家视图
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

//增加数量
- (void)addAction {

    self.num++;
    self.ivAddAndReduce.image = [UIImage imageNamed:@"Add2"];
    self.tfNum.text = [NSString stringWithFormat:@"%i",self.num];

    [self priceChangeAction];

}

//减少数量
- (void)reduceAction {

    if (self.num == 2) {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add1"];
    }

    if (self.num >1) {
        self.num --;
        self.tfNum.text = [NSString stringWithFormat:@"%i",self.num];
         [self priceChangeAction];
    }


}

//价格变化
- (void)priceChangeAction{

    self.lbTotalPrice.text = [NSString stringWithFormat:@"￥%@",[self getMoneyStringWithMoneyNumber:[self.currentModel.price doubleValue]* self.num]];
    NSRange range;
    range = [self.lbTotalPrice.text rangeOfString:@".00"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lbTotalPrice.text];

    [AttributedStr addAttribute:NSFontAttributeName

                          value:[UIFont systemFontOfSize:14]

                          range:NSMakeRange(range.location,self.lbTotalPrice.text.length - range.location)];
    self.lbTotalPrice.attributedText = AttributedStr;
}


/**
 *  UITextFiledDelegate
 *
 */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    self.num = [textField.text intValue];
    [self priceChangeAction];
    if (self.num == 1) {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add1"];
    }else {
        self.ivAddAndReduce.image = [UIImage imageNamed:@"Add2"];

    }
    
    
    
    
    return YES;
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
    vc.type = 1;
    if(self.addressType == 1){

        vc.name = self.lbName.text;
        vc.phone = self.lbPhone.text;
    }
    [self.navigationController pushViewController:vc animated:YES];
    WS(ws);

    [vc returnInfo:^(NSString *name, NSString *phone, NSString *startFullName, NSString *endFullName) {

        ws.lbName.text = name;
        ws.lbPhone.text = phone;

        ws.addressType = 1;
        [self bindView];
        [self checkButton];

    }];

}

//时间选择
- (void)timeViewMake {

    [self.viTimePicker addSubview:self.btnCancle];
    [self.viTimePicker addSubview:self.datePicker];

}

//时间选择
- (void)dateAction{

    self.viTimePicker.hidden = NO;
}

//商品选择
- (void)chooseGoodsAction {

    ZSSearchViewController * vc = [ZSSearchViewController new];
    vc.vcDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

//加载商品
- (void)getGood:(GoodsInfo *)goods {

    self.goodsInfo = goods;

    self.lbGoods.text = goods.name;
    
    [self checkButton];
}

//按钮颜色检测
- (void)checkButton {

    if (self.addressType == 1&&self.goodsInfo &&self.startDate) {


        self.btnNext.backgroundColor = APP_COLOR_BLUE_BTN;
    }
}

//下一步按钮点击事件
- (void)nextAction {

    if (self.addressType == 1&&self.goodsInfo &&self.startDate) {

        EmptyCarTrainOrShipOrderCentainerVC *vc= [EmptyCarTrainOrShipOrderCentainerVC new];
        vc.startTime = self.startDate;
        vc.name = self.lbName.text;
        vc.phone  = self.lbPhone.text;
        vc.goods = self.goodsInfo;
        vc.currentModel = self.currentModel;
        vc.type = self.type;
        vc.num = self.num;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//上下收缩
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

- (UIImageView *)ivCell {
    if (!_ivCell) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 20, 7, 13);


        _ivCell = imageView;
    }
    return _ivCell;
}

- (UIImageView *)ivColorLine {
    if (!_ivColorLine) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"colorLine"];
        imageView.frame = CGRectMake(0, 49, SCREEN_W, 1);


        _ivColorLine = imageView;
    }
    return _ivColorLine;
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

- (UIView *)viGoods {
    if (!_viGoods) {
        _viGoods = [UIView new];
        _viGoods.backgroundColor = [UIColor whiteColor];

    }
    return _viGoods;
}

- (UIImageView *)ivGoods {
    if (!_ivGoods) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"001"];
        imageView.frame = CGRectMake(15, 20, 70, 70);
        if (self.currentModel.imgArr) {
            [imageView sd_setImageWithURL:[self.currentModel.imgArr objectAtIndex:0]];
        }



        _ivGoods = imageView;
    }
    return _ivGoods;
}

- (UILabel *)lbGoodsName {
    if (!_lbGoodsName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = self.currentModel.name;
        label.frame = CGRectMake(self.ivGoods.right + 10, 20, 150, 20);



        _lbGoodsName = label;
    }
    return _lbGoodsName;
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
        label.text  = self.currentModel.certification;
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



        label.frame = CGRectMake(self.ivGoods.right + 10, self.lbGoodsName.bottom + 10, 150, 20);

        label.textColor = [UIColor redColor];

        if ([self.currentModel.price intValue]) {

            label.text = [NSString stringWithFormat:@"￥%@ ／TEU",[self getMoneyStringWithMoneyNumber:[self.currentModel.price doubleValue]]];

            NSRange range;
            range = [label.text rangeOfString:@"／TEU"];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];


            [AttributedStr addAttribute:NSForegroundColorAttributeName

                                  value:APP_COLOR_GRAY999

                                  range:NSMakeRange(range.location,label.text.length - range.location)];
            [AttributedStr addAttribute:NSFontAttributeName

                                  value:[UIFont systemFontOfSize:10]

                                  range:NSMakeRange(label.text.length - 7, 7)];
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
//        label.textColor = APP_COLOR_GRAY999;
        label.font = [UIFont systemFontOfSize:12.0f];


        if (self.type == 0) {

            label.text = [NSString stringWithFormat:@"%@ - %@",self.currentModel.trainStartStation,self.currentModel.trainEndStation];
        }else {

            label.text = [NSString stringWithFormat:@"%@ - %@",self.currentModel.shipStartStation,self.currentModel.shipEndStation];
        }
        label.frame = CGRectMake(self.ivGoods.right + 10, self.lbPrice.bottom +4, 150, 20);


        _lbCity = label;
    }
    return _lbCity;
}

- (UIView *)viGoodsMessage {
    if (!_viGoodsMessage) {
        _viGoodsMessage = [UIView new];

    }
    return _viGoodsMessage;
}

- (UIView *)viNum {
    if (!_viNum) {
        _viNum = [UIView new];
        _viNum.backgroundColor = [UIColor whiteColor];
        _viNum.frame = CGRectMake(0, self.viGoods.bottom + 10, SCREEN_W, 44);
        UILabel *lbTitle = [self labelWithText:@"数量(TEU)" WithFont:[UIFont systemFontOfSize:14] WithTextAlignment:NSTextAlignmentLeft WithTextColor:[UIColor blackColor]];
        lbTitle.frame = CGRectMake(15, 0, SCREEN_W - 15, 44);
        [_viNum addSubview:lbTitle];

        self.ivAddAndReduce.frame = CGRectMake(SCREEN_W - 118, 7, 98, 30);
        [_viNum addSubview:self.ivAddAndReduce];

        self.btnReduce.frame = CGRectMake(SCREEN_W - 118, 7, 34, 30);
        self.tfNum.frame = CGRectMake(self.btnReduce.right, 7, 30, 30);
        self.btnAdd.frame = CGRectMake(self.tfNum.right, 7, 34, 30);

        [_viNum addSubview:self.btnReduce];
        [_viNum addSubview:self.tfNum];
        [_viNum addSubview:self.btnAdd];




    }
    return _viNum;
}

- (UIImageView *)ivAddAndReduce {
    if (!_ivAddAndReduce) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"Add1"];


        _ivAddAndReduce = imageView;
    }
    return _ivAddAndReduce;
}

- (UITextField *)tfNum {

    if (!_tfNum) {
        _tfNum = [UITextField new];
        _tfNum.text = @"1";
        _tfNum.textAlignment = NSTextAlignmentCenter;
        _tfNum.delegate = self;
        _tfNum.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _tfNum;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];



        _btnAdd = button;
    }
    return _btnAdd;
}

- (UIButton *)btnReduce {
    if (!_btnReduce) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(reduceAction) forControlEvents:UIControlEventTouchUpInside];


        _btnReduce = button;
    }
    return _btnReduce;
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
        _viTime.frame = CGRectMake(0, self.viNum.bottom + 10, SCREEN_W, 44);
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

- (UIView *)viCarryGoods {
    if (!_viCarryGoods) {
        _viCarryGoods = [UIView new];
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, SCREEN_W, 44);
        [btn addTarget:self action:@selector(chooseGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [_viCarryGoods addSubview:btn];
        _viCarryGoods.frame = CGRectMake(0, self.viTime.bottom + 10, SCREEN_W, 44);
        _viCarryGoods.backgroundColor = [UIColor whiteColor];
        UILabel *lbTitle = [UILabel new];
        lbTitle.font = [UIFont systemFontOfSize:14];
        lbTitle.frame = CGRectMake(15, 0, 80, 44);
        lbTitle.text = @"货品名称";
        [_viCarryGoods addSubview:lbTitle];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"cell"];
        imageView.frame = CGRectMake(SCREEN_W - 17, 15, 7, 13);
        [_viCarryGoods addSubview:imageView];

        self.lbGoods.frame = CGRectMake(SCREEN_W - 127, 0, 100, 44);
        self.lbGoods.textAlignment = NSTextAlignmentRight;
        self.lbGoods.textColor = [UIColor lightGrayColor];
        self.lbGoods.text = @"未选择";
        [_viCarryGoods addSubview:self.lbGoods];

    }
    return _viCarryGoods;
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


        if ([self.currentModel.price intValue]) {
            label.text = [NSString stringWithFormat:@"￥%@",[self getMoneyStringWithMoneyNumber:[self.currentModel.price doubleValue]]];
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
