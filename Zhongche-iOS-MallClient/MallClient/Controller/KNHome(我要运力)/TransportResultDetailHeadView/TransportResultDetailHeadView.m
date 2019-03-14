//
//  TransportResultDetailHeadView.m
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "TransportResultDetailHeadView.h"

@interface TransportResultDetailHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *beginPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;

@property (weak, nonatomic) IBOutlet UILabel *beginAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;

@end

@implementation TransportResultDetailHeadView

//        sectionHeader.distanceLabel.text = [NSString stringWithFormat:@"%@   至   %@",model.startName,model.endName];
//        sectionHeader.descLabel.text = [NSString stringWithFormat:@"%@   至   %@",model.startEntrepotName.name,model.endEntrepotName.name];

- (void)setModel:(TicketsDetailModel *)model
{
    self.beginPlace.text = model.startEntrepotName.name;
    self.endPlace.text = model.endEntrepotName.name;
    self.beginAddress.text = model.startEntrepotName.address;
    self.endAddress.text = model.endEntrepotName.address;
}

@end
