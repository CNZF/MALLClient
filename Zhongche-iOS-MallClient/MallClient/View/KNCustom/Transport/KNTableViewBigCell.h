//
//  KNTableViewBigCell.h
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityViewModel.h"

@interface KNTableViewBigCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *longTF;

@property (weak, nonatomic) IBOutlet UITextField *widthTF;

@property (weak, nonatomic) IBOutlet UITextField *heightTF;

@property (weak, nonatomic) IBOutlet UITextField *weightTF;

@property (nonatomic, strong) CapacityViewModel *reRequestModel;

@end
