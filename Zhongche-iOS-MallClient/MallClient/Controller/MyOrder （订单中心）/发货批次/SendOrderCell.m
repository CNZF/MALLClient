//
//  SendOrderCell.m
//  MallClient
//
//  Created by lxy on 2018/6/10.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "SendOrderCell.h"
#import "NSString+Money.h"
@interface SendOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeName;
@property (weak, nonatomic) IBOutlet UILabel *containerName;
@property (weak, nonatomic) IBOutlet UILabel *container_number;

@end

@implementation SendOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SendOrderModel *)model
{
    self.orderCode.text = model.code;
    self.orderStatus.text = model.statusName;
    self.orderTime.text = [NSString TimeGetDate:model.estimate_departure_time];
    self.orderTypeName.text = model.businessTypeName;
    if (model.containerName) {
        self.containerName.text = model.containerName;
    }
    
    if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {
        if (model.reality_weight) {
            self.container_number.text =[NSString stringWithFormat:@"%@吨", model.reality_weight];
        }
    }else{
        if (model.container_number) {
            self.container_number.text =[NSString stringWithFormat:@"%@箱", model.container_number];
        }
    }
}
@end
