//
//  StackCell.m
//  MallClient
//
//  Created by lxy on 2018/8/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "StackCell.h"
#import "NSString+Money.h"

@implementation StackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadUIWithmodel:(CapacityEntryModel *)model
{
    self.startPlace.text = model.startRegionName;
    
    self.endPlace.text = model.endRegionName;

    self.goodsName.text = model.goodName;
 
    
    NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[model.price NumberStringToMoneyString]]];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED_TEXT range:NSMakeRange(0,price.length)];
//    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY2 range:NSMakeRange(price.length - 1,1)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 2)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 2,2)];
    self.price.attributedText = price;

    
}
@end
