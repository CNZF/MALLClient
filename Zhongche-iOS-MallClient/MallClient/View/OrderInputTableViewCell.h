//
//  OrderInputTableViewCell.h
//  MallClient
//
//  Created by lxy on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInputTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UITextView *tvText;
@property (weak, nonatomic) IBOutlet UITextField *tfText;

@end
