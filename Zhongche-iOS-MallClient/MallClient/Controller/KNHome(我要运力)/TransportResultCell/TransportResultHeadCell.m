//
//  TransportResultHeadCell.m
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "TransportResultHeadCell.h"

@interface TransportResultHeadCell ()
@property (weak, nonatomic) IBOutlet UILabel *beginPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *beginAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;

@end
@implementation TransportResultHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(TicketsDetailModel *)model
{
    self.beginPlace.text = model.startEntrepotName.name;
    self.endPlace.text = model.endEntrepotName.name;
//    self.beginAddress.text = model.startEntrepotName.address;
//    self.endAddress.text = model.endEntrepotName.address;
}
@end
