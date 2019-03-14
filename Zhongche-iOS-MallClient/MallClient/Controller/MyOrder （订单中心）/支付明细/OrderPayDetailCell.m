//
//  OrderPayDetailCell.m
//  MallClient
//
//  Created by lxy on 2018/6/10.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderPayDetailCell.h"
#import "NSString+Money.h"

@interface OrderPayDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timaLabel;
@property (weak, nonatomic) IBOutlet UILabel *mineyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDetailLabel;

@end

@implementation OrderPayDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderPayModel *)model
{
    _model = model;
    self.statusLabel.text = model.statusName;
    self.timaLabel.text = [NSString TimeGetDate:model.time];
    [self.mineyLabel setAttributedText:[NSString getFormartPrice:[model.price floatValue]]];
    if ([model.trade_order_type isEqualToString:@"2"]) {
        self.typeLabel.text = @"线下付款";
    }else{
        self.typeLabel.text = @"线上支付";
    }
    self.statusDetailLabel.text = model.remark;
}

@end
