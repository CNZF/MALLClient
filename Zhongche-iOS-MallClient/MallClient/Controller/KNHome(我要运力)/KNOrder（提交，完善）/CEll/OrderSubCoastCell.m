//
//  OrderSubCoastCell.m
//  MallClient
//
//  Created by lxy on 2018/6/12.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderSubCoastCell.h"
#import "NSString+Money.h"

@interface OrderSubCoastCell ()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *songPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *songNumber;
@property (weak, nonatomic) IBOutlet UILabel *quPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quNumber;
@property (weak, nonatomic) IBOutlet UILabel *yunPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunNumberLabel;

@end

@implementation OrderSubCoastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CapacityEntryModel *)model
{
    
    NSString * songPrice = model.priceInfo.endAdditionPrice;
    NSString * quPrice = model.priceInfo.startAdditionPrice;
    NSString * yunPrice = model.priceInfo.ticketTotalPrice;
    NSString * goodNum = model.boxNum;
    self.totalPriceLabel.attributedText = [NSString getFormartPrice:[model.priceInfo.orderTotalMoney floatValue]];
    self.yunPriceLabel.attributedText = [NSString getFormartPrice:[yunPrice floatValue]];
    self.yunNumberLabel.text = [NSString stringWithFormat:@" x%@",goodNum];
    self.quPriceLabel.attributedText = [NSString getFormartPrice:[quPrice floatValue]];
    self.quNumber.text = [NSString stringWithFormat:@" x%@",goodNum];
    self.songPriceLabel.attributedText = [NSString getFormartPrice:[songPrice floatValue]];
    self.songNumber.text = [NSString stringWithFormat:@" x%@",goodNum];
    if ([model.serviceWay isEqualToString:@"无"]) {
        self.songPriceLabel.attributedText = [NSString getFormartPrice:[@"0.00" floatValue]];
        self.songNumber.text = [NSString stringWithFormat:@" x%@",@"0"];
        self.quPriceLabel.attributedText = [NSString getFormartPrice:[@"0.00" floatValue]];
        self.quNumber.text = [NSString stringWithFormat:@" x%@",@"0"];
    }
    if ([model.serviceWay isEqualToString:@"送货上门"]) {
        self.songPriceLabel.attributedText = [NSString getFormartPrice:[@"0.00" floatValue]];
        self.songNumber.text = [NSString stringWithFormat:@" x%@",@"0"];
        self.songPriceLabel.attributedText = [NSString getFormartPrice:[songPrice floatValue]];
        self.songNumber.text = [NSString stringWithFormat:@" x%@",goodNum];
    }
    if ([model.serviceWay isEqualToString:@"上门取货"]) {
        self.quPriceLabel.attributedText = [NSString getFormartPrice:[quPrice floatValue]];
        self.quNumber.text = [NSString stringWithFormat:@" x%@",goodNum];
        self.songPriceLabel.attributedText = [NSString getFormartPrice:[@"0.00" floatValue]];
        self.songNumber.text = [NSString stringWithFormat:@" x%@",@"0"];
    }
}

@end
