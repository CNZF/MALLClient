//
//  NewTransportTableViewCell.m
//  MallClient
//
//  Created by lxy on 2017/2/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "NewTransportTableViewCell.h"

@implementation NewTransportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 *   NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f起",[model.price floatValue]]];
 [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED_TEXT range:NSMakeRange(0,price.length - 1)];
 [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY2 range:NSMakeRange(price.length - 1,1)];
 [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 4)];
 [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 4,4)];
 self.priceLab.attributedText = price;
 */

@end
