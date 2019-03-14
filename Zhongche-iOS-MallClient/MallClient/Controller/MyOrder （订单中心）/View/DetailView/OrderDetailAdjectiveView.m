//
//  OrderDetailAdjectiveView.m
//  MallClient
//
//  Created by lxy on 2018/6/8.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailAdjectiveView.h"
#import "NSString+Money.h"

@interface OrderDetailAdjectiveView ()

@property (weak, nonatomic) IBOutlet UILabel *detaLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNunberLabel;

@property (weak, nonatomic) IBOutlet UILabel *getLabel;
@property (weak, nonatomic) IBOutlet UILabel *getNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end


@implementation OrderDetailAdjectiveView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)pressView{
    
    if (self.block) {
        self.block();
    }
    [self removeFromSuperview];
}


- (void) setNewModel:(OrderModelForCapacity * )model WithModel:(OrderModelForCapacity *)oldModel
{
    _model = model;
    NSString *orderNumState;
    NSString *orderNumber;
    if ([oldModel.capacityType containsString:@"集装箱"]) {
        orderNumber = model.goodsNum;
        orderNumState = @"箱";
    }else if ([oldModel.capacityType containsString:@"大件"]){
        orderNumber = model.weight;
        orderNumState = @"吨";
    }else if ([oldModel.capacityType containsString:@"散堆装"]){
        orderNumber = model.weight;
        orderNumState = @"吨";
    }else{
        orderNumber = model.vehicleNum;
        orderNumState = @"台";
    }
    
    float ordernumber = [orderNumber floatValue];
    orderNumber = [NSString stringWithFormat:@"%.2f",ordernumber];

    [self.songLabel setAttributedText:[NSString getFormartPrice:[model.deliveryPrice floatValue]]];
    [self.getLabel setAttributedText:[NSString getFormartPrice:[model.pickupPrice floatValue]]];
    
    if ([model.deliveryPrice intValue]  == 0) {
        self.songNunberLabel.text = @"";
    }else{
        self.songNunberLabel.text = [NSString stringWithFormat:@" x %@%@",orderNumber,orderNumState];
    }
    if ([model.pickupPrice intValue]  == 0) {
        self.getNumberLabel.text = @"";
    }else{
        self.getNumberLabel.text = [NSString stringWithFormat:@" x %@%@",orderNumber,orderNumState];
    }
    [self.costLabel setAttributedText:[NSString getFormartPrice:[model.doorToDoorPrice floatValue]]];
    self.numberLabel.text = [NSString stringWithFormat:@" x %@%@",orderNumber,orderNumState];
}

- (void)setModel:(OrderModelForCapacity *)model
{
    
}
@end
