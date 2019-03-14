//
//  containerCell.m
//  MallClient
//
//  Created by lxy on 2018/11/19.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "containerCell.h"

@implementation containerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadUIWithmodel:(CapacityEntryModel *)model
{
    self.cityLabel.text = model.startPlace.name;
    
    self.endLabel.text = model.endPlace.name;

//    self.startCity.text = model.startPlace.name;
//
//    self.endCity.text = model.endPlace.name;
//    self.cityLabel.text = [NSString stringWithFormat:@"%@ ———— %@",model.startPlace.name,model.endPlace.name];
    //[self.startCity.text sizeWithAttributes:@{NSFontAttributeName:self.startCity.font}].width
    
//    self.startCity.frame = CGRectMake(self.startCity.left, self.startCity.top,80 , self.startCity.height);
//    self.line.frame = CGRectMake(self.startCity.right + 7, self.line.top, self.line.width, self.line.height);
//    self.endCity.frame = CGRectMake(self.line.right + 7, self.endCity.top, 80, self.endCity.height);
    
//    self.boxName.text = model.businessTypeCode;
    
    CGFloat fix = [model.line_fix_price floatValue];
    CGFloat base  = [model.line_base_price floatValue];
    CGFloat all = fix + base;
    NSString * allPrice = [NSString stringWithFormat:@"%f",all];
    
    NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@起",[allPrice NumberStringToMoneyString]]];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_RED_TEXT range:NSMakeRange(0,price.length - 1)];
    [price addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY2 range:NSMakeRange(price.length - 1,1)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0,price.length - 4)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(price.length - 4,4)];
    self.priceLabel.attributedText = price;
    
    
//    self.lbDay.text = [NSString stringWithFormat:@"%@天",model.day];
//    self.lbDistance.text = [NSString stringWithFormat:@"%@km",model.mileage];
//
//    self.lbDay.frame = CGRectMake(15, 42, [self.lbDay.text sizeWithAttributes:@{NSFontAttributeName:self.lbDay.font}].width + 6, 16);
//    [self addSubview:self.lbDay];
//
//    self.lbDistance.frame = CGRectMake(self.lbDay.right + 20, 42, [self.lbDistance.text sizeWithAttributes:@{NSFontAttributeName:self.lbDistance.font}].width + 6, 16);
//    [self addSubview:self.lbDistance];
    
    
    
}
@end
