//
//  ZiXunCell.m
//  MallClient
//
//  Created by lxy on 2018/7/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "ZiXunCell.h"

@implementation ZiXunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ServerLabel.text = APP_CUSTOMER_SERVICE_NO_;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
