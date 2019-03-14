//
//  KNTableViewTextFieldCell.m
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTableViewTextFieldCell.h"

@implementation KNTableViewTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.nameTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_VECHICLE"] && self.section == 1 && self.index == 0) {
         self.goods.name = textField.text;
    }else if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_VECHICLE"] && self.section == 1 && self.index == 1) {
        self.reRequestModel.vehicleType = textField.text ;
    }else if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {
//        self.reRequestModel.weight = [textField.text doubleValue];
        if (self.section == 1 &&self.index == 3) {
            self.reRequestModel.weight = [textField.text doubleValue];
        }else if (self.section == 1 && self.index == 2){
            self.reRequestModel.m3 = [textField.text doubleValue];
        }
        
    }else if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_LARGE_SIZE"]) {
        self.reRequestModel.weight = [textField.text doubleValue];
    }
//    if (self.section == 3) {
//        if (self.index == 0) {
//            self.reRequestModel.shouPerson = textField.text;
//        }else if (self.index == 1) {
//            self.reRequestModel.shouTel = textField.text;
//        }else if (self.index == 2) {
//            self.reRequestModel.faPerson = textField.text;
//        }else{
//            self.reRequestModel.faTel = textField.text;
//        }
//    }
    
}


- (void) setGoods:(GoodsInfo *)goods reRequestModel:(CapacityViewModel *)reRequestModel section:(NSInteger)section  index:(NSInteger) index
{
    _reRequestModel = reRequestModel;
    _goods = goods;
    _index = index;
    _section = section;
}

@end
