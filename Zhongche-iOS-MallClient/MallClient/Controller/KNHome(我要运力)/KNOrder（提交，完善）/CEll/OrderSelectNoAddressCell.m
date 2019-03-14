//
//  OrderSelectNoAddressCell.m
//  MallClient
//
//  Created by lxy on 2018/7/4.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderSelectNoAddressCell.h"

@interface OrderSelectNoAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation OrderSelectNoAddressCell

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
        if (index == 1) {
            self.stateLabel.text = @"起";
            self.nameLabel.text = model.contactInfo.startContacts;
            self.telLabel.text = model.contactInfo.startContactsPhone;
        }else{
            self.stateLabel.text = @"收";
            self.nameLabel.text = model.contactInfo.endContacts;
            self.telLabel.text = model.contactInfo.endContactsPhone;
        }
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
        self.stateLabel.text  = @"收";
        self.nameLabel.text = model.contactInfo.endContacts;
        self.telLabel.text = model.contactInfo.endContactsPhone;
//
//        if (model.contactInfo.startAddress != nil) {
//            self.addressLabel.text = model.contactInfo.startAddress;
//        }else{
//            self.addressLabel.text = @" ";
//        }
//        self.startLabel.text = @"起运地：";
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
        self.stateLabel.text  = @"起";
//        self.startLabel.text = @"抵运地：";
        self.nameLabel.text = model.contactInfo.startContacts;
        self.telLabel.text = model.contactInfo.startContactsPhone;
//        if (model.contactInfo.endAddress != nil) {
//            self.addressLabel.text = model.contactInfo.endAddress;
//        }else{
//            self.addressLabel.text = @" ";
//        }
    }else{

    }
}

- (void) setCapaViewModel:(CapacityViewModel *)model Index:(NSInteger)index type:(NSString *)type{
    
    if ([type isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
        if (index == 1) {
            self.stateLabel.text = @"起";
            self.nameLabel.text = model.startContacts;
            self.telLabel.text = model.startPhone;
        }else{
            self.stateLabel.text = @"收";
            self.nameLabel.text = model.endContacts;
            self.telLabel.text = model.endPhone;
        }
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
        self.stateLabel.text  = @"收";
        self.nameLabel.text = model.endContacts;
        self.telLabel.text = model.endPhone;
        //
        //        if (model.contactInfo.startAddress != nil) {
        //            self.addressLabel.text = model.contactInfo.startAddress;
        //        }else{
        //            self.addressLabel.text = @" ";
        //        }
        //        self.startLabel.text = @"起运地：";
        
    }else if ([type isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
        self.stateLabel.text  = @"起";
        //        self.startLabel.text = @"抵运地：";
        self.nameLabel.text = model.startContacts;
        self.telLabel.text = model.startPhone;
        //        if (model.contactInfo.endAddress != nil) {
        //            self.addressLabel.text = model.contactInfo.endAddress;
        //        }else{
        //            self.addressLabel.text = @" ";
        //        }
    }else{
       
    }
}
@end
