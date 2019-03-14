//
//  OrderDeyailNoAddressCell.h
//  MallClient
//
//  Created by lxy on 2018/7/4.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"
#import "CapacityEntryModel.h"

@interface OrderDeyailNoAddressCell : UITableViewCell

@property (nonatomic, strong) OrderModelForCapacity * model;
@property (nonatomic, strong) CapacityEntryModel *requestModel;
- (void) setModel:(OrderModelForCapacity *)model AndIndex:(NSInteger)index;

- (void) requestModel:(CapacityEntryModel *)model AndIndex:(NSInteger)index;
@end
