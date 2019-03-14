//
//  SubGoodsInfomationCell.h
//  MallClient
//
//  Created by lxy on 2018/8/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportationModel.h"
#import "CapacityEntryModel.h"

@interface SubGoodsInfomationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *writeGoodName;
@property (weak, nonatomic) IBOutlet UILabel *box;
@property (weak, nonatomic) IBOutlet UILabel *boxnum;
@property (weak, nonatomic) IBOutlet UILabel *getTime;
@property (weak, nonatomic) IBOutlet UILabel *songTime;
@property (weak, nonatomic) IBOutlet UILabel *arriveTime;
@property (weak, nonatomic) IBOutlet UILabel *remark;

- (void) setModel:(CapacityEntryModel *)model requeseModel:(TransportationModel *)requeseModel;

@end
