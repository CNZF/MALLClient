//
//  KNTableViewNumberCell.m
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTableViewNumberCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface KNTableViewNumberCell ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@end

@implementation KNTableViewNumberCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.valueTextField.delegate = self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    
    __weak typeof(self) weakSelf = self;
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if(weakSelf.valueTextField.text.integerValue <= 1){
            return;
        } else {
            weakSelf.valueTextField.text = [NSString stringWithFormat:@"%ld",weakSelf.valueTextField.text.integerValue - 1];
            [weakSelf setFieldText: weakSelf.valueTextField.text];
            if (weakSelf.changeBlock) {
                weakSelf.changeBlock(weakSelf.valueTextField.text);
            }
        }
        
    }];
    
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        weakSelf.valueTextField.text = [NSString stringWithFormat:@"%ld",weakSelf.valueTextField.text.integerValue + 1];
        [weakSelf setFieldText: weakSelf.valueTextField.text];
        if (weakSelf.changeBlock) {
            weakSelf.changeBlock(weakSelf.valueTextField.text);
        }
    }];
     
//     [self.valueTextField.rac_textSignal subscribeNext:^(NSString *str) {
//        NSInteger number = str.integerValue;
//        if (number < 1)
//         number = 1;
//        self.valueTextField.text = [NSString stringWithFormat:@"%ld",number];
//     }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text intValue] > 0) {
        [self setFieldText:textField.text];
    }else{
        [self setFieldText:@"1"];
    }
    
    
}

- (void) setFieldText:(NSString *)str
{
    if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_VECHICLE"]) {
        self.reRequestModel.vehicleNum = [str integerValue];
    }
    if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_LARGE_SIZE"]) {
        self.reRequestModel.wrapperNumber = [str integerValue];
    }
    if ([self.reRequestModel.businessTypeCode isEqualToString:@"BUSINESS_TYPE_CONTAINER"]){
        self.reRequestModel.containerNumber = [str integerValue];
    }
    if (self.changeBlock) {
        self.changeBlock(str);
    }
}

- (void)setReRequestModel:(CapacityViewModel *)reRequestModel
{
    _reRequestModel = reRequestModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
