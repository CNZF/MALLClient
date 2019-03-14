//
//  OrderDetailInVoiveCell.m
//  MallClient
//
//  Created by lxy on 2018/6/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailInVoiveCell.h"

@implementation OrderDetailInVoiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNewModel:(OrderModelForCapacity * )model WithModel:(OrderModelForCapacity *)oldModel
{
    //INVOICE_TYPE_COMMON_TAX
    NSString * contentStr = @"";
    contentStr = [contentStr stringByAppendingString:@"发票抬头："];
    contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice_0.title]];
    contentStr = [contentStr stringByAppendingString:@"发票类型："];
    if ([model.invoice_0.type isEqualToString:@"INVOICE_TYPE_COMMON_TAX"]) {
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"普通发票"]];
    }else{
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"增值税发票"]];
    }
//    contentStr = [contentStr stringByAppendingString:@"发票内容："];
//    contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice_0.content]];
    contentStr = [contentStr stringByAppendingString:@"收票人姓名："];
    contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice_0.contactsName]];
    contentStr = [contentStr stringByAppendingString:@"收票人电话："];
    contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice_0.contactsTel]];
    contentStr = [contentStr stringByAppendingString:@"收票人地址："];
    contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@",model.invoice_0.contactsAddress]];
//    self.invoiceLabel.text = contentStr;
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:14];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    self.invoiceLabel.attributedText = attributedString;
}

- (void)setModel:(OrderModelForCapacity *)model
{
    
}

@end
