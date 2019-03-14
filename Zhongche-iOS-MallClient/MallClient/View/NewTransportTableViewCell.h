//
//  NewTransportTableViewCell.h
//  MallClient
//
//  Created by lxy on 2017/2/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTransportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (weak, nonatomic) IBOutlet UILabel *startStation;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endStation;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;

@end
