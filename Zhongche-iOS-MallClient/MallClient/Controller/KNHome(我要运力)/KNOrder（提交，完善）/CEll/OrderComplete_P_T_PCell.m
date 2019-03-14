//
//  OrderComplete_P_T_PCell.m
//  MallClient
//
//  Created by lxy on 2018/6/12.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderComplete_P_T_PCell.h"

@interface OrderComplete_P_T_PCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *feild;

@end

@implementation OrderComplete_P_T_PCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.feild.delegate = self;
}


- (void) setCapaModel:(CapacityEntryModel *)model Index:(NSInteger)index type:(NSString *)type
{
    _model = model;
    _index = index;
    _type = type;
    
    if ([type isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        
        if (index == 1) {
            self.label.text = @"发货人";
            self.feild.placeholder = @"请输入发货人姓名";
        }else if (index == 2){
            self.label.text = @"联系方式";
            self.feild.placeholder = @"请输入发货人联系电话";
        }else if ( index ==3){
            self.label.text = @"收货人";
            self.feild.placeholder = @"请输入收货人姓名";
        }else{
            self.label.text = @"联系方式";
            self.feild.placeholder = @"请输入收货人联系方式";
        }
    }else if ([type isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
        if (index == 2) {
            self.label.text = @"收货人";
            self.feild.placeholder = @"请输入收货人姓名";
        }else if (index == 3){
            self.label.text = @"联系方式";
            self.feild.placeholder = @"请输入收货人联系方式";
        }
    }else if ([type isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
        if (index == 1) {
            self.label.text = @"发货人";
             self.feild.placeholder = @"请输入发货人姓名";
        }else if (index == 2){
            self.label.text = @"联系方式";
            self.feild.placeholder = @"请输入发货人联系电话";
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.type isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        
        if (self.index == 1) {
            self.model.contactInfo.startContacts = textField.text;
        }else if (self.index == 2){
            self.model.contactInfo.startContactsPhone = textField.text;
        }else if ( self.index ==3){
            self.model.contactInfo.endContacts = textField.text;
        }else{
            self.model.contactInfo.endContactsPhone = textField.text;
        }
    }else if ([self.type isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
        if (self.index == 2) {
             self.model.contactInfo.endContacts = textField.text;
        }else if (self.index == 3){
             self.model.contactInfo.endContactsPhone = textField.text;
        }
    }else if ([self.type isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
        if (self.index == 1) {
            self.model.contactInfo.startContacts = textField.text;
        }else if (self.index == 2){
            self.model.contactInfo.startContactsPhone = textField.text;
        }
    }
}

@end
