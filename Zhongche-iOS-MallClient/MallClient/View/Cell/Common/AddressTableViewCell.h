//
//  AddressTableViewCell.h
//  MallClient
//
//  Created by lxy on 2016/12/20.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
@property (weak, nonatomic) IBOutlet UILabel *laAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbAddressType;

@end
