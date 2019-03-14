//
//  KNTableViewTipsCell.h
//  MallClient
//
//  Created by 李二狗 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityViewModel.h"

@interface KNTableViewTipsCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) CapacityViewModel *reRequestModel;
@end
