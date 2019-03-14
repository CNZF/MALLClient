//
//  OrderDetailInVoiveCell.h
//  MallClient
//
//  Created by lxy on 2018/6/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"

@interface OrderDetailInVoiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *invoiceLabel;
@property (nonatomic, strong) OrderModelForCapacity * model;
- (void) setNewModel:(OrderModelForCapacity * )model WithModel:(OrderModelForCapacity *)oldModel;
@end
