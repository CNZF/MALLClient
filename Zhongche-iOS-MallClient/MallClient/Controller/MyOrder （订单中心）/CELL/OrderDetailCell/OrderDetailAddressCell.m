//
//  OrderDetailAddressCell.m
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailAddressCell.h"
#import "NSString+Money.h"
@implementation OrderDetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.orderTypeLabel.layer.borderWidth = 1.0;
//    self.orderTypeLabel.layer.borderColor = [UIColor colorWithRed:15/255.0f green:128/255.0f blue:255/255.0f alpha:1].CGColor;
}
- (void) setNewModel:(OrderModelForCapacity * )model WithModel:(OrderModelForCapacity *)oldModel
{
    NSString * goodName;
    NSString * goodType;
    if ([oldModel.capacityType containsString:@"集装箱"]) {
        goodName = model.goodsName;
        goodType = @"集装箱";
        self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:0.2];
        self.orderTypeLabel.textColor = [UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:1];
    }else if ([oldModel.capacityType containsString:@"大件"]){
        goodType = @"大件";
        goodName = model.goodsName;
        self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:0.2];
        self.orderTypeLabel.textColor = [UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:1];
    }else if ([oldModel.capacityType containsString:@"散堆装"]){
        goodName = model.goodsName;
        goodType = @"散堆装";
        self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:0.2];
        self.orderTypeLabel.textColor = [UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:1];
    }else{
        goodName = @"";
        goodType = @"商品车";
        self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:0.2];
        self.orderTypeLabel.textColor = [UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:1];
    }
    
//    
//    if ([model.capacityType containsString:@"集装箱"]) {
//        orderType = @"集装箱";
//        self.orderType_1.backgroundColor = [UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:0.2];
//        [self.orderType_1 setTitleColor:[UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:1] forState:UIControlStateNormal];
//        orderNumber = [NSString stringWithFormat:@"%@箱",model.goodsNum];
//    }else if ([model.capacityType containsString:@"大件"]){
//        orderType = @"大件";
//        self.orderType_1.backgroundColor = [UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:0.2];
//        [self.orderType_1 setTitleColor:[UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:1] forState:UIControlStateNormal];
//        orderNumber = [NSString stringWithFormat:@"%@吨",model.weight];
//    }else if ([model.capacityType containsString:@"散堆装"]){
//        orderType = @"散堆装";
//        self.orderType_1.backgroundColor = [UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:0.2];
//        [self.orderType_1 setTitleColor:[UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:1] forState:UIControlStateNormal];
//        orderNumber = [NSString stringWithFormat:@"%@吨 %@立方",model.weight,model.volume];
//        self.orderName.text = model.goodsName;
//    }else{
//        orderType = @"商品车";
//        self.orderType_1.backgroundColor = [UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:0.2];
//        [self.orderType_1 setTitleColor:[UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:1] forState:UIControlStateNormal];
//        orderNumber = [NSString stringWithFormat:@"%@台",model.vehicleNum];
//        self.orderName.text = model.vehicleType;
//    }
//    
    
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间%@",[NSString TimeGetDate:model.placeTheOrderTime]];
    self.orderTypeLabel.text = goodType;
    self.orderNumLabel.text = model.orderID;
    self.orderDetailLabel.text = goodName;
    self.startP.text = model.startPlace;
    self.endP.text = model.endPlace;
    self.satrtT.text = [NSString TimeGetDate:model.estimateDepartureTime];
    if (model.estimateFinishTime) {
        self.endT.text = [NSString TimeGetDate:model.estimateFinishTime];
    }else{
        self.endT.text = @" ";
    }
    
    self.startPlaceLabel.text = model.startEntrepotName;
    self.endPlaceLabel.text = model.endEntrepotName;
    self.startAddressLabel.text = model.startEntrepotAddress;
    self.endAddressLabel.text = model.endEntrepotAddress;
    self.startAddressLabel.font = [UIFont systemFontOfSize:14.0f];
    self.endAddressLabel.font = [UIFont systemFontOfSize:14.0f];
}
@end
