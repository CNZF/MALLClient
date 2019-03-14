//
//  AccountTableViewCell.h
//  MallClient
//
//  Created by lxy on 2017/1/24.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbNo;
@property (weak, nonatomic) IBOutlet UILabel *lbStatuse;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@end
