//
//  KNTableViewBigCell.m
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTableViewBigCell.h"

@implementation KNTableViewBigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.longTF.delegate = self;
    self.widthTF.delegate = self;
    self.heightTF.delegate = self;
    self.weightTF.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.longTF) {
        self.reRequestModel.unitMaxLength = [textField.text doubleValue];
    }
    if (textField == self.widthTF) {
        self.reRequestModel.unitMaxWidth = [textField.text doubleValue];
    }
    if (textField == self.heightTF) {
        self.reRequestModel.unitMaxHigh = [textField.text doubleValue];
    }
    if (textField == self.weightTF) {
        self.reRequestModel.unitMaxWeight = [textField.text doubleValue];
    }
}

- (void)setReRequestModel:(CapacityViewModel *)reRequestModel
{
    _reRequestModel =reRequestModel;
}

@end
