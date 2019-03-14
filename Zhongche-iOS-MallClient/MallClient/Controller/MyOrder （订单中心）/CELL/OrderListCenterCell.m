//
//  OrderListCenterCell.m
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderListCenterCell.h"
#import "NSString+Money.h"
#import "ProView.h"
@interface OrderListCenterCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderID;
@property (weak, nonatomic) IBOutlet UILabel *beginCity;
@property (weak, nonatomic) IBOutlet UILabel *endCity;
@property (weak, nonatomic) IBOutlet UILabel *beginDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *orderTransType;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UIButton *orderType_1;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet ProView *proView;
@property (weak, nonatomic) IBOutlet UILabel *ProLabel;

@end



@implementation OrderListCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.orderType_1.layer.borderWidth = 1.0;
//    self.orderType_1.layer.borderColor = [UIColor colorWithRed:15/255.0f green:128/255.0f blue:255/255.0f alpha:0.5].CGColor;
    self.BGView.layer.cornerRadius = 8.0f;
    self.BGView.layer.masksToBounds =YES;
    self.proView.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.ProLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(OrderModelForCapacity *)model{//1003 箱  1002 大件  吨   1001 商品车，台  散装堆，xx吨，xxl立方
    _model = model;
    self.orderID.text = [NSString stringWithFormat:@"订单号：%@",model.orderID];
    self.beginCity.text = model.startPlace;
    self.endCity.text = model.endPlace;
    self.beginDate.text = [self getDate:[model.estimateDepartureTime doubleValue]];
   
    if (model.estimateFinishTime) {
         self.endDate.text = [self getDate:[model.estimateFinishTime doubleValue]];
    }else{
         self.endDate.text = @" ";
    }
    
    self.orderName.text = model.goodsName;
    NSString * orderType;
    NSString * orderNumber;
    if ([model.capacityType containsString:@"集装箱"]) {
        orderType = @"集装箱";
        self.orderType_1.backgroundColor = [UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:0.2];
        [self.orderType_1 setTitleColor:[UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:1] forState:UIControlStateNormal];
        orderNumber = [NSString stringWithFormat:@"%@箱",model.goodsNum];
    }else if ([model.capacityType containsString:@"大件"]){
        orderType = @"大件";
        self.orderType_1.backgroundColor = [UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:0.2];
        [self.orderType_1 setTitleColor:[UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:1] forState:UIControlStateNormal];
        orderNumber = [NSString stringWithFormat:@"%@吨",model.weight];
    }else if ([model.capacityType containsString:@"散堆装"]){
        orderType = @"散堆装";
         self.orderType_1.backgroundColor = [UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:0.2];
        [self.orderType_1 setTitleColor:[UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:1] forState:UIControlStateNormal];
        orderNumber = [NSString stringWithFormat:@"%@吨 %@立方",model.weight,model.volume];
        self.orderName.text = model.goodsName;
    }else{
        orderType = @"商品车";
         self.orderType_1.backgroundColor = [UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:0.2];
         [self.orderType_1 setTitleColor:[UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:1] forState:UIControlStateNormal];
        orderNumber = [NSString stringWithFormat:@"%@台",model.vehicleNum];
        self.orderName.text = model.vehicleType;
    }
    [self.orderType_1 setTitle:orderType forState:UIControlStateNormal];
//    self.orderType.text = orderType;
    self.orderNumber.text = orderNumber;
    self.orderTransType.text = model.ordetType;
    if ([model.ordetType isEqualToString:@"已取消"]) {
        self.orderTransType.textColor = [UIColor darkGrayColor];
    }else{
        self.orderTransType.textColor = [HelperUtil colorWithHexString:@"FF9300"];
    }
    [self.orderPrice setAttributedText:[NSString getFormartPrice:[model.price doubleValue]]];
    
    if ([self.model.ordetType isEqualToString:@"待确认"]) {
        self.ProLabel.text = @"20%";
    }else if ([self.model.ordetType isEqualToString:@"待付款"]) {
        self.ProLabel.text = @"40%";
    }else if ([self.model.ordetType isEqualToString:@"待发货"]) {
        self.ProLabel.text = @"60%";
    }else if ([self.model.ordetType isEqualToString:@"待结算"]) {
        self.ProLabel.text = @"80%";
    }else if ([self.model.ordetType isEqualToString:@"已完成"]) {
        self.ProLabel.text = @"100%";
    }else{
        self.ProLabel.text = @"0%";
    }
    
    //进度框
//    if ([self.model.ordetType isEqualToString:@"已取消"] || [model.capacityType containsString:@"散堆装"]) {
//        self.proView.hidden = YES;
//    }else{
//        self.proView.hidden = NO;
//        long long curttensecond = [self getDateTimeTOMilliSeconds:[NSDate date]];
//
//        long long statr = curttensecond - [model.submitTime longLongValue];
//        long long endr = [model.estimateFinishTime longLongValue] - [model.submitTime longLongValue];
//
//        CGFloat qqq = (float)statr/(float)endr;
//
//        if ([model.ordetType isEqualToString:@"已完成"]) {
//            self.ProLabel.text = @"100%";
//        }else{
//            if (qqq>=0 && qqq<1) {
//                self.ProLabel.text = [NSString stringWithFormat:@"%i%@",(int)roundf(qqq*100) ,@"%"];
//            }else{
//                self.ProLabel.text = @"99%";
//            }
//        }
//
//
//        if (qqq>=0 && ![model.capacityType containsString:@"散堆装"]) {
//             [self.proView drawProRect:statr all:endr Model:model];
//        }
//    }
//    [self.proView drawProRect:statr all:endr Model:model];
    [self.proView drawProRectModel:model];
   
    
}
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime

{
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    
    NSLog(@"转换的时间戳=%f",interval);
    
    long long totalMilliseconds = interval*1000 ;
    
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    
    return totalMilliseconds;
    
}


- (NSString *)getDate:(NSInteger)time
{
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time / 1000]];
    return str;
}

@end
