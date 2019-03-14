//
//  DetailZeroHeadView.m
//  MallClient
//
//  Created by lxy on 2018/11/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "DetailZeroHeadView.h"

@implementation DetailZeroHeadView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.OutView.layer.borderWidth = 1;
    self.OutView.layer.borderColor = [HelperUtil colorWithHexString:@"E9E9E9"].CGColor;
    
    UIColor *color1;
    self.OutView.backgroundColor = [UIColor whiteColor];
    if ([self.model.ordetType isEqualToString:@"待确认"]) {
        self.contentLabel.text = @"20%";
        self.inViewWidth.constant = self.OutView.bounds.size.width*0.2;
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
    }else if ([self.model.ordetType isEqualToString:@"待付款"]) {
        self.contentLabel.text = @"40%";
        self.inViewWidth.constant = self.OutView.bounds.size.width*0.4;
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
    }else if ([self.model.ordetType isEqualToString:@"待发货"]) {
        self.contentLabel.text = @"60%";
        self.inViewWidth.constant = self.OutView.bounds.size.width*0.6;
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
    }else if ([self.model.ordetType isEqualToString:@"待结算"]) {
        self.contentLabel.text = @"80%";
        self.inViewWidth.constant = self.OutView.bounds.size.width*0.8;
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
    }else if ([self.model.ordetType isEqualToString:@"已完成"]) {
        self.contentLabel.text = @"100%";
        self.inViewWidth.constant = self.OutView.bounds.size.width*1-2;
        color1 = [HelperUtil colorWithHexString:@"9CCC4E"];
    }else{
        self.contentLabel.text = @"0%";
        self.inViewWidth.constant = self.OutView.bounds.size.width*1-2;
        color1 = [HelperUtil colorWithHexString:@"F03E3E"];
    }
    self.inView.backgroundColor = color1;
}

- (void)setModel:(OrderModelForCapacity *)model
{
    _model = model;

}

@end
