//
//  OrderDeyaillnCell.m
//  MallClient
//
//  Created by lxy on 2018/6/8.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDeyaillnCell.h"

@interface OrderDeyaillnCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addessImageView;

@end

@implementation OrderDeyaillnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setModel:(OrderModelForCapacity *)model AndIndex:(NSInteger)index
{
    
    if (index == 1) {
        self.stateLabel.text = @"取货人";
        self.nameLabel.text = model.startpName;
        self.telLabel.text = model.startpPhone;
        self.addressLabel.text = @"上门取货地址：";
        self.addressDetailLabel.text = model.startaddress;
        
        if ([model.serviceType isEqualToString:@"无"] || [model.serviceType isEqualToString:@"送货上门"]) {
            self.addessImageView.hidden = YES;
            self.addressLabel.hidden = YES;
            self.addressDetailLabel.text = @"";
        }
    }else{
        
        self.stateLabel.text = @"收货人";
        self.nameLabel.text = model.endpName;
        self.telLabel.text = model.endpPhone;
        self.addressLabel.text = @"送货上门地址：";
        self.addressDetailLabel.text = model.endaddress;
        
        if ([model.serviceType isEqualToString:@"无"] || [model.serviceType isEqualToString:@"上门收货"]) {
            self.addessImageView.hidden = YES;
            self.addressLabel.hidden = YES;
            self.addressDetailLabel.text = @"";
        }
    }
}

- (void) requestModel:(CapacityEntryModel *)model AndIndex:(NSInteger)index
{
    if (index == 0) {
        if ([model.serviceWay isEqualToString:@"无"] || [model.serviceWay isEqualToString:@"送货上门"]) {
            self.addessImageView.hidden = YES;
            self.addressLabel.hidden = YES;
            self.addressDetailLabel.hidden = YES;;
        }
        self.stateLabel.text = @"取货人";
        self.nameLabel.text = model.contactInfo.startContacts;
        self.telLabel.text = model.contactInfo.startContactsPhone;
        self.addressLabel.text = @"上门取货地址：";
        self.addressDetailLabel.text = model.contactInfo.startAddress;
    }else{
        
        if ([model.serviceWay isEqualToString:@"无"] || [model.serviceWay isEqualToString:@"上门取货"]) {
            self.addessImageView.hidden = YES;
            self.addressLabel.hidden = YES;
            self.addressDetailLabel.hidden = YES;
        }
        self.stateLabel.text = @"收货人";
        self.nameLabel.text = model.contactInfo.endContacts;
        self.telLabel.text = model.contactInfo.endContactsPhone;
        self.addressLabel.text = @"送货上门地址：";
        self.addressDetailLabel.text = model.contactInfo.endAddress;
    }
}

@end
