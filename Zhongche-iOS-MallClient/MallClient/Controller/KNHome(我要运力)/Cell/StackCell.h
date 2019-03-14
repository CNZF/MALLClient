//
//  StackCell.h
//  MallClient
//
//  Created by lxy on 2018/8/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityEntryModel.h"
@interface StackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
- (void)loadUIWithmodel:(CapacityEntryModel *)model;
@end
