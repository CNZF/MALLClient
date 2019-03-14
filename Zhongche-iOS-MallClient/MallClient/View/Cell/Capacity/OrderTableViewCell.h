//
//  OrderTableViewCell.h
//  MallClient
//
//  Created by lxy on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbText;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
