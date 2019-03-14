//
//  KNTableViewTipsCell.m
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTableViewTipsCell.h"

@implementation KNTableViewTipsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = APP_COLOR_GRAY_SEARCH_BG.CGColor;
    
}

- (void)layoutSubviews
{
    self.textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.reRequestModel.remark = textView.text;
}


- (void)setReRequestModel:(CapacityViewModel *)reRequestModel
{
    _reRequestModel = reRequestModel;
}


@end
