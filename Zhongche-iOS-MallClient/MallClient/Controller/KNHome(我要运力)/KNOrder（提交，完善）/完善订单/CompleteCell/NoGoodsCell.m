//
//  NoGoodsCell.m
//  MallClient
//
//  Created by lxy on 2018/7/31.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "NoGoodsCell.h"

@interface NoGoodsCell ()
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation NoGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.field.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.requestModel) {
        self.requestModel.noGoodsName = textField.text;
    }else{
        self.requestViewModel.noGoodName = textField.text;
    }
    
}

- (void)setRequestModel:(CapacityEntryModel *)requestModel With:(BOOL)isSelect
{
    _requestModel = requestModel;
    if (isSelect) {
        self.btn.hidden = YES;
        self.field.hidden = NO;
    }else{
        self.btn.hidden = NO;
        self.field.hidden = YES;
    }
}

- (void)setCapacityViewModelRequestModel:(CapacityViewModel *)requestModel With:(BOOL)isSelect
{
    _requestViewModel = requestModel;
    if (isSelect) {
        self.btn.hidden = YES;
        self.field.hidden = NO;
    }else{
        self.btn.hidden = NO;
        self.field.hidden = YES;
    }
}

@end
