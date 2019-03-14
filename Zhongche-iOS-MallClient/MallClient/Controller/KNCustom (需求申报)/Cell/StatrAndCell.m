//
//  StatrAndCell.m
//  MallClient
//
//  Created by lxy on 2018/10/29.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "StatrAndCell.h"

@implementation StatrAndCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.startCityField.delegate = self;
    self.endCityField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.fildBlock) {
        if (textField == self.startCityField) {
            self.fildBlock(1);
        }else{
            self.fildBlock(2);
        }
    }
}
- (IBAction)pressStart:(id)sender {
    if (self.fildBlock) {
        self.fildBlock(1);
    }
}
- (IBAction)pressEnd:(id)sender {
    if (self.fildBlock) {
        self.fildBlock(2);
    }
}

- (IBAction)pressChangeBtn:(id)sender {
    
    if (self.fildBlock) {
        self.fildBlock(3);
    }
}

@end
