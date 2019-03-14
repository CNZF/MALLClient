//
//  OrderSelectAddressCell.m
//  MallClient
//
//  Created by lxy on 2018/6/12.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderSelectAddressCell.h"

@interface OrderSelectAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation OrderSelectAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setCapaModel:(CapacityEntryModel *)model Index:(NSInteger)index type:(NSString *)type
{
    if ([type isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
        self.stateLabel.text  = @"起";
        self.nameLabel.text = model.contactInfo.startContacts;
        self.telLabel.text = model.contactInfo.startContactsPhone;
        
        if (model.contactInfo.startAddress != nil) {
           self.addressLabel.text = model.contactInfo.startAddress;
        }else{
           self.addressLabel.text = @" ";
        }
        self.startLabel.text = @"起运地：";
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
        self.stateLabel.text  = @"收";
        self.startLabel.text = @"抵运地：";
        self.nameLabel.text = model.contactInfo.endContacts;
        self.telLabel.text = model.contactInfo.endContactsPhone;
        if (model.contactInfo.endAddress != nil) {
            self.addressLabel.text = model.contactInfo.endAddress;
        }else{
            self.addressLabel.text = @" ";
        }
    }else{
        if (index == 1) {
            self.stateLabel.text  = @"起";
            self.startLabel.text = @"起运地：";
            self.nameLabel.text = model.contactInfo.startContacts;
            self.telLabel.text = model.contactInfo.startContactsPhone;
            self.addressLabel.text = model.contactInfo.startAddress;
            if (model.contactInfo.startAddress != nil) {
                self.addressLabel.text = model.contactInfo.startAddress;
            }else{
                self.addressLabel.text = @" ";
            }
        }else{
            self.stateLabel.text  = @"收";
            self.startLabel.text = @"抵运地：";
            self.nameLabel.text = model.contactInfo.endContacts;
            self.telLabel.text = model.contactInfo.endContactsPhone;
            if (model.contactInfo.endAddress != nil) {
                self.addressLabel.text = model.contactInfo.endAddress;
            }else{
                self.addressLabel.text = @" ";
            }
        }
    }
 
}


- (void) setCapaViewModel:(CapacityViewModel *)model Index:(NSInteger)index type:(NSString *)type{
    
    if ([type isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
        self.stateLabel.text  = @"起";
        self.nameLabel.text = model.startContacts;
        self.telLabel.text = model.startPhone;
        
        if (model.startAddress != nil) {
            self.addressLabel.text = model.startAddress;
        }else{
            self.addressLabel.text = @" ";
        }
        self.startLabel.text = @"起运地：";
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
        self.stateLabel.text  = @"收";
        self.startLabel.text = @"抵运地：";
        self.nameLabel.text = model.endContacts;
        self.telLabel.text = model.endPhone;
        if (model.endAddress != nil) {
            self.addressLabel.text = model.endAddress;
        }else{
            self.addressLabel.text = @" ";
        }
    }else{
        if (index == 1) {
            self.stateLabel.text  = @"起";
            self.startLabel.text = @"起运地：";
            self.nameLabel.text = model.startContacts;
            self.telLabel.text = model.startPhone;
            self.addressLabel.text = model.startAddress;
            if (model.startAddress != nil) {
                self.addressLabel.text = model.startAddress;
            }else{
                self.addressLabel.text = @" ";
            }
        }else{
            self.stateLabel.text  = @"收";
            self.startLabel.text = @"抵运地：";
            self.nameLabel.text = model.endContacts;
            self.telLabel.text = model.endPhone;
            if (model.endAddress != nil) {
                self.addressLabel.text = model.endAddress;
            }else{
                self.addressLabel.text = @" ";
            }
        }
    }
}
@end
