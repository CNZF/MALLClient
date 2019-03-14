//
//  OrderComplete_P_T_PCell.h
//  MallClient
//
//  Created by lxy on 2018/6/12.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityEntryModel.h"

@interface OrderComplete_P_T_PCell : UITableViewCell

@property (nonatomic, strong)CapacityEntryModel * model;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy)NSString * type;
- (void) setCapaModel:(CapacityEntryModel *)model Index:(NSInteger)index type:(NSString *)type;

@end
