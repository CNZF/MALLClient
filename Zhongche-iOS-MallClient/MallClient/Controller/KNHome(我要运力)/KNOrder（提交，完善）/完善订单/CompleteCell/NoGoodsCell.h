//
//  NoGoodsCell.h
//  MallClient
//
//  Created by lxy on 2018/7/31.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityEntryModel.h"
#import "CapacityViewModel.h"

@interface NoGoodsCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) CapacityEntryModel *requestModel;
@property (nonatomic, strong) CapacityViewModel *requestViewModel;

- (void)setRequestModel:(CapacityEntryModel *)requestModel With:(BOOL)isSelect;
- (void)setCapacityViewModelRequestModel:(CapacityViewModel *)requestModel With:(BOOL)isSelect;
@end
