//
//  KNTableViewTextFieldCell.h
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"
#import "CapacityViewModel.h"

@interface KNTableViewTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) GoodsInfo *goods;
@property (nonatomic, strong) CapacityViewModel *reRequestModel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger index;

- (void) setGoods:(GoodsInfo *)goods reRequestModel:(CapacityViewModel *)reRequestModel section:(NSInteger)section  index:(NSInteger) index;

@end
