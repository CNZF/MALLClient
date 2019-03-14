//
//  OrderDetailsCoal.m
//  MallClient
//
//  Created by lxy on 2017/10/17.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailsCoal.h"
#import "OrderViewModel.h"

@interface OrderDetailsCoal ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView * bgView;
@property (nonatomic,strong ) UIView       * headTitleView;//头部蓝色视图
@property (nonatomic,strong ) UILabel      * orderStatusLab;//订单状态
@property (nonatomic,strong ) UILabel      * orderCodeLab;//订单号
@property (nonatomic,strong ) UIView       * produceView;//商品信息
@property (nonatomic,strong ) UILabel      * coalTypeLab;//煤炭类型
@property (nonatomic,strong ) UILabel      * coalCodeLab;//商品编号
@property (nonatomic,strong ) UIView       * addressView;//地址信息
@property (nonatomic,strong ) UIImageView  * deliverImg;
@property (nonatomic,strong ) UIImageView  * productionImg;
@property (nonatomic,strong ) UILabel      * deliverLab;
@property (nonatomic,strong ) UILabel      * deliverAddressLab;
@property (nonatomic,strong ) UILabel      * productionLab;
@property (nonatomic,strong ) UILabel      * productionAddressLab;

@property (nonatomic,strong ) UIView       * viProperty;

@property (nonatomic, strong) UIView       * lastView;//根部视图
@property (nonatomic, strong) UILabel      * priceLab;
@property (nonatomic, strong) UIButton     * cancelBtn;

@property (nonatomic, strong) UILabel *lbPrice;
@property (nonatomic, strong) UILabel *lbOrderTime;

@property (nonatomic, strong) OrderModelForCapacity *model;



@end

@implementation OrderDetailsCoal

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
}

