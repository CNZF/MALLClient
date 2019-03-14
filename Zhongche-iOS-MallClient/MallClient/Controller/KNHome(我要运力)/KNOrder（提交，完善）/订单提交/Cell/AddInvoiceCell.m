//
//  AddInvoiceCell.m
//  MallClient
//
//  Created by lxy on 2018/8/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AddInvoiceCell.h"


@interface AddInvoiceCell ()
@property (weak, nonatomic) IBOutlet UILabel *conpanyName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *nasuinumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;
@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UILabel *personTel;
@property (weak, nonatomic) IBOutlet UILabel *goodAddress;

@end

@implementation AddInvoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
