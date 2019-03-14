//
//  KNTableViewNumberCell.h
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityViewModel.h"

typedef void (^KNTableViewNumberCellValueChangeBlcok)(NSString *num);

@interface KNTableViewNumberCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabeLeft;

@property (nonatomic, strong) CapacityViewModel *reRequestModel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@property (nonatomic, copy) KNTableViewNumberCellValueChangeBlcok changeBlock;


@end
