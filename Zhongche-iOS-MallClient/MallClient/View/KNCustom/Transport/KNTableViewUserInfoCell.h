//
//  KNTableViewUserInfoCell.h
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityViewModel.h"

@interface KNTableViewUserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *concatButton;

@property (nonatomic, strong) CapacityViewModel *reRequestModel;

@end
