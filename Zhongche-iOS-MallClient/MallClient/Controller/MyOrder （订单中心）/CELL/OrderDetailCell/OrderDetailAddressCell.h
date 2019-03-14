//
//  OrderDetailAddress/Users/lxy/Desktop/zhongche/mall/v3/Zhongche-iOS-MallClient/MallClient/Controller/MyOrder/CELL/OrderDetailCell/OrderDetailNomalCell.hCell.h
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"

@interface OrderDetailAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//下单时间


@property (weak, nonatomic) IBOutlet UILabel *startP;
@property (weak, nonatomic) IBOutlet UILabel *endP;
@property (weak, nonatomic) IBOutlet UILabel *satrtT;
@property (weak, nonatomic) IBOutlet UILabel *endT;


@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;



@property (nonatomic, strong) OrderModelForCapacity * model;
- (void) setNewModel:(OrderModelForCapacity * )model WithModel:(OrderModelForCapacity *)oldModel;
@end
