//
//  CoalOrderCell.h
//  MallClient
//
//  Created by lxy on 2017/10/17.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoalOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbNo;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbPNum;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbPriceNum;

@end
