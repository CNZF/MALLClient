//
//  containerCell.h
//  MallClient
//
//  Created by lxy on 2018/11/19.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityEntryModel.h"

@interface containerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;


-(void)loadUIWithmodel:(CapacityEntryModel *)model;
@end
