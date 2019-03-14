//
//  OrderDeyailIncreaseCell.m
//  MallClient
//
//  Created by lxy on 2018/6/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDeyailIncreaseCell.h"
@interface OrderDeyailIncreaseCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTopTel;

@property (weak, nonatomic) IBOutlet UIView *addressTopView;
@property (weak, nonatomic) IBOutlet UILabel *addressTop;

@property (weak, nonatomic) IBOutlet UILabel *personBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *personBottomTel;

@property (weak, nonatomic) IBOutlet UIView *addressbottomView;
@property (weak, nonatomic) IBOutlet UILabel *addressbottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConerLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConerLine;


@end

@implementation OrderDeyailIncreaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderModelForCapacity *)model
{
    _model = model;
    self.stateLabel.text = model.serviceType;
    self.personTopLabel.text = model.startpName;
    self.personTopTel.text = model.startpPhone;
    self.personBottomLabel.text = model.endpName;
    self.personBottomTel.text = model.endpPhone;
    self.addressTop.text = model.startaddress;
    self.addressbottom.text = model.endaddress;
    
    
    if ([model.serviceType isEqualToString:@"无"]) {
        self.addressTopView.hidden = YES;
        self.topConerLine.constant = 20;
        self.bottomConerLine.constant = 20;
        self.addressbottomView.hidden = YES;
    }
    
}

@end
