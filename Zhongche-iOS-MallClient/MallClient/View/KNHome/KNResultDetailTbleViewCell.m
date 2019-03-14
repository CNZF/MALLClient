//
//  KNResultDetailTbleViewCell.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultDetailTbleViewCell.h"

@interface KNResultDetailTbleViewCell ()

@end

@implementation KNResultDetailTbleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleNameLabel.layer.borderWidth = 1.0;
    self.titleNameLabel.layer.borderColor = APP_COLOR_GRAY_CAPACITY_LINE.CGColor;
    self.orderButton.layer.cornerRadius = 3.0;
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.layer.borderWidth = 1.0;
    self.orderButton.layer.borderColor = [HelperUtil colorWithHexString:@"3BA0F3"].CGColor;
    
}

#pragma mark -- Action
- (IBAction)orderButtonAction:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
