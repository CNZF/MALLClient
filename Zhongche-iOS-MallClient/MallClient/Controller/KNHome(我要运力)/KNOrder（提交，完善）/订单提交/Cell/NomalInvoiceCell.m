//
//  NomalInvoiceCell.m
//  MallClient
//
//  Created by lxy on 2018/8/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "NomalInvoiceCell.h"


@interface NomalInvoiceCell()
@property (weak, nonatomic) IBOutlet UILabel *CompanyName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *invoNumber;
@property (weak, nonatomic) IBOutlet UILabel *reAddress;
@property (weak, nonatomic) IBOutlet UILabel *bank;

@property (weak, nonatomic) IBOutlet UILabel *bankNum;


@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end


@implementation NomalInvoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CapacityEntryModel *)model
{
    _model = model;
    self.CompanyName.text = model.invoice.title;
    if ([model.invoice.type isEqualToString:@"INVOICE_TYPE_COMMON_TAX"]) {
        self.type.text = @"普通发票";
    }else{
        self.type.text =  @"增值税发票";
    }
    
    self.invoNumber.text = model.invoice.idCode;
    self.reAddress.text = model.invoice.regAddress;
    self.bank.text = model.invoice.regBlank;
    self.bankNum.text = model.invoice.regBlankAccount;
    
//    self.content.text = model.invoice.content;
    self.userName.text = model.invoice.contactsName;
    self.tel.text = model.invoice.contactsTel;
    self.address.text = model.invoice.contactsAddress;
}


@end