-(void)bindView{
    self.bgView.frame=CGRectMake(0,0, SCREEN_W, SCREEN_H-64);
    [self.view addSubview:self.bgView];
    self.headTitleView.frame=CGRectMake(0,0, SCREEN_W, 97);
    [self.bgView addSubview:self.headTitleView];
    
    self.orderStatusLab.frame=CGRectMake(25, self.bgView.top+25, SCREEN_W-25, 16);
    [self.headTitleView addSubview:self.orderStatusLab];

    self.orderCodeLab.frame=CGRectMake(25, self.orderStatusLab.bottom+15, SCREEN_W-25, 16);
    [self.headTitleView addSubview:self.orderCodeLab];
    
    
    self.produceView.frame=CGRectMake(0, self.headTitleView.bottom, SCREEN_W, 60);
    [self.bgView addSubview:self.produceView];
    
     CGSize size = [self sizeWithText: self.coalTypeLab.text font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.coalTypeLab.frame=CGRectMake(25,17, size.width, 25);
    [self.produceView addSubview:self.coalTypeLab];
    
    self.coalCodeLab.frame=CGRectMake(self.coalTypeLab.right+10, 26, SCREEN_W-size.width-25-10, 9);
    [self.produceView addSubview:self.coalCodeLab];
    
    self.addressView.frame=CGRectMake(0, self.produceView.bottom+1, SCREEN_W, 96);
    [self.bgView addSubview:self.addressView];
    
    self.deliverImg.frame=CGRectMake(15, 28, 9.4f, 12);
    [self.addressView addSubview:self.deliverImg];
    
    
    self.productionImg.frame=CGRectMake(15, 56, 9.4f, 12);
    [self.addressView addSubview:self.productionImg];
    
    self.deliverLab.frame=CGRectMake(self.deliverImg.right+10, 25, 54, 18);
    self.productionLab.frame=CGRectMake(self.productionImg.right+10, self.deliverLab.bottom+10, 54, 18);
    
    [self.addressView addSubview:self.deliverLab];
    [self.addressView addSubview:self.productionLab];
    
    self.deliverAddressLab.frame=CGRectMake(self.deliverLab.right+2, 25, SCREEN_W-100, 18);
    self.productionAddressLab.frame=CGRectMake(self.productionLab.right+2,self.deliverAddressLab.bottom+10, SCREEN_W-100, 18);
    [self.addressView addSubview:self.deliverAddressLab];
    [self.addressView addSubview:self.productionAddressLab];
    
    self.viProperty.frame=CGRectMake(0, self.addressView.bottom+12, SCREEN_W, 185);
    [self.bgView addSubview:self.viProperty];
    
    NSArray *property = [[NSArray alloc] initWithObjects:@"低位热值Qnet(kcal/kg)",@"全水份Mt(%)",@"全硫份St(%)",@"挥发份V(%)",@"灰份（%）", nil];
    [self initProduceProperty:property];
    
    
    self.lastView.frame = CGRectMake(0, self.viProperty.bottom + 12, SCREEN_W, 80);

    self.lbPrice.frame = CGRectMake(0, 10, SCREEN_W-20, 20);
    [self.lastView addSubview:self.lbPrice];

    self.lbOrderTime.frame = CGRectMake(0, self.lbPrice.bottom + 1, SCREEN_W-20, 20);
    [self.lastView addSubview:self.lbOrderTime];


    [self.view addSubview:self.lastView];

    self.cancelBtn.frame = CGRectMake(0, SCREEN_H - 64 - 44, SCREEN_W  , 44);
    [self.view addSubview:self.cancelBtn];
    
}

-(void)getData {

    OrderViewModel *vm = [OrderViewModel new];
    WS(ws);
    [vm getCoalOrderDetailsWithOrderId:self.detailId callback:^(OrderModelForCapacity *model) {


         ws.orderStatusLab.text = model.status;
         ws.orderCodeLab.text = [NSString stringWithFormat:@"订单号：%@",model.orderCode];
         ws.orderStatusLab.text = model.status;
         ws.coalTypeLab.text = model.produceName;
         ws.coalCodeLab.text = model.produceCode;

        ws.deliverAddressLab.text = model.deliveryAddress;

        ws.productionAddressLab.text = model.goodsPlaceProductionAddress;

        NSArray *arrProperty = @[model.qnet,model.moisture,model.sulfur,model.volatilize,model.ash];
        [ws initProduceProperty:arrProperty];

        ws.lbPrice.text = [NSString stringWithFormat:@"￥%@",model.payablePrice];
        ws.lbOrderTime.text = [NSString stringWithFormat:@"下单时间：%@",[ws stDateToString1:model.createTime]];

        if ([model.status isEqualToString:@"待确定"]) {
            ws.cancelBtn.hidden = NO;

        }

        ws.model = model;


    }];

}

-(void)initProduceProperty:(NSArray *)array{


    for (UIView *view in self.viProperty.subviews) {
        [view removeFromSuperview];
    }

    for(int i=0;i<array.count;i++){

        NSArray *property = [[NSArray alloc] initWithObjects:@"低位热值Qnet(kcal/kg)",@"全水份Mt(%)",@"全硫份St(%)",@"挥发份V(%)",@"灰份（%）", nil];
        NSString * labText=property[i];
        UILabel *labeLeft=[UILabel new];
        labeLeft.frame=CGRectMake(15, i*(15+15)+26, 180, 15);
        labeLeft.text=labText;
        labeLeft.textColor=APP_COLOR_GRAY2;
        labeLeft.font=[UIFont systemFontOfSize:13];
        [self.viProperty addSubview:labeLeft];
        
        UILabel *labeLeright=[UILabel new];
        labeLeright.frame=CGRectMake(labeLeft.right+5, i*(15+15)+26, 100, 15);
        labeLeright.text=array[i];
        labeLeright.textColor=APP_COLOR_GRAY2;
        labeLeright.font=[UIFont systemFontOfSize:13];
        [self.viProperty addSubview:labeLeright];
        
    }
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


-(void)cancleAction{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"是否取消此订单？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.delegate = self;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {

        OrderViewModel *vm = [OrderViewModel new];
        WS(ws);

        [vm cancleCoalOrderWithOrderId:self.model.orderId Withcallback:^(NSString *str) {


            [ws getData];
        }];

    }
}

-(UIScrollView * )bgView{
    if(!_bgView){
        UIScrollView * bgView=[UIScrollView new];
        bgView.backgroundColor=APP_COLOR_GRAY_SEARCH_BG;
        _bgView = bgView;
    }
    return _bgView;
 
}

-(UIView *)headTitleView{
    if(!_headTitleView){
        UIView * view =[UIView new];
        view.backgroundColor=APP_COLOR_BLUE_BTN;
        _headTitleView = view;
    }
    return _headTitleView;
}

-(UILabel *)orderStatusLab{
    if(!_orderStatusLab){
        UILabel * lab=[UILabel new];
        lab.font=[UIFont systemFontOfSize:18.f];
        lab.textColor=APP_COLOR_WHITE;
        [lab setText:@"已发货"];
        _orderStatusLab=lab;
    }
    return _orderStatusLab;
}

-(UILabel *)orderCodeLab{
    if(!_orderCodeLab){
        UILabel * lab=[UILabel new];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textColor=APP_COLOR_WHITE;
        lab.text=@"订单号： 8989800987";
        _orderCodeLab=lab;
    }     return _orderCodeLab;
}

-(UIView *)produceView{
    if(!_produceView){
        UIView * view=[UIView new];
        view.backgroundColor=APP_COLOR_WHITE;
        _produceView=view;
    }
    return _produceView;
}

-(UILabel *)coalTypeLab{
    if(!_coalTypeLab){
        UILabel * lab=[UILabel new];
        lab.font=[UIFont boldSystemFontOfSize:18.f];
        lab.textColor=APP_COLOR_BLACK_TEXT;
        lab.text=@"无烟煤";
        _coalTypeLab=lab;
    }
    return _coalTypeLab;
}

-(UILabel *)coalCodeLab{
    if(!_coalCodeLab){
        UILabel * lab=[UILabel new];
        lab.text=@"QD-0980";
        lab.textColor=APP_COLOR_GRAY2;
        lab.font=[UIFont systemFontOfSize:12];
        _coalCodeLab=lab;
    }
    return _coalCodeLab;
}

-(UIView *)addressView{
    if(!_addressView){
        UIView * view=[UIView new];
        view.backgroundColor=APP_COLOR_WHITE;
        _addressView=view;
    }
    return _addressView;
}

-(UIImageView *)deliverImg{
    if(!_deliverImg){
        UIImageView * img=[[UIImageView alloc]init];
        img.image=[UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _deliverImg=img;
    }
    return _deliverImg;
}

-(UIImageView *)productionImg{
    if(!_productionImg){
        UIImageView * img=[[UIImageView alloc]init];
        img.image=[UIImage imageNamed:[@"Page 1 Copy 5" adS]];
        _productionImg=img;
    }
    return _productionImg;
}

-(UILabel *)deliverLab{
    if(!_deliverLab){
        UILabel *lab=[UILabel new];
        lab.text=@"交货地:";
        lab.textColor=APP_COLOR_GRAY2;
        lab.font=[UIFont systemFontOfSize:13];
        _deliverLab=lab;
    }
    
    return _deliverLab;
}

-(UILabel *)productionLab{
    if(!_productionLab){
        UILabel *lab=[UILabel new];
        lab.text=@"产    地:";
        lab.textColor=APP_COLOR_GRAY2;
        lab.font=[UIFont systemFontOfSize:13];
        _productionLab=lab;
    }
    
    return _productionLab;
}

-(UILabel *)deliverAddressLab{
    if(!_deliverAddressLab){
        UILabel *lab=[UILabel new];
        lab.textColor=APP_COLOR_GRAY4;
        lab.text=@"内蒙古鄂尔多斯市左边胡同右边小姐";
        lab.font=[UIFont systemFontOfSize:13];
        _deliverAddressLab=lab;
    }
    return _deliverAddressLab;
}

-(UILabel *)productionAddressLab{
    if(!_productionAddressLab){
        UILabel *lab=[UILabel new];
        lab.textColor=APP_COLOR_GRAY4;
        lab.text=@"内蒙古鄂尔多斯市左边胡同右边小姐";
        lab.font=[UIFont systemFontOfSize:13];
        _productionAddressLab=lab;
    }
    return _productionAddressLab;
}

-(UIView *)viProperty{
    
    if (!_viProperty) {
        UIView *view=[UIView new];
        view.backgroundColor=APP_COLOR_WHITE;
        _viProperty=view;
        
    }
    return _viProperty;
}

- (UIView *)lastView {
    if (!_lastView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line.frame = CGRectMake(0, 0, SCREEN_W, 0.5);
        [view addSubview:line];
        _lastView = view;
        
    }
    return _lastView;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        UILabel* label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        _priceLab = label;
    }
    return _priceLab;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消订单" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        button.backgroundColor = APP_COLOR_GRAY1;
        button.hidden = YES;
        [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = button;
    }
    return _cancelBtn;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_RED_TEXT;
        label.font = [UIFont boldSystemFontOfSize:18.0f];
        label.text = @"￥1000";
        label.textAlignment = NSTextAlignmentRight;



        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbOrderTime {
    if (!_lbOrderTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY999;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"下单时间：2016-2-14  15:00:02";
        label.textAlignment = NSTextAlignmentRight;



        _lbOrderTime = label;
    }
    return _lbOrderTime;
}


@end
