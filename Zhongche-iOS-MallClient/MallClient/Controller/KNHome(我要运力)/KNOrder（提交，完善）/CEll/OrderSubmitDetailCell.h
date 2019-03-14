//
//  OrderSubmitDetailCell.h
//  MallClient
//
//  Created by lxy on 2018/6/12.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityEntryModel.h"
#import "TicketsDetailModel.h"
#import "TransportationModel.h"

@interface OrderSubmitDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) CapacityEntryModel *model;
@property (nonatomic, strong) TicketsDetailModel * ticketModel;

@property (nonatomic, strong) TransportationModel *transportModel;


@property (nonatomic, assign) NSInteger index;
- (void) setModel:(CapacityEntryModel *)model Index:(NSInteger)index;
- (void) setTicketModel:(TicketsDetailModel *)Ticketmodel Index:(NSInteger)index;
@end
