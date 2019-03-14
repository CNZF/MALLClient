//
//  KNTableViewUserInfoCell.m
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTableViewUserInfoCell.h"

@interface KNTableViewUserInfoCell ()<UITextFieldDelegate>


@end


@implementation KNTableViewUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameTextField.delegate = self;
    self.mobileTextField.delegate = self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField  == self.nameTextField) {
        self.reRequestModel.contacts = self.nameTextField.text;
    }
    if (textField  == self.mobileTextField) {
        self.reRequestModel.contactsPhone = self.mobileTextField.text;
    }
}

- (void)setReRequestModel:(CapacityViewModel *)reRequestModel
{
    _reRequestModel = reRequestModel;
}

@end
